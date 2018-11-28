//
//  LeftMenuTableViewController.swift
//  Recipes
//
//  Created by Apple on 12/04/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

protocol LeftMenuDelegate: class {
    func didSelectItemAtIndex(index idx: Int)
}
class LeftMenuTableViewController: UIViewController {

    // MARK: IBOutlets
    @IBOutlet weak var userAvatarImg: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var menuTableView: UITableView!
    var vc = AgentDashBoardViewController()
    // MARK: Properties
    let kCellIdentifier = "menuCell"
    let items = ["My Job","Find Agents","Profile","Test","Notes", "Bookmarks","Setting","Logout"]
    let images = ["myjob","findAgent","user","test","notes","bookmark1","profile","logout"]
     let agentItems = ["My Job","Connected Jobs","Find Jobs","Profile","Tests", "Notes","Bookmark","Others Resources","Logout"]
    weak var delegate: LeftMenuDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let nib = UINib(nibName: "MenuTableViewCell", bundle: nil)
        menuTableView.register(nib, forCellReuseIdentifier: kCellIdentifier)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
    }
}
extension LeftMenuTableViewController: UITableViewDataSource {
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if  Model.sharedInstance.user == "Buyer"{
            return items.count
        }
        else if  Model.sharedInstance.user == "Agents"{
            return agentItems.count
        }
        else  {
            return items.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kCellIdentifier, for: indexPath) as! MenuTableViewCell
       
        if  Model.sharedInstance.user == "Buyer"{
            cell.titleLabel.text = items[indexPath.row]
            cell.img.image = UIImage(named: images[indexPath.row])
        }
        else if  Model.sharedInstance.user == "Agents"{
            cell.titleLabel.text = agentItems[indexPath.row]
           // cell.img.image = UIImage(named: images[indexPath.row])
        }
        else {
            cell.titleLabel.text = items[indexPath.row]
            cell.img.image = UIImage(named: images[indexPath.row])
        }
        return cell
    }
}
extension LeftMenuTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if  Model.sharedInstance.user == "Buyer"{
            if indexPath.row == 0{
                let addressVC = UIStoryboard(name: "Buyer", bundle: nil).instantiateViewController(withIdentifier: "BuyerMyJobViewController") as! BuyerMyJobViewController
                self.navigationController?.pushViewController(addressVC, animated: true)
            }
            else if indexPath.row == 1{
                let agentVC = UIStoryboard(name: "Buyer", bundle: nil).instantiateViewController(withIdentifier: "BuyerFindAgentViewController") as! BuyerFindAgentViewController
                self.navigationController?.pushViewController(agentVC, animated: true)
            }
            else if indexPath.row == 2{
                let favVC = UIStoryboard(name: "Buyer", bundle: nil).instantiateViewController(withIdentifier: "BuyerProfileViewController") as! BuyerProfileViewController
                self.navigationController?.pushViewController(favVC, animated: true)
            }
            else if indexPath.row == 3{
                let favVC = UIStoryboard(name: "Buyer", bundle: nil).instantiateViewController(withIdentifier: "BuyerTestsViewController") as! BuyerTestsViewController
                self.navigationController?.pushViewController(favVC, animated: true)
            }
            else if indexPath.row == 4{
                let aboutVC = UIStoryboard(name: "Buyer", bundle: nil).instantiateViewController(withIdentifier: "BuyerNotesViewController") as! BuyerNotesViewController
                self.navigationController?.pushViewController(aboutVC, animated: true)
            }
            else if indexPath.row == 5{
                let bookmarkVC = UIStoryboard(name: "Buyer", bundle: nil).instantiateViewController(withIdentifier: "BuyerBookMarkViewController") as! BuyerBookMarkViewController
                self.navigationController?.pushViewController(bookmarkVC, animated: true)
            }
            else if indexPath.row == 6{
                let loginVC = UIStoryboard(name: "Buyer", bundle: nil).instantiateViewController(withIdentifier: "SettingViewController") as! SettingViewController
                self.navigationController?.pushViewController(loginVC, animated: true)
            }
        }
        else if  Model.sharedInstance.user == "Agents"{
            if indexPath.row == 0{
                let addressVC = UIStoryboard(name: "Agents", bundle: nil).instantiateViewController(withIdentifier: "AgentMyJobViewController") as! AgentMyJobViewController
                self.navigationController?.pushViewController(addressVC, animated: true)
            }
            else if indexPath.row == 1{
                let agentVC = UIStoryboard(name: "Agents", bundle: nil).instantiateViewController(withIdentifier: "ConnectedJobsViewController") as! ConnectedJobsViewController
                self.navigationController?.pushViewController(agentVC, animated: true)
            }
            else if indexPath.row == 2{
                let favVC = UIStoryboard(name: "Agents", bundle: nil).instantiateViewController(withIdentifier: "AgentsFindAgentViewController") as! AgentsFindAgentViewController
                self.navigationController?.pushViewController(favVC, animated: true)
            }
            else if indexPath.row == 3{
                let favVC = UIStoryboard(name: "Agents", bundle: nil).instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
                self.navigationController?.pushViewController(favVC, animated: true)
            }
            else if indexPath.row == 4{
                let aboutVC = UIStoryboard(name: "Agents", bundle: nil).instantiateViewController(withIdentifier: "AgentTestsViewController") as! AgentTestsViewController
                self.navigationController?.pushViewController(aboutVC, animated: true)
            }
            else if indexPath.row == 5{
                let bookmarkVC = UIStoryboard(name: "Agents", bundle: nil).instantiateViewController(withIdentifier: "AgentNotesViewController") as! AgentNotesViewController
                self.navigationController?.pushViewController(bookmarkVC, animated: true)
            }
            else if indexPath.row == 6{
                let loginVC = UIStoryboard(name: "Agents", bundle: nil).instantiateViewController(withIdentifier: "AgentBookmarkViewController") as! AgentBookmarkViewController
                self.navigationController?.pushViewController(loginVC, animated: true)
            }
            else if indexPath.row == 7{
                let loginVC = UIStoryboard(name: "Agents", bundle: nil).instantiateViewController(withIdentifier: "OthersResourcesViewController") as! OthersResourcesViewController
                self.navigationController?.pushViewController(loginVC, animated: true)
            }
        }
        else{
            if indexPath.row == 0{
                let addressVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyJobViewController") as! MyJobViewController
                self.navigationController?.pushViewController(addressVC, animated: true)
            }
            else if indexPath.row == 1{
                let agentVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FindAgentViewController") as! FindAgentViewController
                self.navigationController?.pushViewController(agentVC, animated: true)
            }
            else if indexPath.row == 2{
                let favVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
                self.navigationController?.pushViewController(favVC, animated: true)
            }
            else if indexPath.row == 3{
                let favVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SellerTestViewController") as! SellerTestViewController
                self.navigationController?.pushViewController(favVC, animated: true)
            }
            else if indexPath.row == 4{
                let aboutVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SellerNotesViewController") as! SellerNotesViewController
                self.navigationController?.pushViewController(aboutVC, animated: true)
            }
            else if indexPath.row == 5{
                let bookmarkVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SellerBookMarkViewController") as! SellerBookMarkViewController
                self.navigationController?.pushViewController(bookmarkVC, animated: true)
            }
            else if indexPath.row == 6{
                let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SettingViewController") as! SettingViewController
                self.navigationController?.pushViewController(loginVC, animated: true)
            }
        }
    }
}

