//
//  AppError.swift
//  CodeSample-Tia-Giphy
//
//  Created by sadie on 2/26/18.
//  Copyright © 2018 Sadie Contini. All rights reserved.
//

import Foundation
import Foundation
import UIKit

// TODO: deal with device not online
enum AppError: Error, CustomStringConvertible {
    
    // TODO: deal with device not online
    //    case NetworkError(code: Int)
    case InvalidUrlError(urlString: String)
    case ApiError(message: String, debug: String)
    case ImageNotFound()
    case JsonParsingError(message: String, debug: String)
    
    var description: String {
        switch self {
        case .ApiError(let message, let debug):
            return "ApiError: " + message + debug
        case .ImageNotFound:
            return "Image not found"
        case .InvalidUrlError(let urlString):
            return "Invalid URL: " + urlString
        case .JsonParsingError(let message, let debug):
            return "JsonParsingError: " + message + debug
        }
    }
}


