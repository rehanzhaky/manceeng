//
//  HistoryViewModel.swift
//  manceeng
//
//  Created by M. Iqbal on 09/06/26.
//

import Foundation
import Combine

final class HistoryViewModel: ObservableObject {
    /// Koleksi tangkapan (history). Pakai model yang sama dengan peta.
    @Published var catches: [CatchLocation]

    /// Kartu yang dipilih → tampilkan panel detail. `nil` = tertutup.
    @Published var selectedLocation: CatchLocation?

    init(catches: [CatchLocation] = CatchLocation.samples) {
        self.catches = catches
    }
}
