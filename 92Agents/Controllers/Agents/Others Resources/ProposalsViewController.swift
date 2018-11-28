//
//  ProposalsViewController.swift
//  92Agents
//
//  Created by Apple on 19/11/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import SKActivityIndicatorView
import Kingfisher
import Alamofire

class ProposalsViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    var proposalArr = NSArray()
    // add new proposal
    @IBOutlet var proposalView: UITableView!
    @IBOutlet var proposalViewHeight: NSLayoutConstraint!
    @IBOutlet var proposlView: UIView!
    @IBOutlet var proposlViewHeight: NSLayoutConstraint!
    @IBOutlet var textProposalHeight: NSLayoutConstraint!
    @IBOutlet var textProposalTitle: UITextField!
    @IBOutlet var textUploadProposal: UITextField!
    @IBOutlet var lblProposal: UILabel!
    @IBOutlet var btnProposal: UIButton!
    @IBOutlet var btnFile: UIButton!
    @IBOutlet var btnHtml: UIButton!
    var value = String()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
      
        //self.proposlView.isHidden = true
       getProposalAPI()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        getProposalAPI()
    }
    //MARK: AddNewProposalAPI Method
    func getProposalAPI(){
      
        SKActivityIndicator.spinnerColor(UIColor.darkGray)
        SKActivityIndicator.show("Loading...")
        
        let parameters: Parameters = [
            "agents_user_id": Model.sharedInstance.userID,
            "agents_users_role_id":Model.sharedInstance.userRole
        ]
        //http://92agents.com/api/proposals/store
        print(parameters)
        Webservice.apiGet(serviceName:"http://92agents.com/api/profile/agent", parameters: parameters, headers: nil) { (response:NSDictionary?, error:NSError?) in
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
                    self.proposalArr = (((response)?.value(forKey: "response") as! NSDictionary).value(forKey: "proposals") as! NSArray)
                    DispatchQueue.main.async(execute: {
                       // self.tableView.reloadData()
                    })
                }
            }else{
                Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: (response?.value(forKey: "error") as! String))
            }
        }
    }
}
extension ProposalsViewController: UITableViewDataSource {
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.proposalArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DocumentTableViewCell
        cell.lblDocName.text = (((self.proposalArr ).object(at: indexPath.row) as! NSDictionary).value(forKey: "proposals_attachments") as! String)
        cell.btnDelete.tag = indexPath.row
        cell.btnDelete.addTarget(self,action:#selector(buttonViewProposal(sender:)), for: .touchUpInside)
        cell.btnViewProposal.tag = indexPath.row
        cell.btnViewProposal.addTarget(self,action:#selector(buttonDeleteProposal(sender:)), for: .touchUpInside)
        return cell
 }
    //MARK: Delete Proposals
    @objc func buttonDeleteProposal(sender : UIButton){
        self.deleteProposalAPI(proposal_id: (((self.proposalArr ).object(at: sender.tag) as! NSDictionary).value(forKey: "proposals_id") as! String))
    }
    //MARK: deleteProposal Method
    func deleteProposalAPI(proposal_id : String){
        SKActivityIndicator.spinnerColor(UIColor.darkGray)
        SKActivityIndicator.show("Loading...")
        let parameters: Parameters = ["proposal_id" : proposal_id]
        print(parameters)
        Webservice.apiPost(apiURl:"http://92agents.com/api/proposals/delete", parameters: parameters, headers: nil) { (response:NSDictionary?, error:NSError?) in
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
                    self.getProposalAPI()
                }
            }else{
                Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: (response?.value(forKey: "error") as! String))
            }
        }
    }
    @objc func buttonViewProposal(sender : UIButton){
        let signupVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SharedProposalViewController") as! SharedProposalViewController
        signupVC.urlString = (((self.proposalArr ).object(at: sender.tag) as! NSDictionary).value(forKey: "proposals_attachments") as! String)
        self.navigationController?.pushViewController(signupVC, animated: true)
    }
    @IBAction func btnNewProposal(_ sender: UIButton) {
        self.proposlView.isHidden = false
    }
    @IBAction func btnProposalClose(_ sender: UIButton) {
        self.proposlView.isHidden = true
    }
    
    @IBAction func btnProposalSave(_ sender: UIButton) {
        AddNewProposalAPI()
    }
    @IBAction func btnUploadProposal(_ sender: UIButton) {
    }
    @IBAction func btnFileClick(_ sender: UIButton) {
        value = "proposal_file"
        self.proposlViewHeight.constant = 240
        self.textProposalHeight.constant = 30
        self.btnProposal.isHidden = false
        lblProposal.text  = "Upload Your Proposal"
        btnFile.setImage(UIImage.init(named: "selected"), for: .normal)
        btnHtml.setImage(UIImage.init(named: "notSelected"), for: .normal)
    }
    @IBAction func btnHtmlClick(_ sender: Any) {
        value = "proposals_html"
        btnFile.setImage(UIImage.init(named: "notSelected"), for: .normal)
        btnHtml.setImage(UIImage.init(named: "selected"), for: .normal)
        self.btnProposal.isHidden = true
        self.proposlViewHeight.constant = 300
        self.textProposalHeight.constant = 85
        lblProposal.text  = "Type Text"
    }
    //MARK: AddNewProposalAPI Method
    func AddNewProposalAPI(){
        SKActivityIndicator.spinnerColor(UIColor.darkGray)
        SKActivityIndicator.show("Loading...")
        var parameters: Parameters = [:]
        
        if value == "proposal_file"{
            parameters = [
                "type" : "1",
                "proposal_file": self.textUploadProposal.text!,
                "agents_user_id": Model.sharedInstance.userID,
                "agents_users_role_id":Model.sharedInstance.userRole,
                "proposals_title" : self.textProposalTitle.text!
            ]
        }
        else if value == "proposals_html"{
            parameters = [
                "type" : "2",
                "proposals_html": self.textUploadProposal.text!,
                "agents_user_id": Model.sharedInstance.userID,
                "agents_users_role_id":Model.sharedInstance.userRole,
                "proposals_title" : self.textProposalTitle.text!
            ]
        }
        
        print(parameters)
        Webservice.apiPost(apiURl:"http://92agents.com/api/proposals/store", parameters: parameters, headers: nil) { (response:NSDictionary?, error:NSError?) in
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
                    self.proposlView.isHidden = true
                     self.getProposalAPI()
                }
            }else{
                Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: (response?.value(forKey: "error") as! String))
            }
        }
    }
}
