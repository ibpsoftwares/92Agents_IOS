//
//  ProfessionalBioViewController.swift
//  92Agents
//
//  Created by Apple on 09/10/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import SKActivityIndicatorView
import Kingfisher
import Alamofire
class salesHistory {
    var buyers_represented : String
    var sellers_represented: String
    var total_dollar_sales: String
    var year: String
    init(buyers_represented: String,sellers_represented: String,total_dollar_sales: String,year: String) {
        self.buyers_represented = buyers_represented
        self.sellers_represented = sellers_represented
        self.total_dollar_sales = total_dollar_sales
        self.year = year
    }
}
class languageProficiency {
    var language : String
    var speak: String
    var read: String
    var write: String
    init(language: String,speak: String,read: String,write: String) {
        self.language = language
        self.speak = speak
        self.read = read
        self.write = write
    }
}

class ProfessionalBioViewController: UIViewController,UITextFieldDelegate {

   //RealEstateEducation
    @IBOutlet var tableViewRealEstatel: UITableView!
    @IBOutlet var tableViewRealEstatelHeight: NSLayoutConstraint!
    // Education
    @IBOutlet var tableViewEducation: UITableView!
    @IBOutlet var tableViewEducationHeight: NSLayoutConstraint!
     @IBOutlet var viewIndustryHeight: NSLayoutConstraint!
     @IBOutlet  var tagListViewSpeciliazation: TagListView!
     @IBOutlet  var tagListViewCertification: TagListView!
    var realStateArr = [realState]()
    var industryArr = [realState]()
    var languageArr = [languageProficiency]()
    //Sales History
    @IBOutlet var tableViewSalesHistory: UITableView!
    @IBOutlet var tableViewSalesHistoryHeight: NSLayoutConstraint!
    @IBOutlet var viewSalesHistoryHeight: NSLayoutConstraint!
    var salesHistoryArr = [salesHistory]()
    //Associations
    @IBOutlet var associationsView: UIView!
    @IBOutlet var associationsViewHeight: NSLayoutConstraint!
     @IBOutlet var textAssociation: UITextField!
    //Publication
    @IBOutlet var publicationView: UIView!
    @IBOutlet var publicationViewHeight: NSLayoutConstraint!
    @IBOutlet var textPublication: UITextField!
    //Community Involvement
    @IBOutlet var communityView: UIView!
    @IBOutlet var communityViewHeight: NSLayoutConstraint!
    @IBOutlet var textCommunity: UITextField!
    //Language
    @IBOutlet var tableViewLanguagel: UITableView!
    @IBOutlet var tableViewLanguageHeight: NSLayoutConstraint!
    @IBOutlet var ViewLanguageHeight: UIView!
    //Certification
    @IBOutlet var certificationView: UIView!
    @IBOutlet var certificateTableView: UITableView!
   
    var certificationArray = NSArray()
    //Add New Industry
    @IBOutlet var newIndustryView: UIView!
    @IBOutlet var textTitleAddIndustry: UITextField!
    @IBOutlet var textCompanyAddIndustry: UITextField!
    @IBOutlet var textToDateAddIndustry: UITextField!
    @IBOutlet var textFromDateAddIndustry: UITextField!
    @IBOutlet var textViewDetailAddIndustry: UITextView!
    var index = NSInteger()
    var select = String()
    // Edit Sales History
    @IBOutlet var textYearEditSalesHistory: UITextField!
    @IBOutlet var textSellerRepresnted: UITextField!
    @IBOutlet var textBuyerRepresented: UITextField!
    @IBOutlet var textTotalDollerSales: UITextField!
    @IBOutlet var viewSalesHistory: UIView!
     // Edit Language
    @IBOutlet var addLanguageView: UIView!
    @IBOutlet var textAddLang: UITextField!
    @IBOutlet var textAddRead: UITextField!
    @IBOutlet var textAddSpeak: UITextField!
    @IBOutlet var textAddWrite: UITextField!
    var dictData: [Dictionary<String, AnyObject>] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        agentProfessionalAPI()
        let nib = UINib(nibName: "LanguageTableViewCell", bundle: nil)
        tableViewLanguagel.register(nib, forCellReuseIdentifier: "cell")
        tableViewLanguagel.tableFooterView = UIView()
        self.certificationView.isHidden = true
        certificateTableView.tableFooterView = UIView()
        self.newIndustryView.isHidden = true
         textTitleAddIndustry.layer.borderColor = UIColor.darkGray.cgColor
         textCompanyAddIndustry.layer.borderColor = UIColor.darkGray.cgColor
         textFromDateAddIndustry.layer.borderColor = UIColor.darkGray.cgColor
         textFromDateAddIndustry.layer.borderColor = UIColor.darkGray.cgColor
         textViewDetailAddIndustry.layer.borderColor = UIColor.darkGray.cgColor
         textViewDetailAddIndustry.layer.borderWidth = 1.0
         self.viewSalesHistory.isHidden = true
         self.addLanguageView.isHidden = true
    }
    //MARK: agentProfessionalAPI Methods
    func agentProfessionalAPI(){
        self.realStateArr.removeAll()
        self.industryArr.removeAll()
        self.salesHistoryArr.removeAll()
        self.languageArr.removeAll()
        SKActivityIndicator.spinnerColor(UIColor.darkGray)
        SKActivityIndicator.show("Loading...")
        let parameters: Parameters = [
            "agents_user_id": Model.sharedInstance.userID,
            "agents_users_role_id":Model.sharedInstance.userRole
        ]
        print(parameters)
        Webservice.apiGet(serviceName:"http://92agents.com/api/profile/resume", parameters: nil, headers: nil) { (response:NSDictionary?, error:NSError?) in
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
            // print(response!)
            if let dict = response as? [AnyHashable:Any] {
                print(dict)
                
                DispatchQueue.main.async(execute: {
                    // RealEstate
                    if (((((response)?.value(forKey: "response") as! NSDictionary) ).value(forKey: "userdetails") as! NSDictionary).value(forKey: "real_estate_education")as! NSArray).count > 0{
                       for section in 0...((((dict as NSDictionary).value(forKey: "response")as! NSDictionary).value(forKey: "userdetails") as! NSDictionary).value(forKey: "real_estate_education") as! NSArray).count  - 1 {
                         self.realStateArr.append(realState.init(description: ((((((dict as NSDictionary).value(forKey: "response")as! NSDictionary).value(forKey: "userdetails") as! NSDictionary).value(forKey: "real_estate_education") as! NSArray).object(at: section) as! NSDictionary).value(forKey: "description") as! String), from: ((((((dict as NSDictionary).value(forKey: "response")as! NSDictionary).value(forKey: "userdetails") as! NSDictionary).value(forKey: "real_estate_education") as! NSArray).object(at: section) as! NSDictionary).value(forKey: "from") as! String), organization: ((((((dict as NSDictionary).value(forKey: "response")as! NSDictionary).value(forKey: "userdetails") as! NSDictionary).value(forKey: "real_estate_education") as! NSArray).object(at: section) as! NSDictionary).value(forKey: "school") as! String), post: ((((((dict as NSDictionary).value(forKey: "response")as! NSDictionary).value(forKey: "userdetails") as! NSDictionary).value(forKey: "real_estate_education") as! NSArray).object(at: section) as! NSDictionary).value(forKey: "degree") as! String), to: ((((((dict as NSDictionary).value(forKey: "response")as! NSDictionary).value(forKey: "userdetails") as! NSDictionary).value(forKey: "real_estate_education") as! NSArray).object(at: section) as! NSDictionary).value(forKey: "to") as! String)))
                        }
                    }
                    // Certification
                    self.certificationArray = (((response)?.value(forKey: "response") as! NSDictionary).value(forKey: "agentcertifications") as! NSArray)
                    //Industry
                    if (((((response)?.value(forKey: "response") as! NSDictionary) ).value(forKey: "userdetails") as! NSDictionary).value(forKey: "industry_experience")as! NSArray).count > 0{
                        for section in 0...((((dict as NSDictionary).value(forKey: "response")as! NSDictionary).value(forKey: "userdetails") as! NSDictionary).value(forKey: "industry_experience") as! NSArray).count  - 1 {
                            self.industryArr.append(realState.init(description: ((((((dict as NSDictionary).value(forKey: "response")as! NSDictionary).value(forKey: "userdetails") as! NSDictionary).value(forKey: "industry_experience") as! NSArray).object(at: section) as! NSDictionary).value(forKey: "description") as! String), from:((((((dict as NSDictionary).value(forKey: "response")as! NSDictionary).value(forKey: "userdetails") as! NSDictionary).value(forKey: "industry_experience") as! NSArray).object(at: section) as! NSDictionary).value(forKey: "from") as! String) , organization: ((((((dict as NSDictionary).value(forKey: "response")as! NSDictionary).value(forKey: "userdetails") as! NSDictionary).value(forKey: "industry_experience") as! NSArray).object(at: section) as! NSDictionary).value(forKey: "organization") as! String), post: ((((((dict as NSDictionary).value(forKey: "response")as! NSDictionary).value(forKey: "userdetails") as! NSDictionary).value(forKey: "industry_experience") as! NSArray).object(at: section) as! NSDictionary).value(forKey: "post") as! String), to: ((((((dict as NSDictionary).value(forKey: "response")as! NSDictionary).value(forKey: "userdetails") as! NSDictionary).value(forKey: "industry_experience") as! NSArray).object(at: section) as! NSDictionary).value(forKey: "to") as! String)))
                        }
                    }
                
                    //SalesHistory
                    if (((((response)?.value(forKey: "response") as! NSDictionary) ).value(forKey: "userdetails") as! NSDictionary).value(forKey: "sales_history")as! NSArray).count > 0{
                        for section in 0...((((dict as NSDictionary).value(forKey: "response")as! NSDictionary).value(forKey: "userdetails") as! NSDictionary).value(forKey: "sales_history") as! NSArray).count  - 1 {
                            self.salesHistoryArr.append(salesHistory.init(buyers_represented: ((((((dict as NSDictionary).value(forKey: "response")as! NSDictionary).value(forKey: "userdetails") as! NSDictionary).value(forKey: "sales_history") as! NSArray).object(at: section) as! NSDictionary).value(forKey: "buyers_represented") as! String), sellers_represented: ((((((dict as NSDictionary).value(forKey: "response")as! NSDictionary).value(forKey: "userdetails") as! NSDictionary).value(forKey: "sales_history") as! NSArray).object(at: section) as! NSDictionary).value(forKey: "sellers_represented") as! String), total_dollar_sales: ((((((dict as NSDictionary).value(forKey: "response")as! NSDictionary).value(forKey: "userdetails") as! NSDictionary).value(forKey: "sales_history") as! NSArray).object(at: section) as! NSDictionary).value(forKey: "total_dollar_sales") as! String), year: ((((((dict as NSDictionary).value(forKey: "response")as! NSDictionary).value(forKey: "userdetails") as! NSDictionary).value(forKey: "sales_history") as! NSArray).object(at: section) as! NSDictionary).value(forKey: "year") as! String)))
                        }
                    }
                    //Language
                    if (((((response)?.value(forKey: "response") as! NSDictionary) ).value(forKey: "userdetails") as! NSDictionary).value(forKey: "language_proficiency")as! NSArray).count > 0{
                        for section in 0...((((dict as NSDictionary).value(forKey: "response")as! NSDictionary).value(forKey: "userdetails") as! NSDictionary).value(forKey: "language_proficiency") as! NSArray).count  - 1 {
                            self.languageArr.append(languageProficiency.init(language:((((((dict as NSDictionary).value(forKey: "response")as! NSDictionary).value(forKey: "userdetails") as! NSDictionary).value(forKey: "language_proficiency") as! NSArray).object(at: section) as! NSDictionary).value(forKey: "language") as! String),speak:((((((dict as NSDictionary).value(forKey: "response")as! NSDictionary).value(forKey: "userdetails") as! NSDictionary).value(forKey: "language_proficiency") as! NSArray).object(at: section) as! NSDictionary).value(forKey: "speak") as! String),read:((((((dict as NSDictionary).value(forKey: "response")as! NSDictionary).value(forKey: "userdetails") as! NSDictionary).value(forKey: "language_proficiency") as! NSArray).object(at: section) as! NSDictionary).value(forKey: "read") as! String),write:((((((dict as NSDictionary).value(forKey: "response")as! NSDictionary).value(forKey: "userdetails") as! NSDictionary).value(forKey: "language_proficiency") as! NSArray).object(at: section) as! NSDictionary).value(forKey: "write") as! String)))
                        }
                    }
                       var cgfloat6 = CGFloat()
                    if self.languageArr.count > 0{
                        for section in 0...(self.languageArr.count) - 1 {
                            let height = self.calculateHeight(inString:self.languageArr[section].language  )
                            cgfloat6 = cgfloat6 + height + 1
                        }
                    }
                      self.tableViewLanguageHeight.constant = cgfloat6
                    if ((((response)?.value(forKey: "response") as! NSDictionary) ).value(forKey: "userdetails") as! NSDictionary).value(forKey: "associations_awards") is NSNull{
                        
                    }
                    else{
                      //  self.textAssociation.text = (((((response )?.value(forKey: "response") as! NSDictionary) ).value(forKey: "userdetails") as! NSDictionary).value(forKey: "associations_awards") as! String)
                    }
                    if ((((response)?.value(forKey: "response") as! NSDictionary) ).value(forKey: "userdetails") as! NSDictionary).value(forKey: "publications") is NSNull{
                        
                    }
                    else{
                        //self.textPublication.text = (((((response )?.value(forKey: "response") as! NSDictionary) ).value(forKey: "userdetails") as! NSDictionary).value(forKey: "publications") as! String)
                    }
                    
                     // Speciliazation
                    self.tagListViewSpeciliazation.removeAllTags()
                    if (((dict as NSDictionary).value(forKey: "response")as! NSDictionary).value(forKey: "userdetails") as! NSDictionary).value(forKey: "specialization") is NSNull{
                       
                    }
                    else{
                        var str = (((dict as NSDictionary).value(forKey: "response")as! NSDictionary).value(forKey: "userdetails") as! NSDictionary).value(forKey: "specialization") as! String
                        
                        str = str.replacingOccurrences(of: ",", with: "", options: NSString.CompareOptions.literal, range:nil)
                      print(str)
                        
                        for section in 0...str.count - 1{
                             var at = str.character(section)
                            print(at)
                            for section in 0...(((dict as NSDictionary).value(forKey: "response")as! NSDictionary).value(forKey: "agentspecializations") as! NSArray).count  - 1 {
                                let str = (((((dict as NSDictionary).value(forKey: "response") as! NSDictionary).value(forKey: "agentspecializations")  as! NSArray).object(at: section) as! NSDictionary).value(forKey: "skill_id") as! String)
                                if (String(at)) ==  str {
                                   self.tagListViewSpeciliazation.addTags([(((((dict as NSDictionary).value(forKey: "response") as! NSDictionary).value(forKey: "agentspecializations")  as! NSArray).object(at: section) as! NSDictionary).value(forKey: "skill") as! String)])
                                }
                               
                            }
                        }
                   
                        
                    }
                    // Certification
                     self.tagListViewCertification.removeAllTags()
                    if (((dict as NSDictionary).value(forKey: "response")as! NSDictionary).value(forKey: "userdetails") as! NSDictionary).value(forKey: "certifications") is NSNull{
                        
                    }
                    else{
                        var str = (((dict as NSDictionary).value(forKey: "response")as! NSDictionary).value(forKey: "userdetails") as! NSDictionary).value(forKey: "certifications") as! String
                        
                        str = str.replacingOccurrences(of: ",", with: "", options: NSString.CompareOptions.literal, range:nil)
                        print(str)
                        
                        for section in 0...str.count - 1{
                            var at = str.character(section)
                            print(at)
                            for section in 0...(((dict as NSDictionary).value(forKey: "response")as! NSDictionary).value(forKey: "agentcertifications") as! NSArray).count  - 1 {
                                let str = (((((dict as NSDictionary).value(forKey: "response") as! NSDictionary).value(forKey: "agentcertifications")  as! NSArray).object(at: section) as! NSDictionary).value(forKey: "certifications_id") as! String)
                                if (String(at)) ==  str {
                                    self.tagListViewCertification.addTags([(((((dict as NSDictionary).value(forKey: "response") as! NSDictionary).value(forKey: "agentcertifications")  as! NSArray).object(at: section) as! NSDictionary).value(forKey: "certifications_description") as! String)])
                                }
                                
                            }
                        }
                    }
                    DispatchQueue.main.async(execute: {
                      
                        let int1: Int32 = Int32((self.salesHistoryArr.count) * 194  )
                        let cgfloat1 = CGFloat(int1)
                        let int2: Int32 = Int32((self.realStateArr.count) * 75  )
                        let cgfloat2 = CGFloat(int2)
                        let int3: Int32 = Int32((self.industryArr.count) * 80  )
                        let cgfloat3 = CGFloat(int3)
                        // salesHistory
                        self.tableViewSalesHistoryHeight.constant = cgfloat1
                        self.viewSalesHistoryHeight.constant = cgfloat1 + 30
                        
                        self.tableViewRealEstatelHeight.constant = cgfloat2
                        //education
                        self.tableViewEducationHeight.constant = cgfloat3
                        self.viewIndustryHeight.constant = cgfloat3 + 40
//                        let int: Int32 = Int32((self.languageArr.count) * 190)
//                        let cgfloat = CGFloat(int)
//                        self.tableViewLanguageHeight.constant = cgfloat + 30
//
                        self.certificateTableView.reloadData()
                        self.tableViewSalesHistory.reloadData()
                        self.tableViewRealEstatel.reloadData()
                        self.tableViewEducation.reloadData()
                        self.tableViewLanguagel.reloadData()
                        
                    })
                })
            }else{
                Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: (response?.value(forKey: "error") as! String))
            }
        }
    }
    //MARK: CalculateHeight Method
    func calculateHeight(inString:String) -> CGFloat {
        let messageString = inString
        let attributes : [String : Any] = [NSAttributedStringKey.font.rawValue : UIFont.systemFont(ofSize: 15.0)]
        
        let attributedString : NSAttributedString = NSAttributedString(string: messageString, attributes: nil)
        
        let rect : CGRect = attributedString.boundingRect(with: CGSize(width: 222.0, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, context: nil)
        
        let requredSize:CGRect = rect
        return requredSize.height
    }
    //MARK: Add New Association TextField Programatically
    @IBAction func btnAddAssciation(_ sender: UIButton) {
        let sampleTextField =  UITextField(frame: CGRect(x: self.textAssociation.frame.origin.x , y: self.associationsView.frame.size.height , width: self.textAssociation.frame.size.width, height: 30))
        sampleTextField.placeholder = "Enter text here"
        sampleTextField.font = UIFont.systemFont(ofSize: 15)
        sampleTextField.layer.borderWidth = 1.0
        sampleTextField.layer.borderColor = UIColor.black.cgColor
        sampleTextField.delegate = self
        self.associationsView.addSubview(sampleTextField)
        self.associationsViewHeight.constant = self.associationsView.frame.size.height + sampleTextField.frame.size.height + 10
    }
    //MARK: Add New Publication TextField Programatically
    @IBAction func btnAddPublication(_ sender: UIButton) {
        let sampleTextField =  UITextField(frame: CGRect(x: self.textPublication.frame.origin.x , y: self.publicationView.frame.size.height, width: self.textPublication.frame.size.width, height: 30))
        sampleTextField.placeholder = "Enter text here"
        sampleTextField.font = UIFont.systemFont(ofSize: 15)
        sampleTextField.layer.borderWidth = 1.0
        sampleTextField.layer.borderColor = UIColor.black.cgColor
        sampleTextField.delegate = self
        self.publicationView.addSubview(sampleTextField)
        publicationViewHeight.constant = self.publicationView.frame.size.height + sampleTextField.frame.size.height + 10
    }
    //MARK: Add New Publication TextField Programatically
    @IBAction func btnAddCommunity(_ sender: UIButton) {
        let sampleTextField =  UITextField(frame: CGRect(x: self.textCommunity.frame.origin.x , y: self.communityView.frame.size.height, width: self.textCommunity.frame.size.width, height: 30))
        sampleTextField.placeholder = "Enter text here"
        sampleTextField.font = UIFont.systemFont(ofSize: 15)
        sampleTextField.layer.borderWidth = 1.0
        sampleTextField.layer.borderColor = UIColor.black.cgColor
        sampleTextField.delegate = self
        self.communityView.addSubview(sampleTextField)
        communityViewHeight.constant = self.communityView.frame.size.height + sampleTextField.frame.size.height + 10
    }
    // MARK:- ---> Textfield Delegates
    func textFieldDidEndEditing(_ textField: UITextField) {
        //print("\(textField.text!)")
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        //print("hello1")
        return true;
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        //print("hello1")
        return true;
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        print("\(textField.text!)")
//        if textField == self.textFranchise{
//
//        }else{
//            zipStr.append(textField.text!)
//        }
        
        return true;
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print("While entering the characters this method gets called")
        return true;
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("hello2")
        textField.resignFirstResponder();
        return true;
    }
    //MARK: Add Certification
    @IBAction func certificationAddBtn(_ sender: UIButton) {
        self.certificateTableView.reloadData()
        self.certificationView.isHidden = false
    }
    @IBAction func certificationBtnClose(_ sender: UIButton) {
        self.certificationView.isHidden = true
    }
    @IBAction func certificationBtnDone(_ sender: UIButton) {
         self.certificationView.isHidden = true
    }
    //MARK: Add Industry
    @IBAction func industryAddBtn(_ sender: UIButton) {
        self.newIndustryView.isHidden = false
        select = "add"
    }
    @IBAction func industryBtnClose(_ sender: UIButton) {
        self.newIndustryView.isHidden = true
    }
    @IBAction func industryBtnSave(_ sender: UIButton) {
        self.certificationView.isHidden = true
    }
}
public extension String {
    
    //right is the first encountered string after left
    func between(_ left: String, _ right: String) -> String? {
        guard
            let leftRange = range(of: left), let rightRange = range(of: right, options: .backwards)
            , leftRange.upperBound <= rightRange.lowerBound
            else { return nil }
        
        let sub = self[leftRange.upperBound...]
        let closestToLeftRange = sub.range(of: right)!
        return String(sub[..<closestToLeftRange.lowerBound])
    }
    
    var length: Int {
        get {
            return self.count
        }
    }
    
    func substring(to : Int) -> String {
        let toIndex = self.index(self.startIndex, offsetBy: to)
        return String(self[...toIndex])
    }
    
    func substring(from : Int) -> String {
        let fromIndex = self.index(self.startIndex, offsetBy: from)
        return String(self[fromIndex...])
    }
    
    func substring(_ r: Range<Int>) -> String {
        let fromIndex = self.index(self.startIndex, offsetBy: r.lowerBound)
        let toIndex = self.index(self.startIndex, offsetBy: r.upperBound)
        let indexRange = Range<String.Index>(uncheckedBounds: (lower: fromIndex, upper: toIndex))
        return String(self[indexRange])
    }
    
    func character(_ at: Int) -> Character {
        return self[self.index(self.startIndex, offsetBy: at)]
    }
    
    func lastIndexOfCharacter(_ c: Character) -> Int? {
        return range(of: String(c), options: .backwards)?.lowerBound.encodedOffset
    }
    
}

extension ProfessionalBioViewController: UITableViewDataSource {
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableViewSalesHistory{
            return self.salesHistoryArr.count
        }
        else if tableView == self.tableViewLanguagel{
            return self.languageArr.count
        }
        else if tableView == self.tableViewRealEstatel{
            return self.realStateArr.count
        }
        else if tableView == self.tableViewEducation{
            return self.industryArr.count
        }
        else if tableView == self.certificateTableView{
           // return self.certificationArray.count
             return 10
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell1 = SalesHistoryTableViewCell()
        if tableView == self.tableViewSalesHistory{
            cell1  = tableViewSalesHistory.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as! SalesHistoryTableViewCell
            cell1.textSellerRepresnt.text = self.salesHistoryArr[indexPath.row].sellers_represented
            cell1.textBuyerRepresnt.text = self.salesHistoryArr[indexPath.row].buyers_represented
            cell1.textYear.text = self.salesHistoryArr[indexPath.row].year
            cell1.textTotalSales.text = self.salesHistoryArr[indexPath.row].total_dollar_sales
            //cell1.btnDelete.tag = indexPath.row
           // cell1.btnDelete.addTarget(self,action:#selector(buttonNotesTapped(sender:)), for: .touchUpInside)
            //cell1.btnViewProposal.addTarget(self,action:#selector(buttonViewProposal(sender:)), for: .touchUpInside)
        }
        else  if tableView == tableViewLanguagel  {
            let cell = tableViewLanguagel.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LanguageTableViewCell
            cell.lblLanguage.text = self.languageArr[indexPath.row].language
            cell.lblSpeak.text = self.languageArr[indexPath.row].speak
            cell.lblRead.text = self.languageArr[indexPath.row].read
            cell.lblWrite.text = self.languageArr[indexPath.row].write
            return cell
        }
        
        else if tableView == self.tableViewRealEstatel{
            let cell : AgentDetailTableViewCell = tableViewRealEstatel.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as! AgentDetailTableViewCell
            cell.lblPostName.text = self.realStateArr[indexPath.row].post
            cell.lblDate.text = "\(self.realStateArr[indexPath.row].from)\("-") \(self.realStateArr[indexPath.row].to)"
            cell.lblOrgName.text = self.realStateArr[indexPath.row].organization
            cell.lblDetail.text = self.realStateArr[indexPath.row].description
            cell.btnDelete.tag = indexPath.row
            cell.btnEdit.tag = indexPath.row
            cell.btnDelete.addTarget(self,action:#selector(buttonDeleteExp(sender:)), for: .touchUpInside)
            //cell.btnEdit.addTarget(self,action:#selector(buttonEditExp(sender:)), for: .touchUpInside)
            return cell
        }
        else if tableView == self.certificateTableView{
            let cell2 : CertificationTableViewCell = certificateTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as! CertificationTableViewCell
            cell2.btnSelect.setImage(UIImage(named: "uncheck1"), for: .normal)
            cell2.lblName.text = (((self.certificationArray ).object(at: indexPath.row) as! NSDictionary).value(forKey: "certifications_description") as! String)
            return cell2
        }
        else  if tableView == tableViewEducation  {
            let cell : AgentDetailTableViewCell = tableViewEducation.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as! AgentDetailTableViewCell
            cell.lblPostName.text = self.industryArr[indexPath.row].post
            cell.lblDate.text = "\(self.industryArr[indexPath.row].from)\("-") \(self.industryArr[indexPath.row].to)"
            cell.lblOrgName.text = self.industryArr[indexPath.row].organization
            cell.lblDetail.text = self.industryArr[indexPath.row].description
            cell.btnDelete.tag = indexPath.row
            cell.btnEdit.tag = indexPath.row
            cell.btnDelete.addTarget(self,action:#selector(buttonDeleteEducation(sender:)), for: .touchUpInside)
            cell.btnEdit.addTarget(self,action:#selector(buttonEditEducation(sender:)), for: .touchUpInside)
            return cell
        }
        return cell1
    }
    //MARK: Edit Industry
     @objc func buttonEditEducation(sender : UIButton){
        newIndustryView.isHidden = false
        self.textTitleAddIndustry.text = self.industryArr[sender.tag].post
        self.textCompanyAddIndustry.text = self.industryArr[sender.tag].organization
        self.textToDateAddIndustry.text = self.industryArr[sender.tag].to
        self.textFromDateAddIndustry.text = self.industryArr[sender.tag].from
        self.textViewDetailAddIndustry.text = self.industryArr[sender.tag].description
        index = sender.tag
     
    }
    @IBAction func btnUpdateIndustryClick(_ sender: UIButton) {
       
        if  select == "add"{
             self.industryArr.append(realState.init(description: self.textViewDetailAddIndustry.text!, from: self.textFromDateAddIndustry.text!, organization: self.textCompanyAddIndustry.text!, post: self.textTitleAddIndustry.text!, to: self.textToDateAddIndustry.text!))
        }
        else{
            self.industryArr[index].post = self.textTitleAddIndustry.text!
            self.industryArr[index].from = self.textFromDateAddIndustry.text!
            self.industryArr[index].to = self.textToDateAddIndustry.text!
            self.industryArr[index].organization = self.textCompanyAddIndustry.text!
            self.industryArr[index].description = self.textViewDetailAddIndustry.text!
        }
        
        var parameters: Parameters = [:]
            for section in 0...industryArr.count  - 1 {
                let dictPoint = [
                    "post": (self.industryArr[section].post ),
                    "from": (self.industryArr[section].from ),
                    "description": (self.industryArr[section].description ),
                    "to": (self.industryArr[section].to ),
                    "company": (self.industryArr[section].organization )
                ]
                dictData.append(dictPoint as [String : AnyObject])
            }
            parameters = ["id": Model.sharedInstance.userID,
                          "industry_experience":toJSonString(data: dictData)]
        print(parameters)
        SKActivityIndicator.spinnerColor(UIColor.darkGray)
        SKActivityIndicator.show("Loading...")
        
        Webservice.apiPost(apiURl:"http://92agents.com/api/profile/editagentprofessionalprofile", parameters: parameters, headers: nil) { (response:NSDictionary?, error:NSError?) in
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
                    self.newIndustryView.isHidden = true
                    self.agentProfessionalAPI()
                }
            }else{
                Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: (response?.value(forKey: "error") as! String))
            }
        }
        
    }
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
    
    //MARK: UpdateExpreince
    @objc func buttonDeleteExp(sender : UIButton){
        self.realStateArr.remove(at: sender.tag)
        var type = String()
        var parameters: Parameters = [:]
        type = "employment"
        //            self.realStateArr[index].post = self.textProposalTitle.text!
        //            self.realStateArr[index].from = self.textUpdateFromDate.text!
        //            self.realStateArr[index].to = self.textUpdateToDate.text!
        //            self.realStateArr[index].organization = self.textUpdateCompany.text!
        //            self.realStateArr[index].description = self.textViewUpdateDetail.text!
        for section in 0...realStateArr.count  - 1 {
            let dictPoint = [
                "post": (self.realStateArr[section].post ),
                "from": (self.realStateArr[section].from ),
                "description": (self.realStateArr[section].description ),
                "to": (self.realStateArr[section].to ),
                "organization": (self.realStateArr[section].organization )
            ]
            //dictData.append(dictPoint as [String : AnyObject])
        }
       // parameters = ["id": Model.sharedInstance.userID,
                  //    "type": type,//
                 //     "employment":toJSonString(data: dictData)]
        
        print(parameters)
        SKActivityIndicator.spinnerColor(UIColor.darkGray)
        SKActivityIndicator.show("Loading...")
        
        Webservice.apiPost(apiURl:"http://92agents.com/api/profile/editFields", parameters: parameters, headers: nil) { (response:NSDictionary?, error:NSError?) in
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
                   // self.agentProfileAPI()
                }
            }else{
                Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: (response?.value(forKey: "error") as! String))
            }
        }
    }
   
    //MARK: UpdateEducation
    @objc func buttonDeleteEducation(sender : UIButton){
        self.industryArr.remove(at: sender.tag)
        var type = String()
        var parameters: Parameters = [:]
        type = "education"
        //            self.educationArr[index].post = self.textProposalTitle.text!
        //            self.educationArr[index].from = self.textUpdateFromDate.text!
        //            self.educationArr[index].to = self.textUpdateToDate.text!
        //            self.educationArr[index].organization = self.textUpdateCompany.text!
        //            self.educationArr[index].description = self.textViewUpdateDetail.text!
        for section in 0...industryArr.count  - 1 {
            let dictPoint = [
                "degree": (self.industryArr[section].post ),
                "from": (self.industryArr[section].from ),
                "description": (self.industryArr[section].description ),
                "to": (self.industryArr[section].to ),
                "school": (self.industryArr[section].organization )
            ]
            //dictData.append(dictPoint as [String : AnyObject])
        }
       // parameters = ["id": Model.sharedInstance.userID,
                //      "type": type,
                //      "education":toJSonString(data: dictData)]
        
        
        print(parameters)
        SKActivityIndicator.spinnerColor(UIColor.darkGray)
        SKActivityIndicator.show("Loading...")
        
        Webservice.apiPost(apiURl:"http://92agents.com/api/profile/editFields", parameters: parameters, headers: nil) { (response:NSDictionary?, error:NSError?) in
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
                  //  self.agentProfileAPI()
                }
            }else{
                Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: (response?.value(forKey: "error") as! String))
            }
        }
    }
 
    //MARK: Edit Sales History
    @IBAction func btnAddSalesHistory(_ sender: UIButton) {
        viewSalesHistory.isHidden = false
    }
    @objc func buttonEditSalesHistory(sender : UIButton){
        viewSalesHistory.isHidden = false
        textSellerRepresnted.text = self.salesHistoryArr[sender.tag].sellers_represented
        textBuyerRepresented.text = self.salesHistoryArr[sender.tag].buyers_represented
        textYearEditSalesHistory.text = self.salesHistoryArr[sender.tag].year
        textTotalDollerSales.text = self.salesHistoryArr[sender.tag].total_dollar_sales
        index = sender.tag
        
    }
     @IBAction func btnCloseSalesHistoryClick(_ sender: UIButton) {
         viewSalesHistory.isHidden = true
    }
    @IBAction func btnUpdateSalesHistoryClick(_ sender: UIButton) {
        
        if  select == "add"{
            
            self.salesHistoryArr.append(salesHistory.init(buyers_represented: textBuyerRepresented.text!, sellers_represented: textSellerRepresnted.text!, total_dollar_sales: textTotalDollerSales.text!, year:  textYearEditSalesHistory.text!))

        }
        else{
            self.salesHistoryArr[index].sellers_represented = textSellerRepresnted.text!
            self.salesHistoryArr[index].buyers_represented = textBuyerRepresented.text!
            self.salesHistoryArr[index].year = textYearEditSalesHistory.text!
            self.salesHistoryArr[index].total_dollar_sales = self.textTotalDollerSales.text!
        }
        
        var parameters: Parameters = [:]
        for section in 0...salesHistoryArr.count  - 1 {
            let dictPoint = [
                "year": (self.salesHistoryArr[section].year ),
                "sellers_represented": (self.salesHistoryArr[section].sellers_represented),
                "buyers_represented": (self.salesHistoryArr[section].buyers_represented ),
                "total_dollar_sales": (self.salesHistoryArr[section].total_dollar_sales )
            ]
            dictData.append(dictPoint as [String : AnyObject])
        }
        parameters = ["id": Model.sharedInstance.userID,
                      "sales_history":toJSonString(data: dictData)]
        print(parameters)
        SKActivityIndicator.spinnerColor(UIColor.darkGray)
        SKActivityIndicator.show("Loading...")
        
        Webservice.apiPost(apiURl:"http://92agents.com/api/profile/editagentprofessionalprofile", parameters: parameters, headers: nil) { (response:NSDictionary?, error:NSError?) in
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
                    self.newIndustryView.isHidden = true
                    self.agentProfessionalAPI()
                }
            }else{
                Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: (response?.value(forKey: "error") as! String))
            }
        }
        
    }
    //MARK: Edit Language
    @IBAction func btnAddLanguage(_ sender: UIButton) {
        self.addLanguageView.isHidden = false
    }
    @objc func buttonEditLangauge(sender : UIButton){
        addLanguageView.isHidden = false
        textAddLang.text = self.languageArr[sender.tag].language
        textAddSpeak.text = self.languageArr[sender.tag].speak
        textAddRead.text = self.languageArr[sender.tag].read
        textAddWrite.text = self.languageArr[sender.tag].write
        index = sender.tag

    }
    @IBAction func btnLanguageClose(_ sender: UIButton) {
        addLanguageView.isHidden = true
    }
    @IBAction func btnUpdateLanguageClick(_ sender: UIButton) {
        
        if  select == "language"{
            self.languageArr.append(languageProficiency.init(language:textAddLang.text!,speak:textAddSpeak.text!,read:textAddRead.text!,write:textAddWrite.text!))
        }
        else{
            self.languageArr[index].language = self.textAddLang.text!
            self.languageArr[index].speak = self.textAddSpeak.text!
            self.languageArr[index].read = self.textAddRead.text!
            self.languageArr[index].write = self.textAddWrite.text!
        }
        var parameters: Parameters = [:]
        for section in 0...industryArr.count  - 1 {
            let dictPoint = [
                "language": (self.industryArr[section].post ),
                "speak": (self.industryArr[section].from ),
                "read": (self.industryArr[section].description ),
                "write": (self.industryArr[section].to )
            ]
            dictData.append(dictPoint as [String : AnyObject])
        }
        parameters = ["id": Model.sharedInstance.userID,
                      "language":toJSonString(data: dictData)]
        print(parameters)
        SKActivityIndicator.spinnerColor(UIColor.darkGray)
        SKActivityIndicator.show("Loading...")
        
        Webservice.apiPost(apiURl:"http://92agents.com/api/profile/editagentprofessionalprofile", parameters: parameters, headers: nil) { (response:NSDictionary?, error:NSError?) in
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
                    self.newIndustryView.isHidden = true
                    self.agentProfessionalAPI()
                }
            }else{
                Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: (response?.value(forKey: "error") as! String))
            }
        }
        
    }
}
extension ProfessionalBioViewController: UITableViewDelegate {
    //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //        return 100
    //    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
}
