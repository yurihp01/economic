//
//  UIImage+Extensions.swift
//  economic
//
//  Created by Yuri on 10/06/25.
//

import SwiftUI

extension UIImage {
    func resize(toWidth width: CGFloat) -> UIImage {
        let scale = width / size.width
        let height = size.height * scale
        let size = CGSize(width: width, height: height)

        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        draw(in: CGRect(origin: .zero, size: size))
        let resized = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return resized ?? self
    }
}
