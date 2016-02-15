//
//  LoginViewController.swift
//  FeelingClient
//
//  Created by vincent on 13/2/16.
//  Copyright © 2016 xecoder. All rights reserved.
//

import UIKit
import IBAnimatable
import SwiftyJSON
import Alamofire

class LoginViewController: DesignableViewController,UITextFieldDelegate {
    
    @IBOutlet var username: AnimatableTextField!
    @IBOutlet var password: AnimatableTextField!
    
    let jwt = JWTTools()
    var actionButton: ActionButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image = UIImage(named: "lonely-children")
        let blurredImage = image!.imageByApplyingBlurWithRadius(3)
        self.view.layer.contents = blurredImage.CGImage
        
        let register = ActionButtonItem(title: "注册帐号", image: UIImage(named: "new")!)
        register.action = { item in  }
        let forget = ActionButtonItem(title: "忘记密码", image: UIImage(named: "new")!)
        forget.action = { item in }
        let wechatLogin = ActionButtonItem(title: "微信登录", image: UIImage(named: "wechat")!)
        wechatLogin.action = { item in   }
        let qqLogin = ActionButtonItem(title: "QQ登录", image: UIImage(named: "qq")!)
        qqLogin.action = { item in }
        let weiboLogin = ActionButtonItem(title: "微博登录", image: UIImage(named: "weibo")!)
        weiboLogin.action = { item in  }
        let taobaoLogin = ActionButtonItem(title: "淘宝登录", image: UIImage(named: "taobao")!)
        taobaoLogin.action = { item in
            //            self.showWalkthrough()
        }
        actionButton = ActionButton(attachedToView: self.view, items: [register, forget, wechatLogin, qqLogin, weiboLogin, taobaoLogin])
        actionButton.action = { button in button.toggleMenu() }
        actionButton.setImage(UIImage(named: "new"), forState: .Normal)
        actionButton.backgroundColor = UIColor.lightGrayColor()
        
        username.delegate = self
        password.delegate = self
        
        
    }
    
    
    override func textFieldShouldReturn(textField: UITextField) -> Bool {
        if (textField === username) {
            password.becomeFirstResponder()
        } else if (textField === password) {
            password.resignFirstResponder()
            self.login(self)
        } else {
            // etc
        }
        
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func login(sender: AnyObject) {
        
        if username.text != "" && password.text != ""
        {
            //123456789001
            //123456
            let userNameText = username.text
            let passwordText = password.text!.md5()
            NetApi().getResult(Alamofire.Method.POST,params: ["username": userNameText!,"password":passwordText,"device":"APP"]) {
                responseObject, error in
                //print("responseObject = \(responseObject); error = \(error)")
                if let json = responseObject {
                    let myJosn = JSON(json)
                    let code:Int = Int(myJosn["status"].stringValue)!
                    if code != 200 {
                        self.view.makeToast(myJosn.dictionary!["detail"]!.stringValue, duration: 2, position: .Top)                        
                    }
                    else{
                        self.jwt.token = myJosn.dictionary!["token"]!.stringValue
                        self.view.makeToast("登陆成功", duration: 1, position: .Top)
                        self.performSegueWithIdentifier("login", sender: self)
                    }
                }
            }
            
        }
        else
        {
            //self.alertStatusBarMsg("帐号或密码为空");
            self.view.makeToast("帐号或密码为空", duration: 2, position: .Top)
        }
        
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if !jwt.token.isEmpty {
        //    self.performSegueWithIdentifier("login", sender: self)
        }
        
    }
    
    
}
