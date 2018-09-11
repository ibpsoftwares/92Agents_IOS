//
//  AgentAddressViewController.swift
//  92Agents
//
//  Created by Apple on 19/06/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import Alamofire
import SKActivityIndicatorView

class AgentAddressViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

     //MARK: IBOutlet and Variables
    @IBOutlet var textPhone: UITextField!
    @IBOutlet var textAdd1: UITextView!
    @IBOutlet var textAdd2: UITextView!
    @IBOutlet var textCity: UITextField!
    @IBOutlet var textState: UITextField!
    @IBOutlet var textZipCode: UITextField!
    var countryArr = [getCountryName]()
     var fileArr = NSArray()
    var pickerView : UIPickerView!
    var index = NSInteger()
    var select = String()
    
     //MARK: viewDidLoad Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        fetchCountryAPI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    //MARK: fetchCountryAPI Methods
    func fetchCountryAPI(){
        self.countryArr.removeAll()
        SKActivityIndicator.spinnerColor(UIColor.darkGray)
        SKActivityIndicator.show("Loading...")
        
        Webservice.apiGet(serviceName: "http://92agents.com/api/state", parameters: nil, headers: nil, completionHandler: { (response:NSDictionary?, error:NSError?) in
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
            self.fileArr = (response!.value(forKey: "states") as! NSArray)
            print(self.fileArr)
            for item in (response!.value(forKey: "states") as! NSArray) {
                print(item)
                self.countryArr.append(getCountryName.init(name: ((item as! NSDictionary).value(forKey: "state_name") as! String), id: String((item as! NSDictionary).value(forKey: "state_id") as! NSInteger)))
            }
        })
        
    }
    //MARK: textFieldValidation Method
    func textFieldValidation()
    {
        if (self.textPhone.text?.isEmpty)! {
            Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: "Enter Phone Number")
        }
        else if (self.textAdd1.text?.isEmpty)! {
            Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: "Enter Address1")
        }
        else if (self.textAdd2.text?.isEmpty)! {
            Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: "Enter Address2")
        }
        else if (self.textCity.text?.isEmpty)! {
            Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: "Enter City")
        }
        else if (self.textState.text?.isEmpty)! {
            Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: "Enter State")
        }
        else if (self.textZipCode.text?.isEmpty)! {
            Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: "Enter Zipcode")
        }
        else{
            // call api
            addressAPI()
        }
    }
     //MARK: setup PickerView
    func pickUp(_ textField : UITextField){
        
        // UIPickerView
        self.pickerView = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.pickerView.backgroundColor = UIColor.white
        textField.inputView = self.pickerView
    
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(SellerAddressViewController.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(SellerAddressViewController.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
        
    }
    //MARK:- PickerView Delegate & DataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if select == "state"{
            return self.fileArr.count
        }
        else if select == "city"{
            return (((self.fileArr ).object(at: self.index) as! NSDictionary).value(forKey: "state_and_city") as! NSArray).count
        }
        return 0
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if select == "state" {
            return ((self.fileArr ).object(at: row) as! NSDictionary).value(forKey: "state_name") as? String
        }
       else if select == "city" {
           return (((((self.fileArr ).object(at: self.index) as! NSDictionary).value(forKey: "state_and_city") as! NSArray).object(at: row) as! NSDictionary).value(forKey: "city_name") as! String)
        }
        return nil
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       
        if select == "state" {
            self.index = row
            self.textState.text = ((self.fileArr ).object(at: row) as! NSDictionary).value(forKey: "state_name") as? String
        }
        else if select == "city" {
            self.textCity.text = (((((self.fileArr ).object(at: self.index) as! NSDictionary).value(forKey: "state_and_city") as! NSArray).object(at: row) as! NSDictionary).value(forKey: "city_name") as! String)
        }
    }
    //MARK:- TextFiled Delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == self.textState {
           self.pickUp(self.textState)
            select = "state"
        }
        else  if textField == self.textCity {
            self.pickUp(self.textCity)
            select = "city"
        }
    }
    
    //MARK:- Button
    @objc func doneClick() {
        if select == "state" {
            self.textState.resignFirstResponder()
        }
        else  if select == "city" {
            self.textCity.resignFirstResponder()
        }
    }
    @objc func cancelClick() {
        if select == "state" {
            self.textState.resignFirstResponder()
        }
        else  if select == "city" {
            self.textCity.resignFirstResponder()
        }
    }
    @IBAction func btnNext(_ sender: UIButton) {
        textFieldValidation()
    }
    //MARK: addressAPI Methods
    func addressAPI(){
        SKActivityIndicator.spinnerColor(UIColor.darkGray)
        SKActivityIndicator.show("Loading...")
        
        // set params
        let parameters: Parameters = [
            "id": Model.sharedInstance.userID,
            "phone": self.textPhone.text!,
            "address_line_1":self.textAdd1.text!,
            "address_line_2":self.textAdd2.text!,
            "city": self.textCity.text!,
            "state" : self.countryArr[index].id,
            "zip_code": self.textZipCode.text!,
            "step": "2",
            "agents_users_role_id": Model.sharedInstance.userRole
        ]
        print(parameters)
        Webservice.apiPost(apiURl:  "http://92agents.com/api/signup2", parameters: parameters, headers: nil) { (response:NSDictionary?, error:NSError?) in
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
            let addressVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SellerPostViewController") as! SellerPostViewController
            self.navigationController?.pushViewController(addressVC, animated: true)
        }
    }
}
