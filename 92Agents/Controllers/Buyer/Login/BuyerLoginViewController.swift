//
//  BuyerLoginViewController.swift
//  92Agents
//
//  Created by Apple on 19/06/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import Alamofire
import SKActivityIndicatorView

class BuyerLoginViewController: UIViewController {
     //MARK: IbOutlet and Variables
    @IBOutlet var textEmail: UITextField!
    @IBOutlet var textPassword: UITextField!
    
     //MARK: viewDidLoad Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func btnRegister(_ sender: UIButton) {
        let signupVC = UIStoryboard(name: "Buyer", bundle: nil).instantiateViewController(withIdentifier: "BuyerRegistrationViewController") as! BuyerRegistrationViewController
        self.navigationController?.pushViewController(signupVC, animated: true)
    }
    @IBAction func btnForgot(_ sender: UIButton) {
        let signupVC = UIStoryboard(name: "Buyer", bundle: nil).instantiateViewController(withIdentifier: "BuyerForgotPasswordViewController") as! BuyerForgotPasswordViewController
        self.navigationController?.pushViewController(signupVC, animated: true)
    }
    @IBAction func btnLogin(_ sender: UIButton) {
        textFieldValidation()
    }
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    //MARK: textFieldValidation Method
    func textFieldValidation()
    {
        if (self.textEmail.text?.isEmpty)! {
            Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: "Enter Email")
        }
        else if (self.textEmail.text?.isEmpty)! {
            Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: "Enter Password")
        }
        else{
            loginMethodAPI()
        }
    }
    
    //MARK: loginAPI Methods
    func loginMethodAPI(){
        SKActivityIndicator.spinnerColor(UIColor.darkGray)
        SKActivityIndicator.show("Loading...")
        let parameters: Parameters = [
            "grant_type": "password",
            "client_id":"2",
            "client_secret":"9XXqgb1Hk1dSemtoFToUCnrm1LMxW98qmFQIZfuB",
            "email": self.textEmail.text!,
            "password": self.textPassword.text!,
            "agents_users_role_id":Model.sharedInstance.userRole
        ]
        print(parameters)
        Webservice.apiPost(apiURl:  "http://92agents.com/api/login", parameters: parameters, headers: nil) { (response:NSDictionary?, error:NSError?) in
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
                
                if ((dict as NSDictionary).value(forKey: "status") as? String == "100"){
                    Model.sharedInstance.accessToken = ((dict as NSDictionary).value(forKey: "access_token") as? String)!
                    Model.sharedInstance.userID = (String)(((dict as NSDictionary).value(forKey: "user") as? NSDictionary)?.value(forKey: "id") as! NSInteger)
                    Model.sharedInstance.userRole = (((dict as NSDictionary).value(forKey: "user") as? NSDictionary)?.value(forKey: "agents_users_role_id") as! String)
                    Model.sharedInstance.user = "Buyer"
                    let addressVC = UIStoryboard(name: "Buyer", bundle: nil).instantiateViewController(withIdentifier: "BuyerDashboardViewController") as! BuyerDashboardViewController
                    self.navigationController?.pushViewController(addressVC, animated: true)
                }else{
                    Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: (response?.value(forKey: "error") as! String))
                }
            }
            
        }
    }

}
