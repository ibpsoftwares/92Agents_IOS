//
//  Webservice.swift
//  92Agents
//
//  Created by Apple on 14/06/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import Alamofire

struct FV_API
{
    
    //URL is http://www.stack.com/index.php/signup
    static let appBaseURL = "http://kftsoftwares.com/ecomm/recipes"  // assign your base url suppose:  http://www.stack.com/index.php
    static let apiLogin = "login/"   // assign signup i.e: signup
    static let accessToken = "Bearer ZWNvbW1lcmNl"
}
class Webservice: NSObject {
//MARK:- POST APIs
    
    class func apiPost (apiURl:String,parameters: [String:Any]?,headers:[String:Any]?, completionHandler: @escaping (NSDictionary,_ Error:NSError?) -> ()){
        let token = "\(Model.sharedInstance.accessToken)"
        let headers = ["Authorization":"Bearer \(token)"]//,"Accept": "application/json","Content-Type" :"application/json"
       // print(headers)
        //var strURL:String = FV_API.appBaseURL

        //if((apiURl as NSString).length > 0)
//        {
//            strURL = strURL + "/" + apiURl
//        }
         let urlwithPercentEscapes = apiURl.addingPercentEncoding( withAllowedCharacters: CharacterSet.urlQueryAllowed)
        // print(apiURl)
        Alamofire.request(urlwithPercentEscapes!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            print("Request  \(String(describing: response.request))")
            print("RESPONSE \(String(describing: response.result.value))")
            print("RESPONSE \(response.result)")
            print("RESPONSE \(response)")
           
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                       // return result
                    completionHandler(response.result.value as! NSDictionary,nil)
                }
                break

            case .failure(_):
                   // return failure
                print("RESPONSE \(response.result)")
                completionHandler(response.result.value as! NSDictionary,response.result.error as NSError?)
                break
                
            }
        }
    }
    //MARK:- POST APIs
    class func apiPost1 (apiURl:String,parameters: [String:Any]?,headers:[String:Any]?, completionHandler: @escaping ([String: Any],_ Error:NSError?) -> ()){
        
        // let headers = ["Authorization":"Bearer ZWNvbW1lcmNl"]
        let token = "\(Model.sharedInstance.accessToken)"
        let headers = ["Authorization":"Bearer \(token)"]
        print(headers)
        var strURL:String = FV_API.appBaseURL
        
        if((apiURl as NSString).length > 0)
        {
            strURL = strURL + "/" + apiURl
        }
        print(apiURl)
        Alamofire.request(apiURl, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
             print("Request  \(String(describing: response.request))")
             print("RESPONSE \(String(describing: response.result.value))")
            print("RESPONSE \(response.result)")
            //  print("RESPONSE \(response)")
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    // return result
                    completionHandler((response.result.value as? [String: Any])!,nil)
                }
                break
                
            case .failure(_):
                print("RESPONSE \(response.result)")
                   // return error
                completionHandler((response.result.value as? [String: Any])!,response.result.error as NSError?)
                break
                
            }
        }
    }
    //MARK:- GET APIs
    class func apiGet(serviceName:String,parameters: [String:Any]?,headers:[String:Any]?, completionHandler: @escaping (NSDictionary, NSError?) -> ()) {

        let token = "\(Model.sharedInstance.accessToken)"
        let headers = ["Authorization":"Bearer \(token)"]
        print(headers)
        Alamofire.request(serviceName, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { (response:DataResponse<Any>) in

             print("Request  \(String(describing: response.request))")
             print("RESPONSE \(String(describing: response.result.value))")
            print("RESPONSE \(response.result)")
              print("RESPONSE \(response)")
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                       // return result
                    completionHandler(response.result.value as! NSDictionary,nil)
                }
                break

            case .failure(_):
                   // return error
                completionHandler(response.result.value as! NSDictionary,response.result.error as NSError?)
                break

            }
        }
    }
}
