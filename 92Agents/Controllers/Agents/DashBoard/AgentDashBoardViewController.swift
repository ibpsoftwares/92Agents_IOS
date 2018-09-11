//
//  AgentDashBoardViewController.swift
//  92Agents
//
//  Created by Apple on 09/07/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import Alamofire
import SKActivityIndicatorView
import LNSideMenu


class AgentDashBoardViewController: UIViewController {

     //MARK: IBOutlet and Variables
    @IBOutlet var menuContainerView: UIView!
    var mainMenuActive = false
    @IBOutlet var dashboardTableView: UITableView!
    let kCellIdentifier = "cell"
    var selectedPostArr = [getSelectedPosts]()
    var btnMenu : UIButton!
    var MenuIsVisible = false
    @IBOutlet var leadingC: NSLayoutConstraint!
     //MARK: viewDidLoad Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let nib = UINib(nibName: "DashBoardTableViewCell", bundle: nil)
        dashboardTableView.register(nib, forCellReuseIdentifier: kCellIdentifier)
        dashboardTableView.tableFooterView = UIView()
        //Properties of Views
      
        menuContainerView.layer.shadowRadius = 6
        // call api
        dashboardAPI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func btnMenu(_ sender: UIButton) {
      
//        UIView.animate(withDuration: 1, animations: {
//             self.menuContainerView.isHidden = false
//            self.menuContainerView.frame.origin.x = +1
//        }) { (_) in
//            UIView.animate(withDuration: 1, delay: 0.2, options: [.curveEaseIn], animations: {
//               // self.menuContainerView.frame.origin.x -= self.menuContainerView.frame.width
//                 //self.menuContainerView.isHidden = true
//            })
//
//        }
        
      //animation(viewAnimation: self.menuContainerView)
        
       
       
        if !MenuIsVisible {
            leadingC.constant = 150
            MenuIsVisible = true
        } else {
            leadingC.constant = 0
            MenuIsVisible = false
        }
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        }) { (animationComplete) in
            print("The animation is complete!")
        }
    }
    
    func animation(viewAnimation: UIView) {
        UIView.animate(withDuration: 1, delay: 0.5, options: [.curveEaseIn], animations: {
            viewAnimation.frame.origin.x += 10
        })
//        UIView.animate(withDuration: 2, animations: {
//            viewAnimation.frame.origin.x = +170
//        }) { (_) in
//            UIView.animate(withDuration: 2, delay: 1, options: [.curveEaseIn], animations: {
//                viewAnimation.frame.origin.x -= 170
//            })
//
//        }
    }
    
     //MARK: Agent DashBoardAPI Methods
    //MARK: dashboardAPI Method
    func dashboardAPI() {
        let url = URL(string: "http://92agents.com/api/dashboard")!
        let jsonDict = [
            "agents_user_id": Model.sharedInstance.userID,
            "agents_users_role_id":Model.sharedInstance.userRole,
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
                for item in (json as NSDictionary).value(forKey: "selectedPosts") as! NSArray {
                    print(item)
                    self.selectedPostArr.append(getSelectedPosts.init(name: (item as! NSDictionary).value(forKey: "name") as! String, postTitle: (item as! NSDictionary).value(forKey: "posttitle") as! String, date: (item as! NSDictionary).value(forKey: "cron_time") as! String))
                }
                DispatchQueue.main.async(execute: {
                    self.dashboardTableView.reloadData()
                })
            } catch {
                print("error:", error)
            }
        }
        
        task.resume()
    }
}
extension AgentDashBoardViewController: UITableViewDataSource {
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.selectedPostArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kCellIdentifier, for: indexPath) as! DashBoardTableViewCell
        cell.textAgent.text = " are selected for"
        cell.lbl.text = "You"
        cell.textPost.text = "\((selectedPostArr[indexPath.row].postTitle))"
        cell.textPost.textColor = UIColor.init(red: 135.0/255.0, green:  194.0/255.0, blue:  73.0/255.0, alpha: 1)
        cell.textDate.text = selectedPostArr[indexPath.row].date
        
        return cell
    }
}

extension AgentDashBoardViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
}
