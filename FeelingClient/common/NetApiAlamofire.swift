//
//  NetApiAlamofire.swift
//  FeelingClient
//
//  Created by vincent on 13/2/16.
//  Copyright © 2016 xecoder. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper

class NetApi:BaseApi {
    
    //    var apiUrl = "http://192.168.137.1/"
    //    var apiUrl = "http://192.168.1.141/"
    var apiUrl = "http://192.168.1.105/"
    
    
    
    func makeCall(method: Alamofire.Method, section: String, headers: [String: String]?, params: [String: AnyObject]?, completionHandler: CompletionHandlerType) {
        Alamofire.request(method, "\(apiUrl)/\(section)",headers: headers, parameters: params)
            .responseJSON { response in
                switch response.result {
                case .Success(let value):
                    completionHandler(Result.Success(value as? NSDictionary))
                case .Failure(let error):
                    completionHandler(Result.Failure(error))
                }
        }
    }
    
    
    func makeCallArray<T: Mappable>(method: Alamofire.Method, section: String, headers: [String: String]?, params: [String: AnyObject]?,
        completionHandler: Response<[T], NSError> -> Void ) {
            Alamofire.request(method, "\(apiUrl)/\(section)",headers: headers, parameters: params)
                .responseArray { (response: Response<[T], NSError>) in
                    completionHandler(response)
            }
    }
}


