//
//  ImageLoader.swift
//  economic
//
//  Created by Yuri on 11/06/25.
//

import UIKit

struct ImageLoader {
    static func load(from path: String?) -> UIImage? {
        guard let path = path else { return nil }
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(path)
        return UIImage(contentsOfFile: url.path)
    }
}
