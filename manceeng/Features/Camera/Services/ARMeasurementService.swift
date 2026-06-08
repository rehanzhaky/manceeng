//
//  ARMeasurementService.swift
//  manceeng
//
//  Created by Made Vidyatma Adhi Krisna on 07/06/26.
//

import Foundation
import ARKit
import Combine
import UIKit

final class ARMeasurementService: NSObject, ObservableObject {
    @Published var trackingStateText = "Move your phone"
    @Published var isARReady = false
    @Published var distanceMeters: Double?
    @Published var isUsingFallbackMeasurement = true

    private weak var sceneView: ARSCNView?
    /// Focal length in pixels from camera intrinsics — updated every frame
    private var focalLengthPixels: Float?
    /// Image resolution reported by the AR camera
    private var cameraImageResolution: CGSize?

    func attach(sceneView: ARSCNView) {
        self.sceneView = sceneView
        sceneView.session.delegate = self
        sceneView.automaticallyUpdatesLighting = true
        sceneView.autoenablesDefaultLighting = true
    }

    func start() {
        guard ARWorldTrackingConfiguration.isSupported else {
            trackingStateText = "AR not supported"
            isARReady = false
            return
        }

        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]
        sceneView?.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }

    func stop() {
        sceneView?.session.pause()
    }

    func captureImage() -> UIImage? {
        sceneView?.snapshot()
    }

    // MARK: - Measurement

    func estimateLengthCm(for boundingBox: CGRect, imageSize: CGSize) -> Double {
        // Try AR raycast first (most accurate)
        if let arLength = raycastLengthCm(for: boundingBox, imageSize: imageSize) {
            isUsingFallbackMeasurement = false
            return arLength
        }

        // Fallback: use camera intrinsics + estimated distance
        isUsingFallbackMeasurement = true
        return intrinsicsFallbackLengthCm(for: boundingBox, imageSize: imageSize)
    }

    func estimateWeightKg(lengthCm: Double) -> Double {
        let grams = 0.0200 * pow(lengthCm, 3.0)
        return grams / 1000
    }

    // MARK: - Raycast-based measurement

    private func raycastLengthCm(for boundingBox: CGRect, imageSize: CGSize) -> Double? {
        guard let sceneView else { return nil }

        let displaySize = sceneView.bounds.size
        guard displaySize.width > 0, displaySize.height > 0 else { return nil }

        let imageFrame = aspectFillFrame(imageSize: imageSize, displaySize: displaySize)

        // Map the left and right edges of the bounding box to screen coordinates
        let minX = imageFrame.minX + boundingBox.minX * imageFrame.width
        let maxX = imageFrame.minX + boundingBox.maxX * imageFrame.width
        let midY = imageFrame.minY + (1 - boundingBox.midY) * imageFrame.height

        let leftPoint = CGPoint(x: minX, y: midY)
        let rightPoint = CGPoint(x: maxX, y: midY)

        // Try estimatedPlane first, then existingPlaneGeometry, then featurePoint
        guard let left = worldPosition(from: leftPoint, in: sceneView),
              let right = worldPosition(from: rightPoint, in: sceneView) else {
            return nil
        }

        let lengthMeters = simd_distance(left, right)
        guard lengthMeters.isFinite, lengthMeters > 0, lengthMeters < 5.0 else { return nil }
        return Double(lengthMeters) * 100
    }

    private func worldPosition(from point: CGPoint, in sceneView: ARSCNView) -> SIMD3<Float>? {
        // Strategy 1: estimatedPlane (most common)
        if let query = sceneView.raycastQuery(from: point, allowing: .estimatedPlane, alignment: .any),
           let result = sceneView.session.raycast(query).first {
            let t = result.worldTransform
            return SIMD3<Float>(t.columns.3.x, t.columns.3.y, t.columns.3.z)
        }

        // Strategy 2: existingPlaneGeometry
        if let query = sceneView.raycastQuery(from: point, allowing: .existingPlaneGeometry, alignment: .any),
           let result = sceneView.session.raycast(query).first {
            let t = result.worldTransform
            return SIMD3<Float>(t.columns.3.x, t.columns.3.y, t.columns.3.z)
        }

        // Strategy 3: hit test with feature points (legacy but useful fallback)
        let hitResults = sceneView.hitTest(point, types: .featurePoint)
        if let hit = hitResults.first {
            let t = hit.worldTransform
            return SIMD3<Float>(t.columns.3.x, t.columns.3.y, t.columns.3.z)
        }

        return nil
    }

    // MARK: - Intrinsics-based fallback measurement

    /// Uses camera intrinsics (focal length) and estimated distance to calculate fish length.
    /// Formula: realWidth = (pixelWidth / focalLength) * distance
    private func intrinsicsFallbackLengthCm(for boundingBox: CGRect, imageSize: CGSize) -> Double {
        let pixelWidth = boundingBox.width * imageSize.width

        // Use AR-tracked distance to nearest plane, or conservative default
        let distance = distanceMeters ?? 0.50  // Default 50cm (more realistic than 35cm)

        // Use camera intrinsics if available
        if let focalLength = focalLengthPixels, let camRes = cameraImageResolution {
            // Scale focal length to match the image size (snapshot may differ from camera resolution)
            let focalScaled = Double(focalLength) * Double(imageSize.width) / Double(camRes.width)
            let realWidthMeters = (Double(pixelWidth) / focalScaled) * distance
            return max(1, realWidthMeters * 100)
        }

        // Final fallback: use estimated FOV (~69° for iPhone wide camera)
        let horizontalFOVDegrees = 69.0
        let visibleWidthCm = 2 * distance * tan((horizontalFOVDegrees * .pi / 180) / 2) * 100
        return max(1, Double(pixelWidth / imageSize.width) * visibleWidthCm)
    }

    // MARK: - Distance estimation

    /// Estimates the distance from camera to the nearest detected surface
    private func updateDistanceFromFrame(_ frame: ARFrame) {
        let camera = frame.camera
        let cameraTransform = camera.transform
        let cameraPosition = SIMD3<Float>(
            cameraTransform.columns.3.x,
            cameraTransform.columns.3.y,
            cameraTransform.columns.3.z
        )

        // Find distance to nearest anchor plane
        var minDist: Float = .greatestFiniteMagnitude
        for anchor in frame.anchors {
            guard let plane = anchor as? ARPlaneAnchor else { continue }
            let planePos = SIMD3<Float>(
                plane.transform.columns.3.x,
                plane.transform.columns.3.y,
                plane.transform.columns.3.z
            )
            let dist = simd_distance(cameraPosition, planePos)
            if dist < minDist {
                minDist = dist
            }
        }

        if minDist < .greatestFiniteMagnitude, minDist > 0.05, minDist < 5.0 {
            distanceMeters = Double(minDist)
        }
    }

    // MARK: - Helpers

    private func aspectFillFrame(imageSize: CGSize, displaySize: CGSize) -> CGRect {
        let scale = max(displaySize.width / imageSize.width, displaySize.height / imageSize.height)
        let width = imageSize.width * scale
        let height = imageSize.height * scale

        return CGRect(
            x: (displaySize.width - width) / 2,
            y: (displaySize.height - height) / 2,
            width: width,
            height: height
        )
    }
}

// MARK: - ARSessionDelegate

extension ARMeasurementService: ARSessionDelegate {
    nonisolated func session(_ session: ARSession, didUpdate frame: ARFrame) {
        let trackingDescription: String
        let isReady: Bool

        switch frame.camera.trackingState {
        case .normal:
            trackingDescription = "AR On"
            isReady = true
        case .notAvailable:
            trackingDescription = "AR Off"
            isReady = false
        case .limited:
            trackingDescription = "AR Off"
            isReady = false
        }

        // Extract intrinsics from camera
        let intrinsics = frame.camera.intrinsics
        let fx = intrinsics[0][0]  // focal length in x (pixels)
        let imageRes = frame.camera.imageResolution

        Task { @MainActor in
            self.trackingStateText = trackingDescription
            self.isARReady = isReady
            self.focalLengthPixels = fx
            self.cameraImageResolution = imageRes

            if isReady {
                self.updateDistanceFromFrame(frame)
            }
        }
    }
}
