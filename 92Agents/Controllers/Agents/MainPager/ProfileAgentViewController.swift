//
//  ProfileAgentViewController.swift
//  92Agents
//
//  Created by Apple on 09/10/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import SKActivityIndicatorView
import Kingfisher
import Alamofire

//MARK: Class
class realState {
    var description : String
    var from: String
    var organization: String
    var post: String
    var to: String
    init(description: String,from: String,organization: String,post: String,to: String) {
        self.description = description
        self.from = from
         self.organization = organization
         self.post = post
         self.to = to
        
    }
}
class documents {
    var id : String
    var imageNmae: String
    init(id: String,imageNmae: String) {
        self.id = id
        self.imageNmae = imageNmae
    }
}
class proposals {
    var id : String
    var imageNmae: String
    var proposals_attachments: String
    init(id: String,imageNmae: String,proposals_attachments: String) {
        self.id = id
        self.imageNmae = imageNmae
         self.proposals_attachments = proposals_attachments
    }
}

class ProfileAgentViewController: UIViewController , UIPickerViewDelegate, UIPickerViewDataSource,UITextFieldDelegate{

    var pickerView : UIPickerView!
     var select = String()
    var stateArr = NSArray()
     var index = NSInteger()
    @IBOutlet var profileImg: UIImageView!
    @IBOutlet var textAboutme: UITextField!
    @IBOutlet var textFullNamel: UITextField!
    @IBOutlet var textEmail: UITextField!
    @IBOutlet var lblEmail: UILabel!
     @IBOutlet var lblFullName: UILabel!
     @IBOutlet var lblAddress: UILabel!
    @IBOutlet  var tagListView: TagListView!
    //document
    @IBOutlet var documentView: UITableView!
    @IBOutlet var documentViewHeight: NSLayoutConstraint!
    @IBOutlet var tableViewDocument: UITableView!
    @IBOutlet var tableViewDocumentHeight: NSLayoutConstraint!
    //proposals
    @IBOutlet var proposalView: UITableView!
    @IBOutlet var proposalViewHeight: NSLayoutConstraint!
    @IBOutlet var tableViewProposal: UITableView!
    @IBOutlet var tableViewProposalHeight: NSLayoutConstraint!
    //realState
    @IBOutlet var tableViewRealState: UITableView!
    @IBOutlet var tableViewRealStateHeight: NSLayoutConstraint!
    // Education
    @IBOutlet var viewEducation: UIView!
    @IBOutlet var viewEducationHeight: NSLayoutConstraint!
    @IBOutlet var tableViewEducation: UITableView!
    @IBOutlet var tableViewEducationHeight: NSLayoutConstraint!
    
     @IBOutlet var textAddressLine: UITextField!
    @IBOutlet var textAddressLine2: UITextField!
     @IBOutlet var textCity: UITextField!
     @IBOutlet var textState: UITextField!
     @IBOutlet var textPhoneCell: UITextField!
     @IBOutlet var textPhoneHome: UITextField!
     @IBOutlet var textPhoneWork: UITextField!
     @IBOutlet var textFax: UITextField!
     @IBOutlet var textZip: UITextField!
    var newDocumentArr = NSArray()
    var docArr = [documents]()
    var proposalArr = [proposals]()
    var realStateArr = [realState]()
    var educationArr = [realState]()
    // add new proposal
     @IBOutlet var proposlView: UIView!
    @IBOutlet var proposlViewHeight: NSLayoutConstraint!
    @IBOutlet var textProposalHeight: NSLayoutConstraint!
     @IBOutlet var textProposalTitle: UITextField!
    @IBOutlet var textUploadProposal: UITextField!
     @IBOutlet var lblProposal: UILabel!
     @IBOutlet var btnProposal: UIButton!
    @IBOutlet var btnFile: UIButton!
    @IBOutlet var btnHtml: UIButton!
    var value = String()
    // Update Education
    
    @IBOutlet var updateEduView: UIView!
    @IBOutlet var updateTitleLbl: UILabel!
    @IBOutlet var updateMainTitleLbl: UILabel!
    @IBOutlet var textUpdateTitle: UITextField!
    @IBOutlet var updateCompanyLbl: UILabel!
    @IBOutlet var textUpdateCompany: UITextField!
    @IBOutlet var updateFromDatelbl: UILabel!
    @IBOutlet var updateToDatelbl: UILabel!
    @IBOutlet var textUpdateFromDate: UITextField!
    @IBOutlet var textUpdateToDate: UITextField!
    @IBOutlet var textViewUpdateDetail: UITextView!
    var dictData: [Dictionary<String, AnyObject>] = []
     var selectStr = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.profileImg.layer.cornerRadius = self.profileImg.frame.size.height / 2
        self.profileImg.clipsToBounds = true
        agentProfileAPI()
        tableViewDocument.tableFooterView = UIView()
        tableViewProposal.tableFooterView = UIView()
        tableViewRealState.tableFooterView = UIView()
        tableViewEducation.tableFooterView = UIView()
        self.proposlView.isHidden = true
        textUploadProposal.layer.borderColor = UIColor.lightGray.cgColor
        updateEduView.isHidden = true
        textUploadProposal.layer.borderWidth = 1.0
        textViewUpdateDetail.layer.borderWidth = 1.0
        textViewUpdateDetail.layer.borderColor = UIColor.lightGray.cgColor
        
       
        let startDateString:String  = "08/01/1991"
        let endDateString:String = "04/01/2018"
        
        let dateFormtter = DateFormatter()
        dateFormtter.dateFormat = "MM/dd/yyyy"
        
        let startDate = dateFormtter.date(from: startDateString)
        let endDate = dateFormtter.date(from: endDateString)
        
        var monthsStringArray = [String]()
        var monthsIntArray = [Int]()
        var monthsWithyear = [String]()
        dateFormtter.dateFormat = "MM"
        
        if let startYear: Int = startDate?.year(), let endYear = endDate?.year() {
            
            if let startMonth: Int = startDate?.month(), let endMonth: Int = endDate?.month() {
                for i in startYear...endYear {
                    for j in (i == startYear ? startMonth : 1)...(i < endYear ? 12 : endMonth) {
                        let monthTitle = dateFormtter.monthSymbols[j - 1]
                        monthsStringArray.append(monthTitle)
                        monthsIntArray.append(j)
                        
                        let monthWithYear = "\(monthTitle) \(i)"
                        monthsWithyear.append(monthWithYear)
                    }
                }
            }
            
        }
        
        //print(monthsStringArray)
        //print(monthsIntArray)
        //print(monthsWithyear)
        
        
        
    }
    
    //MARK: bookmarkAPI Methods
    func agentProfileAPI(){
        self.docArr.removeAll()
        self.educationArr.removeAll()
        self.realStateArr.removeAll()
        self.proposalArr.removeAll()
        SKActivityIndicator.spinnerColor(UIColor.darkGray)
        SKActivityIndicator.show("Loading...")
        let parameters: Parameters = [
            "agents_user_id": Model.sharedInstance.userID,
            "agents_users_role_id":Model.sharedInstance.userRole
        ]
        print(parameters)
        Webservice.apiGet(serviceName:"http://92agents.com/api/profile/agent", parameters: nil, headers: nil) { (response:NSDictionary?, error:NSError?) in
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
                    self.profileImg.layer.cornerRadius = self.profileImg.frame.size.height / 2
                    self.profileImg.clipsToBounds = true
                     self.stateArr = (((response)?.value(forKey: "response") as! NSDictionary).value(forKey: "state_and_city") as! NSArray)
                    print(self.stateArr)
                    let url = URL(string: (((((response)?.value(forKey: "response") as! NSDictionary) ).value(forKey: "userdetails") as! NSDictionary).value(forKey: "photo") as! String))
                    self.profileImg.kf.indicatorType = .activity
                    self.profileImg.kf.setImage(with: url,placeholder: nil)
                    self.lblFullName.text = (((((response)?.value(forKey: "response") as! NSDictionary) ).value(forKey: "userdetails") as! NSDictionary).value(forKey: "name") as! String)
                    self.textFullNamel.text = (((((response)?.value(forKey: "response") as! NSDictionary) ).value(forKey: "userdetails") as! NSDictionary).value(forKey: "name") as! String)
                    self.textAboutme.text = (((((response)?.value(forKey: "response") as! NSDictionary) ).value(forKey: "userdetails") as! NSDictionary).value(forKey: "description") as! String)
                    self.textEmail.text = (((((response)?.value(forKey: "response") as! NSDictionary) ).value(forKey: "user") as! NSDictionary).value(forKey: "email") as! String)
                    if ((((response)?.value(forKey: "response") as! NSDictionary) ).value(forKey: "user") as! NSDictionary).value(forKey: "address") is NSNull{
                        
                    }
                    else{
                        self.textAddressLine.text = (((((response )?.value(forKey: "response") as! NSDictionary) ).value(forKey: "userdetails") as! NSDictionary).value(forKey: "address") as! String)
                    }
                    if ((((response)?.value(forKey: "response") as! NSDictionary) ).value(forKey: "userdetails") as! NSDictionary).value(forKey: "address2") is NSNull{
                        
                    }
                    else{
                        self.textAddressLine2.text = (((((response )?.value(forKey: "response") as! NSDictionary) ).value(forKey: "userdetails") as! NSDictionary).value(forKey: "address2") as! String)
                    }
                    if ((((response)?.value(forKey: "response") as! NSDictionary) ).value(forKey: "userdetails") as! NSDictionary).value(forKey: "state") is NSNull{
                        
                    }
                    else{
                        self.textState.text = ((((((response )?.value(forKey: "response") as! NSDictionary) ).value(forKey: "userdetails") as! NSDictionary).value(forKey: "state") as! NSDictionary).value(forKey: "state_name") as! String)
                    }
                    if ((((response)?.value(forKey: "response") as! NSDictionary) ).value(forKey: "userdetails") as! NSDictionary).value(forKey: "city") is NSNull{
                        
                    }
                    else{
                        self.textCity.text = (((((response )?.value(forKey: "response") as! NSDictionary).value(forKey: "userdetails") as! NSDictionary).value(forKey: "city") as! NSDictionary).value(forKey: "city_name") as! String)
                    }
                    if ((((response)?.value(forKey: "response") as! NSDictionary) ).value(forKey: "userdetails") as! NSDictionary).value(forKey: "phone") is NSNull{
                        
                    }
                    else{
                        self.textPhoneCell.text = ((((response )?.value(forKey: "response") as! NSDictionary ).value(forKey: "userdetails") as! NSDictionary).value(forKey: "phone") as! String)
                    }
                    if ((((response)?.value(forKey: "response") as! NSDictionary) ).value(forKey: "userdetails") as! NSDictionary).value(forKey: "phone_home") is NSNull{
                        
                    }
                    else{
                        self.textPhoneHome.text = ((((response )?.value(forKey: "response") as! NSDictionary ).value(forKey: "userdetails") as! NSDictionary).value(forKey: "phone_home") as! String)
                    }
                    if ((((response)?.value(forKey: "response") as! NSDictionary) ).value(forKey: "userdetails") as! NSDictionary).value(forKey: "phone_work") is NSNull{
                        
                    }
                    else{
                        self.textPhoneWork.text = ((((response )?.value(forKey: "response") as! NSDictionary ).value(forKey: "userdetails") as! NSDictionary).value(forKey: "phone_work") as! String)
                    }
                    if ((((response)?.value(forKey: "response") as! NSDictionary) ).value(forKey: "userdetails") as! NSDictionary).value(forKey: "fax_no") is NSNull{
                        
                    }
                    else{
                        self.textFax.text = ((((response )?.value(forKey: "response") as! NSDictionary ).value(forKey: "userdetails") as! NSDictionary).value(forKey: "fax_no") as! String)
                    
                    }
                    if ((((response)?.value(forKey: "response") as! NSDictionary) ).value(forKey: "userdetails") as! NSDictionary).value(forKey: "zip_code") is NSNull{
                        
                    }
                    else{
                        self.textZip.text = ((((response )?.value(forKey: "response") as! NSDictionary ).value(forKey: "userdetails") as! NSDictionary).value(forKey: "zip_code") as! String)
                    }
                    var add1 = String()
                    var add2 = String()
                    if ((((response)?.value(forKey: "response") as! NSDictionary) ).value(forKey: "user") as! NSDictionary).value(forKey: "address") is NSNull{
                        
                    }
                    else{
                        add1 = ((((response )?.value(forKey: "response") as! NSDictionary).value(forKey: "userdetails") as! NSDictionary).value(forKey: "address") as! String)
                    }
                    if ((((response)?.value(forKey: "response") as! NSDictionary) ).value(forKey: "userdetails") as! NSDictionary).value(forKey: "address2") is NSNull{
                        
                    }
                    else{
                        add2 = ((((response)?.value(forKey: "response") as! NSDictionary ).value(forKey: "userdetails") as! NSDictionary).value(forKey: "address2") as! String)
                    }
                    self.lblAddress.text = "\(add1) \(add2)"
                })
                //skill tag
                self.tagListView.removeAllTags()
                if ((((dict as NSDictionary).value(forKey: "response")as! NSDictionary).value(forKey: "userdetails") as! NSDictionary).value(forKey: "skills") as! NSArray).count > 0{
                    for section in 0...((((dict as NSDictionary).value(forKey: "response")as! NSDictionary).value(forKey: "userdetails") as! NSDictionary).value(forKey: "skills") as! NSArray).count  - 1 {
                        let str = ((((((dict as NSDictionary).value(forKey: "response") as! NSDictionary).value(forKey: "userdetails") as! NSDictionary).value(forKey: "skills") as! NSArray).object(at: section) as! NSDictionary).value(forKey: "skill") as! String)
                        self.tagListView.addTags([str])
                    }
                }
                //Proposals
                if(((dict as NSDictionary).value(forKey: "response") as! NSDictionary).value(forKey: "proposals") as! NSArray).count > 0{
                    for section in 0...(((dict as NSDictionary).value(forKey: "response") as! NSDictionary).value(forKey: "proposals") as! NSArray).count  - 1 {
                        self.proposalArr.append(proposals.init(id: (((((dict as NSDictionary).value(forKey: "response") as! NSDictionary).value(forKey: "proposals") as! NSArray).object(at: section) as! NSDictionary).value(forKey: "proposals_id") as! String), imageNmae: (((((dict as NSDictionary).value(forKey: "response") as! NSDictionary).value(forKey: "proposals") as! NSArray).object(at: section) as! NSDictionary).value(forKey: "proposals_title") as! String), proposals_attachments: (((((dict as NSDictionary).value(forKey: "response") as! NSDictionary).value(forKey: "proposals") as! NSArray).object(at: section) as! NSDictionary).value(forKey: "proposals_attachments") as! String)))
                    }
                }
                else{
                    //self.languageViewHeight.constant = 0
                    //self.tableViewLanguageHeight.constant = 0
                }
                //New Documents
                if(((dict as NSDictionary).value(forKey: "response") as! NSDictionary).value(forKey: "documents") as! NSArray).count > 0{
                    for section in 0...(((dict as NSDictionary).value(forKey: "response") as! NSDictionary).value(forKey: "documents") as! NSArray).count  - 1 {
                        self.docArr.append(documents.init(id: (((((dict as NSDictionary).value(forKey: "response") as! NSDictionary).value(forKey: "documents") as! NSArray).object(at: section) as! NSDictionary).value(forKey: "upload_share_id") as! String), imageNmae: (((((dict as NSDictionary).value(forKey: "response") as! NSDictionary).value(forKey: "documents") as! NSArray).object(at: section) as! NSDictionary).value(forKey: "attachments") as! String)))
                    }
                }
                else{
                    //self.languageViewHeight.constant = 0
                    //self.tableViewLanguageHeight.constant = 0
                }
                //realState
                if ((((dict as NSDictionary).value(forKey: "response")as! NSDictionary).value(forKey: "userdetails") as! NSDictionary).value(forKey: "employment") as! NSArray).count > 0{
                    for section in 0...((((dict as NSDictionary).value(forKey: "response")as! NSDictionary).value(forKey: "userdetails") as! NSDictionary).value(forKey: "employment") as! NSArray).count  - 1 {
                      self.realStateArr.append(realState.init(description: ((((((dict as NSDictionary).value(forKey: "response")as! NSDictionary).value(forKey: "userdetails") as! NSDictionary).value(forKey: "employment") as! NSArray).object(at: section) as! NSDictionary).value(forKey: "description") as! String), from: ((((((dict as NSDictionary).value(forKey: "response")as! NSDictionary).value(forKey: "userdetails") as! NSDictionary).value(forKey: "employment") as! NSArray).object(at: section) as! NSDictionary).value(forKey: "from") as! String), organization: ((((((dict as NSDictionary).value(forKey: "response")as! NSDictionary).value(forKey: "userdetails") as! NSDictionary).value(forKey: "employment") as! NSArray).object(at: section) as! NSDictionary).value(forKey: "organization") as! String), post: ((((((dict as NSDictionary).value(forKey: "response")as! NSDictionary).value(forKey: "userdetails") as! NSDictionary).value(forKey: "employment") as! NSArray).object(at: section) as! NSDictionary).value(forKey: "post") as! String), to: ((((((dict as NSDictionary).value(forKey: "response")as! NSDictionary).value(forKey: "userdetails") as! NSDictionary).value(forKey: "employment") as! NSArray).object(at: section) as! NSDictionary).value(forKey: "to") as! String)))
                    }
                }
                else{
                   
                }
                //education
                if ((((dict as NSDictionary).value(forKey: "response")as! NSDictionary).value(forKey: "userdetails") as! NSDictionary).value(forKey: "education") as! NSArray).count > 0{
                    for section in 0...((((dict as NSDictionary).value(forKey: "response")as! NSDictionary).value(forKey: "userdetails") as! NSDictionary).value(forKey: "education") as! NSArray).count  - 1 {
                        self.educationArr.append(realState.init(description: ((((((dict as NSDictionary).value(forKey: "response")as! NSDictionary).value(forKey: "userdetails") as! NSDictionary).value(forKey: "education") as! NSArray).object(at: section) as! NSDictionary).value(forKey: "description") as! String), from: ((((((dict as NSDictionary).value(forKey: "response")as! NSDictionary).value(forKey: "userdetails") as! NSDictionary).value(forKey: "education") as! NSArray).object(at: section) as! NSDictionary).value(forKey: "from") as! String), organization: ((((((dict as NSDictionary).value(forKey: "response")as! NSDictionary).value(forKey: "userdetails") as! NSDictionary).value(forKey: "education") as! NSArray).object(at: section) as! NSDictionary).value(forKey: "school") as! String), post: ((((((dict as NSDictionary).value(forKey: "response")as! NSDictionary).value(forKey: "userdetails") as! NSDictionary).value(forKey: "education") as! NSArray).object(at: section) as! NSDictionary).value(forKey: "degree") as! String), to: ((((((dict as NSDictionary).value(forKey: "response")as! NSDictionary).value(forKey: "userdetails") as! NSDictionary).value(forKey: "education") as! NSArray).object(at: section) as! NSDictionary).value(forKey: "to") as! String)))
                    }
                }
                else{
                    
                }
                
             DispatchQueue.main.async(execute: {
                let int: Int32 = Int32((self.docArr.count) * 45  )
                let cgfloat = CGFloat(int)
                let int1: Int32 = Int32((self.proposalArr.count) * 45  )
                let cgfloat1 = CGFloat(int1)
                let int2: Int32 = Int32((self.realStateArr.count) * 75  )
                let cgfloat2 = CGFloat(int2)
                let int3: Int32 = Int32((self.educationArr.count) * 75  )
                let cgfloat3 = CGFloat(int3)
                // document
                self.tableViewDocumentHeight.constant = cgfloat
                self.documentViewHeight.constant = cgfloat + 90
                //proposal
                self.tableViewProposalHeight.constant = cgfloat1
                self.proposalViewHeight.constant = cgfloat1 + 90
                //realstate
                self.tableViewRealStateHeight.constant = cgfloat2
                //education
                self.tableViewEducationHeight.constant = cgfloat3
                self.viewEducationHeight.constant = cgfloat3 + 50
                
                self.tableViewDocument.reloadData()
                self.tableViewProposal.reloadData()
                self.tableViewRealState.reloadData()
                self.tableViewEducation.reloadData()
                })
            }else{
                Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: (response?.value(forKey: "error") as! String))
            }
        }
    }
    
    //MARK: CalculateHeight Method
    func calculateHeight(inString:String) -> CGFloat {
        let messageString = inString
       // let attributes : [String : Any] = [NSAttributedStringKey.font.rawValue : UIFont.systemFont(ofSize: 15.0)]
        
        let attributedString : NSAttributedString = NSAttributedString(string: messageString, attributes: nil)
        
        let rect : CGRect = attributedString.boundingRect(with: CGSize(width: 222.0, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, context: nil)
        
        let requredSize:CGRect = rect
        return requredSize.height
    }
    //new proposal
    @IBAction func btnNewProposal(_ sender: UIButton) {
        self.proposlView.isHidden = false
    }
    @IBAction func btnProposalClose(_ sender: UIButton) {
         self.proposlView.isHidden = true
    }
    
    @IBAction func btnProposalSave(_ sender: UIButton) {
        AddNewProposalAPI()
    }
    @IBAction func btnUploadProposal(_ sender: UIButton) {
    }
    @IBAction func btnFileClick(_ sender: UIButton) {
        value = "proposal_file"
        self.proposlViewHeight.constant = 240
        self.textProposalHeight.constant = 30
         self.btnProposal.isHidden = false
         lblProposal.text  = "Upload Your Proposal"
        btnFile.setImage(UIImage.init(named: "selected"), for: .normal)
        btnHtml.setImage(UIImage.init(named: "notSelected"), for: .normal)
    }
    @IBAction func btnHtmlClick(_ sender: Any) {
         value = "proposals_html"
        btnFile.setImage(UIImage.init(named: "notSelected"), for: .normal)
        btnHtml.setImage(UIImage.init(named: "selected"), for: .normal)
        self.btnProposal.isHidden = true
        self.proposlViewHeight.constant = 300
        self.textProposalHeight.constant = 85
        lblProposal.text  = "Type Text"
    }
    //MARK: AddNewProposalAPI Method
    func AddNewProposalAPI(){
        SKActivityIndicator.spinnerColor(UIColor.darkGray)
        SKActivityIndicator.show("Loading...")
        var parameters: Parameters = [:]
        
        if value == "proposal_file"{
            parameters = [
                "type" : "1",
                "proposal_file": self.textUploadProposal.text!,
                "agents_user_id": Model.sharedInstance.userID,
                "agents_users_role_id":Model.sharedInstance.userRole,
                "proposals_title" : self.textProposalTitle.text!
            ]
        }
        else if value == "proposals_html"{
            parameters = [
               "type" : "2",
                "proposals_html": self.textUploadProposal.text!,
                "agents_user_id": Model.sharedInstance.userID,
                "agents_users_role_id":Model.sharedInstance.userRole,
                "proposals_title" : self.textProposalTitle.text!
            ]
        }
        
        print(parameters)
        Webservice.apiPost(apiURl:"http://92agents.com/api/proposals/store", parameters: parameters, headers: nil) { (response:NSDictionary?, error:NSError?) in
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
                   // self.profileAPI()
                }
            }else{
                Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: (response?.value(forKey: "error") as! String))
            }
        }
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
        if select == "state"{
            return self.stateArr.count
        }
        else if select == "city"{
            return (((self.stateArr ).object(at: self.index) as! NSDictionary).value(forKey: "state_and_city") as! NSArray).count
        }
        return 0
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if select == "state" {
            return ((self.stateArr ).object(at: row) as! NSDictionary).value(forKey: "state_name") as? String
        }
        else if select == "city" {
            return (((((self.stateArr ).object(at: self.index) as! NSDictionary).value(forKey: "state_and_city") as! NSArray).object(at: row) as! NSDictionary).value(forKey: "city_name") as! String)
        }
        return nil
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if select == "state" {
            self.index = row
            self.textState.text = ((self.stateArr ).object(at: row) as! NSDictionary).value(forKey: "state_name") as? String
        }
        else if select == "city" {
            self.textCity.text = (((((self.stateArr ).object(at: self.index) as! NSDictionary).value(forKey: "state_and_city") as! NSArray).object(at: row) as! NSDictionary).value(forKey: "city_name") as! String)
        }
    }
    //MARK:- TextFiled Delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == self.textState {
            self.pickUp(self.textState)
            select = "state"
        }
        else  if textField == self.textCity {
            self.pickUp(self.textCity)
            select = "city"
        }
    }
    //MARK:- Button
    @objc func doneClick() {
        if select == "state" {
            self.textState.resignFirstResponder()
        }
        else  if select == "city" {
            self.textCity.resignFirstResponder()
        }
    }
    @objc func cancelClick() {
        if select == "state" {
            self.textState.resignFirstResponder()
        }
        else  if select == "city" {
            self.textCity.resignFirstResponder()
        }
    }
    //update exp and education
    @IBAction func btnUpdateClose(_ sender: Any) {
      self.updateEduView.isHidden = true
    }
    @IBAction func btnUpdateClick(_ sender: UIButton) {
        var type = String()
         var parameters: Parameters = [:]
        if selectStr == "edu"{
            type = "education"
            self.educationArr[index].post = self.textProposalTitle.text!
            self.educationArr[index].from = self.textUpdateFromDate.text!
            self.educationArr[index].to = self.textUpdateToDate.text!
            self.educationArr[index].organization = self.textUpdateCompany.text!
            self.educationArr[index].description = self.textViewUpdateDetail.text!
            for section in 0...educationArr.count  - 1 { 
                let dictPoint = [
                    "degree": (self.educationArr[section].post ),
                    "from": (self.educationArr[section].from ),
                    "description": (self.educationArr[section].description ),
                    "to": (self.educationArr[section].to ),
                    "school": (self.educationArr[section].organization )
                ]
                dictData.append(dictPoint as [String : AnyObject])
            }
            parameters = ["id": Model.sharedInstance.userID,
                          "type": type,
                          "education":toJSonString(data: dictData)]
        }
        else{
             type = "employment"
            self.realStateArr[index].post = self.textProposalTitle.text!
            self.realStateArr[index].from = self.textUpdateFromDate.text!
            self.realStateArr[index].to = self.textUpdateToDate.text!
            self.realStateArr[index].organization = self.textUpdateCompany.text!
            self.realStateArr[index].description = self.textViewUpdateDetail.text!
            for section in 0...realStateArr.count  - 1 {
                let dictPoint = [
                    "post": (self.realStateArr[section].post ),
                    "from": (self.realStateArr[section].from ),
                    "description": (self.realStateArr[section].description ),
                    "to": (self.realStateArr[section].to ),
                    "organization": (self.realStateArr[section].organization )
                ]
                dictData.append(dictPoint as [String : AnyObject])
            }
            parameters = ["id": Model.sharedInstance.userID,
                          "type": type,
                          "employment":toJSonString(data: dictData)]
        }
        
        
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
                self.updateEduView.isHidden = true
                    self.agentProfileAPI()
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
}
extension ProfileAgentViewController: UITableViewDataSource {
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableViewProposal{
            return self.proposalArr.count

        }
        else if tableView == self.tableViewDocument{
            return self.docArr.count
            
        }
        else if tableView == self.tableViewRealState{
            return self.realStateArr.count
            
        }
        else if tableView == self.tableViewEducation{
            return self.educationArr.count
            
        }
       return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell1 = DocumentTableViewCell()
        if tableView == self.tableViewProposal{
            cell1  = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as! DocumentTableViewCell
            cell1.lblDocName.text = self.proposalArr[indexPath.row].imageNmae
            cell1.btnDelete.tag = indexPath.row
            cell1.btnDelete.addTarget(self,action:#selector(buttonNotesTapped(sender:)), for: .touchUpInside)
            cell1.btnViewProposal.addTarget(self,action:#selector(buttonViewProposal(sender:)), for: .touchUpInside)
        }
        else  if tableView == tableViewDocument  {
            let cell = tableViewDocument.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DocumentTableViewCell
            let file = self.docArr[indexPath.row].imageNmae
            let fileNameWithoutExtension = file.fileName()
            let fileExtension = file.fileExtension()
            cell.lblDocName.text = "\(fileNameWithoutExtension)\(".")\(fileExtension)"
            cell.btnDelete.tag = indexPath.row
            cell.btnDelete.addTarget(self,action:#selector(buttonDeleteDocument(sender:)), for: .touchUpInside)
         
            return cell
        }
        else if tableView == self.tableViewRealState{
            let cell = tableViewRealState.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as! AgentDetailTableViewCell
                cell.lblPostName.text = self.realStateArr[indexPath.row].post
                cell.lblDate.text = "\(self.realStateArr[indexPath.row].from)\("-") \(self.realStateArr[indexPath.row].to)"
                cell.lblOrgName.text = self.realStateArr[indexPath.row].organization
                cell.lblDetail.text = self.realStateArr[indexPath.row].description
                cell.btnDelete.tag = indexPath.row
                cell.btnEdit.tag = indexPath.row
                cell.btnDelete.addTarget(self,action:#selector(buttonDeleteExp(sender:)), for: .touchUpInside)
                cell.btnEdit.addTarget(self,action:#selector(buttonEditExp(sender:)), for: .touchUpInside)
            return cell
            }
        else  if tableView == tableViewEducation  {
            let cell : AgentDetailTableViewCell = tableViewEducation.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as! AgentDetailTableViewCell
            cell.lblPostName.text = self.educationArr[indexPath.row].post
            cell.lblDate.text = "\(self.educationArr[indexPath.row].from)\("-") \(self.educationArr[indexPath.row].to)"
            cell.lblOrgName.text = self.educationArr[indexPath.row].organization
            cell.lblDetail.text = self.educationArr[indexPath.row].description
            cell.btnDelete.tag = indexPath.row
            cell.btnEdit.tag = indexPath.row
            cell.btnDelete.addTarget(self,action:#selector(buttonDeleteEducation(sender:)), for: .touchUpInside)
            cell.btnEdit.addTarget(self,action:#selector(buttonEditEducation(sender:)), for: .touchUpInside)
            return cell
        }
        return cell1
    }
     @objc func buttonNotesTapped(sender : UIButton){
        deleteProposalAPI(proposal_id: self.proposalArr[sender.tag].id)
    }
    //MARK: Delete Doucment
    @objc func buttonDeleteDocument(sender : UIButton){
        deleteDocument(document_id: self.docArr[sender.tag].id)
    }

    @objc func buttonViewProposal(sender : UIButton){
        let signupVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SharedProposalViewController") as! SharedProposalViewController
        signupVC.urlString = self.proposalArr[sender.tag].proposals_attachments
        self.navigationController?.pushViewController(signupVC, animated: true)
    }
    @objc func buttonViewDoc(sender : UIButton){
        let signupVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SharedProposalViewController") as! SharedProposalViewController
        signupVC.urlString = self.proposalArr[sender.tag].proposals_attachments
        self.navigationController?.pushViewController(signupVC, animated: true)
    }
    //MARK: deleteProposal Method
    func deleteProposalAPI(proposal_id : String){
        SKActivityIndicator.spinnerColor(UIColor.darkGray)
        SKActivityIndicator.show("Loading...")
        let parameters: Parameters = ["proposal_id" : proposal_id]
        print(parameters)
        Webservice.apiPost(apiURl:"http://92agents.com/api/proposals/delete", parameters: parameters, headers: nil) { (response:NSDictionary?, error:NSError?) in
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
                    self.agentProfileAPI()
                }
            }else{
                Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: (response?.value(forKey: "error") as! String))
            }
        }
    }
    //MARK: deleteDocument Method
    func deleteDocument(document_id : String){
        SKActivityIndicator.spinnerColor(UIColor.darkGray)
        SKActivityIndicator.show("Loading...")
        let parameters: Parameters = ["document_id" : document_id]
        print(parameters)
        Webservice.apiPost(apiURl:"http://92agents.com/api/uploadandshare/delete", parameters: parameters, headers: nil) { (response:NSDictionary?, error:NSError?) in
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
                    self.agentProfileAPI()
                }
            }else{
                Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: (response?.value(forKey: "error") as! String))
            }
        }
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
                dictData.append(dictPoint as [String : AnyObject])
            }
            parameters = ["id": Model.sharedInstance.userID,
                          "type": type,
                          "employment":toJSonString(data: dictData)]
        
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
                    self.agentProfileAPI()
                }
            }else{
                Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: (response?.value(forKey: "error") as! String))
            }
        }
    }
    @objc func buttonEditExp(sender : UIButton){
        selectStr = "exp"
        updateEduView.isHidden = false
        self.textUpdateTitle.text = self.realStateArr[sender.tag].post
        self.textUpdateCompany.text = self.realStateArr[sender.tag].organization
        self.textUpdateFromDate.text = self.realStateArr[sender.tag].from
        self.textUpdateToDate.text = self.realStateArr[sender.tag].to
        self.textViewUpdateDetail.text = self.realStateArr[sender.tag].description
        self.updateTitleLbl.text = "Experience"
        self.updateMainTitleLbl.text = "Title"
        self.updateCompanyLbl.text = "Company"
    }
    //MARK: UpdateEducation
    @objc func buttonDeleteEducation(sender : UIButton){
        self.educationArr.remove(at: sender.tag)
        var type = String()
        var parameters: Parameters = [:]
            type = "education"
//            self.educationArr[index].post = self.textProposalTitle.text!
//            self.educationArr[index].from = self.textUpdateFromDate.text!
//            self.educationArr[index].to = self.textUpdateToDate.text!
//            self.educationArr[index].organization = self.textUpdateCompany.text!
//            self.educationArr[index].description = self.textViewUpdateDetail.text!
            for section in 0...educationArr.count  - 1 {
                let dictPoint = [
                    "degree": (self.educationArr[section].post ),
                    "from": (self.educationArr[section].from ),
                    "description": (self.educationArr[section].description ),
                    "to": (self.educationArr[section].to ),
                    "school": (self.educationArr[section].organization )
                ]
                dictData.append(dictPoint as [String : AnyObject])
            }
            parameters = ["id": Model.sharedInstance.userID,
                          "type": type,
                          "education":toJSonString(data: dictData)]
        
        
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
                    self.agentProfileAPI()
                }
            }else{
                Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: (response?.value(forKey: "error") as! String))
            }
        }
    }
    @objc func buttonEditEducation(sender : UIButton){
        selectStr = "edu"
        print(self.educationArr[sender.tag].post)
        updateEduView.isHidden = false
        self.textUpdateTitle.text = self.educationArr[sender.tag].post
        self.textUpdateCompany.text = self.educationArr[sender.tag].organization
        self.textUpdateFromDate.text = self.educationArr[sender.tag].from
        self.textUpdateToDate.text = self.educationArr[sender.tag].to
        self.textViewUpdateDetail.text = self.educationArr[sender.tag].description
        self.updateTitleLbl.text = "Education"
        self.updateMainTitleLbl.text = "Degree"
        self.updateCompanyLbl.text = "School/College"
        index = sender.tag
        
       
    }
}
extension ProfileAgentViewController: UITableViewDelegate {
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
extension String {
    
    func fileName() -> String {
        return NSURL(fileURLWithPath: self).deletingPathExtension?.lastPathComponent ?? ""
    }
    
    func fileExtension() -> String {
        return NSURL(fileURLWithPath: self).pathExtension ?? ""
    }
}
extension Date {
    
    func month() -> Int {
        let month = Calendar.current.component(.month, from: self)
        return month
    }
    
    func year() -> Int {
        let year = Calendar.current.component(.year, from: self)
        return year
    }
}
