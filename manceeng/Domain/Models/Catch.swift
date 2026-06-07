//
//  MainModels.swift
//  manceeng
//
//  Created by M. Iqbal on 06/06/26.
//

import Foundation

/// Data satu tangkapan ikan yang ditampilkan di halaman Main.
struct Catch: Identifiable {
    let id = UUID()
    let name: String
    let weight: String
    let length: String
}
