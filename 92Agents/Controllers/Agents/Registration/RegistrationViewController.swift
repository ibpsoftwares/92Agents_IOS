//
//  RegistrationViewController.swift
//  92Agents
//
//  Created by Apple on 19/06/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import Alamofire
import SKActivityIndicatorView

class RegistrationViewController: UIViewController {

     //MARK: IBOutlet and Variables
     var pickerView : UIPickerView!
    var comp = NSDateComponents()
   // @IBOutlet weak var datePicker: datePicker!
    var datePicker = UIDatePicker()
    @IBOutlet var textFirstName: UITextField!
    @IBOutlet var textLastName: UITextField!
    @IBOutlet var textEmail: UITextField!
    @IBOutlet var textPassword: UITextField!
    @IBOutlet var textonfirmPassword: UITextField!
    
    //MARK: viewDidLoad Methods
    override func viewDidLoad() {
        super.viewDidLoad()

 
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
       // textFieldValidation()
        let addressVC = UIStoryboard(name: "Agents", bundle: nil).instantiateViewController(withIdentifier: "AgentAddressViewController") as! AgentAddressViewController
        self.navigationController?.pushViewController(addressVC, animated: true)
    }
    //MARK: signupAPI Methods
    func signupAPI(){
        
        SKActivityIndicator.spinnerColor(UIColor.darkGray)
        SKActivityIndicator.show("Loading...")
        // set params
        let parameters: Parameters = [
            "fname": self.textFirstName.text!,
            "lname": self.textLastName.text!,
            "email":self.textEmail.text!,
            "terms_and_conditions": "1",
            "agents_users_role_id" : "4",
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
//    //MARK:- TextFiled Delegate
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//      self.pickUp(textFirstName)
//    }
//
//    //MARK:- Button
//    @objc func doneClick() {
//
//        print( "\(hour)\(":")\(minutes)\(":")\(seconds)")
//
//        self.textFirstName.resignFirstResponder()
//    }
//    @objc func cancelClick() {
//        self.textFirstName.resignFirstResponder()
//    }
//    func pickUp(_ textField : UITextField){
//
//        // UIPickerView
//        self.pickerView = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
//        self.pickerView.delegate = self
//        self.pickerView.dataSource = self
//        self.pickerView.backgroundColor = UIColor.white
//        textField.inputView = self.pickerView
//
//        // ToolBar
//        let toolBar = UIToolbar()
//        toolBar.barStyle = .default
//        toolBar.isTranslucent = true
//        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
//        toolBar.sizeToFit()
//
//        // Adding Button ToolBar
//        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(SellerAddressViewController.doneClick))
//        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
//        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(SellerAddressViewController.cancelClick))
//        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
//        toolBar.isUserInteractionEnabled = true
//        textField.inputAccessoryView = toolBar
//
//    }
//    //MARK:- PickerView Delegate & DataSource
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 3
//    }
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        switch component {
//        case 0:
//            return 25
//        case 1,2:
//            return 60
//
//        default:
//            return 0
//        }
//    }
//    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
//        return pickerView.frame.size.width/3
//    }
//
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        switch component {
//        case 0:
//            return "\(row) Hour"
//        case 1:
//            return "\(row) Minute"
//        case 2:
//            return "\(row) Second"
//        default:
//            return ""
//        }
//
//    }
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        switch component {
//        case 0:
//            hour = row
//        case 1:
//            minutes = row
//        case 2:
//            seconds = row
//        default:
//            break;
//        }
//    }
}



//extension RegistrationViewController:UIPickerViewDelegate,UIPickerViewDataSource {
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 3
//    }
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        switch component {
//        case 0:
//            return 25
//        case 1,2:
//            return 60
//
//        default:
//            return 0
//        }
//    }
//
//    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
//        return pickerView.frame.size.width/3
//    }
//
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        switch component {
//        case 0:
//            return "\(row) Hour"
//        case 1:
//            return "\(row) Minute"
//        case 2:
//            return "\(row) Second"
//        default:
//            return ""
//        }
//    }
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        switch component {
//        case 0:
//            hour = row
//        case 1:
//            minutes = row
//        case 2:
//            seconds = row
//        default:
//            break;
//        }
//    }
//}

