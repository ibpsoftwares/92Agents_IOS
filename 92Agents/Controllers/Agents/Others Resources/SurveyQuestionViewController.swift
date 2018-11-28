//
//  SurveyQuestionViewController.swift
//  92Agents
//
//  Created by Apple on 26/11/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import Alamofire
import SKActivityIndicatorView

class SurveyQuestionViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    //MARK: IBOutlet and Variables
    @IBOutlet var tableView: UITableView!
    var questionSurveySellerArr = [getQuestions]()
    var questionSurveyBuyerArr = [getQuestions]()
    var buyerStr = String()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
         tableView.tableFooterView = UIView()
        questionMethodAPI()
        buyerStr = "buyer"
    }
    //MARK: questionMethodAPI Methods
    func questionMethodAPI(){
        self.questionSurveySellerArr.removeAll()
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
                            if ((item as! NSDictionary).value(forKey: "survey") as! String) == "1"{
                                if ((item as! NSDictionary).value(forKey: "question_type") as! String) == "2"{
                                    self.questionSurveyBuyerArr.append(getQuestions.init(ques_id: (item as! NSDictionary).value(forKey: "question_id") as! String, question: (item as! NSDictionary).value(forKey: "question") as! String, questionType: (item as! NSDictionary).value(forKey: "question_type") as! String, survey: (item as! NSDictionary).value(forKey: "survey") as! String))
                                }else{
                                   self.questionSurveySellerArr.append(getQuestions.init(ques_id: (item as! NSDictionary).value(forKey: "question_id") as! String, question: (item as! NSDictionary).value(forKey: "question") as! String, questionType: (item as! NSDictionary).value(forKey: "question_type") as! String, survey: (item as! NSDictionary).value(forKey: "survey") as! String))
                                }
                            }
                        }
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if buyerStr == "buyer" {
            return self.questionSurveyBuyerArr.count
        }else{
            return self.questionSurveySellerArr.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : SurveyQuesTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as! SurveyQuesTableViewCell
        if buyerStr == "buyer" {
            cell.lblNo.text = "\(indexPath.row + 1)"
            cell.lblQuestion.text = "\(self.questionSurveyBuyerArr[indexPath.row].question)"
            
        }else{
            cell.lblNo.text = "\(indexPath.row + 1)"
            cell.lblQuestion.text = "\(self.questionSurveySellerArr[indexPath.row].question)"
        }
        
        cell.btnDelete.tag = indexPath.row
        cell.btnDelete.addTarget(self,action:#selector(btnEdit(sender:)), for: .touchUpInside)
        return cell
    }
    @objc func btnEdit(sender:UIButton!){
        SKActivityIndicator.spinnerColor(UIColor.darkGray)
        SKActivityIndicator.show("Loading...")
        let parameters: Parameters = [
            "add_by": Model.sharedInstance.userID,
            "add_by_role":Model.sharedInstance.userRole,
            "question_id":self.questionSurveyBuyerArr[sender.tag].ques_id
        ]
        print(parameters)
        Webservice.apiPost(apiURl:"http://92agents.com/api/questiontoanswer/removesurvayquestion", parameters: parameters, headers: nil) { (response:NSDictionary?, error:NSError?) in
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
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if check == "yes"  {
//            return 177 //Size you want to increase to
//        }
//        return 75 // Default Size
//    }

}
