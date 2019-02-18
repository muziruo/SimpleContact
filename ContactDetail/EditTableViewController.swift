//
//  EditTableViewController.swift
//  SimpleContact
//
//  Created by 李祎喆 on 2018/6/26.
//  Copyright © 2018年 李祎喆. All rights reserved.
//

import UIKit
import CoreData
import SVProgressHUD

class EditTableViewController: UITableViewController {

    
    let infotitle = ["姓名","号码","邮箱","公司","地址"]
    
    var edititem:ContactsMO!
    
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    @IBAction func edit(_ sender: UIBarButtonItem) {
        let name = (view.viewWithTag(101) as! UITextField).text
        let phone = (view.viewWithTag(102) as! UITextField).text
        let email = (view.viewWithTag(103) as! UITextField).text
        let company = (view.viewWithTag(104) as! UITextField).text
        let address = (view.viewWithTag(105) as! UITextField).text
        let id = edititem.objectID
        
        if name == "" || phone == "" {
            SVProgressHUD.showInfo(withStatus: "姓名和号码为必填项")
            return
        }
        
        //修改数据并保存
        let context = self.appdelegate.persistentContainer.viewContext
        let getobject = context.object(with: id) as! ContactsMO
        getobject.contactname = name
        getobject.contactphone = phone
        getobject.contactemail = email
        getobject.contactcompany = company
        getobject.contactaddress = address
        edititem = getobject
        self.appdelegate.saveContext()
        
        performSegue(withIdentifier: "editandback", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editandback" {
            let dest = segue.destination as! DetailViewController
            dest.contactinfo = edititem
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "editcell", for: indexPath) as! EditTableViewCell

        cell.title.text = infotitle[indexPath.row]
        
        switch indexPath.row {
        case 0:
            cell.edit.tag = 101
            cell.edit.text = edititem.contactname
        case 1:
            cell.edit.text = edititem.contactphone
            cell.edit.keyboardType = .numberPad
            cell.edit.tag = 102
        case 2:
            cell.edit.text = edititem.contactemail
            cell.edit.keyboardType = .emailAddress
            cell.edit.tag = 103
        case 3:
            cell.edit.text = edititem.contactcompany
            cell.edit.tag = 104
        case 4:
            cell.edit.text = edititem.contactaddress
            cell.edit.tag = 105
        default:
            break
        }

        return cell
    }
 
    //
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UITableViewHeaderFooterView.init(frame: .zero)
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
