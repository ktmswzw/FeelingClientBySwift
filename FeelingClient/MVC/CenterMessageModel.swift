//
//  CenterMessageModel.swift
//  FeelingClient
//
//  Created by vincent on 10/3/16.
//  Copyright © 2016 xecoder. All rights reserved.
//

import Foundation
import MapKit

public class MessageViewModel {
    
    public let msgs: Messages = Messages.defaultMessages
    
    
    //id
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
    
    var latitude:Double = 0.0
    var longitude:Double = 0.0
    
    public weak var delegate: MessageViewModelDelegate?
    
    var imageData = [UIImage]()
    
    private var index: Int = -1
    
    var isNew: Bool {
        return index == -1
    }
    
    // new initializer
    public init(delegate: MessageViewModelDelegate) {
        self.delegate = delegate
    }
    
    
    func sendMessage() {
        let msg = MessageBean()
        msg.burnAfterReading = burnAfterReading
        msg.to = to
        msg.limitDate = limitDate
        msg.video = video
        msg.sound = sound
        msg.content = content
        msg.x = latitude
        msg.y = longitude
        msgs.saveMsg(msg, imags: imageData) { (r:BaseApi.Result) -> Void in
            switch (r) {
            case .Success(let r):
                self.id = r as! String
                break;
            case .Failure(_):
                
                break;
            }
        }
    }
    
    func searchMessage(map: MKMapView) {
        msgs.searchMsg("", x: "\(latitude)", y: "\(longitude)", page: 0, size: 100) { (r:BaseApi.Result) -> Void in
            switch (r) {
            case .Success(let r):
                self.msgs.msgs = r as! [MessageBean]
                
                
                
                
                let museum1 = MuseumInfo()
                museum1.coordinate = CLLocationCoordinate2DMake(29.8539157631154, 121.425866184497)
                //设置点击大头针之后显示的标题
                museum1.title = "南京夫子庙"
                //设置点击大头针之后显示的描述
                museum1.subtitle = "南京市秦淮区秦淮河北岸中华路"
                museum1.url = "https://google.com"
                
                map.addAnnotation(museum1)
                
                
                break;
            case .Failure(_):
                
                break;
            }
        }
    }
    
}

public protocol MessageViewModelDelegate: class {
    func sendMessage()
    func searchMessage()
}
