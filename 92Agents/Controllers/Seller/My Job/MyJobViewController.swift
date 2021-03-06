//
//  MyJobViewController.swift
//  92Agents
//
//  Created by Apple on 29/06/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

//MARK: Class
class myJobs {
    var add: String
    var city : String
    var state : String
    var zipcode : String
    var posttitle : String
    var propertyDetail : String
    var postViewCount : NSInteger
    var date : String
    init(add: String,city : String,state : String,zipcode: String,posttitle: String,propertyDetail: String,postViewCount: NSInteger,date: String) {
        self.add = add
        self.city = city
        self.state = state
        self.zipcode = state
        self.posttitle = posttitle
        self.propertyDetail = propertyDetail
        self.postViewCount = postViewCount
        self.date = date
    }
}
class MyJobViewController: UIViewController {

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
    
        //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        myJobAPI()
        self.agentView.isHidden = true
         self.btnClose.isHidden = true
        self.check = false
        tableView.tableFooterView = UIView()
        agentTableView.tableFooterView = UIView()
    }

    @IBAction func closeBtn(_ sender: UIButton) {
        self.agentView.isHidden = true
        self.btnClose.isHidden = true
        self.tableView.isHidden = false
         self.check = false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        let url = URL(string: "http://92agents.com/api/buyerPosts")!
        let jsonDict = [
            "agents_user_id": Model.sharedInstance.userID,
            "agents_users_role_id":Model.sharedInstance.userRole,
            ]
        let jsonData = try! JSONSerialization.data(withJSONObject: jsonDict, options: [])
        
        var request = URLRequest(url: url)
        request.httpMethod = "post"
        let token = "\(Model.sharedInstance.accessToken)"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("error:", error)
                return
            }
            do {
                guard let data = data else { return }
                guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] else { return }
                print("json:", json)
                self.get_Resp = (json as NSDictionary).value(forKey: "posts") as! NSArray
                print(self.get_Resp)
                for item in (json as NSDictionary).value(forKey: "posts") as! NSArray {
                    print(item)
                    if (item as! NSDictionary).value(forKey: "state_name")  is NSNull {
                       self.myJobArr.append(myJobs.init(add: (item as! NSDictionary).value(forKey: "address1") as! String, city: (item as! NSDictionary).value(forKey: "city") as! String, state: "", zipcode: (item as! NSDictionary).value(forKey: "zip") as! String, posttitle: (item as! NSDictionary).value(forKey: "posttitle") as! String, propertyDetail: (item as! NSDictionary).value(forKey: "details") as! String, postViewCount: (item as! NSDictionary).value(forKey: "post_view_count") as! NSInteger, date: (item as! NSDictionary).value(forKey: "created_at") as! String))
                    }
                    else{
                       self.myJobArr.append(myJobs.init(add: (item as! NSDictionary).value(forKey: "address1") as! String, city: (item as! NSDictionary).value(forKey: "city") as! String, state: (item as! NSDictionary).value(forKey: "state_name") as! String, zipcode: (item as! NSDictionary).value(forKey: "zip") as! String, posttitle: (item as! NSDictionary).value(forKey: "posttitle") as! String, propertyDetail: (item as! NSDictionary).value(forKey: "details") as! String, postViewCount: (item as! NSDictionary).value(forKey: "post_view_count") as! NSInteger, date: (item as! NSDictionary).value(forKey: "created_at") as! String))
                    }
                }
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
extension MyJobViewController: UITableViewDataSource {
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView == self.tableView)
        {
            return self.myJobArr.count
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
        
        var cell = MyJobTableViewCell()
        if(tableView == self.tableView)
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as! MyJobTableViewCell
            cell.lblPostTitle.text = self.myJobArr[indexPath.row].posttitle
            cell.lblAddress.text = "\(self.myJobArr[indexPath.row].add) \(self.myJobArr[indexPath.row].city)  \(self.myJobArr[indexPath.row].state)  \(self.myJobArr[indexPath.row].zipcode)"
            cell.lblDetail.text = self.myJobArr[indexPath.row].propertyDetail
            cell.lblDetail.adjustsFontSizeToFitWidth = false;
            cell.lblDetail.lineBreakMode = NSLineBreakMode.byTruncatingTail;
            cell.lblDate.text = self.myJobArr[indexPath.row].date
            let agentCount = String(self.myJobArr[indexPath.row].postViewCount)
            cell.btnAgentCount.setTitle("\(agentCount) Agents Applied", for: .normal)
            cell.btnAgentCount.tag = indexPath.row
            cell.btnAgentCount.addTarget(self,action:#selector(btnClick(sender:)), for: .touchUpInside)
            cell.btnEditPost.tag = indexPath.row
            cell.btnEditPost.addTarget(self,action:#selector(btnEditpost(sender:)), for: .touchUpInside)
            cell.btnDetail.tag = indexPath.row
            cell.btnDetail.addTarget(self,action:#selector(btnDetail(sender:)), for: .touchUpInside)
        }
        else if(tableView == self.agentTableView){
            let cell : AgentTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as! AgentTableViewCell
            cell.lblName.text = ((((((self.get_Resp as NSArray).object(at: index) as! NSDictionary).value(forKey: "applied_agent") )as! NSArray).object(at: indexPath.row) as! NSDictionary).value(forKey: "name") as! String)
            cell.lblDate.text = ((((((self.get_Resp as NSArray).object(at: index) as! NSDictionary).value(forKey: "applied_agent") )as! NSArray).object(at: indexPath.row) as! NSDictionary).value(forKey: "created_at") as! String)
            cell.lblDecription.text = ((((((self.get_Resp as NSArray).object(at: index) as! NSDictionary).value(forKey: "applied_agent") )as! NSArray).object(at: indexPath.row) as! NSDictionary).value(forKey: "description") as! String)
            cell.lblDecription.adjustsFontSizeToFitWidth = false;
            cell.lblDecription.lineBreakMode = NSLineBreakMode.byTruncatingTail;
            return cell
        }
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

extension MyJobViewController: UITableViewDelegate {
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

