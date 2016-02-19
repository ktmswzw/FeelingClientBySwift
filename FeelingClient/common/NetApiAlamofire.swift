//
//  NetApiAlamofire.swift
//  FeelingClient
//
//  Created by vincent on 13/2/16.
//  Copyright © 2016 xecoder. All rights reserved.
//

import Foundation
import Alamofire

public class NetApi{
    
    var apiUrl = "http://192.168.137.1:80/"
    //    var apiUrl = "http://192.168.1.141/"
    
    
    
    func getResult(method: Alamofire.Method,section: String, headers: [String: String]?, params: [String: AnyObject]?, completionHandler: (NSDictionary?, NSError?) -> ()) {
        makeCall(method, section: section,headers: headers, params: params, completionHandler: completionHandler)
    }
    
    func makeCall(method: Alamofire.Method, section: String, headers: [String: String]?, params: [String: AnyObject]?, completionHandler: (NSDictionary?, NSError?) -> ()) {
        Alamofire.request(method, "\(apiUrl)/\(section)",headers: headers, parameters: params)
            .responseJSON { response in
                switch response.result {
                case .Success(let value):
                    completionHandler(value as? NSDictionary, nil)
                case .Failure(let error):
                    completionHandler(nil, error)
                }
        }
    }
}


