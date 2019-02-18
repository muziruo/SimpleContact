//
//  ViewController.swift
//  SimpleContact
//
//  Created by 李祎喆 on 2018/6/13.
//  Copyright © 2018年 李祎喆. All rights reserved.
//

import UIKit
import SVProgressHUD
import LeanCloud

class ViewController: UIViewController ,UITextFieldDelegate{

    @IBOutlet weak var nameinput: UITextField!
    @IBOutlet weak var passwordinput: UITextField!
    
    @IBAction func login(_ sender: UIButton) {
        //performSegue(withIdentifier: "loginsuccess", sender: nil)

        let username = nameinput.text!
        let password = passwordinput.text!
        if username != "" && password != "" {
            if username.count != 11 {
                SVProgressHUD.showError(withStatus: "请输入正确的号码格式")
                return
            }
            SVProgressHUD.show(withStatus: "正在登录")
            LCUser.logIn(username: username, password: password) { (result) in
                switch result {
                case .success( _):
                    SVProgressHUD.dismiss()
                    let userdefault = UserDefaults.standard
                    userdefault.setValue(username, forKey: "username")
                    userdefault.setValue(password, forKey: "password")
                    self.performSegue(withIdentifier: "loginsuccess", sender: nil)
                case .failure(let error):
                    SVProgressHUD.dismiss()
                    switch error.code {
                    case 211:
                        SVProgressHUD.showInfo(withStatus: "找不到用户")
                    case 210:
                        SVProgressHUD.showInfo(withStatus: "手机号和密码不匹配")
                    default:
                        SVProgressHUD.showInfo(withStatus: "网络出错，请重新输入手机号和密码")
                    }
                }
            }
        }else{
            SVProgressHUD.showInfo(withStatus: "请输入完整登录信息")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        let name = defaults.object(forKey: "username")
        let password = defaults.object(forKey: "password")
        //如果有数据就自动登录
        if name != nil && password != nil {
            autologin(loginname: name as! String, loginpassword: password as! String)
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //自动登录
    func autologin(loginname:String , loginpassword:String) {
        SVProgressHUD.show(withStatus: "自动登录中...")
        LCUser.logIn(username: loginname, password: loginpassword) { (result) in
            switch result {
            case .success(_):
                SVProgressHUD.dismiss()
                self.performSegue(withIdentifier: "loginsuccess", sender: nil)
            case .failure(let error):
                SVProgressHUD.dismiss()
                switch error.code {
                case 211:
                    SVProgressHUD.showInfo(withStatus: "找不到用户,请重新输入手机号和密码进行登录")
                case 210:
                    SVProgressHUD.showInfo(withStatus: "手机号和密码不匹配，请重新输入手机号和密码进行登录")
                default:
                    SVProgressHUD.showInfo(withStatus: "请重新输入手机号密码进行登录")
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //清空登录信息
        nameinput.text = ""
        passwordinput.text = ""
        
        //判断引导页是否已经显示过了
        let defaults = UserDefaults.standard
        if defaults.bool(forKey: "showguide") {
            return
        }
        //显示引导页
        if let pagevc = storyboard?.instantiateViewController(withIdentifier: "GuideController") as? PageViewController{
            present(pagevc, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //点击输入框外部隐藏键盘
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func closefromregister(sugue: UIStoryboardSegue) {
        
    }
    
    //显示提示
    func shownotice(info:String) {
        let notice = UIAlertController(title: "提示", message: info, preferredStyle: .alert)
        let action = UIAlertAction(title: "确定", style: .default, handler: nil)
        notice.addAction(action)
        present(notice, animated: true, completion: nil)
    }
}

