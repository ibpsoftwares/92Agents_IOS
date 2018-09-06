//
//  BuyerBookMarkViewController.swift
//  92Agents
//
//  Created by Apple on 09/07/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import SKActivityIndicatorView

class BuyerBookMarkViewController: UIViewController {

     //MARK: IBOutlet and Variables
    @IBOutlet var tableView: UITableView!
    let kCellIdentifier = "cell"
    var bookmarkArr = [BookMark]()
    
     //MARK: viewDidLoad Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let nib = UINib(nibName: "SellerBoolmarlTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: kCellIdentifier)
        tableView.tableFooterView = UIView()
        // call api
        bookmarkAPI() 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    //MARK: BookmarkAPI Method
    func bookmarkAPI() {
        self.bookmarkArr.removeAll()
        SKActivityIndicator.spinnerColor(UIColor.darkGray)
        SKActivityIndicator.show("Loading...")
        
        let url = URL(string: "http://92agents.com/api/bookmarks")! // set url
        //set params
        let jsonDict = [
            "agents_user_id": Model.sharedInstance.userID,
            "agents_users_role_id":Model.sharedInstance.userRole,
            ]
        print(jsonDict)
        let jsonData = try! JSONSerialization.data(withJSONObject: jsonDict, options: [])
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        //set token
        let token = "\(Model.sharedInstance.accessToken)"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("error:", error)
                return
            }
            DispatchQueue.main.async(execute: {
                SKActivityIndicator.dismiss()
            })
            do {
                guard let data = data else { return }
                guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] else { return }
                print("json:", json)
                for item in((json as NSDictionary).value(forKey: "response") as! NSArray) {
                    
                    self.bookmarkArr.append(BookMark.init(id: (item as! NSDictionary).value(forKey: "bookmark_id") as! String, postText: (item as! NSDictionary).value(forKey: "post_text") as! String, bookmarkText: (item as! NSDictionary).value(forKey: "bookmark_text") as! String, date: (item as! NSDictionary).value(forKey: "created_at") as! String))
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
extension BuyerBookMarkViewController: UITableViewDataSource {
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
        return cell
    }
}

extension BuyerBookMarkViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
}

