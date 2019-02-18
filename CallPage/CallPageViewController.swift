//
//  CallPageViewController.swift
//  SimpleContact
//
//  Created by 李祎喆 on 2018/6/18.
//  Copyright © 2018年 李祎喆. All rights reserved.
//

import UIKit
import SVProgressHUD

class CallPageViewController: UIViewController {

    @IBOutlet weak var phonenumber: UILabel!
    
    @IBAction func deletenumber(_ sender: UIButton) {
        if numberstring.count > 0 {
            numberstring.removeLast()
        }
        phonenumber.text = numberstring
    }
    
    @IBAction func call(_ sender: UIButton) {
        if numberstring == "" {
            SVProgressHUD.showInfo(withStatus: "号码为空")
            return
        }
        
        let urlstring = "telprompt://" + numberstring
        let url = URL(string: urlstring)!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @IBAction func input1(_ sender: UIButton) {
        if numberstring.count < 16 {
            switch sender.tag {
            case 1:
                numberstring += "1"
                break
            case 2:
                numberstring += "2"
                break
            case 3:
                numberstring += "3"
                break
            case 4:
                numberstring += "4"
                break
            case 5:
                numberstring += "5"
                break
            case 6:
                numberstring += "6"
                break
            case 7:
                numberstring += "7"
                break
            case 8:
                numberstring += "8"
                break
            case 9:
                numberstring += "9"
                break
            case 10:
                numberstring += "*"
                break
            case 11:
                numberstring += "0"
                break
            case 12:
                numberstring += "#"
                break
            default:
                break
            }
            phonenumber.text = numberstring
        }
    }
    
    
    var numberstring = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
