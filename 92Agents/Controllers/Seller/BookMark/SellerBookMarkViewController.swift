//
//  SellerBookMarkViewController.swift
//  92Agents
//
//  Created by Apple on 28/06/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import SKActivityIndicatorView
import Alamofire

 //MARK: Class
class BookMark {
    var id : String
    var postText: String
    var bookmarkText : String
    var date : String
    init(id: String,postText: String,bookmarkText : String,date : String) {
        self.id = id
         self.postText = postText
        self.bookmarkText = bookmarkText
        self.date = date
        
    }
}
class SellerBookMarkViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    let kCellIdentifier = "cell"
    var bookmarkArr = [BookMark]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let nib = UINib(nibName: "SellerBoolmarlTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: kCellIdentifier)
        tableView.tableFooterView = UIView()
        bookmarkAPI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: bookmarkAPI Methods
    func bookmarkAPI(){
        self.bookmarkArr.removeAll()
        SKActivityIndicator.spinnerColor(UIColor.darkGray)
        SKActivityIndicator.show("Loading...")
        let parameters: Parameters = [
            "agents_user_id": Model.sharedInstance.userID,
            "agents_users_role_id":Model.sharedInstance.userRole
        ]
        print(parameters)
        Webservice.apiGet(serviceName:"http://92agents.com/api/bookmarks", parameters: parameters, headers: nil) { (response:NSDictionary?, error:NSError?) in
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
                    for item in ((response as! NSDictionary).value(forKey: "response") as! NSArray) {
                        
                        self.bookmarkArr.append(BookMark.init(id: (item as! NSDictionary).value(forKey: "bookmark_id") as! String, postText: (item as! NSDictionary).value(forKey: "post_text") as! String, bookmarkText: (item as! NSDictionary).value(forKey: "bookmark_text") as! String, date: (item as! NSDictionary).value(forKey: "created_at") as! String))
                    }
                    DispatchQueue.main.async(execute: {
                        self.tableView.reloadData()
                    })
                    
                    
                }else{
                    Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: (response?.value(forKey: "error") as! String))
                }
            }
            
        }
    }
    
    
    
    

}
extension SellerBookMarkViewController: UITableViewDataSource {
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.bookmarkArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kCellIdentifier, for: indexPath) as! SellerBoolmarlTableViewCell
       
        cell.textPost.text = self.bookmarkArr[indexPath.row].postText
        cell.textBookmark.text = self.bookmarkArr[indexPath.row].bookmarkText
        cell.textDate.text = self.bookmarkArr[indexPath.row].date
        cell.btnDelete.tag = indexPath.row
        cell.btnDelete.addTarget(self,action:#selector(buttonTapped(sender:)), for: .touchUpInside)
       
        return cell
    }
    @objc func buttonTapped(sender : UIButton){
        
        let alertView = UIAlertController(title: "Note", message: " Are You Sure This Bookmark Remove In Bookmark List?", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: { (alert) in
             self.deleteBookMarkAPI(bookmarkID:  self.bookmarkArr[sender.tag].id)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        
        // Add the actions
        alertView.addAction(cancelAction)
        alertView.addAction(action)
        self.present(alertView, animated: true, completion: nil)
      
    }
    
    // MARK: - deleteBookMarkAPI Method
    func deleteBookMarkAPI(bookmarkID : String){
        SKActivityIndicator.spinnerColor(UIColor.darkGray)
        SKActivityIndicator.show("Loading...")
       
        let parameters: Parameters = [
            "bookmark_id":bookmarkID
        ]
        
        print(parameters)
        
        Webservice.apiPost1(apiURl:  "http://92agents.com/api/deleteBookmark", parameters: parameters, headers: nil) { (response:[String : Any], error:NSError?) in
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
                 
                    let alertView = UIAlertController(title: "Alert!", message: ((dict as NSDictionary).value(forKey: "response") as! String), preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default, handler: { (alert) in
                           self.bookmarkAPI()
                    })
                    alertView.addAction(action)
                    self.present(alertView, animated: true, completion: nil)
                   
                }else{
                    Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: ((dict as NSDictionary).value(forKey: "error") as! String))
                }
            }
        }
    }

}

extension SellerBookMarkViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
}
