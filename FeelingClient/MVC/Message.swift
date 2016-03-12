//
//  Message.swift
//  FeelingClient
//
//  Created by vincent on 9/3/16.
//  Copyright © 2016 xecoder. All rights reserved.
//

import Foundation
import ObjectMapper

import SwiftyJSON
import Alamofire


public class Messages:BaseApi {
    static let defaultMessages = Messages()
    var msgs = [MessageBean]()
    
    var loader = PhotoUpLoader.init()
    
    var jwt = JWTTools()
    var imagesData: [UIImage]?
    
    func addMsg(msg: MessageBean, imags:[UIImage]) {
        msgs.insert(msg, atIndex:0)
    }
    
    func saveMsg(msg: MessageBean, imags:[UIImage],completeHander: CompletionHandlerType)
    {
        
        let newDict = Dictionary<String,String>()
        let headers = jwt.getHeader(jwt.token, myDictionary: newDict)
        
        loader.completionAll(imags) { (r:PhotoUpLoader.Result) -> Void in
            
            switch (r) {
            case .Success(let pathIn):
                let params = ["to": msg.to,"limitDate":msg.limitDate,"content":msg.content, "photos":pathIn as!String,  "burnAfterReading":msg.burnAfterReading, "x": msg.x, "y":msg.y]
                NetApi().makeCall(Alamofire.Method.POST,section: "messages/send", headers: headers, params: params as? [String : AnyObject] , completionHandler: { (result:BaseApi.Result) -> Void in
                    switch (result) {
                    case .Success(let r):
                        if let json = r {
                            let myJosn = JSON(json)
                            let code:Int = Int(myJosn["status"].stringValue)!
                            let result = myJosn.dictionary!["message"]!.stringValue
                            if code != 200 {
                                completeHander(Result.Failure(result))
                            }
                            else{
                                msg.id = result
                                completeHander(Result.Success(result))
                            }
                        }
                        self.msgs.append(msg)
                        break;
                    case .Failure(let error):
                        print("\(error)")
                        break;
                    }
                    
                    
                })
                
                break;
            case .Failure(let error):
                print("\(error)")
                break;
            }
        }
        
    }
    
//    * @param to   接受人
//    * @param x    经度
//    * @param y    维度
//    * @param page
//    * @param size
    
    func searchMsg(to: String,x: Double,y:Double,page:Int,size:Int,completeHander: CompletionHandlerType)
    {
        
        let newDict = Dictionary<String,String>()
        let headers = jwt.getHeader(jwt.token, myDictionary: newDict)
        
        let params = ["to": to,"x": x, "y":y, "page": page,"size":size]
        
        NetApi().makeCall(Alamofire.Method.POST,section: "messages/search",headers: [:], params: params as? [String : AnyObject] , completionHandler: { (result:BaseApi.Result) -> Void in
                    switch (result) {
                    case .Success(let r):
                        if let json = r {
                            let myJosn = JSON(json)
                            let code:Int = Int(myJosn["status"].stringValue)!
                            let result = myJosn.dictionary!["message"]!.stringValue
                            if code != 200 {
                                completeHander(Result.Failure(result))
                            }
                            else{
                                msg.id = result
                                completeHander(Result.Success(result))
                            }
                        }
                        self.msgs.append(msg)
                        break;
                    case .Failure(let error):
                        print("\(error)")
                        break;
                    }
                    
                    
                })
        
        }
}

class MessageBean: BaseModel {
    
    override static func newInstance() -> Mappable {
        return MessageBean();
    }
    
    override func mapping(map: Map) {
        
        super.mapping(map)
        id <- map["id"]
        to <- map["to"]
        limitDate <- map["limit_date"]
        content <- map["content"]
        photos <- map["photos"]
        video <- map["video"]
        sound <- map["sound"]
        burnAfterReading <- map["burn_after_reading"]
        x <- map["x"]
        y <- map["y"]
        
    }
    
    var id: String = ""
    //发送对象
    var to: String = ""
    //期限
    var limitDate: String = ""
    //内容
    var content: String = ""
    //图片地址
    var photos: [String] = [""]
    //视频地址
    var video: String = ""
    //音频地址
    var sound: String = ""
    //阅后即焚
    var burnAfterReading: Bool = false
    //坐标
    var x: Double = 0.0
    //坐标
    var y: Double = 0.0
    
}