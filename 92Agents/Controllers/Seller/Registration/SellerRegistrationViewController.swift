//
//  SellerRegistrationViewController.swift
//  92Agents
//
//  Created by Apple on 14/06/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import Alamofire
import SKActivityIndicatorView

class SellerRegistrationViewController: UIViewController {

     //MARK: IBOUTLET
    @IBOutlet var textFirstName: UITextField!
    @IBOutlet var textLastName: UITextField!
    @IBOutlet var textEmail: UITextField!
    @IBOutlet var textPassword: UITextField!
    @IBOutlet var textonfirmPassword: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    //MARK: textFieldValidation Method
    func textFieldValidation()
    {
        if (self.textFirstName.text?.isEmpty)! {
            Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: "Enter First Name")
        }
        else if (self.textLastName.text?.isEmpty)! {
            Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: "Enter Last Name")
        }
        else if (self.textEmail.text?.isEmpty)! {
            Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: "Enter Password")
        }
        else if (self.textEmail.text?.isEmpty)! {
            Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: "Enter Password")
        }
        else if (self.textonfirmPassword.text?.isEmpty)! {
            Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: "Enter Confirm Password")
        }
        else{
            signupAPI()
        }
    }
    @IBAction func btnNext(_ sender: UIButton) {
        textFieldValidation()

    }
    //MARK: signupAPI Methods
    func signupAPI(){
       
        SKActivityIndicator.spinnerColor(UIColor.darkGray)
        SKActivityIndicator.show("Loading...")
        let parameters: Parameters = [
            "fname": self.textFirstName.text!,
            "lname": self.textLastName.text!,
            "email":self.textEmail.text!,
            "terms_and_conditions": "1",
            "agents_users_role_id" : "3",
            "password": self.textPassword.text!,
            "confirm_password": self.textonfirmPassword.text!,
            "step":"1"
        ]
        print(parameters)
        Webservice.apiPost(apiURl:  "http://92agents.com/api/signup1", parameters: parameters, headers: nil) { (response:NSDictionary?, error:NSError?) in
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
            
            Model.sharedInstance.userID =  (response?.value(forKey: "userDetails") as! NSDictionary).value(forKey: "id") as! String
            let addressVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SellerAddressViewController") as! SellerAddressViewController
            self.navigationController?.pushViewController(addressVC, animated: true)
//            if (response?.value(forKey: "error") as! String) != ""{
//                Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: (response?.value(forKey: "message") as! String))
//            }
//            else{
//
//            }
        }
    }
}
