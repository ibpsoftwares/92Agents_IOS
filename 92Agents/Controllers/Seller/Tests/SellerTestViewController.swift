//
//  SellerTestViewController.swift
//  92Agents
//
//  Created by Apple on 02/07/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import Alamofire
import SKActivityIndicatorView

//MARK: Class
class getQuestions {
    var ques_id: String
    var question : String
    
    init(ques_id: String,question : String) {
        self.ques_id = ques_id
        self.question = question
    }
}
class getAnswer {
    var answer: String
    init(answer: String) {
        self.answer = answer
    }
}
class SellerTestViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    //MARK: IBOutlet and Variables
    @IBOutlet var tableView: UITableView!
     var questionArr = [getQuestions]()
    var ansArr = [getAnswer]()
    var selectedIndex = NSInteger()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        selectedIndex = 200
        // call api
       // getNotesAPI()
        loginMethodAPI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: loginAPI Methods
    func loginMethodAPI(){
        SKActivityIndicator.spinnerColor(UIColor.darkGray)
        SKActivityIndicator.show("Loading...")
        let parameters: Parameters = [
            "agent_user_id": Model.sharedInstance.userID,
            "agents_users_role_id":Model.sharedInstance.userRole
        ]
        print(parameters)
        Webservice.apiPost(apiURl:  "http://92agents.com/api/tests", parameters: parameters, headers: nil) { (response:NSDictionary?, error:NSError?) in
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
                   
                    for item in (dict as NSDictionary).value(forKey: "questions") as! NSArray {
                        print(item)
                        self.questionArr.append(getQuestions.init(ques_id: (item as! NSDictionary).value(forKey: "question_id") as! String, question: (item as! NSDictionary).value(forKey: "question") as! String))
                    }
                    for row in 0...self.questionArr.count - 1{
                        self.ansArr.append(getAnswer.init(answer: ((dict as NSDictionary).value(forKey: "answers") as! NSDictionary).object(forKey: self.questionArr[row].ques_id) as! String))
                    }
                    print(self.ansArr)
                    DispatchQueue.main.async(execute: {
                        self.tableView.reloadData()
                    })
                }else{
                    Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: (response?.value(forKey: "error") as! String))
                }
            }
            
        }
    }
    //MARK: getNotesAPI
    func getNotesAPI() {
        self.questionArr.removeAll()
        self.ansArr.removeAll()
        let url = URL(string: "http://92agents.com/api/tests")!//set url
        let jsonDict = [
            "agent_user_id": Model.sharedInstance.userID,
            "agents_users_role_id":Model.sharedInstance.userRole,
            ]
        print(jsonDict)
        let jsonData = try! JSONSerialization.data(withJSONObject: jsonDict, options: [])
        
        var request = URLRequest(url: url)
        request.httpMethod = "post"
        //set token
        let token = "\(Model.sharedInstance.accessToken)"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
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
                for item in (json as NSDictionary).value(forKey: "questions") as! NSArray {
                    print(item)
                    self.questionArr.append(getQuestions.init(ques_id: (item as! NSDictionary).value(forKey: "question_id") as! String, question: (item as! NSDictionary).value(forKey: "question") as! String))
                }
                for row in 0...self.questionArr.count - 1{
                    self.ansArr.append(getAnswer.init(answer: ((json as NSDictionary).value(forKey: "answers") as! NSDictionary).object(forKey: self.questionArr[row].ques_id) as! String))
                }
              print(self.ansArr)
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
            } catch {
                print("error:", error)
            }
        }
        task.resume()
    }
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    //MARK: Tableview Delegate and Data Source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.questionArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : SellerTestTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as! SellerTestTableViewCell
         cell.lblNo.text = "\(indexPath.row + 1)"
        //cell.ansView.isHidden = true
        cell.lblQuestion.text = "\(self.questionArr[indexPath.row].question)"
        cell.textAns.text = self.ansArr[indexPath.row].answer
        if selectedIndex == indexPath.row {
             cell.viewHeight.constant = 104
        }else{
             cell.viewHeight.constant = 0
        }
        cell.btnAnswer.tag = indexPath.row
        cell.btnAnswer.addTarget(self,action:#selector(btnAnswer(sender:)), for: .touchUpInside)
        return cell
    }
    @objc func btnAnswer(sender:UIButton!){
        let indexPath = IndexPath(item: sender.tag, section: 0)
        let cell = tableView.cellForRow(at: indexPath) as! SellerTestTableViewCell!
      //  let cell : SellerTestTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as! SellerTestTableViewCell
        //cell?.ansView.isHidden = false
        selectedIndex =  sender.tag
        //tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.fade)
         cell?.viewHeight.constant = 104
        
        self.tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == selectedIndex  {
            
            return 177 //Size you want to increase to
        }
        return 75 // Default Size
    }
}


