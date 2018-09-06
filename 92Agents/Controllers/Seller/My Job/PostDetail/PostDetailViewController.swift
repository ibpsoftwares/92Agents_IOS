//
//  PostDetailViewController.swift
//  92Agents
//
//  Created by Apple on 05/07/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import TagListView
import TagListView.Swift


class PostDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,TagListViewDelegate {

    //MARK: IBOutlet and Variables
    @IBOutlet var postOverviewTableView: UITableView!
    @IBOutlet var postOverviewHeight: NSLayoutConstraint!
    @IBOutlet var featureTableView: UITableView!
    @IBOutlet var featureTableHeight: NSLayoutConstraint!
    @IBOutlet var seletedAgentTableView: UITableView!
    @IBOutlet var seletedAgentTableHeight: NSLayoutConstraint!
    @IBOutlet var appliedAtbleView: UITableView!
    @IBOutlet var appliedTableHeight: NSLayoutConstraint!
    @IBOutlet var compareAgentTableViiew: UITableView!
    @IBOutlet var compareTableHeight: NSLayoutConstraint!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblPostedBy: UILabel!
    @IBOutlet var lblAddress: UILabel!
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var lbl1: UILabel!
    @IBOutlet var lbl2: NSLayoutConstraint!
     @IBOutlet  var tagListView: TagListView!
    @IBOutlet var lblDescription: UILabel!
    var PostDict = NSDictionary()
    let featureData = NSMutableArray()
     let overViewData = NSMutableArray()
    
        //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        seletedAgentTableHeight.constant = 471
        appliedTableHeight.constant = 412
        compareTableHeight.constant = 280
        print(PostDict)
        self.lblName.text = ((PostDict ).value(forKey: "posttitle") as! String)
        self.lblPostedBy.text = "Posted By: \(((PostDict ).value(forKey: "name") as! String))"
        if ((PostDict ).value(forKey: "state_name")) is NSNull{
            
        }
        else{
             lblAddress.text = "\(((PostDict ).value(forKey: "address1") as! String)) \(((PostDict ).value(forKey: "city") as! String))  \(((PostDict ).value(forKey: "state_name") as! String))  \(((PostDict ).value(forKey: "zip") as! String))"
        }
        if ((PostDict ).value(forKey: "details")) is NSNull{
            
        }
        else{
            lblDescription.text = ((PostDict ).value(forKey: "details") as! String)
        }
        
        if ((PostDict ).value(forKey: "best_features") as! NSDictionary).count > 0 {
            self.featureData.add(((PostDict ).value(forKey: "best_features") as! NSDictionary).value(forKey: "best_features_1") as! String)
             self.featureData.add(((PostDict ).value(forKey: "best_features") as! NSDictionary).value(forKey: "best_features_2") as! String)
             self.featureData.add(((PostDict ).value(forKey: "best_features") as! NSDictionary).value(forKey: "best_features_3") as! String)
             self.featureData.add(((PostDict ).value(forKey: "best_features") as! NSDictionary).value(forKey: "best_features_4") as! String)
            if(((PostDict ).value(forKey: "best_features") as! NSDictionary).value(forKey: "best_features_5") != nil) {
                // The key existed...
                self.featureData.add(((PostDict ).value(forKey: "best_features") as! NSDictionary).value(forKey: "best_features_5") as! String)
            }
            else {
                // No joy...
            }
        }
       
        self.lblDate.text = "\(((PostDict ).value(forKey: "created_at") as! String))"
        
        if ((PostDict ).value(forKey: "when_do_you_want_to_sell")) is NSNull{
            
        }
        else{
            
            self.overViewData.add("Want To Sell: \((PostDict ).value(forKey: "when_do_you_want_to_sell") as! String)")
        }
        if ((PostDict ).value(forKey: "need_Cash_back") as! String) == "1" {
            self.overViewData.add("Need Cash BAckand Negotiate Commision")
        }
        if ((PostDict ).value(forKey: "interested_short_sale") as! String) == "1" {
            self.overViewData.add("Interested In A short Sale")
        }
        if (PostDict ).value(forKey: "got_lender_approval_for_short_sale")  is NSNull {
            self.overViewData.add("Got Lender Approval For Short Sale")
        }
        if ((PostDict ).value(forKey: "home_type")) is NSNull{
            
        }
        else{
            self.overViewData.add((PostDict ).value(forKey: "home_type") as! String)
        }
        
        let int1: Int32 = Int32((self.overViewData.count) * 36)
        let cgfloat1 = CGFloat(int1)
         postOverviewHeight.constant = cgfloat1
        let int2: Int32 = Int32((self.overViewData.count) * 36 + 30)
        let cgfloat2 = CGFloat(int2)
        featureTableHeight.constant = cgfloat2
       
        tagListView.removeAllTags()
        tagListView.addTags([(PostDict ).value(forKey: "when_do_you_want_to_sell") as! String])
         tagListView.addTags([(PostDict ).value(forKey: "home_type") as! String])
        
//        for section in 0...(((self.get_dest ).object(at: 0) as! NSDictionary).value(forKey: "skill_data") as! NSArray).count - 1 {
//            let str = ((((self.get_dest ).object(at: indexPath.row) as! NSDictionary).value(forKey: "skill_data") as! NSArray).object(at: section) as! NSDictionary).value(forKey: "skill") as! String
//            cell.tagListView.addTags([str])
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    //MARK: UITableVIew Delegate and DataSounrce Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView == self.postOverviewTableView)
        {
             return self.overViewData.count
        }
        else if(tableView == self.featureTableView){
             return ((PostDict ).value(forKey: "best_features") as! NSDictionary).count
        }
        else if(tableView == self.seletedAgentTableView){
             return 3
        }
        else if(tableView == self.appliedAtbleView){
             return 2
        }
        else if(tableView == self.compareAgentTableViiew){
            return 2
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        var cell = postOverviewTableViewCell()
        if(tableView == self.postOverviewTableView)
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as! postOverviewTableViewCell
            cell.lblOverView.text = self.overViewData[indexPath.row] as? String
            
        }
        else if(tableView == self.featureTableView){
            let cell : featureTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as! featureTableViewCell
            cell.lblFeature.text = self.featureData[indexPath.row] as? String
            return cell
        }
        else if(tableView == self.seletedAgentTableView){
            let cell : seletedAgentTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as! seletedAgentTableViewCell
            return cell
        }
        else if(tableView == self.appliedAtbleView){
            let cell : appliedTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as! appliedTableViewCell
            return cell
        }
        else if(tableView == self.compareAgentTableViiew){
            let cell : compareAgenTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as! compareAgenTableViewCell
            return cell
        }
       return cell
    }
}
