//
//  ProfileViewController.swift
//  92Agents
//
//  Created by Apple on 29/06/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import SKActivityIndicatorView
import Kingfisher
import Alamofire


class ProfileViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
     //MARK: IBOutlet and Variables
    var pickerView : UIPickerView!
    @IBOutlet var profileImg: UIImageView!
    @IBOutlet var textAboutme: UITextField!
    @IBOutlet var textFullNamel: UITextField!
    @IBOutlet var textEmail: UITextField!
    @IBOutlet var textAdd1: UITextField!
    @IBOutlet var textadd2: UITextField!
    @IBOutlet var textCity: UITextField!
    @IBOutlet var textState: UITextField!
    @IBOutlet var textPhonecell: UITextField!
    @IBOutlet var textPhonechome: UITextField!
    @IBOutlet var textPhonework: UITextField!
    @IBOutlet var textFax: UITextField!
    @IBOutlet var textZipcode: UITextField!
     @IBOutlet var lblFullName: UILabel!
     @IBOutlet var lblEmail: UILabel!
     @IBOutlet var btnAboutMe: UIButton!
     @IBOutlet var btnAccount: UIButton!
     @IBOutlet var btnLocation: UIButton!
     var countryArr = [getCountryName]()
     let picker = UIImagePickerController()
    var fileArr = NSArray()
    var select = String()
    var index = NSInteger()
     var value = String()
    var cityID = String()
    var stateID = String()
     //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.profileImg.layer.cornerRadius = self.profileImg.frame.size.height / 2
        self.profileImg.clipsToBounds = true
        btnAboutMe.isHidden = true
        btnAccount.isHidden = true
        btnLocation.isHidden = true
        self.textAboutme.isUserInteractionEnabled = false
        self.textFullNamel.isUserInteractionEnabled = false
        self.textEmail.isUserInteractionEnabled = false
        self.textAdd1.isUserInteractionEnabled = false
        self.textadd2.isUserInteractionEnabled = false
        self.textCity.isUserInteractionEnabled = false
        self.textState.isUserInteractionEnabled = false
        self.textPhonecell.isUserInteractionEnabled = false
        self.textPhonechome.isUserInteractionEnabled = false
        self.textPhonework.isUserInteractionEnabled = false
        self.textFax.isUserInteractionEnabled = false
        self.textZipcode.isUserInteractionEnabled = false
        
        //fetchCountryAPI()
        profileAPI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
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
        
        })
    }
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    //MARK: profileAPI Methods
    func profileAPI(){
        SKActivityIndicator.spinnerColor(UIColor.darkGray)
        SKActivityIndicator.show("Loading...")
        let parameters: Parameters = [
            "agents_user_id": Model.sharedInstance.userID,
            "agents_users_role_id":Model.sharedInstance.userRole
        ]
        print(parameters)
        Webservice.apiGet(serviceName:"http://92agents.com/api/profile/buyer", parameters: parameters, headers: nil) { (response:NSDictionary?, error:NSError?) in
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
//                for item in ((((response)?.value(forKey: "response") as! NSDictionary) ).value(forKey: "states") as! NSArray) {
//                    self.countryArr.append(getCountryName.init(name: ((item as! NSDictionary).value(forKey: "state_name") as! String), id: ((item as! NSDictionary).value(forKey: "state_id") as! String)))
//                }
                DispatchQueue.main.async(execute: {
                    self.profileImg.layer.cornerRadius = self.profileImg.frame.size.height / 2
                    self.profileImg.clipsToBounds = true
                    let url = URL(string: (((((response)?.value(forKey: "response") as! NSDictionary) ).value(forKey: "userdetails") as! NSDictionary).value(forKey: "photo") as! String))
                    self.profileImg.kf.indicatorType = .activity
                    self.profileImg.kf.setImage(with: url,placeholder: nil)
                    if ((((response)?.value(forKey: "response") as! NSDictionary) ).value(forKey: "user") as! NSDictionary).value(forKey: "email") is NSNull{
                        
                    }
                    else{
                        self.lblEmail.text = (((((response)?.value(forKey: "response") as! NSDictionary) ).value(forKey: "user") as! NSDictionary).value(forKey: "email") as! String)
                    }
                    if ((((response)?.value(forKey: "response") as! NSDictionary) ).value(forKey: "user") as! NSDictionary).value(forKey: "name") is NSNull{
                        
                    }
                    else{
                        self.lblFullName.text = (((((response)?.value(forKey: "response") as! NSDictionary) ).value(forKey: "userdetails") as! NSDictionary).value(forKey: "name") as! String)
                    }
                    if ((((response)?.value(forKey: "response") as! NSDictionary) ).value(forKey: "user") as! NSDictionary).value(forKey: "description") is NSNull{
                        
                    }
                    else{
                         self.textAboutme.text = (((((response)?.value(forKey: "response") as! NSDictionary) ).value(forKey: "userdetails") as! NSDictionary).value(forKey: "description") as! String)
                    }
                    if ((((response)?.value(forKey: "response") as! NSDictionary) ).value(forKey: "user") as! NSDictionary).value(forKey: "email") is NSNull{
                        
                    }
                    else{
                         self.textEmail.text = (((((response)?.value(forKey: "response") as! NSDictionary) ).value(forKey: "user") as! NSDictionary).value(forKey: "email") as! String)
                    }
                    if ((((response)?.value(forKey: "response") as! NSDictionary) ).value(forKey: "user") as! NSDictionary).value(forKey: "name") is NSNull{
                        
                    }
                    else{
                         self.textFullNamel.text = (((((response)?.value(forKey: "response") as! NSDictionary) ).value(forKey: "userdetails") as! NSDictionary).value(forKey: "name") as! String)
                    }
                    if ((((response)?.value(forKey: "response") as! NSDictionary) ).value(forKey: "user") as! NSDictionary).value(forKey: "address") is NSNull{
                        
                    }
                    else{
                        self.textAdd1.text = (((((response )?.value(forKey: "response") as! NSDictionary) ).value(forKey: "userdetails") as! NSDictionary).value(forKey: "address") as! String)
                    }
                    if ((((response)?.value(forKey: "response") as! NSDictionary) ).value(forKey: "userdetails") as! NSDictionary).value(forKey: "address2") is NSNull{
                        
                    }
                    else{
                        self.textadd2.text = (((((response)?.value(forKey: "response") as! NSDictionary) ).value(forKey: "userdetails") as! NSDictionary).value(forKey: "address2") as! String)
                    }
                    if ((((response)?.value(forKey: "response") as! NSDictionary) ).value(forKey: "user") as! NSDictionary).value(forKey: "city_id") is NSNull{
                        
                    }
                    else{
                        self.textCity.text = (((((response)?.value(forKey: "response") as! NSDictionary) ).value(forKey: "userdetails") as! NSDictionary).value(forKey: "city_id") as! String)
                    }
                    if ((((((response)?.value(forKey: "response") as! NSDictionary) ).value(forKey: "userdetails") as! NSDictionary).value(forKey: "state") as! NSDictionary).value(forKey: "state_name") as! String) == "" {
                    }
                    else{
                         self.textState.text = ((((((response)?.value(forKey: "response") as! NSDictionary) ).value(forKey: "userdetails") as! NSDictionary).value(forKey: "state") as! NSDictionary).value(forKey: "state_name") as! String)
                        self.stateID = String((((((response)?.value(forKey: "response") as! NSDictionary) ).value(forKey: "userdetails") as! NSDictionary).value(forKey: "state") as! NSDictionary).value(forKey: "state_id") as! NSInteger)
                        self.cityID = String((((((response)?.value(forKey: "response") as! NSDictionary) ).value(forKey: "userdetails") as! NSDictionary).value(forKey: "city") as! NSDictionary).value(forKey: "city_id") as! NSInteger)
                        self.textCity.text = ((((((response)?.value(forKey: "response") as! NSDictionary) ).value(forKey: "userdetails") as! NSDictionary).value(forKey: "city") as! NSDictionary).value(forKey: "city_name") as! String)
                    }
                    if ((((response)?.value(forKey: "response") as! NSDictionary) ).value(forKey: "user") as! NSDictionary).value(forKey: "phone") is NSNull{
                        
                    }
                    else{
                       self.textPhonecell.text = (((((response)?.value(forKey: "response") as! NSDictionary) ).value(forKey: "userdetails") as! NSDictionary).value(forKey: "phone") as! String)
                    }
                    if ((((response )?.value(forKey: "response") as! NSDictionary) ).value(forKey: "userdetails") as! NSDictionary).value(forKey: "phone_work") is NSNull{
                        
                    }
                    else{
                         self.textPhonework.text = (((((response )?.value(forKey: "response") as! NSDictionary) ).value(forKey: "userdetails") as! NSDictionary).value(forKey: "phone_work") as! String)
                    }
                    if ((((response )?.value(forKey: "response") as! NSDictionary) ).value(forKey: "userdetails") as! NSDictionary).value(forKey: "phone_home") is NSNull{
                        
                    }
                    else{
                         self.textPhonechome.text = (((((response )?.value(forKey: "response") as! NSDictionary) ).value(forKey: "userdetails") as! NSDictionary).value(forKey: "phone_home") as! String)
                    }
                    if ((((response )?.value(forKey: "response") as! NSDictionary) ).value(forKey: "userdetails") as! NSDictionary).value(forKey: "zip_code") is NSNull{
                        
                    }
                    else{
                        self.textFax.text = (((((response)?.value(forKey: "response") as! NSDictionary) ).value(forKey: "userdetails") as! NSDictionary).value(forKey: "zip_code") as! String)
                    }
                    if ((((response )?.value(forKey: "response") as! NSDictionary) ).value(forKey: "userdetails") as! NSDictionary).value(forKey: "zip_code") is NSNull{
                        
                    }
                    else{
                         self.textZipcode.text = (((((response)?.value(forKey: "response") as! NSDictionary) ).value(forKey: "userdetails") as! NSDictionary).value(forKey: "zip_code") as! String)
                    }
                })
                }else{
                    Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: (response?.value(forKey: "error") as! String))
                }
            }
        }
    @IBAction func btnEditAboutMe(_ sender: UIButton) {
        btnAboutMe.isHidden = false
        self.textAboutme.isUserInteractionEnabled = true
        value = "aboutme"
    }
    @IBAction func btnEditLocation(_ sender: UIButton) {
        btnLocation.isHidden = false
        self.textEmail.isUserInteractionEnabled = true
        self.textAdd1.isUserInteractionEnabled = true
        self.textadd2.isUserInteractionEnabled = true
        self.textCity.isUserInteractionEnabled = true
        self.textState.isUserInteractionEnabled = true
        self.textPhonecell.isUserInteractionEnabled = true
        self.textPhonechome.isUserInteractionEnabled = true
        self.textPhonework.isUserInteractionEnabled = true
        self.textFax.isUserInteractionEnabled = true
        self.textZipcode.isUserInteractionEnabled = true
         value = "location"
    }
    @IBAction func btnEditAccount(_ sender: UIButton) {
         btnAccount.isHidden = false
         self.textFullNamel.isUserInteractionEnabled = true
         value = "account"
    }
    @IBAction func btnAboutMe(_ sender: UIButton) {
        updateProfileAPI()
    }
    @IBAction func btnLocation(_ sender: UIButton) {
        updateProfileAPI()
    }
    @IBAction func btnAccount(_ sender: UIButton) {
        updateProfileAPI()
    }
    //MARK: updateProfileAPI Method
    func updateProfileAPI(){
        SKActivityIndicator.spinnerColor(UIColor.darkGray)
        SKActivityIndicator.show("Loading...")
//        let parameters: Parameters = [
//            "agents_user_id": Model.sharedInstance.userID,
//            "agents_users_role_id":Model.sharedInstance.userRole
//        ]
        
        var parameters: Parameters = [:]
        
        if value == "aboutme"{
            parameters = [
                 "id": Model.sharedInstance.userID,
                "description" : self.textAboutme.text!
            ]
        }
        else if value == "account"{
            parameters = [
                "id": Model.sharedInstance.userID,
                "name" : self.textFullNamel.text!
            ]
        }
        else if value == "location"{
            parameters = [
                "id": Model.sharedInstance.userID,
                "address" : self.textEmail.text!,
                "address2" : self.textFullNamel.text!,
                 "city_id" : self.cityID,
                 "state_id" : self.stateID,
                   "phone" : self.textPhonecell.text!,
                   "phone_home" : self.textPhonechome.text!,
                     "phone_work" : self.textPhonework.text!,
                      "fax_no" : self.textFax.text!,
                      "zip_code" : self.textZipcode.text!
            ]
        }
        print(parameters)
        Webservice.apiPost(apiURl:"http://92agents.com/api/profile/editFields", parameters: parameters, headers: nil) { (response:NSDictionary?, error:NSError?) in
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
            if self.value == "aboutme"{
                self.btnAboutMe.isHidden = true
            }
            else if self.value == "account"{
                self.btnAccount.isHidden = true
            }
            else if self.value == "location"{
                self.btnLocation.isHidden = true
            }
            if let dict = response as? [AnyHashable:Any] {
                print(dict)
                if ((dict as NSDictionary).value(forKey: "status") as? String == "100"){
                    self.profileAPI()
                }
            }else{
                Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: (response?.value(forKey: "error") as! String))
            }
        }
    }
    //MARK: textFieldValidation Method
    func textFieldValidation()
    {
        if (self.textCity.text?.isEmpty)! {
            Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: "Select City")
        }
        else  if (self.textState.text?.isEmpty)! {
            Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: "Select State")
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
            self.stateID = (((self.fileArr ).object(at: row) as! NSDictionary).value(forKey: "state_id") as? String)!
        }
        else if select == "city" {
            self.textCity.text = (((((self.fileArr ).object(at: self.index) as! NSDictionary).value(forKey: "state_and_city") as! NSArray).object(at: row) as! NSDictionary).value(forKey: "city_name") as! String)
            self.cityID = (((((self.fileArr ).object(at: self.index) as! NSDictionary).value(forKey: "state_and_city") as! NSArray).object(at: row) as! NSDictionary).value(forKey: "city_id") as! String)
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
     //MARK:- Choose Gallery and Camera
    @IBAction func chooseProfilePicBtnClicked(sender: AnyObject) {
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            self.openCamera()
        }
        let gallaryAction = UIAlertAction(title: "Gallary", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            self.openGallary()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel)
        {
            UIAlertAction in
        }
        // Add the actions
        picker.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    func openCamera(){
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)){
            picker.sourceType = UIImagePickerControllerSourceType.camera
            self .present(picker, animated: true, completion: nil)
        }else{
            let alert = UIAlertView()
            alert.title = "Warning"
            alert.message = "You don't have camera"
            alert.addButton(withTitle: "OK")
            alert.show()
        }
    }
    func openGallary(){
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(picker, animated: true, completion: nil)
    }
    //MARK:UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.profileImg.image = pickedImage
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

