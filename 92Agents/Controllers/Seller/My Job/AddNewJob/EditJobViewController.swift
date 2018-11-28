//
//  EditJobViewController.swift
//  92Agents
//
//  Created by Apple on 10/07/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import Alamofire
import SKActivityIndicatorView

class EditJobViewController: UIViewController , UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate{

        //MARK: IBOutlet and Variables
    var pickerView : UIPickerView!
    var countryArr = [getCountryName]()
    var check = NSInteger()
    @IBOutlet var textState: UITextField!
    @IBOutlet var textSell: UITextField!
    @IBOutlet var textHomeType: UITextField!
    @IBOutlet var textPostTitle: UITextField!
    @IBOutlet var textPropertyDetail: UITextField!
    @IBOutlet var textAddressLine1: UITextField!
    @IBOutlet var textAddressLine2: UITextField!
    @IBOutlet var textCity: UITextField!
    @IBOutlet var textZipcode: UITextField!
    @IBOutlet var textBestFeature1: UITextField!
     @IBOutlet var textBestFeature2: UITextField!
     @IBOutlet var textBestFeature3: UITextField!
     @IBOutlet var textBestFeature4: UITextField!
     var editPostDict = NSDictionary()
    let pickerData = ["when do you want to sell", "Now", "Within 30 days", "Within 30 days", "Undecided"]
    let HomeTypeData = ["Select Home type", "Single Family", "Condo/Townhome", "Multi Family", "Manufactured", "Lots/Land"]
    
        //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
         fetchCountryAPI()
        print(editPostDict)
        
        // set data
        self.textPostTitle.text = (editPostDict as NSDictionary).value(forKey: "posttitle") as? String
        self.textPropertyDetail.text = (editPostDict as NSDictionary).value(forKey: "details") as? String
        self.textAddressLine1.text = (editPostDict as NSDictionary).value(forKey: "address1") as? String
        self.textAddressLine2.text = (editPostDict as NSDictionary).value(forKey: "address2") as? String
        self.textCity.text = (editPostDict as NSDictionary).value(forKey: "city") as? String
        self.textState.text = (editPostDict as NSDictionary).value(forKey: "state_name") as? String
        self.textZipcode.text = (editPostDict as NSDictionary).value(forKey: "zip") as? String
        self.textSell.text = (editPostDict as NSDictionary).value(forKey: "when_do_you_want_to_sell") as? String
        self.textHomeType.text = (editPostDict as NSDictionary).value(forKey: "home_type") as? String
        if ((editPostDict as NSDictionary).value(forKey: "best_features") as? NSDictionary)?.count != 0{
             self.textBestFeature1.text = ((editPostDict as NSDictionary).value(forKey: "best_features") as? NSDictionary)?.value(forKey: "best_features_1") as? String
             self.textBestFeature2.text = ((editPostDict as NSDictionary).value(forKey: "best_features") as? NSDictionary)?.value(forKey: "best_features_2") as? String
             self.textBestFeature3.text = ((editPostDict as NSDictionary).value(forKey: "best_features") as? NSDictionary)?.value(forKey: "best_features_3") as? String
             self.textBestFeature4.text = ((editPostDict as NSDictionary).value(forKey: "best_features") as? NSDictionary)?.value(forKey: "best_features_4") as? String
        }
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
            //print(response!)
            for item in (response!.value(forKey: "states") as! NSArray) {
              //  print(item)
                self.countryArr.append(getCountryName.init(name: ((item as! NSDictionary).value(forKey: "state_name") as! String), id: String((item as! NSDictionary).value(forKey: "state_id") as! NSInteger)))
            }
        })
        
    }
        //MARK: Setup PickerView
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
        
        if check == 1 {
            return self.countryArr.count
        }
        else if check == 2 {
            return self.pickerData.count
        }
        else if check == 3 {
            return self.HomeTypeData.count
        }
        return 0
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if check == 1 {
            return self.countryArr[row].name
        }
        else if check == 2 {
            return self.pickerData[row]
        }
        else if check == 3 {
            return self.HomeTypeData[row]
        }
        return nil
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if check == 1 {
            self.textState.text = self.countryArr[row].name
        }
        else if check == 2 {
            self.textSell.text = self.pickerData[row]
        }
        else if check == 3 {
            self.textHomeType.text = self.HomeTypeData[row]
        }
        
    }
    //MARK:- TextFiled Delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == textState {
            self.pickUp(self.textState)
            check = 1
        }
        else if textField == textSell {
            self.pickUp(self.textSell)
            check = 2
        }
        else if textField == textHomeType {
            self.pickUp(self.textHomeType)
            check = 3
        }
    }
    //MARK:- Button
    @objc func doneClick() {
        
        if check == 1 {
            self.textState.resignFirstResponder()
        }
        else if check == 2 {
            self.textSell.resignFirstResponder()
        }
        else if check == 3 {
            self.textHomeType.resignFirstResponder()
        }
    }
    @objc func cancelClick() {
        if check == 1 {
            self.textState.resignFirstResponder()
        }
        else if check == 2 {
            self.textSell.resignFirstResponder()
        }
        else if check == 3 {
            self.textHomeType.resignFirstResponder()
        }
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnSave(_ sender: UIButton) {
       editAPI()
    }
    //MARK: editAPI Method
    func editAPI() {
        let tempDict = NSMutableDictionary()
        tempDict.setValue(self.textBestFeature1.text!, forKey : "best_features_1")
         tempDict.setValue(self.textBestFeature2.text!, forKey : "best_features_2")
         tempDict.setValue(self.textBestFeature3.text!, forKey : "best_features_3")
         tempDict.setValue(self.textBestFeature4.text!, forKey : "best_features_4")
        print(tempDict)
        
        let url = URL(string: "http://92agents.com/api/newpost")!
        let jsonDict = [
            "agents_user_id": Model.sharedInstance.userID,
            "agents_users_role_id":Model.sharedInstance.userRole,
            "post_title": self.textPostTitle.text!,
            "details":self.textPropertyDetail.text!,
            "address_Line_1": self.textAddressLine1.text!,
            "city": self.textCity.text!,
            "state": self.textState.text!,
            "zip": self.textZipcode.text!,
            "need_Cash_back": "1",
            "address2": self.textAddressLine2.text!,
            "interested_short_sale":"1",
            "got_lender_approval_for_short_sale":"1",
            "home_type": self.textHomeType.text!,
            "best_features" :toJSonString(data: tempDict),
            "when_do_you_want_to_sell": self.textSell.text!,
            "price_range":"2",
            "id": ((editPostDict as NSDictionary).value(forKey: "post_id") as? String)!
            
            ] as [String : Any]
        print(jsonDict)
        let jsonData = try! JSONSerialization.data(withJSONObject: jsonDict, options: [])
        
        var request = URLRequest(url: url)
        request.httpMethod = "post"
        let token = "\(Model.sharedInstance.accessToken)"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("error:", error)
                return
            }
            
            do {
                guard let data = data else { return }
                guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] else { return }
                print("json:", json)
            } catch {
                print("error:", error)
            }
        }
        
        task.resume()
    }
    //MARK: Convert JsonToString Method
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


