//
//  BuyerNotesViewController.swift
//  92Agents
//
//  Created by Apple on 09/07/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import Alamofire
import SKActivityIndicatorView

class BuyerNotesViewController: UIViewController {

     //MARK:IBOutlet and Variables
    @IBOutlet var tableView: UITableView!
    var selectedPostArr = [getNotes]()
    
     //MARK: viewDidLoad Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // call api
        NotesAPI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: NotesAPI Method
    func NotesAPI() {
        self.selectedPostArr.removeAll()
        // set url
        let url = URL(string: "http://92agents.com/api/notes")!
        //set params
        let jsonDict = [
            "agents_user_id": Model.sharedInstance.userID,
            "agents_users_role_id":Model.sharedInstance.userRole,
            ]
        let jsonData = try! JSONSerialization.data(withJSONObject: jsonDict, options: [])
        
        var request = URLRequest(url: url)
        request.httpMethod = "post"
        // set token
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
                for item in (json as NSDictionary).value(forKey: "notes") as! NSArray {
                    print(item)
                    self.selectedPostArr.append(getNotes.init(id: "", name: (item as! NSDictionary).value(forKey: "notes_type_text") as! String, postTitle: (item as! NSDictionary).value(forKey: "post_text") as! String, date: (item as! NSDictionary).value(forKey: "created_at") as! String, note: (item as! NSDictionary).value(forKey: "notes") as! String, agentID: (item as! NSDictionary).value(forKey: "receiver_id") as! String, postID: ""))
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
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
extension BuyerNotesViewController: UITableViewDataSource {
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.selectedPostArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : SellerNotesTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as! SellerNotesTableViewCell
        cell.textDate.text = self.selectedPostArr[indexPath.row].date
        cell.textProposal.text = self.selectedPostArr[indexPath.row].name
        cell.textPost.text = self.selectedPostArr[indexPath.row].postTitle
        cell.textNotes.text = self.selectedPostArr[indexPath.row].note
        
        return cell
    }
}

extension BuyerNotesViewController: UITableViewDelegate {
    //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //        return 100
    //    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
}

