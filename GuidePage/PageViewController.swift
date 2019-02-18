//
//  PageViewController.swift
//  SimpleContact
//
//  Created by 李祎喆 on 2018/6/13.
//  Copyright © 2018年 李祎喆. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController ,UIPageViewControllerDataSource{
    
    let guideinfo = ["简洁、轻量化","备份，不丢失","朋友，常联系"]
    let guideimageinfo = ["guideimage","guideimage2","guideimage3"]
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! GuideViewController).index
        index = index - 1
        return vc(atIndex: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! GuideViewController).index
        index = index + 1
        return vc(atIndex: index)
    }
    
    func vc(atIndex: Int) -> GuideViewController? {
        if case 0..<guideinfo.count = atIndex{
            if let contentvc = storyboard?.instantiateViewController(withIdentifier: "Contentview") as? GuideViewController{
                contentvc.guideinfovalue = guideinfo[atIndex]
                contentvc.guideimagevalue = guideimageinfo[atIndex]
                contentvc.index = atIndex
                return contentvc
            }
        }
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        if let startvc = vc(atIndex: 0) {
            setViewControllers([startvc], direction: .forward, animated: true, completion: nil)
        }
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
