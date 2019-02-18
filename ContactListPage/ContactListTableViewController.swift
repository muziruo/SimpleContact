//
//  ContactListTableViewController.swift
//  SimpleContact
//
//  Created by 李祎喆 on 2018/6/25.
//  Copyright © 2018年 李祎喆. All rights reserved.
//

import UIKit
import CoreData
import Contacts
import SVProgressHUD

class ContactListTableViewController: UITableViewController ,NSFetchedResultsControllerDelegate ,UISearchResultsUpdating{
    
    //搜索
    func updateSearchResults(for searchController: UISearchController) {
        if var text = searchController.searchBar.text {
            text = text.trimmingCharacters(in: .whitespaces)
            searchfilter(text: text)
            tableView.reloadData()
        }
    }
    
    //搜索
    func searchfilter(text: String) {
        searchinfo = coredatainfo.filter({ (searchresult) -> Bool in
            return searchresult.contactname!.localizedCaseInsensitiveContains(text)
        })
    }

    //数据上下文
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    
    //取出的数据
    var contacts :ContactsMO!
    var coredatainfo:[ContactsMO] = []
    
    //搜索数据
    var searchinfo:[ContactsMO] = []
    var sc:UISearchController!
    
    var fc: NSFetchedResultsController<ContactsMO>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //添加搜索
        sc = UISearchController(searchResultsController: nil)
        sc.searchResultsUpdater = self
        tableView.tableHeaderView = sc.searchBar
        sc.dimsBackgroundDuringPresentation = false
        sc.searchBar.placeholder = "输入联系人姓名以进行查询..."
        sc.searchBar.searchBarStyle = .minimal
        
        //初始化必须数据
        let userdefalut = UserDefaults.standard
        let ifpost = userdefalut.bool(forKey: "getinfofromsystem")
        
        //如果是新用户就先删除所有本地数据
        let isnew = userdefalut.bool(forKey: "isnewuser")
        if isnew {
            deleteall()
            userdefalut.set(false, forKey: "isnewuser")
        }
        
        //在第一次载入数据的时候从系统通讯录获取数据，存储到app内数据库，之后再次进入不再获取通讯录数据
        if !ifpost {
            CNContactStore().requestAccess(for: .contacts) { (issuccess, error) in
                if issuccess {
                    self.loadinfo()
                    print("1数据数量\(self.coredatainfo.count)")
                    OperationQueue.main.addOperation {
                        self.fetchinfo()
                        userdefalut.set(true, forKey: "getinfofromsystem")
                        self.tableView.reloadData()
                    }
                }else{
                    SVProgressHUD.setStatus("请在设置中给予相应的权限")
                }
            }
        }else{
            fetchinfo()
            print("数据数量\(coredatainfo.count)")
            self.tableView.reloadData()
        }
    }

    //新用户先删除所有数据
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
    
    //内存管理
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //每次出现都刷新页面
    override func viewDidAppear(_ animated: Bool) {
        fetchinfo()
        tableView.reloadData()
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    //从系统加载数据
    func loadinfo() {
        let status = CNContactStore.authorizationStatus(for: .contacts)
        guard status == .authorized else {
            SVProgressHUD.setStatus("请在设置中给予相应的权限")
            return
        }
        
        //创建通讯录数据对象并且写入需要得到的关键字
        let store = CNContactStore()
        let keys = [CNContactGivenNameKey,CNContactFamilyNameKey,CNContactPhoneNumbersKey,CNContactEmailAddressesKey,CNContactOrganizationNameKey,CNContactPostalAddressesKey,CNContactImageDataKey]
        
        let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
        
        //开始修整数据
        do {
            try store.enumerateContacts(with: request, usingBlock: { (contact, stop) in
                //将数据挨个取出，并且直接存储在数据库中
                let context = self.appdelegate.persistentContainer.viewContext
                self.contacts = ContactsMO(context: context)
                let name = contact.familyName + contact.givenName
                let phonenum = contact.phoneNumbers
                let emails = contact.emailAddresses
                let companys = contact.organizationName
                _ = contact.imageData
                
                if name != "" {
                    self.contacts.contactname = name
                }else{
                    self.contacts.contactname = ""
                }
                if phonenum != [] {
                    self.contacts.contactphone = phonenum[0].value.stringValue
                }else{
                    self.contacts.contactphone = ""
                }
                if emails != [] {
                    self.contacts.contactemail = emails[0].value as String
                }else{
                    self.contacts.contactemail = ""
                }
                if companys != "" {
                    self.contacts.contactcompany = companys
                }else{
                    self.contacts.contactcompany = ""
                }
                self.contacts.contactaddress = ""
                
                self.appdelegate.saveContext()
                print("保存成功")
            })
        } catch  {
            SVProgressHUD.showError(withStatus: "导出通讯录出错")
        }
        print("2数据数量\(coredatainfo.count)")
    }

    //从数据库中获取数据
    func fetchinfo() {
        let fetchresult:NSFetchRequest<ContactsMO> = ContactsMO.fetchRequest()
        //let sd = NSSortDescriptor(key: "contactname", ascending: true)
        fetchresult.sortDescriptors = []
        
        let context = appdelegate.persistentContainer.viewContext
        fc = NSFetchedResultsController(fetchRequest: fetchresult, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fc.delegate = self
        
        do {
            try fc.performFetch()
            if let object = fc.fetchedObjects {
                self.coredatainfo = object
                print("3数据数量\(coredatainfo.count)")
                self.sort()
            }
        } catch  {
            print("取出数据出错")
            print(error)
        }
    }
    
    //排序
    func sort() {
        let count = coredatainfo.count
        if count < 2 {
            return
        }
        for i in 0..<count - 1 {
            for j in 0..<count - i - 1 {
                var tempdata:ContactsMO
                let name1:String!
                let name2:String!
                if coredatainfo[j].contactname == "" {
                    name1 = "未命名"
                }else{
                    name1 = coredatainfo[j].contactname
                }
                if coredatainfo[j+1].contactname  == "" {
                    name2 = "未命名"
                }else{
                    name2 = coredatainfo[j+1].contactname
                }
                if sortbyalphabetic(name1: name1, name2: name2) {
                    tempdata = coredatainfo[j]
                    coredatainfo[j] = coredatainfo[j+1]
                    coredatainfo[j+1] = tempdata
                }
            }
        }
    }
    
    //本地化排序
    func sortbyalphabetic(name1:String, name2:String) -> Bool {
        let result = name1.localizedCompare(name2) == .orderedDescending
        return result
    }
    
    // MARK: - Table view data source

    //返回段落数
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    //返回行数
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return coredatainfo.count
        if sc.isActive {
            return searchinfo.count
        }else{
            return coredatainfo.count
        }
    }

    //构建各个cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactslist", for: indexPath) as! ContactListTableViewCell

        cell.contactpeopleimage.image = #imageLiteral(resourceName: "placehold")
        
        if sc.isActive {
            if searchinfo[indexPath.row].contactname != "" {
                cell.contactname.text = searchinfo[indexPath.row].contactname
            }else{
                cell.contactname.text = "未命名"
            }
            if searchinfo[indexPath.row].contactphone != "" {
                cell.contactphone.text = searchinfo[indexPath.row].contactphone
            }else{
                cell.contactphone.text = "未设置"
            }
        }else{
            if coredatainfo[indexPath.row].contactname != "" {
                cell.contactname.text = coredatainfo[indexPath.row].contactname
            }else{
                cell.contactname.text = "未命名"
            }
            if coredatainfo[indexPath.row].contactphone != "" {
                cell.contactphone.text = coredatainfo[indexPath.row].contactphone
            }else{
                cell.contactphone.text = "未设置"
            }
        }

        return cell
    }
    
    //点击后恢复视图，以及跳转
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        sc.isActive = false
        //performSegue(withIdentifier: "gotodetail", sender: nil)
    }
 
    //跳转前的数据准备
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gotodetail" {
            let dest = segue.destination as! DetailViewController
            print("跳转序列\(tableView.indexPathForSelectedRow!.row)")
            dest.hidesBottomBarWhenPushed = true
            //print("id为\(coredatainfo[tableView.indexPathForSelectedRow!.row].objectID)")
            //dest.contactinfo = coredatainfo[tableView.indexPathForSelectedRow!.row]
            dest.contactinfo = sc.isActive ? searchinfo[tableView.indexPathForSelectedRow!.row] : coredatainfo[tableView.indexPathForSelectedRow!.row]
        }
    }
    
    //侧边栏菜单
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteaction = UITableViewRowAction(style: .destructive, title: "删除") { (_, indexPath) in
            
            let notice = UIAlertController(title: "警告", message: "确定要删除该联系人？", preferredStyle: .alert)
            let action = UIAlertAction(title: "确定", style: .destructive, handler: { (action) in
                //获取ID，便于后续删除
                let id = self.coredatainfo[indexPath.row].objectID
                
                //先删除与表格绑定的数据，然后刷新表格
                print("删除\(self.coredatainfo[indexPath.row].contactname ?? "无数据")")
                self.coredatainfo.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                
                //删除数据库中对应的数据
                self.deleteobject(id: id)
            })
            let action2 = UIAlertAction(title: "取消", style: .default, handler: nil)
            notice.addAction(action)
            notice.addAction(action2)
            self.present(notice, animated: true, completion: nil)
        }
        return [deleteaction]
    }
    
    //删除数据库中对应项
    func deleteobject(id:NSManagedObjectID) {
        let context = self.appdelegate.persistentContainer.viewContext
        let getobject = context.object(with: id)
        context.delete(getobject)
        self.appdelegate.saveContext()
    }
    
    //底部留白
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UITableViewHeaderFooterView.init(frame: .zero)
    }
    
    //从详情页返回
    @IBAction func backfromdetail(segue: UIStoryboardSegue) {
        
    }
    
    //添加联系人页面返回
    @IBAction func backfromadd(segue: UIStoryboardSegue) {
        
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return !sc.isActive
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
