//
//  WebAPIService.swift
//  CodeSample-Tia-Giphy
//
//  Created by sadie on 2/26/18.
//  Copyright © 2018 Sadie Contini. All rights reserved.
//

import Foundation
import Alamofire

typealias JsonObject = Dictionary<String, AnyObject>

enum ApiResult<T> {
    case success(T)
    case error(AppError)
}

class WebAPIService: NSObject {
    
    // Singleton
    static let shared = WebAPIService()
    override private init() { super.init() }
    
    // MARK: - Fetch
    
    func fetchRandomGiphyImage(closure: @escaping (ApiResult<GiphyImage>) -> Void) {
        
        let api_key = "yJeLZdXoA8hU91oChsmAGY8J7aZ44uzU"
        let randomGifEndpoint = "https://api.giphy.com/v1/gifs/random?api_key=" + api_key

        guard let requestUrl = URL(string: randomGifEndpoint) else {
            // TODO: use localized string for userMessage
            let userMessage = "Server error. Try again."
            let debug = "Request URL invalid: " + randomGifEndpoint
            let error = AppError.ApiError(message: userMessage,
                                          debug: debug)
            closure(ApiResult.error(error))
            return
        }
        
        Alamofire.request(
            requestUrl,
            parameters: nil,
            encoding: URLEncoding.default,
            headers: nil) // is optional : HTTPHeaders?
            .validate()
            .responseJSON {
                (response) -> Void in
                guard response.result.isSuccess else {
                    // TODO: use localized string for userMessage
                    // TODO: parse for server error codes?
                    // TODO: redo errors so that front end checks for type of issue and then gives user message
                    // only front end would know what to communicate to user
                    let userMessage = "Error while fetching remote items."
                    let debug = "Error while fetching remote items."
                    let error = AppError.ApiError(message: userMessage,
                                                  debug: debug)
                    closure(ApiResult.error(error))
                    return
                }
                
                guard let data = response.result.value as? JsonObject else {
                    // TODO: use localized string for userMessage
                    let userMessage = "Server error. Try again."
                    let debug = "Malformed data received from api "
                    let error = AppError.JsonParsingError(message: userMessage,
                                                          debug: debug)
                    closure(ApiResult.error(error))
                    return
                }
                
                //get image url
                guard let dataJson = data["data"],
                    let imagesJson = dataJson["images"] as? JsonObject,
                    let smallImageJson = imagesJson["fixed_height_small"] as? JsonObject,
                    let urlString = smallImageJson["url"] as? String else {
                    let error = AppError.ImageNotFound()
                    closure(ApiResult.error(error))
                        return
                }
                
                closure(ApiResult.success(GiphyImage(urlString: urlString, image: nil)))
        }
    }
}
