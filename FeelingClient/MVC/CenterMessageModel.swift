//
//  CenterMessageModel.swift
//  FeelingClient
//
//  Created by vincent on 10/3/16.
//  Copyright © 2016 xecoder. All rights reserved.
//

import Foundation


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
    
    func searchMessage() {
        msgs.searchMsg("", x: latitude, y: longitude, page: 0, size: 100)
        print(msgs.msgs.count)
    }
    
}

public protocol MessageViewModelDelegate: class {
    func sendMessage()
    func searchMessage()
}
