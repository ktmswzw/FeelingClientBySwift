import UIKit
import Alamofire
import SwiftyJSON


class PhotoUpLoader {
    
    let jwt = JWTTools()
    private var uploadMgr: TXYUploadManager!;
    private var sign = "";
    private var bucket = "habit";
    private var appId = "10005997";
    private var semaphore: dispatch_semaphore_t?;
    private var queue: dispatch_queue_t = dispatch_get_global_queue(0, 0);
    
    static let sharedInstance = PhotoUpLoader()
    
    init()
    {
        sign = initSign()
    }
    
    func initSign() -> String {
        if sign.length == 0 {
            let headers = jwt.getHeader(jwt.token, myDictionary: Dictionary<String,String>())            
            NetApi().makeCall(Alamofire.Method.GET,section: "user/imageSign",headers: headers, params: [:]) {
                responseObject, error in
                
                print("responseObject = \(responseObject); error = \(error)")
                
                if let json = responseObject {
                    let myJosn = JSON(json)
                    self.jwt.sign = myJosn.dictionary!["message"]!.stringValue
                }
            }
        }
        return self.jwt.sign
    }
    
    
    func getPath(image: UIImage) -> NSData{
        return UIImagePNGRepresentation(image)!
    }
    
    
    
    /// 上传至万象优图
    func uploadToTXY(image: UIImage,name: String,completionHandler: String? -> ()) {
        let data = getPath(image)
        if data.length == 0 {
            NSLog("没有data");
            completionHandler("")
        }
        
        
        if self.sign.length == 0 {
            NSLog("没有sign");
            completionHandler("")
        }
        var path = ""
        
        uploadMgr = TXYUploadManager(cloudType: TXYCloudType.ForImage, persistenceId: "", appId: self.appId);
        if uploadMgr == nil {
            semaphore = dispatch_semaphore_create(0);
        }
        dispatch_async(queue) {[weak self] () -> Void in
            if self?.semaphore != nil {
                NSLog("开始等待获取到签名信号");
                let timer = dispatch_time(DISPATCH_TIME_NOW, Int64(15) * Int64(NSEC_PER_SEC));
                dispatch_semaphore_wait((self?.semaphore)!, timer);
                self?.semaphore = nil
                NSLog("结束等待获取到签名信号");
            }
            if self?.uploadMgr == nil {
                NSLog("不能开始上传, 万象优图上传管理器没有创建...");
                return;
            }
            //let uploadNode = TXYPhotoUploadTask(imageData: path, sign: self!.sign, bucket: self!.bucket, expiredDate: 0, msgContext: "msg", fileId: nil);
            
            let uploadNode = TXYPhotoUploadTask(imageData: data, fileName: name, sign: self!.sign, bucket: self!.bucket, expiredDate: 0, msgContext: "", fileId: nil);
            self?.uploadMgr.upload(uploadNode, complete: { (rsp: TXYTaskRsp!, context: [NSObject : AnyObject]!) -> Void in
                if let photoResp = rsp as? TXYPhotoUploadTaskRsp {
                    NSLog(photoResp.photoFileId);
                    NSLog(photoResp.photoURL);
                    path = photoResp.photoURL
                }
                }, progress: {(total: Int64, complete: Int64, context: [NSObject : AnyObject]!) -> Void in
                    NSLog("progress total:\(total) complete:\(complete)");
                }, stateChange: {(state: TXYUploadTaskState, context: [NSObject : AnyObject]!) -> Void in
                    NSLog("stateChange:\(state)");
            })
        };
        completionHandler(path)
    }
}
