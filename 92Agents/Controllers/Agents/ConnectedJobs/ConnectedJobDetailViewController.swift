//
//  ConnectedJobDetailViewController.swift
//  92Agents
//
//  Created by Apple on 03/10/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import Alamofire
import SKActivityIndicatorView

class ConnectedJobDetailViewController: UIViewController {

    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblExp: UILabel!
    @IBOutlet var lblPostName: UILabel!
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var lblAddress: UILabel!
    @IBOutlet var lblDescription: UILabel!
    @IBOutlet var lblAddBookmark: UILabel!
    @IBOutlet var tableViewHomeType: UITableView!
    @IBOutlet var tableViewHeight: NSLayoutConstraint!
    @IBOutlet var tableViewBestFeatures: UITableView!
     @IBOutlet  var tagListView: TagListView!
    var postID = String()
     let featureData = NSMutableArray()
     let overViewData = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        agentDetailAPI()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - FindAgentAPI Method
    func agentDetailAPI(){
        SKActivityIndicator.spinnerColor(UIColor.darkGray)
        SKActivityIndicator.show("Loading...")
        let parameters: Parameters = [
            "agents_user_id": Model.sharedInstance.userID,
            "agents_users_role_id":Model.sharedInstance.userRole,
            "post_id": postID
        ]
        print(parameters)
        
        Webservice.apiPost1(apiURl:  "http://92agents.com/api/getPostDetails", parameters: parameters, headers: nil) { (response:[String : Any], error:NSError?) in
            if error != nil {
                print(error?.localizedDescription as Any)
                DispatchQueue.main.async(execute: {
                    SKActivityIndicator.dismiss()
                })
                Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: "Login Failed.Try Again..")
                return
                
            }
            DispatchQueue.main.async(execute: {
                SKActivityIndicator.dismiss()
            })
            print(response)
            
            if let dict = response as? [AnyHashable:Any] {
                print(dict)
                if ((dict as NSDictionary).value(forKey: "status") as? String == "100"){
                    
                    DispatchQueue.main.async(execute: {
                        self.lblName.text = ((((dict as NSDictionary).value(forKey: "response") as! NSDictionary).value(forKey: "post") as! NSDictionary).value(forKey: "posttitle") as! String)
                        self.lblDate.text = ((((dict as NSDictionary).value(forKey: "response") as! NSDictionary).value(forKey: "post") as! NSDictionary).value(forKey: "created_at") as! String)
                        
                        
                        var zip = String()
                        if (((dict as NSDictionary).value(forKey: "response") as! NSDictionary).value(forKey: "post") as! NSDictionary).value(forKey: "zip") is NSNull{
                            
                        }
                        else{
                           zip = (((dict as NSDictionary).value(forKey: "response") as! NSDictionary).value(forKey: "post") as! NSDictionary).value(forKey: "zip") as! String
                        }
                        
                        let state = (((dict as NSDictionary).value(forKey: "response") as! NSDictionary).value(forKey: "post") as! NSDictionary).value(forKey: "state_name") as! String
                        let city = (((dict as NSDictionary).value(forKey: "response") as! NSDictionary).value(forKey: "post") as! NSDictionary).value(forKey: "city_name") as! String
                        
                        self.lblAddress.text = "\(city) \(state) \(zip)"
                        self.lblPostName.text = "Posted By: \((((dict as NSDictionary).value(forKey: "response") as! NSDictionary).value(forKey: "post") as! NSDictionary).value(forKey: "name") as! String)"
                        
                        self.tagListView.removeAllTags()
                        
                        if ((((dict as NSDictionary).value(forKey: "response") as! NSDictionary).value(forKey: "post") as! NSDictionary).value(forKey: "best_features") as! NSDictionary).count > 0 {
                            self.featureData.add(((((dict as NSDictionary).value(forKey: "response") as! NSDictionary).value(forKey: "post") as! NSDictionary).value(forKey: "best_features") as! NSDictionary).value(forKey: "best_features_1") as! String)
                            self.featureData.add(((((dict as NSDictionary).value(forKey: "response") as! NSDictionary).value(forKey: "post") as! NSDictionary).value(forKey: "best_features") as! NSDictionary).value(forKey: "best_features_2") as! String)
                             self.featureData.add(((((dict as NSDictionary).value(forKey: "response") as! NSDictionary).value(forKey: "post") as! NSDictionary).value(forKey: "best_features") as! NSDictionary).value(forKey: "best_features_3") as! String)
                             self.featureData.add(((((dict as NSDictionary).value(forKey: "response") as! NSDictionary).value(forKey: "post") as! NSDictionary).value(forKey: "best_features") as! NSDictionary).value(forKey: "best_features_4") as! String)
                            if(((((dict as NSDictionary).value(forKey: "response") as! NSDictionary).value(forKey: "post") as! NSDictionary).value(forKey: "best_features") as! NSDictionary).value(forKey: "best_features_5") != nil) {
                                // The key existed...
                                self.featureData.add(((((dict as NSDictionary).value(forKey: "response") as! NSDictionary).value(forKey: "post") as! NSDictionary).value(forKey: "best_features") as! NSDictionary).value(forKey: "best_features_5") as! String)
                            }
                            else {
                                // No joy...
                            }
                        }
                        
                        if (((dict as NSDictionary).value(forKey: "response") as! NSDictionary).value(forKey: "post") as! NSDictionary).value(forKey: "when_do_you_want_to_sell") is NSNull{
                            
                        }
                        else{
                            
                            self.overViewData.add("Want To Sell: \((((dict as NSDictionary).value(forKey: "response") as! NSDictionary).value(forKey: "post") as! NSDictionary).value(forKey: "when_do_you_want_to_sell") as! String)")
                            self.tagListView.addTags(["Sell \((((dict as NSDictionary).value(forKey: "response") as! NSDictionary).value(forKey: "post") as! NSDictionary).value(forKey: "when_do_you_want_to_sell") as! String)"])
                        }
                        if ((((dict as NSDictionary).value(forKey: "response") as! NSDictionary).value(forKey: "post") as! NSDictionary).value(forKey: "need_Cash_back") as! String) == "1" {
                            self.overViewData.add("need_Cash_back")
                        }
                        if (((dict as NSDictionary).value(forKey: "response") as! NSDictionary).value(forKey: "post") as! NSDictionary).value(forKey: "interested_short_sale") is NSNull {
                            
                        }
                        else{
                            self.overViewData.add("Interested In A short Sale")
                        }
                        if (((dict as NSDictionary).value(forKey: "response") as! NSDictionary).value(forKey: "post") as! NSDictionary).value(forKey: "got_lender_approval_for_short_sale")  is NSNull {
                            self.overViewData.add("Got Lender Approval For Short Sale")
                        }
                        if (((dict as NSDictionary).value(forKey: "response") as! NSDictionary).value(forKey: "post") as! NSDictionary).value(forKey: "home_type") is NSNull{
                            
                        }
                        else{
                            self.overViewData.add((((dict as NSDictionary).value(forKey: "response") as! NSDictionary).value(forKey: "post") as! NSDictionary).value(forKey: "home_type") as! String)
                            self.tagListView.addTags([(((dict as NSDictionary).value(forKey: "response") as! NSDictionary).value(forKey: "post") as! NSDictionary).value(forKey: "home_type") as! String])
                        }
                        
                        DispatchQueue.main.async(execute: {
                            self.tableViewBestFeatures.reloadData()
                            self.tableViewHomeType.reloadData()
                        })
                      
                        
                    })
                    
                }else{
                    //Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: (response?.value(forKey: "error") as! String))
                }
            }
        }
    }
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

}
extension ConnectedJobDetailViewController: UITableViewDataSource {
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableViewHomeType{
            return self.overViewData.count
        }
        else  if tableView == tableViewBestFeatures  {
             return featureData.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell1 = featureTableViewCell()
        if tableView == self.tableViewBestFeatures{
             cell1  = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as! featureTableViewCell
             cell1.lblFeature.text = self.featureData[indexPath.row] as? String
        }
        else  if tableView == tableViewHomeType  {
            let cell : featureTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as! featureTableViewCell
            cell.lblFeature.text = self.featureData[indexPath.row] as? String
            return cell
        }
        return cell1
    }
}

extension ConnectedJobDetailViewController: UITableViewDelegate {
    //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //        return 100
    //    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
}
