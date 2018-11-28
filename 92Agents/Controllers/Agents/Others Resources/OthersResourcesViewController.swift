//
//  OthersResourcesViewController.swift
//  92Agents
//
//  Created by Apple on 19/11/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import ViewPager_Swift

class OthersResourcesViewController: UIViewController {

    var tabs = [
        ViewPagerTab(title: "Proposals", image: UIImage(named: "")),
        ViewPagerTab(title: "Documents", image: UIImage(named: "")),
        ViewPagerTab(title: "Questions", image: UIImage(named: "")),
        ViewPagerTab(title: "Survey Questions", image: UIImage(named: ""))
        ]
    var viewPager:ViewPagerController!
    var options:ViewPagerOptions!
    var index = NSInteger()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        self.title = "Awesome View pager"
        index = 0
        options = ViewPagerOptions(viewPagerWithFrame: CGRect(x: 0, y: 75, width: self.view.frame.size.width, height: self.view.frame.size.height))
        options.tabType = ViewPagerTabType.basic
        options.tabViewImageSize = CGSize(width: 20, height: 20)
        options.tabViewTextFont = UIFont.systemFont(ofSize: 14)
        options.tabViewPaddingLeft = 10
        options.tabViewPaddingRight = 10
        options.isTabHighlightAvailable = true
        
        viewPager = ViewPagerController()
        viewPager.options = options
        viewPager.dataSource = self
        viewPager.delegate = self
        
        self.addChildViewController(viewPager)
        self.view.addSubview(viewPager.view)
        viewPager.didMove(toParentViewController: self)
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        options.viewPagerFrame = CGRect(x: 0, y: 75, width: self.view.frame.size.width, height: self.view.frame.size.height)
    }
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnAdd(_ sender: UIButton) {
//        var vc = ProposalsViewController()
//        if tabs[index].title! == "Proposals" {
//            vc  = UIStoryboard(name: "Agents", bundle: nil).instantiateViewController(withIdentifier: "ProposalsViewController") as! ProposalsViewController
//            vc.proposlView.isHidden = false
//        }
//        else if tabs[index].title! == "Documents" {
//            let vc  = UIStoryboard(name: "Agents", bundle: nil).instantiateViewController(withIdentifier: "UploadNewDocumentViewController") as! UploadNewDocumentViewController
//            vc.documentView.isHidden = false
//
//        }
//        else if tabs[index].title! == "Questions" {
//            let vc  = UIStoryboard(name: "Agents", bundle: nil).instantiateViewController(withIdentifier: "AgentQuestionViewController") as! AgentQuestionViewController
//            vc.questionView.isHidden = false
//        }
//        else if tabs[index].title! == "Questions" {
//            let vc  = UIStoryboard(name: "Agents", bundle: nil).instantiateViewController(withIdentifier: "AgentQuestionViewController") as! AgentQuestionViewController
//            vc.questionView.isHidden = false
//        }
    }
}
extension OthersResourcesViewController: ViewPagerControllerDataSource {
    
    func numberOfPages() -> Int {
        return tabs.count
    }
    
    func viewControllerAtPosition(position:Int) -> UIViewController {
        index = position
        var vc = ProposalsViewController()
        if tabs[position].title! == "Proposals" {
            vc  = UIStoryboard(name: "Agents", bundle: nil).instantiateViewController(withIdentifier: "ProposalsViewController") as! ProposalsViewController
        }
        else if tabs[position].title! == "Documents" {
            let vc  = UIStoryboard(name: "Agents", bundle: nil).instantiateViewController(withIdentifier: "UploadNewDocumentViewController") as! UploadNewDocumentViewController
            return vc
        }
        else if tabs[position].title! == "Survey Questions" {
            let vc  = UIStoryboard(name: "Agents", bundle: nil).instantiateViewController(withIdentifier: "SurveyQuestionViewController") as! SurveyQuestionViewController
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

extension OthersResourcesViewController: ViewPagerControllerDelegate {
    
    func willMoveToControllerAtIndex(index:Int) {
        print("Moving to page \(index)")
    }
    
    func didMoveToControllerAtIndex(index: Int) {
        print("Moved to page \(index)")
    }
}
