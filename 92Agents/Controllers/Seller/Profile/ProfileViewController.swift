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


class ProfileViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
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
     var countryArr = [getCountryName]()
     let picker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.profileImg.layer.cornerRadius = self.profileImg.frame.size.height / 2
        self.profileImg.clipsToBounds = true
        bookmarkAPI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    //MARK: bookmarkAPI Methods
    func bookmarkAPI(){
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
                for item in ((((response)?.value(forKey: "response") as! NSDictionary) ).value(forKey: "states") as! NSArray) {
                    self.countryArr.append(getCountryName.init(name: ((item as! NSDictionary).value(forKey: "state_name") as! String), id: ((item as! NSDictionary).value(forKey: "state_id") as! String)))
                }
                DispatchQueue.main.async(execute: {
                    self.profileImg.layer.cornerRadius = self.profileImg.frame.size.height / 2
                    self.profileImg.clipsToBounds = true
                    let url = URL(string: (((((response)?.value(forKey: "response") as! NSDictionary) ).value(forKey: "userdetails") as! NSDictionary).value(forKey: "photo") as! String))
                    self.profileImg.kf.indicatorType = .activity
                    self.profileImg.kf.setImage(with: url,placeholder: nil)
                    self.lblEmail.text = (((((response)?.value(forKey: "response") as! NSDictionary) ).value(forKey: "user") as! NSDictionary).value(forKey: "email") as! String)
                    self.lblFullName.text = (((((response)?.value(forKey: "response") as! NSDictionary) ).value(forKey: "userdetails") as! NSDictionary).value(forKey: "name") as! String)
                    self.textAboutme.text = (((((response)?.value(forKey: "response") as! NSDictionary) ).value(forKey: "userdetails") as! NSDictionary).value(forKey: "description") as! String)
                    self.textEmail.text = (((((response)?.value(forKey: "response") as! NSDictionary) ).value(forKey: "user") as! NSDictionary).value(forKey: "email") as! String)
                    self.textFullNamel.text = (((((response)?.value(forKey: "response") as! NSDictionary) ).value(forKey: "userdetails") as! NSDictionary).value(forKey: "name") as! String)
                    self.textAdd1.text = (((((response )?.value(forKey: "response") as! NSDictionary) ).value(forKey: "userdetails") as! NSDictionary).value(forKey: "address") as! String)
                    self.textadd2.text = (((((response)?.value(forKey: "response") as! NSDictionary) ).value(forKey: "userdetails") as! NSDictionary).value(forKey: "address2") as! String)
                    self.textCity.text = (((((response)?.value(forKey: "response") as! NSDictionary) ).value(forKey: "userdetails") as! NSDictionary).value(forKey: "city_id") as! String)
                    
                    if (((((response)?.value(forKey: "response") as! NSDictionary) ).value(forKey: "userdetails") as! NSDictionary).value(forKey: "state_id") as! String) == "" {
                    }
                    else{
                        for section in 0...self.countryArr.count - 1 {
                            
                            if (((((response)?.value(forKey: "response") as! NSDictionary) ).value(forKey: "userdetails") as! NSDictionary).value(forKey: "state_id") as! String) == self.countryArr[section].id{
                                self.textState.text = self.countryArr[section].name
                            }
                        }
                    }
                    self.textPhonecell.text = (((((response)?.value(forKey: "response") as! NSDictionary) ).value(forKey: "userdetails") as! NSDictionary).value(forKey: "phone") as! String)
                    self.textPhonework.text = (((((response )?.value(forKey: "response") as! NSDictionary) ).value(forKey: "userdetails") as! NSDictionary).value(forKey: "phone_work") as! String)
                    self.textPhonechome.text = (((((response )?.value(forKey: "response") as! NSDictionary) ).value(forKey: "userdetails") as! NSDictionary).value(forKey: "phone_home") as! String)
                    self.textFax.text = (((((response)?.value(forKey: "response") as! NSDictionary) ).value(forKey: "userdetails") as! NSDictionary).value(forKey: "zip_code") as! String)
                    self.textZipcode.text = (((((response)?.value(forKey: "response") as! NSDictionary) ).value(forKey: "userdetails") as! NSDictionary).value(forKey: "zip_code") as! String)
                })
                    
                }else{
                    Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: (response?.value(forKey: "error") as! String))
                }
            }
            
        }
    
    //MARK: profileAPI Method
    func profileAPI() {
        self.countryArr.removeAll()
        SKActivityIndicator.spinnerColor(UIColor.darkGray)
        SKActivityIndicator.show("Loading...")
        let url = URL(string: "http://92agents.com/api/profile/buyer")!
        let jsonDict = [
            "agents_user_id": Model.sharedInstance.userID,
            "agents_users_role_id":Model.sharedInstance.userRole,
            ]
        let jsonData = try! JSONSerialization.data(withJSONObject: jsonDict, options: [])
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let token = "\(Model.sharedInstance.accessToken)"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
       // request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("error:", error)
                return
            }
            DispatchQueue.main.async(execute: {
                SKActivityIndicator.dismiss()
            })
            do {
                
                guard let data = data else { return }
                guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] else { return }
                print("json:", json)
               
                for item in ((((json as NSDictionary).value(forKey: "response") as! NSDictionary) ).value(forKey: "states") as! NSArray) {
                    self.countryArr.append(getCountryName.init(name: ((item as! NSDictionary).value(forKey: "state_name") as! String), id: ((item as! NSDictionary).value(forKey: "state_id") as! String)))
                }
                DispatchQueue.main.async(execute: {
                    self.profileImg.layer.cornerRadius = self.profileImg.frame.size.height / 2
                    self.profileImg.clipsToBounds = true
                    let url = URL(string: (((((json as NSDictionary).value(forKey: "response") as! NSDictionary) ).value(forKey: "userdetails") as! NSDictionary).value(forKey: "photo") as! String))
                    self.profileImg.kf.indicatorType = .activity
                    self.profileImg.kf.setImage(with: url,placeholder: nil)
                    self.lblEmail.text = (((((json as NSDictionary).value(forKey: "response") as! NSDictionary) ).value(forKey: "user") as! NSDictionary).value(forKey: "email") as! String)
                    self.lblFullName.text = (((((json as NSDictionary).value(forKey: "response") as! NSDictionary) ).value(forKey: "userdetails") as! NSDictionary).value(forKey: "name") as! String)
                    self.textAboutme.text = (((((json as NSDictionary).value(forKey: "response") as! NSDictionary) ).value(forKey: "userdetails") as! NSDictionary).value(forKey: "description") as! String)
                    self.textEmail.text = (((((json as NSDictionary).value(forKey: "response") as! NSDictionary) ).value(forKey: "user") as! NSDictionary).value(forKey: "email") as! String)
                    self.textFullNamel.text = (((((json as NSDictionary).value(forKey: "response") as! NSDictionary) ).value(forKey: "userdetails") as! NSDictionary).value(forKey: "name") as! String)
                    self.textAdd1.text = (((((json as NSDictionary).value(forKey: "response") as! NSDictionary) ).value(forKey: "userdetails") as! NSDictionary).value(forKey: "address") as! String)
                    self.textadd2.text = (((((json as NSDictionary).value(forKey: "response") as! NSDictionary) ).value(forKey: "userdetails") as! NSDictionary).value(forKey: "address2") as! String)
                    self.textCity.text = (((((json as NSDictionary).value(forKey: "response") as! NSDictionary) ).value(forKey: "userdetails") as! NSDictionary).value(forKey: "city_id") as! String)
                    if (((((response)?.value(forKey: "response") as! NSDictionary) ).value(forKey: "userdetails") as! NSDictionary).value(forKey: "state_id") as! String) == "" {
                    }
                    else{
                        for section in 0...self.countryArr.count - 1 {
                            
                            if (((((response)?.value(forKey: "response") as! NSDictionary) ).value(forKey: "userdetails") as! NSDictionary).value(forKey: "state_id") as! String) == self.countryArr[section].id{
                                self.textState.text = self.countryArr[section].name
                            }
                        }
                    }
                    self.textPhonecell.text = (((((json as NSDictionary).value(forKey: "response") as! NSDictionary) ).value(forKey: "userdetails") as! NSDictionary).value(forKey: "phone") as! String)
                    self.textPhonework.text = (((((json as NSDictionary).value(forKey: "response") as! NSDictionary) ).value(forKey: "userdetails") as! NSDictionary).value(forKey: "phone_work") as! String)
                    self.textPhonechome.text = (((((json as NSDictionary).value(forKey: "response") as! NSDictionary) ).value(forKey: "userdetails") as! NSDictionary).value(forKey: "phone_home") as! String)
                    self.textFax.text = (((((json as NSDictionary).value(forKey: "response") as! NSDictionary) ).value(forKey: "userdetails") as! NSDictionary).value(forKey: "zip_code") as! String)
                    self.textZipcode.text = (((((json as NSDictionary).value(forKey: "response") as! NSDictionary) ).value(forKey: "userdetails") as! NSDictionary).value(forKey: "zip_code") as! String)
                })
            } catch {
                print("error:", error)
            }
        }
        
        task.resume()
    }
    
    //MARK: textFieldValidation Method
    func textFieldValidation()
    {
        if (self.textState.text?.isEmpty)! {
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
        return self.countryArr.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.countryArr[row].name
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.textState.text = self.countryArr[row].name
    }
    //MARK:- TextFiled Delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.pickUp(self.textState)
    }
    
    //MARK:- Button
    @objc func doneClick() {
        self.textState.resignFirstResponder()
    }
    @objc func cancelClick() {
        self.textState.resignFirstResponder()
    }
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

