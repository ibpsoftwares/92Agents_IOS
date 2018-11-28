//
//  MainViewController.swift
//  92Agents
//
//  Created by Apple on 09/10/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import ViewPager_Swift

class MainViewController: UIViewController {
    var tabs = [
        ViewPagerTab(title: "Profile", image: UIImage(named: "fries")),
        ViewPagerTab(title: "PersonalBio", image: UIImage(named: "hamburger")),
        ViewPagerTab(title: "ProfessionalBio", image: UIImage(named: "pint")),
        ]
    var viewPager:ViewPagerController!
    var options:ViewPagerOptions!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        self.title = "Awesome View pager"
        
        options = ViewPagerOptions(viewPagerWithFrame: CGRect(x: 0, y: 75, width: self.view.frame.size.width, height: self.view.frame.size.height))
        options.tabType = ViewPagerTabType.basic
        options.tabViewImageSize = CGSize(width: 20, height: 20)
        options.tabViewTextFont = UIFont.systemFont(ofSize: 16)
        options.tabViewPaddingLeft = 20
        options.tabViewPaddingRight = 20
        options.isTabHighlightAvailable = true
        
        viewPager = ViewPagerController()
        viewPager.options = options
        viewPager.dataSource = self
        viewPager.delegate = self
        
        self.addChildViewController(viewPager)
        self.view.addSubview(viewPager.view)
        viewPager.didMove(toParentViewController: self)
    }
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        options.viewPagerFrame = CGRect(x: 0, y: 75, width: self.view.frame.size.width, height: self.view.frame.size.height)
    }
}
extension MainViewController: ViewPagerControllerDataSource {
    
    func numberOfPages() -> Int {
        return tabs.count
    }
    
    func viewControllerAtPosition(position:Int) -> UIViewController {
        
        var vc = ProfileAgentViewController()
        if tabs[position].title! == "Profile" {
            vc  = UIStoryboard(name: "Agents", bundle: nil).instantiateViewController(withIdentifier: "ProfileAgentViewController") as! ProfileAgentViewController
        }
        else if tabs[position].title! == "PersonalBio" {
            let vc  = UIStoryboard(name: "Agents", bundle: nil).instantiateViewController(withIdentifier: "PersonalBioViewController") as! PersonalBioViewController
            return vc
        }
        else if tabs[position].title! == "ProfessionalBio" {
            let vc  = UIStoryboard(name: "Agents", bundle: nil).instantiateViewController(withIdentifier: "ProfessionalBioViewController") as! ProfessionalBioViewController
            return vc
        }
        return vc
    }
    
    func tabsForPages() -> [ViewPagerTab] {
        return tabs
    }
    
    func startViewPagerAtIndex() -> Int {
        return 0
    }
}

extension MainViewController: ViewPagerControllerDelegate {
    
    func willMoveToControllerAtIndex(index:Int) {
        print("Moving to page \(index)")
    }
    
    func didMoveToControllerAtIndex(index: Int) {
        print("Moved to page \(index)")
    }
}
