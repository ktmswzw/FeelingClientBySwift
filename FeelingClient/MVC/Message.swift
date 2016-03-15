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
                let params = ["to": msg.to,"limitDate":msg.limitDate,"content":msg.content, "photos":pathIn as!String,  "burnAfterReading":msg.burnAfterReading, "x": "\(msg.y)", "y":"\(msg.x)"]
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
    //    
    func searchMsg(to: String,x: String,y:String,page:Int,size:Int,completeHander: CompletionHandlerType)
    {
        let params = ["to": to,"x": y, "y":x, "page": page,"size":size]
        NetApi().makeCallArray(Alamofire.Method.POST, section: "messages/search", headers: [:], params: params as? [String:AnyObject]) { (response: Response<[MessageBean], NSError>) -> Void in
            switch (response.result) {
            case .Success(let value):
                for msg in value {
                    let bean = MessageBean()
                    bean.to = msg.to
                    bean.x = msg.y
                    bean.y = msg.x
                    self.msgs.append(bean)
                }
                completeHander(Result.Success(self.msgs))
                break;
            case .Failure(let error):
                print("\(error)")
                break;
            }
        }
    }
    
}

//    
//    let mappedObject = response.result.value
//    
//    XCTAssertNotNil(mappedObject, "Response should not be nil")
//    XCTAssertNotNil(mappedObject?.location, "Location should not be nil")
//    XCTAssertNotNil(mappedObject?.threeDayForecast, "ThreeDayForcast should not be nil")
//    
//    for forecast in mappedObject!.threeDayForecast! {
//    XCTAssertNotNil(forecast.day, "day should not be nil")
//    XCTAssertNotNil(forecast.conditions, "conditions should not be nil")
//    XCTAssertNotNil(forecast.temperature, "temperature should not be nil")
//    }


class MessageBean: BaseModel {
    
    override static func newInstance() -> Mappable {
        return MessageBean();
    }
    
    override func mapping(map: Map) {
        
        super.mapping(map)
        id <- map["id"]
        to <- map["to"]
        from <- map["from"]
        limitDate <- map["limit_date"]
        content <- map["content"]
        //photos <- map["photos"]
        video <- map["videoPath"]
        sound <- map["soundPath"]
        burnAfterReading <- map["burn_after_reading"]
        x <- map["x"]
        y <- map["y"]
        distance <- map["distance"]
        
    }
    
    var id: String = ""
    //发送对象
    var to: String = ""
    //
    var from: String = ""
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
    //距离
    var distance: Double = 0.0
    
}



//"errorCode": "0",
//"id": "56bae476841701c82215ff6b",
//"from": "小红",
//"to": "小明",
//"content": "我在这里，你在哪里？",
//"photos":[
//{
//"name": "1",
//"source": "222",
//"thumbnails": "111"
//}
//],
//"soundPath": null,
//"videoPath": null,
//"point":{"x": 112.99206, "y": 22.740501, "type": "Point", "coordinates":[112.99206,…},
//    "city": "宁波",
//    "district": "鄞州",
//    "address": "学士路655号",
//    "question": "who is me",
//    "answer": "me is who",
//    "burnAfterReading": true,
//    "state": 1,
//    "fromId": null,
//    "toId": null,
//    "distance": 394.4369926352266,
//    "limit_date": "2016-02-20 15:19:18",
//    "create_date": "2016-02-10 15:19:18",
//    "update_date": null
