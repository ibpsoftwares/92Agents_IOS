//
//  BuyerForgotPasswordViewController.swift
//  92Agents
//
//  Created by Apple on 20/06/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import Alamofire
import SKActivityIndicatorView

class BuyerForgotPasswordViewController: UIViewController {

     @IBOutlet var textForgot: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: textFieldValidation Method
    func textFieldValidation()
    {
        if (self.textForgot.text?.isEmpty)! {
            Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: "Enter Email")
        }
        else{
            sellPostTitleAPI()
        }
    }
    @IBAction func btnPost(_ sender: UIButton) {
        textFieldValidation()
    }
    //MARK: addressAPI Methods
    func sellPostTitleAPI(){
        SKActivityIndicator.spinnerColor(UIColor.darkGray)
        SKActivityIndicator.show("Loading...")
        
        let parameters: Parameters = [
            "email": self.textForgot.text!
        ]
        print(parameters)
        Webservice.apiPost(apiURl:  "http://92agents.com/api/forgotPassword", parameters: parameters, headers: nil) { (response:NSDictionary?, error:NSError?) in
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
            if (response?.value(forKey: "status") as! String) == "100"{
                
                let alertController = UIAlertController(title: "Forget Password", message: (response?.value(forKey: "response") as! String), preferredStyle: UIAlertControllerStyle.alert)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (result : UIAlertAction) -> Void in
                }
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                    
                    // let addressVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SelectLoginViewController") as! SelectLoginViewController
                    //self.navigationController?.pushViewController(addressVC, animated: true)
                    self.navigationController?.popViewController(animated: false)
                    
                }
                alertController.addAction(cancelAction)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
                
                
            }else{
                Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: (response?.value(forKey: "error") as! String))
            }
        }
    }

}
