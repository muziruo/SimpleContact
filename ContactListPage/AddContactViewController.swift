//
//  AddContactViewController.swift
//  SimpleContact
//
//  Created by 李祎喆 on 2018/6/22.
//  Copyright © 2018年 李祎喆. All rights reserved.
//

import UIKit
import IQKeyboardManager
import SVProgressHUD

class AddContactViewController: UIViewController ,UITableViewDelegate ,UITableViewDataSource{
    
    let infotitle = ["姓名","号码","邮箱","公司","地址"]
    //建立delegate
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "inputinfo", for: indexPath) as! AddContactTableViewCell
        
        cell.infotitle.text = infotitle[indexPath.row]
        
        switch indexPath.row {
        case 0:
            cell.infoinput.tag = 1
        case 1:
            cell.infoinput.keyboardType = .numberPad
            cell.infoinput.tag = 2
            break
        case 2:
            cell.infoinput.keyboardType = .emailAddress
            cell.infoinput.tag = 3
            break
        case 3:
            cell.infoinput.tag = 4
        case 4:
            cell.infoinput.tag = 5
        default:
            break
        }
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //激活键盘管理
        IQKeyboardManager.shared().isEnabled = true
        
        // Do any additional setup after loading the view.
    }
    
    //添加联系人
    @IBAction func AddContacts(_ sender: UIBarButtonItem) {
        //通过tag值得到相应的控件，进而得到相应的值
        let nameinput = (view.viewWithTag(1) as! UITextField).text
        let numberinput = (view.viewWithTag(2) as! UITextField).text
        let emailimput = (view.viewWithTag(3) as! UITextField).text
        let companyinput = (view.viewWithTag(4) as! UITextField).text
        let addressinput = (view.viewWithTag(5) as! UITextField).text
        
        if nameinput != "" && numberinput != "" {
            var contact:ContactsMO
            contact = ContactsMO(context: self.appdelegate.persistentContainer.viewContext)
            contact.contactname = nameinput
            contact.contactphone = numberinput
            contact.contactemail = emailimput
            contact.contactcompany = companyinput
            contact.contactaddress = addressinput
            self.appdelegate.saveContext()
            performSegue(withIdentifier: "addandback", sender: nil)
        }else{
            SVProgressHUD.showError(withStatus: "姓名和电话号码为必填项")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UITableViewHeaderFooterView.init(frame: .zero)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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
