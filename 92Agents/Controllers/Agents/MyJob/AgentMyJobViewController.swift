//
//  AgentMyJobViewController.swift
//  92Agents
//
//  Created by Apple on 05/09/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import Alamofire
import SKActivityIndicatorView

class AgentMyJobViewController: UIViewController {

    //MARK: IBOutlet and Variables
    @IBOutlet var tableView: UITableView!
    @IBOutlet var agentTableView: UITableView!
    @IBOutlet var agentView: UIView!
    @IBOutlet var btnClose: UIButton!
    @IBOutlet var lbl: UILabel!
    var myJobArr = [myJobs]()
    var get_Resp = NSArray()
    var index = NSInteger()
    var check = Bool()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //loginMethodAPI()
        self.check = false
        tableView.tableFooterView = UIView()
         myJobAPI()
    }

   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: loginAPI Methods
    func loginMethodAPI(){
        SKActivityIndicator.spinnerColor(UIColor.darkGray)
        SKActivityIndicator.show("Loading...")
        let parameters: Parameters = [
            "agents_user_id": Model.sharedInstance.userID,
            "agents_users_role_id":Model.sharedInstance.userRole,
            "selected":"2"
        ]
        print(parameters)
        
        Webservice.apiPost(apiURl:"http://92agents.com/api/state", parameters: nil, headers: nil) { (response:NSDictionary?, error:NSError?) in
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
            print(response!)
            
            if let dict = response as? [AnyHashable:Any] {
                print(dict)
                if ((dict as NSDictionary).value(forKey: "status") as? String == "100"){
                    Model.sharedInstance.accessToken = ((dict as NSDictionary).value(forKey: "access_token") as? String)!
                    
                    let tempNumber = (((dict as NSDictionary).value(forKey: "user") as! NSDictionary).value(forKey: "id") as! Int)
                    let stringTemp = String(tempNumber)
                    Model.sharedInstance.userID = stringTemp
                    let addressVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SellerDashBoardViewController") as! SellerDashBoardViewController
                    self.navigationController?.pushViewController(addressVC, animated: true)
                    
                    
                }else{
                    Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: (response?.value(forKey: "error") as! String))
                }
            }
            
        }
    }
    
    
    
    @IBAction func btnAddNewJob(_ sender: UIButton) {
        let signupVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddNewJobViewController") as! AddNewJobViewController
        self.navigationController?.pushViewController(signupVC, animated: true)
    }
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    //MARK: MyjobAPI Method
    func myJobAPI() {
        SKActivityIndicator.spinnerColor(UIColor.darkGray)
        SKActivityIndicator.show("Loading...")
        let url = URL(string: "http://92agents.com/api/agentPosts")!
        let jsonDict = [
            "agents_user_id": Model.sharedInstance.userID,
            "agents_users_role_id":Model.sharedInstance.userRole,
            "selected":"2"
            ]
        
       
        let jsonData = try! JSONSerialization.data(withJSONObject: jsonDict, options: [])
        var request = URLRequest(url: url)
        request.httpMethod = "post"
        let token = "\(Model.sharedInstance.accessToken)"
        print(token)
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("error:", error)
                return
            }
            do {
                DispatchQueue.main.async(execute: {
                    SKActivityIndicator.dismiss()
                })
                guard let data = data else { return }
                let result = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String:AnyObject]
                print(result!)
                guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] else { return }
                print("json:", json)
                self.get_Resp = (json as NSDictionary).value(forKey: "posts") as! NSArray
                print(self.get_Resp)
               
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
            } catch {
                print("error:", error)
            }
        }
        task.resume()
    }
}
extension AgentMyJobViewController: UITableViewDataSource {
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView == self.tableView)
        {
            return self.get_Resp.count
        }
        else if(tableView == self.agentTableView){
            if  self.check == true{
                self.lbl.isHidden = true
                return ((((self.get_Resp as NSArray).object(at: index) as! NSDictionary).value(forKey: "applied_agent") )as! NSArray).count
            }else{
                return 0
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //  let cell : MyJobTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as! MyJobTableViewCell
        
        var cell = AgentMyJobTableViewCell()
        if(tableView == self.tableView)
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as! AgentMyJobTableViewCell
            
            if ((self.get_Resp ).object(at: indexPath.row) as! NSDictionary).value(forKey: "posttitle")  is NSNull{
                
            }
            else{
                
                cell.lblPostTitle.text =  (((self.get_Resp ).object(at: indexPath.row) as! NSDictionary).value(forKey: "posttitle") as! String)
            }
            
            if ((self.get_Resp ).object(at: indexPath.row) as! NSDictionary).value(forKey: "details")  is NSNull{
                cell.lblDetail.text = ""
            }
            else{
                
                cell.lblDetail.text =  (((self.get_Resp ).object(at: indexPath.row) as! NSDictionary).value(forKey: "details") as! String)
            }
            //cell.lblDetail.adjustsFontSizeToFitWidth = false;
           // cell.lblDetail.lineBreakMode = NSLineBreakMode.byTruncatingTail;
            if ((self.get_Resp ).object(at: indexPath.row) as! NSDictionary).value(forKey: "created_at")  is NSNull{
                 cell.lblDate.text = ""
            }
            else{
                
                cell.lblDate.text =  (((self.get_Resp ).object(at: indexPath.row) as! NSDictionary).value(forKey: "created_at") as! String)
            }
            if ((self.get_Resp ).object(at: indexPath.row) as! NSDictionary).value(forKey: "name")  is NSNull{
                
            }
            else{
                
                cell.lblName.text =  (((self.get_Resp ).object(at: indexPath.row) as! NSDictionary).value(forKey: "name") as! String)
            }
            
            cell.lblActiveAgent.text = "1 Active Agent"
            cell.lblNewMsg.text = "New Message 0"
            cell.lblNotification.text = "New Notification 0"
        }
//        else if(tableView == self.agentTableView){
//            let cell : AgentTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as! AgentTableViewCell
//            cell.lblName.text = ((((((self.get_Resp as NSArray).object(at: index) as! NSDictionary).value(forKey: "applied_agent") )as! NSArray).object(at: indexPath.row) as! NSDictionary).value(forKey: "name") as! String)
//            cell.lblDate.text = ((((((self.get_Resp as NSArray).object(at: index) as! NSDictionary).value(forKey: "applied_agent") )as! NSArray).object(at: indexPath.row) as! NSDictionary).value(forKey: "created_at") as! String)
//            cell.lblDecription.text = ((((((self.get_Resp as NSArray).object(at: index) as! NSDictionary).value(forKey: "applied_agent") )as! NSArray).object(at: indexPath.row) as! NSDictionary).value(forKey: "description") as! String)
//            cell.lblDecription.adjustsFontSizeToFitWidth = false;
//            cell.lblDecription.lineBreakMode = NSLineBreakMode.byTruncatingTail;
//            return cell
//        }
        return cell
    }
    @objc func btnClick(sender:UIButton!){
        self.index = sender.tag
        self.agentView.isHidden = false
        self.btnClose.isHidden = false
        self.tableView.isHidden = true
        self.agentView.isHidden = true
        self.lbl.isHidden = false
        if ((((self.get_Resp as NSArray).object(at: index) as! NSDictionary).value(forKey: "applied_agent") )as! NSArray).count > 0{
            self.agentView.isHidden = false
            self.check = true
            self.agentTableView.reloadData()
        }else{
            self.agentView.isHidden = true
            self.check = false
        }
    }
    @objc func btnEditpost(sender:UIButton!){
        let signupVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EditJobViewController") as! EditJobViewController
        signupVC.editPostDict = ((self.get_Resp as NSArray).object(at: sender.tag) as! NSDictionary)
        self.navigationController?.pushViewController(signupVC, animated: true)
    }
    @objc func btnDetail(sender:UIButton!){
        
        
    }
}

extension AgentMyJobViewController: UITableViewDelegate {
    //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //        return 100
    //    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(tableView == self.tableView)
        {
            let addressVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PostDetailViewController") as! PostDetailViewController
            addressVC.PostDict = ((self.get_Resp as NSArray).object(at: indexPath.row) as! NSDictionary)
            self.navigationController?.pushViewController(addressVC, animated: true)
        }
        else if(tableView == self.agentTableView){
            let addressVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AgentDetailViewController") as! AgentDetailViewController
            addressVC.postID = ((((((self.get_Resp as NSArray).object(at: index) as! NSDictionary).value(forKey: "applied_agent") )as! NSArray).object(at: indexPath.row) as! NSDictionary).value(forKey: "post_id") as! String)
            addressVC.agentID = ((((((self.get_Resp as NSArray).object(at: index) as! NSDictionary).value(forKey: "applied_agent") )as! NSArray).object(at: indexPath.row) as! NSDictionary).value(forKey: "id") as! String)
            self.navigationController?.pushViewController(addressVC, animated: true)
        }
        
    }
}
