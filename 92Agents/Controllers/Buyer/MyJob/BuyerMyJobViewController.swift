//
//  BuyerMyJobViewController.swift
//  92Agents
//
//  Created by Apple on 09/07/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class BuyerMyJobViewController: UIViewController {

     //MARK:IBOutlet and Variables
    @IBOutlet var tableView: UITableView!
    var myJobArr = [myJobs]()
     var get_Resp = NSArray()
    
     //MARK: viewDidLoad Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        myJobAPI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    func myJobAPI() {
        //set url
        let url = URL(string: "http://92agents.com/api/buyerPosts")!
        //set params
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

                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
            } catch {
                print("error:", error)
            }
        }
        
        task.resume()
    }
    @IBAction func btnNewJob(_ sender: UIButton) {
        Model.sharedInstance.userRole = "3"
        let signupVC = UIStoryboard(name: "Buyer", bundle: nil).instantiateViewController(withIdentifier: "BuyerNewJobViewController") as! BuyerNewJobViewController
        self.navigationController?.pushViewController(signupVC, animated: true)
    }
}
extension BuyerMyJobViewController: UITableViewDataSource {
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.get_Resp.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : MyJobTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as! MyJobTableViewCell
        //"\(Model.sharedInstance.currency)\(self.product[indexPath.row].price)"
        
        if ((self.get_Resp ).object(at: indexPath.row) as! NSDictionary).value(forKey: "address1")  is NSNull {
        }
        else{
            let add = (((self.get_Resp ).object(at: indexPath.row) as! NSDictionary).value(forKey: "address1") as! String)
            let state = (((self.get_Resp ).object(at: indexPath.row) as! NSDictionary).value(forKey: "state_name") as! String)
            let city = (((self.get_Resp ).object(at: indexPath.row) as! NSDictionary).value(forKey: "city") as! String)
             let zipcode = (((self.get_Resp ).object(at: indexPath.row) as! NSDictionary).value(forKey: "zip") as! String)
             cell.lblAddress.text = "\(add) \(city)  \(state)  \(zipcode)"
        }
        if ((self.get_Resp ).object(at: indexPath.row) as! NSDictionary).value(forKey: "posttitle")  is NSNull {
        }
        else{
             cell.lblPostTitle.text = (((self.get_Resp ).object(at: indexPath.row) as! NSDictionary).value(forKey: "posttitle") as! String)
        }
        if ((self.get_Resp ).object(at: indexPath.row) as! NSDictionary).value(forKey: "details")  is NSNull {
        }
        else{
            cell.lblDetail.text = (((self.get_Resp ).object(at: indexPath.row) as! NSDictionary).value(forKey: "details") as! String)
        }
        if ((self.get_Resp ).object(at: indexPath.row) as! NSDictionary).value(forKey: "created_at")  is NSNull {
        }
        else{
            cell.lblDate.text = (((self.get_Resp ).object(at: indexPath.row) as! NSDictionary).value(forKey: "created_at") as! String)
        }
        if ((self.get_Resp ).object(at: indexPath.row) as! NSDictionary).value(forKey: "post_view_count")  is NSNull {
        }
        else{
            let agentCount = String(((self.get_Resp ).object(at: indexPath.row) as! NSDictionary).value(forKey: "post_view_count") as! NSInteger)
           // cell.btnAgentCount.text = "\(agentCount) Agents Applied"
        }
    
        return cell
    }
}

extension BuyerMyJobViewController: UITableViewDelegate {
    //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //        return 100
    //    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let addressVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PostDetailViewController") as! PostDetailViewController
        self.navigationController?.pushViewController(addressVC, animated: true)
    }
}
