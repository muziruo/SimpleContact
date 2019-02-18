//
//  GuideViewController.swift
//  SimpleContact
//
//  Created by 李祎喆 on 2018/6/13.
//  Copyright © 2018年 李祎喆. All rights reserved.
//

import UIKit

class GuideViewController: UIViewController {

    @IBOutlet weak var guideinfo: UILabel!
    @IBOutlet weak var guideimage: UIImageView!
    @IBOutlet weak var startbutton: UIButton!
    @IBOutlet weak var pagecontrol: UIPageControl!
    
    var index = 0
    var guideinfovalue:String!
    var guideimagevalue:String!
    
    @IBAction func opentheapp(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        let userdefault = UserDefaults.standard
        userdefault.set(true, forKey: "showguide")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pagecontrol.currentPage = index
        guideinfo.text = guideinfovalue
        
        guideimage.image = UIImage(named: guideimagevalue)
        startbutton.isHidden = (index != 2)
        
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
