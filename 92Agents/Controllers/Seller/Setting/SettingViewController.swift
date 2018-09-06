//
//  SettingViewController.swift
//  92Agents
//
//  Created by Apple on 29/06/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import SKActivityIndicatorView

 //MARK: Class
class getSecurityQuestions {
    var ques_id: String
    var question : String
    
    init(ques_id: String,question : String) {
        self.ques_id = ques_id
        self.question = question
        
    }
}
class getSecurityAnswer {
    var answer: String
    var ques_id: String
    init(answer: String,ques_id: String) {
        self.answer = answer
         self.ques_id = ques_id
    }
}
class SettingViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

     //MARK: IBOutlet and Variables
    @IBOutlet var textOldPassword: UITextField!
    @IBOutlet var textConfirmPassword: UITextField!
    @IBOutlet var textNewPassword: UITextField!
    @IBOutlet var textques1: UITextField!
    @IBOutlet var textques2: UITextField!
    @IBOutlet var textAns1: UITextField!
    @IBOutlet var textAns2: UITextField!
    var pickerView : UIPickerView!
    var check = NSInteger()
    var questionArr = [getSecurityQuestions]()
     var ansArr = [getSecurityAnswer]()
    
     //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        fetchSecurityQues()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: fetchSecurityQues Methods
    func fetchSecurityQues(){
         self.questionArr.removeAll()
        SKActivityIndicator.spinnerColor(UIColor.darkGray)
        SKActivityIndicator.show("Loading...")
        let url = URL(string: "http://92agents.com/api/security/buyer")! //change the url
        
        //create the session object
        let session = URLSession.shared
        
        //now create the URLRequest object using the url object
        var request = URLRequest(url: url)
         let token = "\(Model.sharedInstance.accessToken)"
         request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard error == nil else {
                return
            }
            
            guard let data = data else {
                return
            }
            DispatchQueue.main.async(execute: {
                SKActivityIndicator.dismiss()
            })
            do {
                //create json object from data
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    print(json)
                    for item in ((json as NSDictionary).value(forKey: "response") as! NSDictionary).value(forKey: "securty_questio") as! NSArray {
                        print(item)
                        self.questionArr.append(getSecurityQuestions.init(ques_id: (item as! NSDictionary).value(forKey: "securty_question_id") as! String, question: (item as! NSDictionary).value(forKey: "question") as! String))
                        
                    }
                    self.ansArr.append(getSecurityAnswer.init(answer: ((((json as NSDictionary).value(forKey: "response") as! NSDictionary).value(forKey: "userdetails") as! NSDictionary).value(forKey: "answer_1") as! String), ques_id: ((((json as NSDictionary).value(forKey: "response") as! NSDictionary).value(forKey: "userdetails") as! NSDictionary).value(forKey: "question_1") as! String)))
                    self.ansArr.append(getSecurityAnswer.init(answer: ((((json as NSDictionary).value(forKey: "response") as! NSDictionary).value(forKey: "userdetails") as! NSDictionary).value(forKey: "answer_2") as! String), ques_id: ((((json as NSDictionary).value(forKey: "response") as! NSDictionary).value(forKey: "userdetails") as! NSDictionary).value(forKey: "question_2") as! String)))
                    DispatchQueue.main.async(execute: {
                        
                        for row in 0...self.questionArr.count - 1{
                            if self.ansArr[0].ques_id == self.questionArr[row].ques_id{
                                self.textques1.text = self.questionArr[row].question
                                self.textAns1.text = self.ansArr[0].answer
                            }
                            else if self.ansArr[1].ques_id == self.questionArr[row].ques_id{
                                self.textques2.text = self.questionArr[row].question
                                self.textAns2.text = self.ansArr[1].answer
                            }
                        }
                    })

                }
            } catch let error {
                print(error.localizedDescription)
            }
        })
        
        task.resume()
    }
    
    @IBAction func btnChangePassword(_ sender: UIButton) {
       textFieldValidation()
    }
    //MARK: textFieldValidation Method
    func textFieldValidation()
    {
        if (self.textOldPassword.text?.isEmpty)! {
            Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: "Enter Old aAssword")
        }
        else if (self.textConfirmPassword.text?.isEmpty)! {
            Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: "Enter Confirm Password")
        }
        else if (self.textNewPassword.text?.isEmpty)! {
            Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: "Enter New Password")
        }
        else{
            changePasswordAPI()
        }
    }
    //MARK: BookmarkAPI
    func changePasswordAPI() {
        SKActivityIndicator.spinnerColor(UIColor.darkGray)
        SKActivityIndicator.show("Loading...")
        let url = URL(string: "http://92agents.com/api/changepassword")!
        let jsonDict = [
            "id": Model.sharedInstance.userID,
            "oldpassword":self.textOldPassword.text!,
            "password":self.textNewPassword.text!,
            "password_confirmation":self.textConfirmPassword.text!
            ]
        let jsonData = try! JSONSerialization.data(withJSONObject: jsonDict, options: [])
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let token = "\(Model.sharedInstance.accessToken)"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
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
                DispatchQueue.main.async(execute: {
                    if ((json as NSDictionary).value(forKey: "status") as! String == "100"){
                        self.textOldPassword.text  = ""
                        self.textNewPassword.text = ""
                        self.textConfirmPassword.text = ""
                        Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: (json as NSDictionary).value(forKey: "response") as! String)
                    }
                })
            } catch {
                print("error:", error)
            }
        }
        task.resume()
    }
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
            return self.questionArr.count
        }
        else if check == 2 {
            return self.questionArr.count
        }
       
        return 0
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if check == 1 {
            return self.questionArr[row].question
        }
        else if check == 2 {
            return self.questionArr[row].question
        }
        return nil
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if check == 1 {
            self.textques1.text = self.questionArr[row].question
        }
        else if check == 2 {
            self.textques2.text = self.questionArr[row].question
        }
    }
    //MARK:- TextFiled Delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == textques1 {
            self.pickUp(self.textques1)
            check = 1
        }
        else if textField == textques2 {
            self.pickUp(self.textques2)
            check = 2
        }
    }
    //MARK:- Button
    @objc func doneClick() {
        
        if check == 1 {
            self.textques1.resignFirstResponder()
        }
        else if check == 2 {
            self.textques2.resignFirstResponder()
        }
    }
    @objc func cancelClick() {
        if check == 1 {
            self.textques1.resignFirstResponder()
        }
        else if check == 2 {
            self.textques2.resignFirstResponder()
        }
        
    }

    @IBAction func btnUpdate(_ sender: UIButton) {
       upadteSecurityQuestion()
    }
    //MARK: upadteSecurityQuestion
    func upadteSecurityQuestion() {
        SKActivityIndicator.spinnerColor(UIColor.darkGray)
        SKActivityIndicator.show("Loading...")
        let url = URL(string: "http://92agents.com/api/securtyquestion")!
        let jsonDict = [
            "id": Model.sharedInstance.userID,
            "question1":self.textques1.text!,
            "answer1":self.textAns1.text!,
            "question2":self.textques2.text!,
            "answer2":self.textAns2.text!
        ]
        let jsonData = try! JSONSerialization.data(withJSONObject: jsonDict, options: [])
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let token = "\(Model.sharedInstance.accessToken)"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
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
                DispatchQueue.main.async(execute: {
                    if ((json as NSDictionary).value(forKey: "status") as! String == "100"){
                        self.fetchSecurityQues()
                    }
                })
            } catch {
                print("error:", error)
            }
        }
        task.resume()
    }
}
