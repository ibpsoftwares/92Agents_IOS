//
//  BuyerNewJobViewController.swift
//  92Agents
//
//  Created by Apple on 24/07/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import SKActivityIndicatorView

class BuyerNewJobViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate{

     //MARK: IBOutlet and Variables
    @IBOutlet var textPostTitle: UITextField!
    @IBOutlet var textSpecificReq: UITextField!
    @IBOutlet var textCity: UITextField!
    @IBOutlet var textState: UITextField!
    @IBOutlet var textNeighborhood: UITextField!
    @IBOutlet var textZip1: UITextField!
     @IBOutlet var textZip2: UITextField!
     @IBOutlet var textZip3: UITextField!
     @IBOutlet var textZip4: UITextField!
     @IBOutlet var textZip5: UITextField!
    @IBOutlet var textWantToBuy: UITextField!
    @IBOutlet var textPriceRange: UITextField!
    @IBOutlet var textPropertyType: UITextField!
    @IBOutlet var btnHomeBuyerYes: UIButton!
    @IBOutlet var btnHomeBuyerNo: UIButton!
    @IBOutlet var btnHomeToSellYes: UIButton!
     @IBOutlet var btnHomeToSellNo: UIButton!
    @IBOutlet var btnHelpSellingYes: UIButton!
    @IBOutlet var btnHelpSellingNo: UIButton!
    @IBOutlet var textBids: UITextField!
    @IBOutlet var textNeedFinancing: UITextField!
    @IBOutlet var btnNegotiableYes: UIButton!
    @IBOutlet var btnNegotiableNo: UIButton!
    @IBOutlet var btnForeClosureYes: UIButton!
    @IBOutlet var btnForeClosureNo: UIButton!
    
     var countryArr = [getCountryName]()
    var check = NSInteger()
    let whenYouWantToBuy = [ "Now", "Within 30 days", "Within 30 days", "Undecided"]
    let priceRange = [ "Less Than 75k", "75k - 150k", "150k - 250k", "250k - 400k", "Above 400k"]
     let propertyType = [ "Single Family", "Condo/Townhome", "Multi Family", "Manufactured", "Lots/Land"]
     let bids = ["Once A Day", "As it arrives"]
    var pickerView : UIPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        fetchCountryAPI()
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
            for item in (response!.value(forKey: "states") as! NSArray) {
                print(item)
                self.countryArr.append(getCountryName.init(name: ((item as! NSDictionary).value(forKey: "state_name") as! String), id: ((item as! NSDictionary).value(forKey: "state_id") as! String)))
            }
        })
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
        
        if check == 1 {
            return self.countryArr.count
        }
        else if check == 2 {
            return self.whenYouWantToBuy.count
        }
        else if check == 3 {
            return self.priceRange.count
        }
        else if check == 4 {
            return self.propertyType.count
        }
        else if check == 5 {
            return self.bids.count
        }
        return 0
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if check == 1 {
            return self.countryArr[row].name
        }
        else if check == 2 {
            return self.whenYouWantToBuy[row]
        }
        else if check == 3 {
            return self.priceRange[row]
        }
        else if check == 4 {
            return self.propertyType[row]
        }
        else if check == 5 {
            return self.bids[row]
        }
        return nil
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if check == 1 {
            self.textState.text = self.countryArr[row].name
        }
        else if check == 2 {
            self.textWantToBuy.text = self.whenYouWantToBuy[row]
        }
        else if check == 3 {
            self.textPriceRange.text = self.priceRange[row]
        }
        else if check == 4 {
            self.textPropertyType.text = self.propertyType[row]
        }
        else if check == 5 {
            self.textBids.text = self.bids[row]
        }
    }
    //MARK:- TextFiled Delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == textState {
            self.pickUp(self.textState)
            check = 1
        }
        else if textField == textWantToBuy {
            self.pickUp(self.textWantToBuy)
            check = 2
        }
        else if textField == textPriceRange {
            self.pickUp(self.textPriceRange)
            check = 3
        }
        else if textField == textPropertyType {
            self.pickUp(self.textPropertyType)
            check = 4
        }
        else if textField == textBids {
            self.pickUp(self.textBids)
            check = 5
        }
    }
    //MARK:- Button
    @objc func doneClick() {
        
        if check == 1 {
            self.textState.resignFirstResponder()
        }
        else if check == 2 {
            self.textWantToBuy.resignFirstResponder()
        }
        else if check == 3 {
            self.textPriceRange.resignFirstResponder()
        }
        else if check == 4 {
            self.textPropertyType.resignFirstResponder()
        }
        else if check == 5 {
            self.textBids.resignFirstResponder()
        }
    }
    @objc func cancelClick() {
        if check == 1 {
            self.textState.resignFirstResponder()
        }
        else if check == 2 {
            self.textWantToBuy.resignFirstResponder()
        }
        else if check == 3 {
            self.textPriceRange.resignFirstResponder()
        }
        else if check == 4 {
            self.textPropertyType.resignFirstResponder()
        }
        else if check == 5 {
            self.textBids.resignFirstResponder()
        }
    }
    @IBAction func btnHomeBuyerYes(_ sender: UIButton) {
        self.btnHomeBuyerYes.setImage(UIImage(named: "selected"), for: .normal)
        self.btnHomeBuyerNo.setImage(UIImage(named: "notSelected"), for: .normal)
    }
    @IBAction func btnHomeBuyerNo(_ sender: UIButton) {
        self.btnHomeBuyerNo.setImage(UIImage(named: "selected"), for: .normal)
        self.btnHomeBuyerYes.setImage(UIImage(named: "notSelected"), for: .normal)
    }
    @IBAction func btnHomeToSellYes(_ sender: UIButton) {
        self.btnHomeToSellYes.setImage(UIImage(named: "selected"), for: .normal)
        self.btnHomeToSellNo.setImage(UIImage(named: "notSelected"), for: .normal)
    }
    @IBAction func btnHomeToSellNo(_ sender: UIButton) {
        self.btnHomeToSellNo.setImage(UIImage(named: "selected"), for: .normal)
        self.btnHomeToSellYes.setImage(UIImage(named: "notSelected"), for: .normal)
    }
    @IBAction func btnHelpSellingYes(_ sender: UIButton) {
        self.btnHelpSellingYes.setImage(UIImage(named: "selected"), for: .normal)
        self.btnHelpSellingNo.setImage(UIImage(named: "notSelected"), for: .normal)
    }
    @IBAction func btnHelpSellingNo(_ sender: UIButton) {
        self.btnHelpSellingNo.setImage(UIImage(named: "selected"), for: .normal)
        self.btnHelpSellingYes.setImage(UIImage(named: "notSelected"), for: .normal)
    }
    @IBAction func btnNegotiableYes(_ sender: UIButton) {
        self.btnNegotiableYes.setImage(UIImage(named: "selected"), for: .normal)
        self.btnHelpSellingNo.setImage(UIImage(named: "notSelected"), for: .normal)
    }
    @IBAction func btnNegotiableNo(_ sender: UIButton) {
        self.btnNegotiableNo.setImage(UIImage(named: "selected"), for: .normal)
        self.btnNegotiableYes.setImage(UIImage(named: "notSelected"), for: .normal)
    }
    @IBAction func btnForeClosureYes(_ sender: UIButton) {
        self.btnForeClosureYes.setImage(UIImage(named: "selected"), for: .normal)
        self.btnForeClosureNo.setImage(UIImage(named: "notSelected"), for: .normal)
    }
    @IBAction func btnForeClosureNo(_ sender: UIButton) {
        self.btnForeClosureNo.setImage(UIImage(named: "selected"), for: .normal)
        self.btnForeClosureYes.setImage(UIImage(named: "notSelected"), for: .normal)
    }
    //MARK:AddNewJobAPI
//    func AddNewJobAPI() {
//        self.countryArr.removeAll()
//        SKActivityIndicator.spinnerColor(UIColor.darkGray)
//        SKActivityIndicator.show("Loading...")
////        let tempDict = NSMutableDictionary()
////        tempDict.setValue(self.textBestFeature1.text!, forKey : "best_features_1")
////        tempDict.setValue(self.textBestFeature2.text!, forKey : "best_features_2")
////        tempDict.setValue(self.textBestFeature3.text!, forKey : "best_features_3")
////        tempDict.setValue(self.textBestFeature4.text!, forKey : "best_features_4")
////        print(tempDict)
//
//        let url = URL(string: "http://92agents.com/api/newpost")!

//
//        let jsonData = try! JSONSerialization.data(withJSONObject: jsonDict, options: [])
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "post"
//        let token = "\(Model.sharedInstance.accessToken)"
//        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.httpBody = jsonData
//
//        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
//            if let error = error {
//                print("error:", error)
//                return
//            }
//            DispatchQueue.main.async(execute: {
//                SKActivityIndicator.dismiss()
//            })
//            do {
//                guard let data = data else { return }
//                guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] else { return }
//                print("json:", json)
//
//            } catch {
//                print("error:", error)
//            }
//        }
//
//        task.resume()
//    }
    //MARK: Convert inot JsonString
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
