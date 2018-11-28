//
//  AgentNotesViewController.swift
//  92Agents
//
//  Created by Apple on 08/10/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import SKActivityIndicatorView
import Alamofire
class AgentNotesViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var editPostView: UIView!
    @IBOutlet var editTextView: UITextView!
    var selectedPostArr = [getNotes]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //MARK:viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        NotesAPI()
        self.editPostView.isHidden = true
    }
    //MARK: NotesAPI
    func NotesAPI() {
        self.selectedPostArr.removeAll()
        let url = URL(string: "http://92agents.com/api/notes")!
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
                if ((json as NSDictionary).value(forKey: "notes") as! NSArray).count > 0{
                for item in (json as NSDictionary).value(forKey: "notes") as! NSArray {
                    self.selectedPostArr.append(getNotes.init(id: (item as! NSDictionary).value(forKey: "notes_id") as! String, name: (item as! NSDictionary).value(forKey: "notes_type_text") as! String, postTitle: (item as! NSDictionary).value(forKey: "post_text") as! String, date: (item as! NSDictionary).value(forKey: "created_at") as! String, note: (item as! NSDictionary).value(forKey: "notes") as! String, agentID: (item as! NSDictionary).value(forKey: "receiver_id") as! String, postID: (item as! NSDictionary).value(forKey: "post_id") as! String))
                 }
                }
                else{
                    Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: "No Data Available!")
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
    @IBAction func btnClose(_ sender: UIButton) {
        self.editPostView.isHidden = true
    }
    @IBAction func btnUpdate(_ sender: UIButton) {
        
        self.updateNote(id: selectedPostArr[sender.tag].id)
    }
    //MARK: updateNote
    func updateNote(id: String) {
        self.selectedPostArr.removeAll()
        let url = URL(string: "http://92agents.com/api/updateNote")!
        let jsonDict = [
            "id": id,
            "notes": self.editTextView.text!
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
                
                DispatchQueue.main.async(execute: {
                    self.editPostView.isHidden = true
                    self.NotesAPI()
                })
            } catch {
                print("error:", error)
            }
        }
        
        task.resume()
    }
}
extension AgentNotesViewController: UITableViewDataSource {
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
        cell.btnEdit.tag = indexPath.row
        cell.btnDelete.tag = indexPath.row
        cell.btnDelete.addTarget(self,action:#selector(buttonTapped(sender:)), for: .touchUpInside)
        cell.btnEdit.addTarget(self,action:#selector(buttonEditTapped(sender:)), for: .touchUpInside)
        return cell
    }
    @objc func buttonEditTapped(sender : UIButton){
        self.editPostView.isHidden = false
        self.editTextView.text = self.selectedPostArr[sender.tag].note
    }
    @objc func buttonTapped(sender : UIButton){
        
        self.deleteNote(id: self.selectedPostArr[sender.tag].id)
    }
    //MARK: deleteNote
    func deleteNote(id: String) {
        let url = URL(string: "http://92agents.com/api/deleteNotes")!
        let jsonDict = [
            "id": id
        ]
        print(jsonDict)
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
                DispatchQueue.main.async(execute: {
                    self.NotesAPI()
                })
            } catch {
                print("error:", error)
            }
        }
        task.resume()
    }
}
extension AgentNotesViewController: UITableViewDelegate {
    //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //        return 100
    //    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let addressVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AgentDetailViewController") as! AgentDetailViewController
        addressVC.postID = self.selectedPostArr[indexPath.row].postID
        addressVC.agentID = self.selectedPostArr[indexPath.row].agentID
        addressVC.agentName = self.selectedPostArr[indexPath.row].name
        self.navigationController?.pushViewController(addressVC, animated: true)
    }
}
