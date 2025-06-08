//
//  Receipt.swift
//  economic
//
//  Created by Yuri on 08/06/25.
//

import Foundation

struct Receipt: Identifiable {
    let id: UUID
    let imageData: Data
    let date: Date
    let amount: Double
    let currency: String
}
