//
//  AppPages.swift
//  economic
//
//  Created by Yuri on 09/06/25.
//

import SwiftUI

enum AppPages: Hashable {
    case receipts
    case addReceipt
}

enum FullScreenCover: Equatable, Identifiable {
    case camera(Binding<UIImage?>)
    
    var id: String {
        switch self {
        case .camera:
            return "camera"
        }
    }
    
    static func == (lhs: FullScreenCover, rhs: FullScreenCover) -> Bool {
        switch (lhs, rhs) {
        case (.camera, .camera): return true
        }
    }
}
