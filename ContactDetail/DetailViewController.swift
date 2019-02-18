//
//  DetailViewController.swift
//  SimpleContact
//
//  Created by 李祎喆 on 2018/6/15.
//  Copyright © 2018年 李祎喆. All rights reserved.
//

import UIKit
import SVProgressHUD

class DetailViewController: UIViewController ,UITableViewDataSource ,UITableViewDelegate{
    
    @IBOutlet weak var tableview: UITableView!
    
    @IBAction func sendmessage(_ sender: UIButton) {
        if contactinfo.contactphone == "" {
            SVProgressHUD.showError(withStatus: "没有电话号码")
            return
        }
        let urlstring = "sms://" + contactinfo.contactphone!
        let url = URL(string: urlstring)!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @IBAction func call(_ sender: UIButton) {
        if contactinfo.contactphone == "" {
            SVProgressHUD.showError(withStatus: "没有电话号码")
            return
        }
        let urlstring = "telprompt://" + contactinfo.contactphone!
        let url = URL(string: urlstring)!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactdetail", for: indexPath) as! DetailTableViewCell
        
        switch indexPath.row {
        case 0:
            if contactinfo.contactname != "" {
                cell.detailinfo.text = contactinfo.contactname
            }else{
                cell.detailinfo.text = "未命名"
            }
            break
        case 1:
            if contactinfo.contactphone != "" {
                cell.detailinfo.text = contactinfo.contactphone
            }else{
                cell.detailinfo.text = "未设置"
            }
            break
        case 2:
            if contactinfo.contactemail != "" {
                cell.detailinfo.text = contactinfo.contactemail
            }else{
                cell.detailinfo.text = "未设置"
            }
            break
        case 3:
            if contactinfo.contactcompany != "" {
                cell.detailinfo.text = contactinfo.contactcompany
            }else{
                cell.detailinfo.text = "未设置"
            }
            break
        case 4:
            if contactinfo.contactaddress != "" {
                cell.detailinfo.text = contactinfo.contactaddress
            }else{
                cell.detailinfo.text = "未设置"
            }
            break
        default:
            break
        }
        
        return cell
    }
    

    var contactinfo:ContactsMO!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableview.reloadData()
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
    
    @IBAction func backfromedit(segue:UIStoryboardSegue) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gotoedit" {
            let dest = segue.destination as! EditTableViewController
            dest.edititem = contactinfo
        }
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
