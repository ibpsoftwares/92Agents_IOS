//
//  AgentQuestionViewController.swift
//  92Agents
//
//  Created by Apple on 21/11/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import Alamofire
import SKActivityIndicatorView

class AgentQuestionViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource,UITextFieldDelegate {

    //MARK: IBOutlet and Variables
    @IBOutlet var tableView: UITableView!
     @IBOutlet var btnBuyer: UIButton!
     @IBOutlet var btnSeller: UIButton!
    var pickerView : UIPickerView!
    var questionSellerArr = [getQuestions]()
    var questionBuyerArr = [getQuestions]()
    var ansArr = [getAnswer]()
    var selectedIndex = NSInteger()
    var check = String()
     var sellerStr = String()
    var type = String()
     var buyerStr = String()
    var selectTypeArr = ["Buyer","Seller"]
    //Add New Question
    @IBOutlet var questionView: UIView!
    @IBOutlet var userNameLbl: UILabel!
    @IBOutlet var textViewAddQues: UITextView!
    @IBOutlet var textQuesType: UITextField!
    @IBOutlet var btnYes: UIButton!
    @IBOutlet var btnNo: UIButton!
    @IBOutlet var btnAdd: UIButton!
    var value = String()
    var quesID = String()
    var surveyType = String()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        questionMethodAPI()
         tableView.tableFooterView = UIView()
         buyerStr = "buyer"
        btnAdd.layer.cornerRadius = btnAdd.frame.height / 2
        btnAdd.clipsToBounds = true
        questionView.isHidden = true
        textViewAddQues.layer.borderWidth = 1
        textViewAddQues.layer.borderColor = UIColor.black.cgColor
        btnSeller.layer.backgroundColor = UIColor.white.cgColor
        btnSeller.titleLabel?.textColor = UIColor.black
    }
    //MARK: questionMethodAPI Methods
    func questionMethodAPI(){
        self.questionSellerArr.removeAll()
        self.questionBuyerArr.removeAll()
        SKActivityIndicator.spinnerColor(UIColor.darkGray)
        SKActivityIndicator.show("Loading...")
        let parameters: Parameters = [
            "add_by": Model.sharedInstance.userID,
            "add_by_role":Model.sharedInstance.userRole
        ]
        print(parameters)
        Webservice.apiPost(apiURl:"http://92agents.com/api/question/get/only/user", parameters: parameters, headers: nil) { (response:NSDictionary?, error:NSError?) in
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
                //print(dict)
                if ((dict as NSDictionary).value(forKey: "status") as? String == "100"){
                    
                    if ((dict as NSDictionary).value(forKey: "questions") as! NSArray).count > 0{
                        for item in (dict as NSDictionary).value(forKey: "questions") as! NSArray {
                           // print(item)
                            if ((item as! NSDictionary).value(forKey: "question_type") as! String) == "2"{
                                self.questionBuyerArr.append(getQuestions.init(ques_id: (item as! NSDictionary).value(forKey: "question_id") as! String, question: (item as! NSDictionary).value(forKey: "question") as! String, questionType: (item as! NSDictionary).value(forKey: "question_type") as! String, survey: (item as! NSDictionary).value(forKey: "survey") as! String))
                            }
                            else{
                                self.questionSellerArr.append(getQuestions.init(ques_id: (item as! NSDictionary).value(forKey: "question_id") as! String, question: (item as! NSDictionary).value(forKey: "question") as! String, questionType: (item as! NSDictionary).value(forKey: "question_type") as! String, survey: (item as! NSDictionary).value(forKey: "survey") as! String))
                            }
                        }
//                        for row in 0...self.questionSellerArr.count - 1{
//                            self.ansArr.append(getAnswer.init(answer: ((dict as NSDictionary).value(forKey: "answers") as! NSDictionary).object(forKey: self.questionSellerArr[row].ques_id) as! String))
//                        }
                        print(self.ansArr)
                        DispatchQueue.main.async(execute: {
                            self.tableView.reloadData()
                        })
                    }
                    else{
                        Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: "No Questions Available!")
                    }
                }else{
                    Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: (response?.value(forKey: "error") as! String))
                }
            }
            
        }
    }
    @IBAction func btnBuyer(_ sender: UIButton) {
        buyerStr = "buyer"
        btnSeller.layer.backgroundColor = UIColor.white.cgColor
        btnSeller.titleLabel?.textColor = UIColor.black
        btnBuyer.layer.backgroundColor = UIColor (red: 135.0/255.0, green: 194.0/255.0, blue: 73.0/255.0, alpha: 1).cgColor
        btnBuyer.titleLabel?.textColor = UIColor.white
        DispatchQueue.main.async(execute: {
            self.tableView.reloadData()
        })
    }
    @IBAction func btnSeller(_ sender: UIButton) {
       sellerStr = "seller"
        buyerStr = ""
        btnBuyer.layer.backgroundColor = UIColor.white.cgColor
        btnBuyer.titleLabel?.textColor = UIColor.black
        btnSeller.layer.backgroundColor = UIColor (red: 135.0/255.0, green: 194.0/255.0, blue: 73.0/255.0, alpha: 1).cgColor
        btnSeller.titleLabel?.textColor = UIColor.white
        DispatchQueue.main.async(execute: {
            self.tableView.reloadData()
        })
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if buyerStr == "buyer" {
            return self.questionBuyerArr.count
        }else{
           return self.questionSellerArr.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : SellerTestTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as! SellerTestTableViewCell
         if buyerStr == "buyer" {
            cell.lblNo.text = "\(indexPath.row + 1)"
            cell.lblQuestion.text = "\(self.questionBuyerArr[indexPath.row].question)"
            cell.textAns.text = self.questionBuyerArr[indexPath.row].question
            if self.questionBuyerArr[indexPath.row].survey == "1" {
                cell.surveyImg.setImage(UIImage(named: "surveyDelete"), for: .normal)
            }else{
                cell.surveyImg.setImage(UIImage(named: "surveyAdd"), for: .normal)
            }
         }else{
            cell.lblNo.text = "\(indexPath.row + 1)"
            cell.lblQuestion.text = "\(self.questionSellerArr[indexPath.row].question)"
            cell.textAns.text = self.questionSellerArr[indexPath.row].question
            if self.questionSellerArr[indexPath.row].survey == "1" {
                cell.surveyImg.setImage(UIImage(named: "surveyDelete"), for: .normal)
            }else{
                cell.surveyImg.setImage(UIImage(named: "surveyAdd"), for: .normal)
            }
        }
        if check == "yes"{
            cell.viewHeight.constant = 104
        }else{
            cell.viewHeight.constant = 0
        }
        
        cell.btnAnswer.tag = indexPath.row
        cell.btnAnswer.addTarget(self,action:#selector(btnEdit(sender:)), for: .touchUpInside)
        cell.btnSave.tag = indexPath.row
        cell.btnSave.addTarget(self,action:#selector(btnSave(sender:)), for: .touchUpInside)
        cell.btnSurvey.tag = indexPath.row
        cell.btnSurvey.addTarget(self,action:#selector(btnSurvey(sender:)), for: .touchUpInside)
        return cell
    }
    @objc func btnEdit(sender:UIButton!){
        let indexPath = IndexPath(item: sender.tag, section: 0)
        let cell = tableView.cellForRow(at: indexPath) as! SellerTestTableViewCell!
        //  let cell : SellerTestTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as! SellerTestTableViewCell
        //cell?.ansView.isHidden = false
        selectedIndex =  sender.tag
        check = "yes"
        //tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.fade)
        cell?.viewHeight.constant = 104
        self.tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if check == "yes"  {
            return 177 //Size you want to increase to
        }
        return 75 // Default Size
    }
    //MARK: UpdateQuestion API
    @objc func btnSave(sender:UIButton!){
        if buyerStr == "buyer" {
            let indexPath = IndexPath(item: sender.tag, section: 0) // This defines what indexPath is which is used later to define a cell
            let cell = tableView.cellForRow(at: indexPath) as! SellerTestTableViewCell
            let str = (cell.textAns.text)!
            cell.viewHeight.constant = 0
            print(str)
            UpdateQuestionMethodAPI(question_id: "\(self.questionBuyerArr[sender.tag].ques_id)", question: (cell.textAns.text!))
        }
        else{
            let indexPath = IndexPath(item: sender.tag, section: 0) // This defines what indexPath is which is used later to define a cell
            let cell = tableView.cellForRow(at: indexPath) as! SellerTestTableViewCell
            cell.viewHeight.constant = 0
             UpdateQuestionMethodAPI(question_id: "\(self.questionSellerArr[sender.tag].ques_id)", question: (cell.textAns.text!))
        }
    }
    func UpdateQuestionMethodAPI(question_id:String,question: String){
        SKActivityIndicator.spinnerColor(UIColor.darkGray)
        SKActivityIndicator.show("Loading...")
        let parameters: Parameters = [
            "add_by": Model.sharedInstance.userID,
            "add_by_role":Model.sharedInstance.userRole,
            "question":question,
            "question_id":question_id
        ]
        print(parameters)
        Webservice.apiPost(apiURl:"http://92agents.com/api/questionanswer/updatequestion", parameters: parameters, headers: nil) { (response:NSDictionary?, error:NSError?) in
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
                //print(dict)
                if ((dict as NSDictionary).value(forKey: "status") as? String == "100"){
                        DispatchQueue.main.async(execute: {
                            self.questionMethodAPI()
                        })
                }else{
                    Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: (response?.value(forKey: "error") as! String))
                }
            }
            
        }
    }
    //MARK:AddNewQuestion
    @IBAction func btnAddQues(_ sender: UIButton) {
        self.questionView.isHidden = false
        self.btnAdd.isHidden = true
        self.btnBuyer.isHidden = true
        self.btnSeller.isHidden = true
    }
    @IBAction func btnSaveQues(_ sender: UIButton) {
        if self.textQuesType.text == "Buyer" {
            value = "2"
        }else{
            value = "3"
        }
        let parameters: Parameters = [
            "add_by": Model.sharedInstance.userID,
            "add_by_role":Model.sharedInstance.userRole,
            "question":self.textViewAddQues.text!,
            "question_type":value,
            "survey":surveyType,
            "importance1":"0"
        ]
        print(parameters)
        SKActivityIndicator.spinnerColor(UIColor.darkGray)
        SKActivityIndicator.show("Loading...")
        Webservice.apiPost(apiURl:"http://92agents.com/api/insertquestion", parameters: parameters, headers: nil) { (response:NSDictionary?, error:NSError?) in
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
                    self.questionView.isHidden = true
                    self.btnAdd.isHidden = false
                    self.btnBuyer.isHidden = false
                    self.btnSeller.isHidden = false
                   // self.agentProfileAPI()
                }
            }else{
                Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: (response?.value(forKey: "error") as! String))
            }
        }
    }
    @IBAction func btnClose(_ sender: Any) {
        self.questionView.isHidden = true
        self.btnAdd.isHidden = false
        self.btnBuyer.isHidden = false
        self.btnSeller.isHidden = false
    }
    @IBAction func btnYesClick(_ sender: UIButton) {
        surveyType = "1"
        btnYes.setImage(UIImage.init(named: "selected"), for: .normal)
        btnNo.setImage(UIImage.init(named: "notSelected"), for: .normal)
    }
    @IBAction func btnNoClick(_ sender: Any) {
        surveyType = "0"
        btnYes.setImage(UIImage.init(named: "notSelected"), for: .normal)
        btnNo.setImage(UIImage.init(named: "selected"), for: .normal)
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
        return selectTypeArr.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return selectTypeArr[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.textQuesType.text = selectTypeArr[row]
    }
    //MARK:- TextFiled Delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.pickUp(self.textQuesType)
    }
    //MARK:- Button
    @objc func doneClick() {
        self.textQuesType.resignFirstResponder()
    }
    @objc func cancelClick() {
       self.textQuesType.resignFirstResponder()
    }
    //MARK: Add Survey
    @objc func btnSurvey(sender:UIButton!){
       // print(sender.tag)
        
        if buyerStr == "buyer" {
            quesID = self.questionBuyerArr[sender.tag].ques_id
            print(quesID)
            if self.questionBuyerArr[sender.tag].survey == "1" {
                type = "delete"
                addSurvey(question_id:quesID)
            }
            else{
                 type = "update"
                addSurvey(question_id:quesID)
            }
        }else{
            quesID = self.questionSellerArr[sender.tag].ques_id
            print(quesID)
            if sender.imageView?.image == UIImage.init(named: "surveyAdd") {
                addSurvey(question_id:quesID)
            }
            else{
                addSurvey(question_id:quesID)
            }
            
        }
    }
    func deleteSurvey(question_id:String){
        let alertController = UIAlertController(title: "Survey", message: "Are You Sure That You Need To Remove Question (How Are You Guyz?) To The Survey.", preferredStyle: UIAlertControllerStyle.alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (result : UIAlertAction) -> Void in
        }
        let okAction = UIAlertAction(title: "Sure", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            
            self.addSurvey(question_id:question_id)
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    func addSurvey(question_id:String){
        let alertController = UIAlertController(title: "Survey", message: "Are You Sure That You Need To Add Question (How Are You Guyz?) To The Survey.", preferredStyle: UIAlertControllerStyle.alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (result : UIAlertAction) -> Void in
        }
        let okAction = UIAlertAction(title: "Sure", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            
            self.surveyMethodAPI(question_id:"")
            
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    func surveyMethodAPI(question_id:String){
        SKActivityIndicator.spinnerColor(UIColor.darkGray)
        SKActivityIndicator.show("Loading...")
        let parameters: Parameters = [
            "agents_user_id": Model.sharedInstance.userID,
            "agents_users_role_id":Model.sharedInstance.userRole,
            "question_id":quesID,
            "type" : type
        ]
        print(parameters)
        Webservice.apiPost(apiURl:"http://92agents.com/api/questiontoanswer/updatesurvey", parameters: parameters, headers: nil) { (response:NSDictionary?, error:NSError?) in
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
                //print(dict)
                if ((dict as NSDictionary).value(forKey: "status") as? String == "100"){
                    DispatchQueue.main.async(execute: {
                        self.questionMethodAPI()
                    })
                }else{
                    Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: (response?.value(forKey: "error") as! String))
                }
            }
            
        }
    }
    
}
