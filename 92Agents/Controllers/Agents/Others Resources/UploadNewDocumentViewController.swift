//
//  UploadNewDocumentViewController.swift
//  92Agents
//
//  Created by Apple on 20/11/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import SKActivityIndicatorView
import Kingfisher
import Alamofire

class UploadNewDocumentViewController: UIViewController {

    var documentArr = NSArray()
    // add new Document
    @IBOutlet var documentTableView: UITableView!
    @IBOutlet var documentView: UIView!
    @IBOutlet var textUploadFiles: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.getProposalAPI()
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
                    self.documentArr = (((response)?.value(forKey: "response") as! NSDictionary).value(forKey: "documents") as! NSArray)
                    DispatchQueue.main.async(execute: {
                        self.documentTableView.reloadData()
                    })
                }
            }else{
                Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: (response?.value(forKey: "error") as! String))
            }
        }
    }
   
    @IBAction func btnUploadNewDocument(_ sender: Any) {
        self.documentView.isHidden = false
    }
    @IBAction func btnUploadFiles(_ sender: Any) {
    }
    @IBAction func btnClose(_ sender: UIButton) {
        self.documentView.isHidden = true
    }
    @IBAction func btnSave(_ sender: UIButton) {
    }
}
extension UploadNewDocumentViewController: UITableViewDataSource {
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.documentArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DocumentTableViewCell
        cell.lblDocName.text = (((self.documentArr ).object(at: indexPath.row) as! NSDictionary).value(forKey: "attachments") as! String)
        cell.btnDelete.tag = indexPath.row
        cell.btnDelete.addTarget(self,action:#selector(buttonViewProposal(sender:)), for: .touchUpInside)
        cell.btnViewProposal.tag = indexPath.row
        cell.btnViewProposal.addTarget(self,action:#selector(buttonDeleteProposal(sender:)), for: .touchUpInside)
        return cell
    }
    //MARK: Delete Proposals
    @objc func buttonDeleteProposal(sender : UIButton){
        self.deleteProposalAPI(document_id: (((self.documentArr ).object(at: sender.tag) as! NSDictionary).value(forKey: "upload_share_id") as! String))
    }
    //MARK: deleteProposal Method
    func deleteProposalAPI(document_id : String){
        SKActivityIndicator.spinnerColor(UIColor.darkGray)
        SKActivityIndicator.show("Loading...")
        let parameters: Parameters = ["document_id" : document_id]
        print(parameters)
        Webservice.apiPost(apiURl:"http://92agents.com/api/uploadandshare/delete", parameters: parameters, headers: nil) { (response:NSDictionary?, error:NSError?) in
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
        signupVC.urlString = (((self.documentArr ).object(at: sender.tag) as! NSDictionary).value(forKey: "attachments") as! String)
        self.navigationController?.pushViewController(signupVC, animated: true)
 }
}
