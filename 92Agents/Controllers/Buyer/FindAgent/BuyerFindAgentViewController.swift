//
//  BuyerFindAgentViewController.swift
//  92Agents
//
//  Created by Apple on 09/07/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import Alamofire
import SKActivityIndicatorView

class BuyerFindAgentViewController: UIViewController {

     //MARK: IBOutlet and Variables
    @IBOutlet var tableView: UITableView!
    @IBOutlet var textName: UITextField!
    @IBOutlet var textDate: UITextField!
    @IBOutlet var textAddress: UITextField!
    @IBOutlet var textState: UITextField!
    @IBOutlet var textCity: UITextField!
    @IBOutlet var tableViewHeight: NSLayoutConstraint!
    @IBOutlet var textZipcode: UITextField!
    var findAgentArr = [FindAgent]()
    var get_dest = NSArray()
    var searchArr = NSArray()
  
     //MARK: viewDidLoad Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //call method
          FindAgentAPI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    // MARK: - FindAgentAPI Methods
    func FindAgentAPI(){
        //set params
        let parameters: Parameters = [
            "searchinputtype": "name",
            "agents_users_role_id": "4",
            "date": "",
            "city": "",
            "state": "",
            "zipcodes": "",
            "pricerange": "",
            "address": "",
            "keyword": ""
        ]
        print(parameters)
        
        Webservice.apiPost1(apiURl:  "http://92agents.com/api/searchAgentsList", parameters: parameters, headers: nil) { (response:[String : Any], error:NSError?) in
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
            //            if  response as? [AnyHashable:Any] is NSNull{
            //
            //            }
            if let dict = response as? [AnyHashable:Any] {
                print(dict)
                if ((dict as NSDictionary).value(forKey: "status") as? String == "100"){
                    
                    self.get_dest = (dict as NSDictionary).value(forKey: "response") as! NSArray
                    
                    DispatchQueue.main.async(execute: {
                        let int1: Int32 = Int32((self.get_dest.count) * 188 )
                        let cgfloat1 = CGFloat(int1)
                        self.tableViewHeight.constant = cgfloat1
                        self.tableView.reloadData()
                        
                    })
                }else{
                    //Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: (response?.value(forKey: "error") as! String))
                }
            }
            
        }
    }
    
    @IBAction func btnSearch(_ sender: UIButton) {
        searchAgent()
    }
    // MARK: - searchAgent
    func searchAgent(){
        
        //set params
        let parameters: Parameters = [
            "searchinputtype": "name",
            "agents_users_role_id": "4",
            "date": self.textDate.text!,
            "city": self.textCity.text!,
            "state": self.textState.text!,
            "zipcodes": self.textZipcode.text!,
            "pricerange": "",
            "address": self.textAddress.text!,
            "keyword": self.textName.text!
        ]
        print(parameters)
        
        Webservice.apiPost1(apiURl:  "http://92agents.com/api/searchAgentsList", parameters: parameters, headers: nil) { (response:[String : Any], error:NSError?) in
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
                if  (dict as NSDictionary).value(forKey: "response") is NSNull{
                    print("Response is null")
                    
                    self.FindAgentAPI()
                }
                else{
                    
                    if ((dict as NSDictionary).value(forKey: "status") as? String == "100"){
                        
                        self.get_dest = (dict as NSDictionary).value(forKey: "response") as! NSArray
                        
                        DispatchQueue.main.async(execute: {
                            let int1: Int32 = Int32((self.get_dest.count) * 188 )
                            let cgfloat1 = CGFloat(int1)
                            self.tableViewHeight.constant = cgfloat1
                            self.tableView.reloadData()
                            
                        })
                    }else{
                        //Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: (response?.value(forKey: "error") as! String))
                    }
                }
                
            }
            
        }
    }

}

extension BuyerFindAgentViewController: UITableViewDataSource {
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.get_dest.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : FindAgentTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as! FindAgentTableViewCell
        self.tableView.beginUpdates()
        self.tableView.reloadSections(NSIndexSet(index: 1) as IndexSet, with: UITableViewRowAnimation.none)
        self.tableView.endUpdates()
        if (cell == nil)
        {
            
        }
        else{
            
            cell.lblName.text = (((self.get_dest ).object(at: indexPath.row) as! NSDictionary).value(forKey: "name") as! String)
            
            if (((self.get_dest ).object(at: indexPath.row) as! NSDictionary).value(forKey: "login_status") as! String) == "Online"{
                cell.lblOnlineStatus.backgroundColor = UIColor.green
                cell.lblOnlineStatus.layer.cornerRadius = cell.lblOnlineStatus.frame.size.height / 2
                cell.lblOnlineStatus.clipsToBounds = true
            }
            else{
                cell.lblOnlineStatus.backgroundColor = UIColor.red
                cell.lblOnlineStatus.layer.cornerRadius = cell.lblOnlineStatus.frame.size.height / 2
                cell.lblOnlineStatus.clipsToBounds = true
            }
           // cell.lblOnlineStatus.text = (((self.get_dest ).object(at: indexPath.row) as! NSDictionary).value(forKey: "login_status") as! String)
            if ((self.get_dest ).object(at: indexPath.row) as! NSDictionary).value(forKey: "city_name")  is NSNull {
            }
            else{
                cell.lblCity.text = (((self.get_dest ).object(at: indexPath.row) as! NSDictionary).value(forKey: "city_name") as! String)
            }
            if ((self.get_dest ).object(at: indexPath.row) as! NSDictionary).value(forKey: "state_name")  is NSNull {
            }
            else{
                cell.lblState.text = (((self.get_dest ).object(at: indexPath.row) as! NSDictionary).value(forKey: "state_name") as! String)
            }
            cell.lblDate.text = "Posted: \((((self.get_dest ).object(at: indexPath.row) as! NSDictionary).value(forKey: "created_at") as! String))"
            if ((self.get_dest ).object(at: indexPath.row) as! NSDictionary).value(forKey: "years_of_expreience")  is NSNull {
            }
            else{
                cell.lblExperiencee.text = "Experience: \((((self.get_dest ).object(at: indexPath.row) as! NSDictionary).value(forKey: "years_of_expreience") as! String))"
            }
            if ((self.get_dest ).object(at: indexPath.row) as! NSDictionary).value(forKey: "description")  is NSNull {
            }
            else{
                cell.lbleDesrcription.text = (((self.get_dest ).object(at: indexPath.row) as! NSDictionary).value(forKey: "description") as! String)
            }
            cell.tagListView.removeAllTags()
            cell.tagListView.addTag("TagListView")
            if ((self.get_dest ).object(at: indexPath.row) as! NSDictionary).value(forKey: "skill_data")  is NSNull {
            }
            else{
                for section in 0...(((self.get_dest ).object(at: 0) as! NSDictionary).value(forKey: "skill_data") as! NSArray).count - 1 {
                    let str = ((((self.get_dest ).object(at: indexPath.row) as! NSDictionary).value(forKey: "skill_data") as! NSArray).object(at: section) as! NSDictionary).value(forKey: "skill") as! String
                    cell.tagListView.addTags([str])
                }
            }
            //            if ((self.get_dest ).object(at: indexPath.row) as! NSDictionary).value(forKey: "years_of_expreience")  is NSNull {
            //            }
            //            else{
            //                cell.lblExperiencee.text = "Expreience: \((((self.get_dest ).object(at: indexPath.row) as! NSDictionary).value(forKey: "years_of_expreience") as! String))"
            //            }
        }
    
        return cell
    }
   
}

extension BuyerFindAgentViewController: UITableViewDelegate {
    //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //        return 100
    //    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
}
