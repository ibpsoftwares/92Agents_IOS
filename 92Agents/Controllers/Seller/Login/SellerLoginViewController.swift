//
//  SellerLoginViewController.swift
//  92Agents
//
//  Created by Apple on 14/06/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import Alamofire
import SKActivityIndicatorView

class SellerLoginViewController: UIViewController {

    //MARK: IBOUTLET
    @IBOutlet var textEmail: UITextField!
    @IBOutlet var textPassword: UITextField!
    
     //MARK: viewDidLoad Method
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
     //MARK: ButtonAction Method
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnRegister(_ sender: UIButton) {
        let signupVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SellerRegistrationViewController") as! SellerRegistrationViewController
        self.navigationController?.pushViewController(signupVC, animated: true)
    }
    @IBAction func btnLogin(_ sender: UIButton) {
         textFieldValidation()
        //let activityViewController = UIActivityViewController(activityItems: ["Name To Present to User", ""], applicationActivities: nil)
       // present(activityViewController, animated: true, completion: nil)
    }
    @IBAction func btnForgotPassword(_ sender: UIButton) {
        let addressVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SellerForgotViewController") as! SellerForgotViewController
        self.navigationController?.pushViewController(addressVC, animated: true)
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
               print(dict)
                if ((dict as NSDictionary).value(forKey: "status") as? String == "100"){
                    Model.sharedInstance.accessToken = ((dict as NSDictionary).value(forKey: "access_token") as? String)!
                    
                    let tempNumber = (((dict as NSDictionary).value(forKey: "user") as! NSDictionary).value(forKey: "id") as! Int)
                    let stringTemp = String(tempNumber)
                    Model.sharedInstance.userID = stringTemp
                   let addressVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SellerDashBoardViewController") as! SellerDashBoardViewController
                   self.navigationController?.pushViewController(addressVC, animated: true)
                  
                    
                }else{
                     Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: (response?.value(forKey: "error") as! String))
                }
            }

        }
    }
}
