//
//  servisModel.swift
//  rezervisApp
//
//  Created by Oktay Aydın on 17.03.2025.
//

import Foundation

struct Servis: Identifiable {
    var id = UUID()
    var kalkisYeri: String
    var varisyeri: String
    var kalkisTarihi = Data()
    var kalkisSaati = Timer()
    var koltukSayisi: Int
    
}


