//
//  BuyerProfileViewController.swift
//  92Agents
//
//  Created by Apple on 09/07/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import SKActivityIndicatorView
import Kingfisher
import Alamofire

class BuyerProfileViewController: UIViewController {

     //MARK: IBOutlet and Variables
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
    
     //MARK: viewDidLoad Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // acll api
         //profileAPI()
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
    
    
    
    //MARK: profileAPI
    func profileAPI() {
        self.countryArr.removeAll()
        SKActivityIndicator.spinnerColor(UIColor.darkGray)
        SKActivityIndicator.show("Loading...")
        let url = URL(string: "http://92agents.com/api/profile/buyer")! // set url
        // set params
        let jsonDict = [
            "agents_user_id": Model.sharedInstance.userID,
            "agents_users_role_id":Model.sharedInstance.userRole,
            ]
        print(jsonDict)
        let jsonData = try! JSONSerialization.data(withJSONObject: jsonDict, options: [])
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        // set token
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
                    self.textState.text = (((((json as NSDictionary).value(forKey: "response") as! NSDictionary) ).value(forKey: "userdetails") as! NSDictionary).value(forKey: "city_id") as! String)
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

}
