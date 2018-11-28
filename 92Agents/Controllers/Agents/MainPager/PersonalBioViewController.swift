//
//  PersonalBioViewController.swift
//  92Agents
//
//  Created by Apple on 09/10/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import SKActivityIndicatorView
import Kingfisher
import Alamofire

class PersonalBioViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource,UITextFieldDelegate {

    var pickerView : UIPickerView!
    var select = String()
    var stateArr = NSArray()
     var franchiesArr = NSArray()
    var index = NSInteger()
    var stateID = String()
    var cityID = String()
    var franchiesID = String()
     var zipStrFinal = String()
    @IBOutlet var textCity: UITextField!
    @IBOutlet var textState: UITextField!
    @IBOutlet var textOfficeAddress: UITextField!
    @IBOutlet var textZipCode: UITextField!
    @IBOutlet var textLicsenseNo: UITextField!
    @IBOutlet var textFranchise: UITextField!
    @IBOutlet var textCompnayName: UITextField!
    @IBOutlet var textYearExp: UITextField!
    @IBOutlet var textFaxNo: UITextField!
    @IBOutlet var textBrokerName: UITextField!
    @IBOutlet var textMlsOfficeId: UITextField!
    @IBOutlet var textMlsPublicId: UITextField!
    @IBOutlet var textDocument: UITextField!
    @IBOutlet var zipcodeView: UIView!
    @IBOutlet var zipcodeViewHeight: NSLayoutConstraint!
    var yearExp = ["<1","5-10","10-15","greater than 10"]
     var zipStr:[String] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        franchiseAPI()
        agentProfileAPI()
    }
    //MARK: agentProfileAPI Methods
    func agentProfileAPI(){
        SKActivityIndicator.spinnerColor(UIColor.darkGray)
        SKActivityIndicator.show("Loading...")
        let parameters: Parameters = [
            "agents_user_id": Model.sharedInstance.userID,
            "agents_users_role_id":Model.sharedInstance.userRole
        ]
        print(parameters)
        Webservice.apiGet(serviceName:"http://92agents.com/api/profile/agent", parameters: nil, headers: nil) { (response:NSDictionary?, error:NSError?) in
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
            // print(response!)
            
            if let dict = response as? [AnyHashable:Any] {
                print(dict)
               
                DispatchQueue.main.async(execute: {
                    self.stateArr = (((response)?.value(forKey: "response") as! NSDictionary).value(forKey: "state_and_city") as! NSArray)
                    if ((((response)?.value(forKey: "response") as! NSDictionary) ).value(forKey: "userdetails") as! NSDictionary).value(forKey: "office_address") is NSNull{
                        
                    }
                    else{
                        self.textOfficeAddress.text = (((((response )?.value(forKey: "response") as! NSDictionary) ).value(forKey: "userdetails") as! NSDictionary).value(forKey: "office_address") as! String)
                    }
                    if ((((response)?.value(forKey: "response") as! NSDictionary) ).value(forKey: "userdetails") as! NSDictionary).value(forKey: "zip_code") is NSNull{
                        
                    }
                    else{
                        self.textZipCode.text = (((((response )?.value(forKey: "response") as! NSDictionary) ).value(forKey: "userdetails") as! NSDictionary).value(forKey: "zip_code") as! String)
                        self.zipStr.append(self.textZipCode.text!)
                    }
                    if ((((response)?.value(forKey: "response") as! NSDictionary) ).value(forKey: "userdetails") as! NSDictionary).value(forKey: "licence_number") is NSNull{
                        
                    }
                    else{
                        self.textLicsenseNo.text = (((((response )?.value(forKey: "response") as! NSDictionary) ).value(forKey: "userdetails") as! NSDictionary).value(forKey: "licence_number") as! String)
                    }
                    if ((((response)?.value(forKey: "response") as! NSDictionary) ).value(forKey: "userdetails") as! NSDictionary).value(forKey: "franchise") is NSNull{
                        
                    }
                    else{
                        self.textFranchise.text = (((((response )?.value(forKey: "response") as! NSDictionary) ).value(forKey: "userdetails") as! NSDictionary).value(forKey: "franchise") as! String)
                    }
                    if ((((response)?.value(forKey: "response") as! NSDictionary) ).value(forKey: "userdetails") as! NSDictionary).value(forKey: "company_name") is NSNull{
                        
                    }
                    else{
                        self.textCompnayName.text = (((((response )?.value(forKey: "response") as! NSDictionary) ).value(forKey: "userdetails") as! NSDictionary).value(forKey: "company_name") as! String)
                    }
                    if ((((response)?.value(forKey: "response") as! NSDictionary) ).value(forKey: "userdetails") as! NSDictionary).value(forKey: "years_of_expreience") is NSNull{
                        
                    }
                    else{
                        self.textYearExp.text = (((((response )?.value(forKey: "response") as! NSDictionary) ).value(forKey: "userdetails") as! NSDictionary).value(forKey: "years_of_expreience") as! String)
                    }
                    if ((((response)?.value(forKey: "response") as! NSDictionary) ).value(forKey: "userdetails") as! NSDictionary).value(forKey: "fax_no") is NSNull{
                        
                    }
                    else{
                        self.textFaxNo.text = (((((response )?.value(forKey: "response") as! NSDictionary) ).value(forKey: "userdetails") as! NSDictionary).value(forKey: "fax_no") as! String)
                    }
                    if ((((response)?.value(forKey: "response") as! NSDictionary) ).value(forKey: "userdetails") as! NSDictionary).value(forKey: "brokers_name") is NSNull{
                        
                    }
                    else{
                        self.textBrokerName.text = (((((response )?.value(forKey: "response") as! NSDictionary) ).value(forKey: "userdetails") as! NSDictionary).value(forKey: "brokers_name") as! String)
                    }
                    if ((((response)?.value(forKey: "response") as! NSDictionary) ).value(forKey: "userdetails") as! NSDictionary).value(forKey: "MLS_office_id") is NSNull{
                        
                    }
                    else{
                        self.textMlsOfficeId.text = (((((response )?.value(forKey: "response") as! NSDictionary) ).value(forKey: "userdetails") as! NSDictionary).value(forKey: "MLS_office_id") as! String)
                    }
                    if ((((response)?.value(forKey: "response") as! NSDictionary) ).value(forKey: "userdetails") as! NSDictionary).value(forKey: "MLS_public_id") is NSNull{
                        
                    }
                    else{
                        self.textMlsPublicId.text = (((((response )?.value(forKey: "response") as! NSDictionary) ).value(forKey: "userdetails") as! NSDictionary).value(forKey: "MLS_public_id") as! String)
                    }
                    if ((((response)?.value(forKey: "response") as! NSDictionary) ).value(forKey: "userdetails") as! NSDictionary).value(forKey: "statement_document") is NSNull{
                        
                    }
                    else{
                        self.textDocument.text = (((((response )?.value(forKey: "response") as! NSDictionary) ).value(forKey: "userdetails") as! NSDictionary).value(forKey: "statement_document") as! String)
                    }
                    if ((((response)?.value(forKey: "response") as! NSDictionary) ).value(forKey: "userdetails") as! NSDictionary).value(forKey: "state") is NSNull{
                        
                    }
                    else{
                        self.textState.text = ((((((response )?.value(forKey: "response") as! NSDictionary) ).value(forKey: "userdetails") as! NSDictionary).value(forKey: "state") as! NSDictionary).value(forKey: "state_name") as! String)
                        self.stateID = String((((((response )?.value(forKey: "response") as! NSDictionary) ).value(forKey: "userdetails") as! NSDictionary).value(forKey: "state") as! NSDictionary).value(forKey: "state_id") as! NSInteger)
                    }
                    if ((((response)?.value(forKey: "response") as! NSDictionary) ).value(forKey: "userdetails") as! NSDictionary).value(forKey: "city") is NSNull{
                        
                    }
                    else{
                        self.textCity.text = ((((((response )?.value(forKey: "response") as! NSDictionary) ).value(forKey: "userdetails") as! NSDictionary).value(forKey: "city") as! NSDictionary).value(forKey: "city_name") as! String)
                        self.cityID = String((((((response )?.value(forKey: "response") as! NSDictionary) ).value(forKey: "userdetails") as! NSDictionary).value(forKey: "city") as! NSDictionary).value(forKey: "city_id") as! NSInteger)
                    }
                })
            }else{
                Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: (response?.value(forKey: "error") as! String))
            }
        }
    }
    //MARK: Set PickerView
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
            return self.stateArr.count
        }
        else if select == "city"{
            return (((self.stateArr ).object(at: self.index) as! NSDictionary).value(forKey: "state_and_city") as! NSArray).count
        }
        else if select == "yearExp"{
            return self.yearExp.count
        }
        else if select == "franchies"{
            return self.franchiesArr.count
        }
        return 0
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if select == "state" {
            return ((self.stateArr ).object(at: row) as! NSDictionary).value(forKey: "state_name") as? String
        }
        else if select == "city" {
            return (((((self.stateArr ).object(at: self.index) as! NSDictionary).value(forKey: "state_and_city") as! NSArray).object(at: row) as! NSDictionary).value(forKey: "city_name") as! String)
        }
        else if select == "yearExp"{
            return self.yearExp[row]
        }
        else if select == "franchies"{
            return ((self.franchiesArr ).object(at: row) as! NSDictionary).value(forKey: "franchise_name") as? String
        }
        return nil
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if select == "state" {
            self.index = row
            self.textState.text = ((self.stateArr ).object(at: row) as! NSDictionary).value(forKey: "state_name") as? String
            self.stateID = ((self.stateArr ).object(at: row) as! NSDictionary).value(forKey: "state_id") as! String
        }
        else if select == "city" {
            self.textCity.text = (((((self.stateArr ).object(at: self.index) as! NSDictionary).value(forKey: "state_and_city") as! NSArray).object(at: row) as! NSDictionary).value(forKey: "city_name") as! String)
            self.cityID = (((((self.stateArr ).object(at: self.index) as! NSDictionary).value(forKey: "state_and_city") as! NSArray).object(at: row) as! NSDictionary).value(forKey: "city_id") as! String)
        }
        else if select == "yearExp"{
            self.textYearExp.text =  self.yearExp[row]
        }
        else if select == "franchies"{
            self.textFranchise.text =  ((self.franchiesArr ).object(at: row) as! NSDictionary).value(forKey: "franchise_name") as? String
            franchiesID = ((self.franchiesArr ).object(at: row) as! NSDictionary).value(forKey: "franchise_id") as! String
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
        else  if textField == self.textYearExp {
            self.pickUp(self.textYearExp)
            select = "yearExp"
        }
        else  if textField == self.textFranchise {
            self.pickUp(self.textFranchise)
            select = "franchies"
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
        else  if select == "yearExp" {
            self.textYearExp.resignFirstResponder()
        }
        else  if select == "franchies" {
            self.textFranchise.resignFirstResponder()
        }
    }
    @objc func cancelClick() {
        if select == "state" {
            self.textState.resignFirstResponder()
        }
        else  if select == "city" {
            self.textCity.resignFirstResponder()
        }
        else  if select == "yearExp" {
            self.textYearExp.resignFirstResponder()
        }
        else  if select == "franchies" {
            self.textFranchise.resignFirstResponder()
        }
    }
    //MARK: franchiseAPI Methods
    func franchiseAPI(){
        SKActivityIndicator.spinnerColor(UIColor.darkGray)
        SKActivityIndicator.show("Loading...")
        
        Webservice.apiPost(apiURl: "http://92agents.com/api/franchise", parameters: nil, headers: nil, completionHandler: { (response:NSDictionary?, error:NSError?) in
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
            self.franchiesArr = ((response)?.value(forKey: "response") as! NSArray)
        })
    }
    //MARK: Add New Zipcide Button Programatically
    @IBAction func btnAddZipcode(_ sender: UIButton) {
        let sampleTextField =  UITextField(frame: CGRect(x: self.zipcodeView.frame.origin.x - 10, y: self.zipcodeView.frame.size.height + 10, width: self.zipcodeView.frame.size.width, height: 30))
        sampleTextField.placeholder = "Enter text here"
        sampleTextField.font = UIFont.systemFont(ofSize: 15)
        sampleTextField.layer.borderWidth = 1.0
        sampleTextField.layer.borderColor = UIColor.black.cgColor
        //sampleTextField.backgroundColor = UIColor.red
//        sampleTextField.borderStyle = UITextBorderStyle.roundedRect
//        sampleTextField.autocorrectionType = UITextAutocorrectionType.no
//        sampleTextField.keyboardType = UIKeyboardType.default
//        sampleTextField.returnKeyType = UIReturnKeyType.done
//        sampleTextField.clearButtonMode = UITextFieldViewMode.whileEditing;
//        sampleTextField.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        sampleTextField.delegate = self
        self.zipcodeView.addSubview(sampleTextField)
        self.zipcodeViewHeight.constant = self.zipcodeView.frame.size.height + sampleTextField.frame.size.height + 10
    }
    // MARK:- ---> Textfield Delegates
    func textFieldDidEndEditing(_ textField: UITextField) {
        //print("\(textField.text!)")
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        //print("hello1")
        return true;
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        //print("hello1")
        return true;
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
         print("\(textField.text!)")
        if textField == self.textFranchise{
            
        }else{
             zipStr.append(textField.text!)
        }
       
        return true;
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print("While entering the characters this method gets called")
        return true;
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("hello2")
        textField.resignFirstResponder();
        return true;
    }
     @IBAction func updatePersonalBio(_ sender: UIButton) {
        updatePersonalBioAPI()
    }
    //MARK: updatePersonalBioAPI Method
    func updatePersonalBioAPI(){
        SKActivityIndicator.spinnerColor(UIColor.darkGray)
        SKActivityIndicator.show("Loading...")
        for index in 0..<zipStr.count{
            if index == 0 {
                zipStrFinal = self.textZipCode.text!
                print(zipStrFinal)
            }
            else{
                zipStrFinal = zipStrFinal + "," + zipStr[index]
            }
        }
        print(zipStrFinal)
        var parameters: Parameters = [:]
            parameters = [
                "id": Model.sharedInstance.userID,
                "office_address" : self.textOfficeAddress.text!,
                "state_id" : self.stateID,
                "city_id" : self.cityID,
                "zip_code" : zipStrFinal,
                "licence_number" : self.textLicsenseNo.text!,
                "franchise" : franchiesID,
                "company_name" : self.textCompnayName.text!,
                "years_of_expreience" : self.textYearExp.text!,
                "fax_no" : self.textFaxNo.text!,
                "brokers_name" : self.textBrokerName.text!,
                "MLS_public_id" : self.textMlsPublicId.text!,
                "MLS_office_id" : self.textMlsOfficeId.text!,
                "statement_document" : "",
                "statement_document_c" : self.textDocument.text!,
                "terms_and_conditions" : "1"
            ]
        print(parameters)
        Webservice.apiPost(apiURl:"http://92agents.com/api/profile/editagentprofile", parameters: parameters, headers: nil) { (response:NSDictionary?, error:NSError?) in
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
                    //self.profileAPI()
                }
            }else{
                Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: (response?.value(forKey: "error") as! String))
            }
        }
    }
    func toJSonString(data : Any) -> String {
        var jsonString = "";
        do {
            
            let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
            jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
            
        } catch {
            print(error.localizedDescription)
        }
        
        return jsonString;
    }
}
