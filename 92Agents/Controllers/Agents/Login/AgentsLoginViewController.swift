//
//  AgentsLoginViewController.swift
//  92Agents
//
//  Created by Apple on 19/06/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import Alamofire
import SKActivityIndicatorView

class AgentsLoginViewController: UIViewController {

     //MARK: IBOutlet and Variables
    @IBOutlet var textEmail: UITextField!
    @IBOutlet var textPassword: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnRegister(_ sender: UIButton) {
        let signupVC = UIStoryboard(name: "Agents", bundle: nil).instantiateViewController(withIdentifier: "RegistrationViewController") as! RegistrationViewController
        self.navigationController?.pushViewController(signupVC, animated: true)
    }
    @IBAction func btnLogin(_ sender: UIButton) {
        textFieldValidation()
        //let signupVC = UIStoryboard(name: "Agents", bundle: nil).instantiateViewController(withIdentifier: "AgentDashBoardViewController") as! AgentDashBoardViewController
        //self.navigationController?.pushViewController(signupVC, animated: true)
    }
    @IBAction func btnForgotPassword(_ sender: UIButton) {
        let addressVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SellerForgotViewController") as! SellerForgotViewController
        self.navigationController?.pushViewController(addressVC, animated: true)
    }
    
    //MARK: textFieldValidation Method
    func textFieldValidation()
    {
        if (self.textEmail.text?.isEmpty)! {
            Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: "Enter Email")
        }
        else if (self.textEmail.text?.isEmpty)! {
            Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: "Enter Password")
        }
        else{
            
            
//            Alamofire.request("http://92agents.com/api/state", parameters: ["foo": "bar"])
//                .validate(statusCode: 200..<300)
//                .validate(contentType: ["application/json"])
//                .response { response in
//
//                    print("Request  \(String(describing: response.request?.httpBody))")
//                    print("RESPONSE \(String(describing: response.request?.value))")
//                    print("RESPONSE \(response.request)")
//                    print("RESPONSE \(response)")
//            }

            
            loginMethodAPI()
            //callPostService(url:"http://92agents.com/api/state",parameters: [:])
            //hitPostServiceJsonForm()
            
           // Alamofire.request(urlString,method: .post, parameters: requestParams, encoding: JSONEncoding.default, headers: [:])
            let Auth_header: [String:String] = ["Accept":"application/json", "Content-Type" : "application/json"]
            let urlRequest = URLRequest(url: URL(string: "http://92agents.com/api/state")!)
            let urlString = urlRequest.url?.absoluteString
//            Alamofire.request(urlString!, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: Auth_header).responseJSON { response in
//                print("Request  \(String(describing: response.request?.httpBody))")
//                print("RESPONSE \(String(describing: response.result.value))")
//                print("RESPONSE \(response.result)")
//                print("RESPONSE \(response)")
//                
//                switch(response.result) {
//                case .success(_):
//                    if response.result.value != nil{
//                        // return result
//                    }
//                    break
//                    
//                case .failure(_):
//                    // return failure
//                    print("RESPONSE \(response.result)")
//                    break
//                    
//                }
//            }
    }
}
    
    func hitPostServiceJsonForm() {
        
        var request = URLRequest(url: URL(string: "http://92agents.com/api/state")!)
        request.httpMethod = "POST"
       //  request.addValue("application/form-data", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type") // the request is JSON
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept") // the expected response is also JSON
        request.httpBody = try! JSONSerialization.data(withJSONObject: [:], options: .prettyPrinted)
        
        Alamofire.request(request).responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            switch response.result {
            case .success:
                if let jsonDict = response.result.value as? Dictionary<String,Any> {
                    print("Json Response: \(jsonDict)") // serialized json response
                }
                else{
                }
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    print("Server Response: \(utf8Text)") // original server data as UTF8 string
                }
                break
            case .failure(let error):
                print(error)
                break
            }
        }
    }
    
   
    func callPostService(url:String,parameters:NSDictionary){
        
        
        print("url is===>\(url)")
        
        let request = NSMutableURLRequest(url: NSURL(string:url)! as URL)
        
        let session = URLSession.shared
        request.httpMethod = "POST"
        
        //Note : Add the corresponding "Content-Type" and "Accept" header. In this example I had used the application/json.
        //request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/form-data", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONSerialization.data(withJSONObject:parameters, options: [])
        
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            guard data != nil else {
                print("no data found: \(error!)")
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                    print("Response: \(json)")
                } else {
                    let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)// No error thrown, but not NSDictionary
                    print("Error could not parse JSON: \(jsonStr!)")
                }
            } catch let parseError {
                print(parseError)// Log the error thrown by `JSONObjectWithData`
                let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                print("Error could not parse JSON: '\(jsonStr!)'")
            }
        }
        
        task.resume()
    }
    
    
    
    
    
    
    
    
    //MARK: fetchCountryAPI Methods
    func fetchCountryAPI(){
        SKActivityIndicator.spinnerColor(UIColor.darkGray)
        SKActivityIndicator.show("Loading...")
        
        Webservice.apiPost(apiURl: "http://92agents.com/api/state", parameters: nil, headers: nil, completionHandler: { (response:NSDictionary?, error:NSError?) in
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
              
            }
        })
    }
    
    
    
    //MARK: loginAPI Methods
    func loginMethodAPI(){
        SKActivityIndicator.spinnerColor(UIColor.darkGray)
        SKActivityIndicator.show("Loading...")
        // set params
        let parameters: Parameters = [
            "grant_type": "password",
            "client_id":"2",
            "client_secret":"9XXqgb1Hk1dSemtoFToUCnrm1LMxW98qmFQIZfuB",
            "email": self.textEmail.text!,
            "password": self.textPassword.text!,
            "agents_users_role_id":Model.sharedInstance.userRole
        ]
        print(parameters)
        Webservice.apiPost(apiURl:  "http://92agents.com/api/login", parameters: parameters, headers: nil) { (response:NSDictionary?, error:NSError?) in
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
            
            if let dict = response as? [AnyHashable:Any] {
                
                if ((dict as NSDictionary).value(forKey: "status") as? String == "100"){
                    let addressVC = UIStoryboard(name: "Agents", bundle: nil).instantiateViewController(withIdentifier: "AgentDashBoardViewController") as! AgentDashBoardViewController
                    Model.sharedInstance.accessToken = ((dict as NSDictionary).value(forKey: "access_token") as? String)!
                    let tempNumber = (((dict as NSDictionary).value(forKey: "user") as! NSDictionary).value(forKey: "id") as! Int)
                    let stringTemp = String(tempNumber)
                    Model.sharedInstance.userID = stringTemp
                    self.navigationController?.pushViewController(addressVC, animated: true)
                }else{
                    Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: (response?.value(forKey: "error") as! String))
                }
            }
            
        }
    }
}
