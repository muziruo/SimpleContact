//
//  UserInfoViewController.swift
//  SimpleContact
//
//  Created by 李祎喆 on 2018/6/14.
//  Copyright © 2018年 李祎喆. All rights reserved.
//

import UIKit
import SVProgressHUD
import LeanCloud
import CoreData

class UserInfoViewController: UIViewController ,UITableViewDataSource ,UITableViewDelegate ,NSFetchedResultsControllerDelegate{
    
    @IBOutlet weak var userimage: UIImageView!
    @IBOutlet weak var usernamelabel: UILabel!
    
    //必要数据初始化
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    var fc: NSFetchedResultsController<ContactsMO>!
    
    //列表数据
    let functionname = ["备份通讯录","下载通讯录","反馈"]
    let functionimage = ["upload","download","feedback"]
    
    //通讯录数据
    var contactinfo: [ContactsMO]!
    var contacts :ContactsMO!
    
    //网络数据
    var cloudinfo:[LCObject] = []
    
    //数据库名称
    var cloudname:String!
    
    //注销
    @IBAction func logout(_ sender: UIButton) {
        let notice = UIAlertController(title: "警告", message: "注销将回到登录页面", preferredStyle: .alert)
        let action = UIAlertAction(title: "确定", style: .destructive) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        let actioncanel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        notice.addAction(action)
        notice.addAction(actioncanel)
        present(notice, animated: true, completion: nil)
    }
    
    //三个cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    //构建每一个cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "functionlist", for: indexPath) as! FunctionListTableViewCell
        
        cell.functionimage.image = UIImage(named: functionimage[indexPath.row])
        cell.functionname.text = functionname[indexPath.row]
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let defaults = UserDefaults.standard
        let namestring = defaults.string(forKey: "username")
        cloudname = "c" + namestring!
        
        //调试信息
        print("数据库名称锁定为\(cloudname!)")
        
        usernamelabel.text = namestring!
        // Do any additional setup after loading the view.
    }

    //内存管理
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //表格底部视图
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UITableViewHeaderFooterView.init(frame: .zero)
    }
    
    //点击事件
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            let notice = UIAlertController(title: "警告", message: "确定将本地通讯录信息上传，云端数据将会被当前本地数据替换", preferredStyle: .alert)
            let action = UIAlertAction(title: "确定", style: .destructive) { (action) in
                //print("共计需上传\(self.contactinfo.count)个数据")
                self.getinfo()
                self.searchdeleteclouddata()
            }
            let action2 = UIAlertAction(title: "取消", style: .default, handler: nil)
            notice.addAction(action)
            notice.addAction(action2)
            present(notice, animated: true, completion: nil)
        case 1:
            let notice = UIAlertController(title: "警告", message: "下载通讯录将会覆盖当前本地通讯录，是否继续", preferredStyle: .alert)
            let action = UIAlertAction(title: "确定", style: .destructive) { (action) in
                self.download()
            }
            let action2 = UIAlertAction(title: "取消", style: .default, handler: nil)
            notice.addAction(action)
            notice.addAction(action2)
            present(notice, animated: true, completion: nil)
        case 2:
            let url = URL(string: "mailto://muziruo.com@gmail.com")!
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        default:
            break
        }
    }
    
    //先查询出要删除的云端数据
    func searchdeleteclouddata() {
        SVProgressHUD.show(withStatus: "正在整理云端信息")
        let deletequery = LCQuery(className: cloudname)
        deletequery.find { (result) in
            switch result {
            case .success(let resultobject):
                SVProgressHUD.dismiss()
                self.cloudinfo = resultobject
                self.deletecloudata()
            case .failure(let error):
                switch error.code {
                case 101:
                    SVProgressHUD.dismiss()
                    self.upload()
                default:
                    SVProgressHUD.dismiss()
                    SVProgressHUD.showError(withStatus: "云端数据清理出错")
                }
            }
        }
    }
    
    //云端数据的删除
    func deletecloudata() {
        SVProgressHUD.show(withStatus: "正在整理云端信息")
        for object in cloudinfo {
            let delete = LCObject(className: cloudname, objectId: object.objectId!)
            delete.delete()
        }
        SVProgressHUD.dismiss()
        upload()
    }
    
    //删除coredata中的所有数据，为下载数据作准备
    func deleteall() {
        let context = appdelegate.persistentContainer.viewContext
        
        let deletefetch = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Contacts")
        deletefetch.returnsObjectsAsFaults = false
        
        do {
            let result = try context.fetch(deletefetch)
            for managedobject in result {
                let manageobjectdata:NSManagedObject = managedobject as! NSManagedObject
                context.delete(manageobjectdata)
            }
            self.appdelegate.saveContext()
        } catch let error as NSError {
            print("删除\(error.userInfo)")
        }
    }
    
    //从云端下载数据
    func download() {
        SVProgressHUD.show(withStatus: "正在下载同步")
        let query = LCQuery(className: cloudname)
        
        query.find { (result) in
            switch result {
            case .success(let object):
                SVProgressHUD.dismiss()
                self.cloudinfo = object
                self.deleteall()
                self.saveinfo()
                SVProgressHUD.showInfo(withStatus: "同步完毕")
            case .failure( _):
                SVProgressHUD.dismiss()
                SVProgressHUD.showError(withStatus: "同步发生错误，请确保进行过云端备份")
            }
        }
    }
    
    //保存数据到数据库
    func saveinfo() {
        for infos in cloudinfo {
            let context = appdelegate.persistentContainer.viewContext
            self.contacts = ContactsMO(context: context)
            if infos.value(forKey: "name") != nil {
                self.contacts.contactname = infos.get("name")?.stringValue
            }else{
                self.contacts.contactname = ""
            }
            if infos.value(forKey: "phone") != nil {
                self.contacts.contactphone = infos.get("phone")?.stringValue
            }else{
                self.contacts.contactphone = ""
            }
            if infos.value(forKey: "email") != nil {
                self.contacts.contactemail = infos.get("email")?.stringValue
            }else{
                self.contacts.contactemail = ""
            }
            if infos.value(forKey: "company") != nil {
                self.contacts.contactcompany = infos.get("company")?.stringValue
            }else{
                self.contacts.contactcompany = ""
            }
            if infos.value(forKey: "address") != nil {
                self.contacts.contactaddress = infos.get("address")?.stringValue
            }else{
                self.contacts.contactaddress = ""
            }
            self.appdelegate.saveContext()
        }
    }
    
    //上传数据
    func upload() {
        SVProgressHUD.show(withStatus: "正在上传")
        let sumnumber = contactinfo.count
        var count = 0
        for contact in contactinfo {
            let contactlist = LCObject(className: cloudname)
            contactlist.set("name", value: contact.contactname!)
            contactlist.set("phone", value: contact.contactphone!)
            contactlist.set("email", value: contact.contactemail!)
            contactlist.set("company", value: contact.contactcompany!)
            contactlist.set("address", value: contact.contactaddress!)
            
            //云端存储
            if (contactlist.save()).isSuccess {
                count += 1
            }
        }
        SVProgressHUD.dismiss()
        SVProgressHUD.showInfo(withStatus: "上传完成,\(count)成功,\(sumnumber - count)失败")
    }
    
    //取出数据库数据
    func getinfo() {
        let fetchresult:NSFetchRequest<ContactsMO> = ContactsMO.fetchRequest()
        fetchresult.sortDescriptors = []
        
        let context = appdelegate.persistentContainer.viewContext
        fc = NSFetchedResultsController(fetchRequest: fetchresult, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fc.delegate = self
        
        do {
            try fc.performFetch()
            if let object = fc.fetchedObjects {
                self.contactinfo = object
                print("3数据数量\(contactinfo.count)")
            }
        } catch  {
            print("取出数据出错")
            print(error)
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
