//
//  AgentPostViewController.swift
//  92Agents
//
//  Created by Apple on 22/06/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import Alamofire
import SKActivityIndicatorView

class AgentPostViewController: UIViewController {

     //MARK: IBoutlet and Variables
     @IBOutlet var textPost: UITextField!
    
    
     //MARK: viewDidLoad Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: textFieldValidation Method
    func textFieldValidation()
    {
        if (self.textPost.text?.isEmpty)! {
            Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: "Sell Post Title")
        }
        else{
            sellPostTitleAPI()
        }
    }
    @IBAction func btnBack(_ sender: UIButton) {
       self.navigationController?.popViewController(animated: false)
    }
    @IBAction func btnPost(_ sender: UIButton) {
        textFieldValidation()
    }
    //MARK: addressAPI Methods
    func sellPostTitleAPI(){
        SKActivityIndicator.spinnerColor(UIColor.darkGray)
        SKActivityIndicator.show("Loading...")
        // set params
        let parameters: Parameters = [
            "id": Model.sharedInstance.userID,
            "step": "3",
            "agents_users_role_id": Model.sharedInstance.userRole,
            "posttitle": self.textPost.text!
        ]
        print(parameters)
        Webservice.apiPost(apiURl:  "http://92agents.com/api/signup3", parameters: parameters, headers: nil) { (response:NSDictionary?, error:NSError?) in
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
            
        }
    }

}
