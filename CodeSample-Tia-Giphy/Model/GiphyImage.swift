//
//  GiphyImage.swift
//  CodeSample-Tia-Giphy
//
//  Created by sadie on 2/26/18.
//  Copyright © 2018 Sadie Contini. All rights reserved.
//

import Foundation
import UIKit

struct GiphyImage {
    var urlString: String
    var image: UIImage?
    
    func url() -> URL? {
        return URL(string: urlString)
    }
}
