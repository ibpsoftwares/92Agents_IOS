//
//  FindAgentViewController.swift
//  92Agents
//
//  Created by Apple on 04/07/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import Alamofire
import SKActivityIndicatorView

//MARK: Class
class FindAgent {
    var description : String
    var state: String
    var city : String
    var brokerName : String
     var date : String
    var experience : String
    var loginStatus : String
    var name : String
  
    init(description: String,state: String,city : String,brokerName : String,date : String,experience : String,loginStatus : String,name : String) {
        self.description = description
        self.state = state
        self.city = city
        self.brokerName = brokerName
         self.date = date
         self.experience = experience
         self.loginStatus = loginStatus
         self.name = name
     
    }
}


class FindAgentViewController: UIViewController , UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate{
    
    //MARK: Iboutlet and Variables
    var datePicker : UIDatePicker!
    @IBOutlet var addressView: UIView!
    @IBOutlet var calanderView: UIView!
    @IBOutlet var nameView: UIView!
    @IBOutlet var tableView: UITableView!
     @IBOutlet var textName: UITextField!
     @IBOutlet var textDate: UITextField!
      @IBOutlet var textDate1: UITextField!
     @IBOutlet var textAddress: UITextField!
    @IBOutlet var textState: UITextField!
    @IBOutlet var textCity: UITextField!
     @IBOutlet var tableViewHeight: NSLayoutConstraint!
    @IBOutlet var textZipcode: UITextField!
     @IBOutlet var btnSetDate: UIButton!
     @IBOutlet var btnSetDate1: UIButton!
     var findAgentArr = [FindAgent]()
     var get_dest = NSArray()
     var postArr = NSArray()
     var searchArr = NSArray()
     var stateID = String()
    var agentID = String()
    var selectDate = String()
    var countryArr = [getCountryName]()
    var pickerView : UIPickerView!
    var isAnimatingScroll = false
    @IBOutlet var postView: UIView!
    @IBOutlet var postTableView: UITableView!
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
       // fetchCountryAPI()
        FindAgentAPI()
        // Do any additional setup after loading the view.
      
        self.nameView.layer.borderColor = UIColor.lightGray.cgColor
        self.calanderView.layer.borderWidth = 1
        self.calanderView.layer.borderColor = UIColor.lightGray.cgColor
        self.nameView.layer.borderWidth = 1
        self.addressView.layer.borderColor = UIColor.lightGray.cgColor
        self.addressView.layer.borderWidth = 1
        self.postView.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
     // MARK: - FindAgentAPI Method
    func FindAgentAPI(){
       
        let parameters: Parameters = [
            "searchinputtype": "name",
            "agents_users_role_id": "4",
            "date": "",
            "city": "",
            "state": "",
            "zipcodes": "",
            "pricerange": "",
            "address": "",
            "keyword": ""
        ]
        print(parameters)
       
        Webservice.apiPost1(apiURl:  "http://92agents.com/api/searchAgentsList", parameters: parameters, headers: nil) { (response:[String : Any], error:NSError?) in
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
            print(response)
//            if  response as? [AnyHashable:Any] is NSNull{
//
//            }
            if let dict = response as? [AnyHashable:Any] {
                print(dict)
                if ((dict as NSDictionary).value(forKey: "status") as? String == "100"){
                    
                      self.get_dest = (dict as NSDictionary).value(forKey: "response") as! NSArray

                    DispatchQueue.main.async(execute: {
                        let int1: Int32 = Int32((self.get_dest.count) * 220)
                        let cgfloat1 = CGFloat(int1)
                        self.tableViewHeight.constant = cgfloat1
                        self.tableView.reloadData()
                    })
                }else{
                    //Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: (response?.value(forKey: "error") as! String))
                }
            }
        }
    }
    // Swift 4
    @objc func dismissPicker() {
        view.endEditing(true)
    }
    @IBAction func btnSearch(_ sender: UIButton) {
        searchAgent()
    }
    // MARK: - searchAgent Method
    func searchAgent(){
        
        let parameters: Parameters = [
            "searchinputtype": "name",
            "agents_users_role_id": "4",
            "date": self.textDate.text!,
            "city": self.textCity.text!,
            "state": stateID,
            "zipcodes": self.textZipcode.text!,
            "pricerange": "",
            "address": self.textAddress.text!,
            "keyword": self.textName.text!
        ]
        print(parameters)
        Webservice.apiPost1(apiURl:  "http://92agents.com/api/searchAgentsList", parameters: parameters, headers: nil) { (response:[String : Any], error:NSError?) in
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
            print(response)
            if let dict = response as? [AnyHashable:Any] {
                print(dict)
                if  (dict as NSDictionary).value(forKey: "response") is NSNull{
                    print("Response is null")

                    self.FindAgentAPI()
                    }
                else{
                    if ((dict as NSDictionary).value(forKey: "status") as? String == "100"){
                        
                        self.get_dest = (dict as NSDictionary).value(forKey: "response") as! NSArray
                        
                        DispatchQueue.main.async(execute: {
                            let int1: Int32 = Int32((self.get_dest.count) * 188 )
                            let cgfloat1 = CGFloat(int1)
                            self.tableViewHeight.constant = cgfloat1
                            self.tableView.reloadData()
                           
                        })
                    }else{
                        //Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: (response?.value(forKey: "error") as! String))
                    }
                }
            }
        }
    }

    //MARK:- Function of datePicker
    func pickUpDate(){
        
        // DatePicker
        self.datePicker = UIDatePicker(frame:CGRect(x: 0, y:0, width: self.view.frame.size.width, height: 216))
        self.datePicker.backgroundColor = UIColor.gray
        self.datePicker.datePickerMode = UIDatePickerMode.date
        textDate.inputView = self.datePicker
         textDate1.inputView = self.datePicker
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(FindAgentViewController.done1Click))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(FindAgentViewController.cancel1Click))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textDate.inputAccessoryView = toolBar
         textDate1.inputAccessoryView = toolBar
         //self.datePicker.addSubview(self.toolBar)
    }
    
    // MARK:- Button Done and Cancel
    @objc func done1Click() {
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateStyle = .medium
        dateFormatter1.timeStyle = .none
        if selectDate == "to" {
             textDate.text = dateFormatter1.string(from: datePicker.date)
             textDate.resignFirstResponder()
        }
        else if selectDate == "from"{
             textDate1.text = dateFormatter1.string(from: datePicker.date)
             textDate1.resignFirstResponder()
        }
       
    }
    @objc func cancel1Click() {
        textDate.resignFirstResponder()
        textDate1.resignFirstResponder()
    }

    @IBAction func btnClose(_ sender: UIButton) {
        self.postView.isHidden = true
    }
    // MARK: - PostAPI Method
    func PostAPI(agentID:String){
        let parameters: Parameters = [
            "agent_id": agentID,
        ]
        print(parameters)
        Webservice.apiPost1(apiURl:  "http://92agents.com/api/searchAgentsDetails", parameters: parameters, headers: nil) { (response:[String : Any], error:NSError?) in
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
            print(response)
            if let dict = response as? [AnyHashable:Any] {
                print(dict)
                if  (dict as NSDictionary).value(forKey: "response") is NSNull{
                    print("Response is null")
                }
                else  if ((dict as NSDictionary).value(forKey: "status") as? String == "100"){
                        self.postArr = (dict as NSDictionary).value(forKey: "response") as! NSArray
                        print(self.postArr)
                        self.postView.isHidden = false
                        DispatchQueue.main.async(execute: {
                            self.FindAgentAPI()
                            self.postTableView.reloadData()
                        })
                    }else{
                        //Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: (response?.value(forKey: "error") as! String))
                    }
                }
            }
        }
}
extension FindAgentViewController: UITableViewDataSource {
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView == self.tableView)
        {
            return  self.get_dest.count
        }
        else if(tableView == self.postTableView){
            if self.postArr.count > 0 {
               return (((self.postArr as NSArray).object(at: 0) as! NSDictionary).value(forKey: "post") as! NSArray).count
            }else{
               return  0
            }
        }
        return  0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        var cell1 = FindAgentTableViewCell()
        if(tableView == self.tableView)
        {
            cell1  = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as! FindAgentTableViewCell
            cell1.lblName.text = (((self.get_dest ).object(at: indexPath.row) as! NSDictionary).value(forKey: "name") as! String)
            
            if (((self.get_dest ).object(at: indexPath.row) as! NSDictionary).value(forKey: "login_status") as! String) == "Online"{
                cell1.lblOnlineStatus.backgroundColor = UIColor.green
                cell1.lblOnlineStatus.layer.cornerRadius = cell1.lblOnlineStatus.frame.size.height / 2
                cell1.lblOnlineStatus.clipsToBounds = true
            }
            else{
                cell1.lblOnlineStatus.backgroundColor = UIColor.red
                cell1.lblOnlineStatus.layer.cornerRadius = cell1.lblOnlineStatus.frame.size.height / 2
                cell1.lblOnlineStatus.clipsToBounds = true
            }
            // cell.lblOnlineStatus.text = (((self.get_dest ).object(at: indexPath.row) as! NSDictionary).value(forKey: "login_status") as! String)
            if ((self.get_dest ).object(at: indexPath.row) as! NSDictionary).value(forKey: "city_name")  is NSNull {
            }
            else{
                cell1.lblCity.text = (((self.get_dest ).object(at: indexPath.row) as! NSDictionary).value(forKey: "city_name") as! String)
            }
            if ((self.get_dest ).object(at: indexPath.row) as! NSDictionary).value(forKey: "state_name")  is NSNull {
            }
            else{
                cell1.lblState.text = (((self.get_dest ).object(at: indexPath.row) as! NSDictionary).value(forKey: "state_name") as! String)
            }
            cell1.lblDate.text = "Posted: \((((self.get_dest ).object(at: indexPath.row) as! NSDictionary).value(forKey: "created_at") as! String))"
            if ((self.get_dest ).object(at: indexPath.row) as! NSDictionary).value(forKey: "years_of_expreience")  is NSNull {
            }
            else{
                cell1.lblExperiencee.text = "Experience: \((((self.get_dest ).object(at: indexPath.row) as! NSDictionary).value(forKey: "years_of_expreience") as! String))"
            }
            if ((self.get_dest ).object(at: indexPath.row) as! NSDictionary).value(forKey: "description")  is NSNull {
            }
            else{
                
                cell1.lbleDesrcription.text = (((self.get_dest ).object(at: indexPath.row) as! NSDictionary).value(forKey: "description") as! String)
                cell1.lbleDesrcription.adjustsFontSizeToFitWidth = false;
                cell1.lbleDesrcription.lineBreakMode = NSLineBreakMode.byTruncatingTail;
            }
            cell1.tagListView.removeAllTags()
            if (((self.get_dest ).object(at: indexPath.row) as! NSDictionary).value(forKey: "skill_data") as! NSArray).count > 0 {
                
                for section in 0...(((self.get_dest ).object(at: indexPath.row) as! NSDictionary).value(forKey: "skill_data") as! NSArray).count - 1 {
                    let str = ((((self.get_dest ).object(at: indexPath.row) as! NSDictionary).value(forKey: "skill_data") as! NSArray).object(at: section) as! NSDictionary).value(forKey: "skill") as! String
                    cell1.tagListView.addTags([str])
                }
            }
        }
        else if(tableView == self.postTableView){
            let cell : FindPostTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as! FindPostTableViewCell
            cell.lblName.text = (((((postArr as NSArray).object(at: 0) as! NSDictionary).value(forKey: "post") as! NSArray).object(at:indexPath.row ) as! NSDictionary).value(forKey: "posttitle") as! String)
            return cell
        }
        return cell1
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
                self.countryArr.append(getCountryName.init(name: ((item as! NSDictionary).value(forKey: "state_name") as! String), id: String((item as! NSDictionary).value(forKey: "state_id") as! NSInteger)))
            }
        })
    }
    //MARK: textFieldValidation Method
    func textFieldValidation()
    {
        if (self.textState.text?.isEmpty)! {
            Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: "Select State")
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
        return self.countryArr.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.countryArr[row].name
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        stateID = self.countryArr[row].id
        self.textState.text = self.countryArr[row].name
    }
    //MARK:- TextFiled Delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.textDate {
            self.pickUpDate()
        }
        else if textField == self.textDate1 {
           self.pickUpDate()
        }
        else if textField == self.textState {
             self.pickUp(self.textState)
        }
    }
    
    //MARK:- Button
    @objc func doneClick() {
        self.textState.resignFirstResponder()
    }
    @objc func cancelClick() {
        self.textState.resignFirstResponder()
    }
}
extension FindAgentViewController: UITableViewDelegate {
    //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //        return 100
    //    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print(((((self.get_dest ).object(at: indexPath.row) as! NSDictionary).value(forKey: "id") as! String)))
        agentID = ((((self.get_dest ).object(at: indexPath.row) as! NSDictionary).value(forKey: "id") as! String))
        
        if(tableView == self.tableView)
        {
            self.PostAPI(agentID: ((((self.get_dest ).object(at: indexPath.row) as! NSDictionary).value(forKey: "id") as! String)))
        }
        else if(tableView == self.postTableView){
            let addressVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AgentDetailViewController") as! AgentDetailViewController
            addressVC.postID = (((((postArr as NSArray).object(at: 0) as! NSDictionary).value(forKey: "post") as! NSArray).object(at:indexPath.row ) as! NSDictionary).value(forKey: "post_id") as! String)
            addressVC.agentID = agentID
            addressVC.applied_post = (((((postArr as NSArray).object(at: 0) as! NSDictionary).value(forKey: "post") as! NSArray).object(at:indexPath.row ) as! NSDictionary).value(forKey: "applied_post") as! String)
             addressVC.poatName = (((((postArr as NSArray).object(at: 0) as! NSDictionary).value(forKey: "post") as! NSArray).object(at:indexPath.row ) as! NSDictionary).value(forKey: "posttitle") as! String)
            if ((((postArr as NSArray).object(at: 0) as! NSDictionary).value(forKey: "post") as! NSArray).object(at:indexPath.row ) as! NSDictionary).value(forKey: "applied_user_id") is NSNull{
                
            }else{
                 addressVC.applied_user_id = (((((postArr as NSArray).object(at: 0) as! NSDictionary).value(forKey: "post") as! NSArray).object(at:indexPath.row ) as! NSDictionary).value(forKey: "applied_user_id") as! String)
            }
            self.navigationController?.pushViewController(addressVC, animated: true)
        }
    }
}

