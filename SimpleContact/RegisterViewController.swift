//
//  RegisterViewController.swift
//  SimpleContact
//
//  Created by 李祎喆 on 2018/6/14.
//  Copyright © 2018年 李祎喆. All rights reserved.
//

import UIKit
import SVProgressHUD
import LeanCloud

class RegisterViewController: UIViewController {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var userpassword: UITextField!
    
    @IBAction func register(_ sender: UIButton) {
        let nameinput = username.text!
        let passwordinput = userpassword.text!
        
        if nameinput != "" && passwordinput != "" {
            if nameinput.count != 11 {
                SVProgressHUD.showError(withStatus: "请输入正确格式的手机号")
                return
            }
            SVProgressHUD.show()
            
            let newuser = LCUser()
            newuser.username = LCString(nameinput)
            newuser.password = LCString(passwordinput)
            newuser.signUp { (result) in
                switch result {
                case .success:
                    let defaults = UserDefaults.standard
                    defaults.setValue(nameinput, forKey: "username")
                    defaults.set(passwordinput, forKey: "password")
                    defaults.set(false, forKey: "getinfofromsystem")
                    defaults.set(true, forKey: "isnewuser")
                    self.performSegue(withIdentifier: "registerlogin", sender: nil)
                case .failure(let error):
                    switch error.code {
                    case 202:
                        SVProgressHUD.showInfo(withStatus: "手机号已被注册")
                    default:
                        SVProgressHUD.showInfo(withStatus: "未知错误")
                    }
                }
            }
        }else{
            shownotice(info: "请填写完整的注册信息")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //点击输入框外部隐藏键盘
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    //显示提示
    func shownotice(info:String) {
        let notice = UIAlertController(title: "提示", message: info, preferredStyle: .alert)
        let action = UIAlertAction(title: "确定", style: .default, handler: nil)
        notice.addAction(action)
        self.present(notice, animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
