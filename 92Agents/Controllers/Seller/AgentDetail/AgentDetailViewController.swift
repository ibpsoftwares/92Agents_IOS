//
//  AgentDetailViewController.swift
//  92Agents
//
//  Created by Apple on 11/07/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import Alamofire
import SKActivityIndicatorView

class AgentDetailViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    //MARK: IBoutlet and Variables
     @IBOutlet var tableView: UITableView!
     @IBOutlet var tableViewHeight: NSLayoutConstraint!
    @IBOutlet var tableViewEducation: UITableView!
    @IBOutlet var tableViewEducationHeight: NSLayoutConstraint!
    // Array
      var get_dest = NSArray()
    var educationArr = NSArray()
    var industryArr = NSArray()
    var realStateArr = NSArray()
    var languageArr = NSArray()
    var proposalArr = NSArray()
    var fileArr = NSArray()
     var quesArr = NSArray()
     var agentID = String()
     var agentName = String()
     var poatName = String()
     var postID = String()
      var selection = String()
   var applied_post = String()
     var applied_user_id = String()
     @IBOutlet var lblName: UILabel!
     @IBOutlet var lblExp: UILabel!
     @IBOutlet var lblPostName: UILabel!
     @IBOutlet var lblDate: UILabel!
      @IBOutlet var lblAddress: UILabel!
    @IBOutlet var lblDescription: UILabel!
     @IBOutlet var lblAddBookmark: UILabel!
    @IBOutlet var blurView: UIView!
    
    @IBOutlet var notesTextView: UITextView!
    @IBOutlet var lblNotesName: UILabel!
    @IBOutlet var notePostView: UIView!
    @IBOutlet  var tagListView: TagListView!
    @IBOutlet var postViewHeight: NSLayoutConstraint!
    @IBOutlet var postView: UIView!
     var bookmarkArr = [BookMark]()
    
    @IBOutlet var certificateView: UIView!
    @IBOutlet  var certificatetagListView: TagListView!
    @IBOutlet var certificateViewHeight: NSLayoutConstraint!
    @IBOutlet var franchiseView: UIView!
    @IBOutlet  var franchiseTagListView: TagListView!
    @IBOutlet var franchiseViewHeight: NSLayoutConstraint!
    @IBOutlet var specializationView: UIView!
    @IBOutlet  var specializationTagListView: TagListView!
    @IBOutlet var specializationViewHeight: NSLayoutConstraint!
    @IBOutlet var associationView: UIView!
    @IBOutlet var lblAssociation: UILabel!
    @IBOutlet var associationViewHeight: NSLayoutConstraint!
    @IBOutlet var communityView: UIView!
    @IBOutlet var lblCommunity: UILabel!
    @IBOutlet var communityViewHeight: NSLayoutConstraint!
    @IBOutlet var publicationView: UIView!
    @IBOutlet var lblPublication: UILabel!
    @IBOutlet var publicationViewHeight: NSLayoutConstraint!
    @IBOutlet var saleHistoryView: UIView!
    @IBOutlet var lblSaleHistory: UILabel!
    @IBOutlet var saleHistoryViewHeight: NSLayoutConstraint!
    @IBOutlet var languageView: UIView!
    @IBOutlet var languageViewHeight: NSLayoutConstraint!
    @IBOutlet var tableViewLanguage: UITableView!
    @IBOutlet var tableViewLanguageHeight: NSLayoutConstraint!
    @IBOutlet var nonRealStateExpView: UIView!
    @IBOutlet var nonRealStateExpViewHeight: NSLayoutConstraint!
    @IBOutlet var nonRealStateEduView: UIView!
    @IBOutlet var nonRealStateEduViewHeight: NSLayoutConstraint!
    @IBOutlet var industryView: UIView!
    @IBOutlet var industryViewHeight: NSLayoutConstraint!
    @IBOutlet var tableViewIndustry: UITableView!
    @IBOutlet var tableViewIndustryHeight: NSLayoutConstraint!
    @IBOutlet var assoLabel: UILabel!
    
    @IBOutlet var eduLabel: UILabel!
    @IBOutlet var expLabel: UILabel!
    @IBOutlet var indLabel: UILabel!
    @IBOutlet var saleLabel: UILabel!
    @IBOutlet var publicationLabel: UILabel!
    @IBOutlet var communityLabel: UILabel!
    @IBOutlet var realStateView: UIView!
    @IBOutlet var realStateViewHeight: NSLayoutConstraint!
    @IBOutlet var tableViewRealState: UITableView!
    @IBOutlet var tableViewRealStateHeight: NSLayoutConstraint!
    @IBOutlet var skillView: UIView!
    @IBOutlet var skillViewViewHeight: NSLayoutConstraint!
    @IBOutlet var shareView: UIView!
     @IBOutlet var viewAskQues: UIView!
     @IBOutlet var viewShareProp: UIView!
     @IBOutlet var viewShareFiles: UIView!
    @IBOutlet var sharedProposalView: UIView!
    // for collectionview
    @IBOutlet var collectionView: UICollectionView!
    let inset: CGFloat = 10
    let minimumLineSpacing: CGFloat = 10
    let minimumInteritemSpacing: CGFloat = 10
    let cellsPerRow = 5
    // for ask ques.
    @IBOutlet var viewAskedQues: UIView!
    @IBOutlet var lblAskedQues: UILabel!
    @IBOutlet var lblAskedQuesDate: UILabel!
    @IBOutlet var lblAskedQuesName: UILabel!
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let nib = UINib(nibName: "LanguageTableViewCell", bundle: nil)
        tableViewLanguage.register(nib, forCellReuseIdentifier: "cell")
        tableViewLanguage.tableFooterView = UIView()
       
          self.collectionView.contentInsetAdjustmentBehavior = .always
         self.collectionView.register(UINib(nibName: "SharedProposalCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "myCell")
    
         tableViewLanguage.tableFooterView = UIView()
        self.viewAskQues.layer.borderColor = UIColor.gray.cgColor
        self.viewAskQues.layer.borderWidth = 0.5
        self.viewAskQues.layer.cornerRadius = 5.0
        self.viewShareProp.layer.borderColor = UIColor.gray.cgColor
        self.viewShareProp.layer.borderWidth = 0.5
        self.viewShareProp.layer.cornerRadius = 5.0
        self.viewShareFiles.layer.borderColor = UIColor.gray.cgColor
        self.viewShareFiles.layer.borderWidth = 0.5
        self.viewShareFiles.layer.cornerRadius = 5.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        self.sharedProposalView.isHidden = true
        self.viewAskedQues.isHidden = true
        tableViewHeight.constant  = 0
        tableViewEducationHeight .constant  = 0
       
        self.notePostView.isHidden = true
        self.blurView.isHidden = true
        print(applied_post)
        print(applied_user_id)
        print(postID)
        lblPostName.isHidden = true
         agentDetailAPI()
        if applied_post == "1" && applied_user_id == agentID{
            lblPostName.isHidden = false
            lblPostName.text = "Selected Agent This Post \(poatName)"
            postView.isHidden = true
            postViewHeight.constant = 0
        }
        else if applied_post == "1" && applied_user_id == agentID{
            postView.isHidden = true
            postViewHeight.constant = 0
        }
        else if applied_post == "2" && applied_user_id == agentID{
            postView.isHidden = false
            postViewHeight.constant = 40
        }
    }
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    //MARK: proposal Buttom
    @IBAction func btnClose(_ sender: UIButton) {
        self.sharedProposalView.isHidden = true
    }
    @IBAction func btnSharedProposal(_ sender: UIButton) {
         self.sharedProposalView.isHidden = false
        selection = "proposal"
        self.collectionView.reloadData()
    }
    //MARK: proposal Buttom
    @IBAction func btnSharedFiles(_ sender: UIButton) {
        self.sharedProposalView.isHidden = false
        selection = "Files"
         self.collectionView.reloadData()
    }
    // MARK: - FindAgentAPI Method
    func agentDetailAPI(){
        self.bookmarkArr.removeAll()
        SKActivityIndicator.spinnerColor(UIColor.darkGray)
        SKActivityIndicator.show("Loading...")
        let parameters: Parameters = [
            "agent_id": agentID,
            "post_id": postID
        ]
        print(parameters)
        
        Webservice.apiPost1(apiURl:  "http://92agents.com/api/Agentsdetails", parameters: parameters, headers: nil) { (response:[String : Any], error:NSError?) in
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
                if ((dict as NSDictionary).value(forKey: "status") as? String == "100"){
                    
                    DispatchQueue.main.async(execute: {
                        self.lblName.text = (((((dict as NSDictionary).value(forKey: "response") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "agents") as! NSDictionary).value(forKey: "name") as! String)
                        self.lblNotesName.text = (((((dict as NSDictionary).value(forKey: "response") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "agents") as! NSDictionary).value(forKey: "name") as! String)
                         self.lblAskedQuesName.text = "\((((((dict as NSDictionary).value(forKey: "response") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "agents") as! NSDictionary).value(forKey: "name") as! String)) Asked Question For Your Post"
                        
                        if ((((dict as NSDictionary).value(forKey: "response") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "agents") as! NSDictionary).value(forKey: "years_of_expreience") is NSNull{
                           self.lblExp.text = "Experience:"
                        }else{
                           
                            self.lblExp.text = "Experience: \((((((dict as NSDictionary).value(forKey: "response") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "agents") as! NSDictionary).value(forKey: "years_of_expreience") as! String))"
                        }
                        
                        self.lblDate.text = "Posted: \((((((dict as NSDictionary).value(forKey: "response") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "agents") as! NSDictionary).value(forKey: "created_at") as! String))"
                        
                        self.lblAddress.text = "\((((((dict as NSDictionary).value(forKey: "response") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "agents") as! NSDictionary).value(forKey: "address") as! String)) \((((((dict as NSDictionary).value(forKey: "response") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "agents") as! NSDictionary).value(forKey: "city_name") as! String))  \((((((dict as NSDictionary).value(forKey: "response") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "agents") as! NSDictionary).value(forKey: "state_name") as! String))"
                        
                        self.lblDescription.text = "\((((((dict as NSDictionary).value(forKey: "response") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "agents") as! NSDictionary).value(forKey: "description") as! String))"
                        
                        //skill tag
                          self.tagListView.removeAllTags()
                        if (((((dict as NSDictionary).value(forKey: "response") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "agents") as! NSDictionary).value(forKey: "skills") as! NSArray).count > 0{
                            for section in 0...(((((dict as NSDictionary).value(forKey: "response") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "agents") as! NSDictionary).value(forKey: "skills") as! NSArray).count  - 1 {
                                let str = (((((((dict as NSDictionary).value(forKey: "response") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "agents") as! NSDictionary).value(forKey: "skills") as! NSArray).object(at: section) as! NSDictionary).value(forKey: "skill") as! String)
                                self.tagListView.addTags([str])
                                //self.skillViewViewHeight.constant = 49
                            }
                        }
                        else{
                            //self.skillViewViewHeight.constant = 0
                        }
                         //certifications tag
                        self.certificatetagListView.removeAllTags()

                        if (((((dict as NSDictionary).value(forKey: "response") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "agents") as! NSDictionary).value(forKey: "certifications") as! NSArray).count > 0{

                            for section in 0...(((((dict as NSDictionary).value(forKey: "response") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "agents") as! NSDictionary).value(forKey: "certifications") as! NSArray).count  - 1 {
                                let str = (((((((dict as NSDictionary).value(forKey: "response") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "agents") as! NSDictionary).value(forKey: "certifications") as! NSArray).object(at: section) as! NSDictionary).value(forKey: "certifications_description") as! String)
                               // self.certificateViewHeight.constant = 49
                                self.certificatetagListView.addTags([str])
                            }
                        }
                        else{
                            //self.certificateViewHeight.constant = 0
                        }
                         //franchise tag
                         self.franchiseTagListView.removeAllTags()
                        if (((((dict as NSDictionary).value(forKey: "response") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "agents") as! NSDictionary).value(forKey: "franchise") as! NSArray).count > 0{

                            for section in 0...(((((dict as NSDictionary).value(forKey: "response") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "agents") as! NSDictionary).value(forKey: "franchise") as! NSArray).count  - 1 {
                                let str = (((((((dict as NSDictionary).value(forKey: "response") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "agents") as! NSDictionary).value(forKey: "franchise") as! NSArray).object(at: section) as! NSDictionary).value(forKey: "franchise_name") as! String)
                                self.franchiseTagListView.addTags([str])
                                self.franchiseViewHeight.constant = 49
                            }
                        }
                        else{
                            self.franchiseViewHeight.constant = 0
                        }
                        //specialization tag
                         self.specializationTagListView.removeAllTags()
                        if ((((((dict as NSDictionary).value(forKey: "response") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "agents") as! NSDictionary).value(forKey: "specialization")) as! NSArray).count > 0{

                            for section in 0...(((((dict as NSDictionary).value(forKey: "response") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "agents") as! NSDictionary).value(forKey: "specialization") as! NSArray).count  - 1 {
                                let str = (((((((dict as NSDictionary).value(forKey: "response") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "agents") as! NSDictionary).value(forKey: "specialization") as! NSArray).object(at: section) as! NSDictionary).value(forKey: "skill") as! String)
                                self.specializationTagListView.addTags([str])
                                self.specializationViewHeight.constant = 49
                            }
                        }
                        else{
                            self.specializationViewHeight.constant = 0
                        }
                        
                        //associations
                        if (((((dict as NSDictionary).value(forKey: "response") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "agents") as! NSDictionary).value(forKey: "associations_awards"))  is NSNull{
                            self.associationViewHeight.constant = 0
                            
                        }
                            else{

                            self.lblAssociation.text = (((((dict as NSDictionary).value(forKey: "response") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "agents") as! NSDictionary).value(forKey: "associations_awards") as! String)
                            self.associationViewHeight.constant = 49
                        }
                        //community
                        if (((((dict as NSDictionary).value(forKey: "response") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "agents") as! NSDictionary).value(forKey: "community_involvement"))  is NSNull{
                            self.communityViewHeight.constant = -5
                            self.communityLabel.isHidden = true
                        }
                        else{

                            self.lblCommunity.text = (((((dict as NSDictionary).value(forKey: "response") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "agents") as! NSDictionary).value(forKey: "community_involvement") as! String)
                             self.communityViewHeight.constant = 49
                        }
                        //publications
                        if (((((dict as NSDictionary).value(forKey: "response") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "agents") as! NSDictionary).value(forKey: "publications"))  is NSNull{
                            self.publicationViewHeight.constant = -5
                            self.publicationLabel.isHidden = true
                        }
                        else{

                            self.lblPublication.text = (((((dict as NSDictionary).value(forKey: "response") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "agents") as! NSDictionary).value(forKey: "publications") as! String)
                            self.publicationViewHeight.constant = 49
                        }
                         //sales_history
                        if (((((dict as NSDictionary).value(forKey: "response") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "agents") as! NSDictionary).value(forKey: "sales_history") as! NSArray).count > 0{

                            let date = Date()
                            let calendar = Calendar.current
                            let currYear = calendar.component(.year, from: date)
                            print(currYear)
                            let year = (((((((dict as NSDictionary).value(forKey: "response") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "agents") as! NSDictionary).value(forKey: "sales_history") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "year") as! String)
                            let yr = currYear - Int(year)!
                            self.lblSaleHistory.text = "Over All Total For\(String(yr))Years Sales History $\((((((((dict as NSDictionary).value(forKey: "response") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "agents") as! NSDictionary).value(forKey: "sales_history") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "total_dollar_sales") as! String))"
                             self.saleHistoryViewHeight.constant = 49
                        }
                        else{
                            self.saleHistoryViewHeight.constant = -5
                            self.saleLabel.isHidden = true
                        }
                        //employment
                        if (((((dict as NSDictionary).value(forKey: "response") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "agents") as! NSDictionary).value(forKey: "employment") as! NSArray).count > 0{
                              self.get_dest = (((((dict as NSDictionary).value(forKey: "response") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "agents") as! NSDictionary).value(forKey: "employment") as! NSArray)
                        }
                        else{
                            self.tableViewHeight.constant = 0
                            self.nonRealStateExpViewHeight.constant = 0
                            self.expLabel.isHidden = true
                        }
                       
                        //education
                        if (((((dict as NSDictionary).value(forKey: "response") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "agents") as! NSDictionary).value(forKey: "education") as! NSArray).count > 0{
                             self.educationArr = (((((dict as NSDictionary).value(forKey: "response") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "agents") as! NSDictionary).value(forKey: "education") as! NSArray)
                        }
                        else{
                            self.tableViewEducationHeight.constant = 0
                            self.nonRealStateEduViewHeight.constant = 0
                            self.eduLabel.isHidden = true
                        }
                        //industry
                        if (((((dict as NSDictionary).value(forKey: "response") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "agents") as! NSDictionary).value(forKey: "industry_experience") as! NSArray).count > 0{
                            self.industryArr = (((((dict as NSDictionary).value(forKey: "response") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "agents") as! NSDictionary).value(forKey: "industry_experience") as! NSArray)
                        }
                        else{
                            self.tableViewIndustryHeight.constant = 0
                            self.industryViewHeight.constant = 0
                            self.indLabel.isHidden = true
                        }
                        //realState
                        if (((((dict as NSDictionary).value(forKey: "response") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "agents") as! NSDictionary).value(forKey: "real_estate_education") as! NSArray).count > 0{
                            self.realStateArr = (((((dict as NSDictionary).value(forKey: "response") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "agents") as! NSDictionary).value(forKey: "real_estate_education") as! NSArray)
                        }
                        else{
                            self.realStateViewHeight.constant = 0
                        }
                        //language
                        if (((((dict as NSDictionary).value(forKey: "response") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "agents") as! NSDictionary).value(forKey: "real_estate_education") as! NSArray).count > 0{
                            self.languageArr = (((((dict as NSDictionary).value(forKey: "response") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "agents") as! NSDictionary).value(forKey: "language_proficiency") as! NSArray)
                        }
                        else{
                            self.languageViewHeight.constant = 0
                            self.tableViewLanguageHeight.constant = 0
                        }
                        var cgfloat6 = CGFloat()
                        if self.languageArr.count > 0{
                            for section in 0...(self.languageArr.count) - 1 {
                                let height = self.calculateHeight(inString:  (((self.languageArr as NSArray).object(at: section) as! NSDictionary).value(forKey: "language") as! String))
                                cgfloat6 = cgfloat6 + height + 1
                            }
                        }
                        self.languageViewHeight.constant = cgfloat6
                        self.tableViewLanguageHeight.constant = cgfloat6
                        // for proposal
                        if (((((dict as NSDictionary).value(forKey: "response") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "proposal") as! NSDictionary).value(forKey: "result") as! NSArray).count > 0{
                            self.proposalArr = (((((dict as NSDictionary).value(forKey: "response") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "proposal") as! NSDictionary).value(forKey: "result") as! NSArray)
                        }
                        //for file
                        if ((((dict as NSDictionary).value(forKey: "response") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "files") as! NSArray).count > 0{
                            self.fileArr = ((((dict as NSDictionary).value(forKey: "response") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "files") as! NSArray)
                        }
                        // for AskedQues.
                        if ((((dict as NSDictionary).value(forKey: "response") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "questions") as! NSArray).count > 0{
                            self.quesArr = ((((dict as NSDictionary).value(forKey: "response") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "questions") as! NSArray)
                           self.lblAskedQues.text = ((((((dict as NSDictionary).value(forKey: "response") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "questions") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "question") as! String)
                            self.lblAskedQuesDate.text = "Posted: \(((((((dict as NSDictionary).value(forKey: "response") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "questions") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "created_at") as! String))"
                        }
                        var cgfloat1 = CGFloat()
                        if self.get_dest.count > 0{

                            for section in 0...(self.get_dest.count) - 1 {

                                let height = self.calculateHeight(inString:  (((self.get_dest as NSArray).object(at: section) as! NSDictionary).value(forKey: "description") as! String))
                                cgfloat1 = cgfloat1 + height + 10
                            }
                        }
                        print(cgfloat1)
                        self.tableViewHeight.constant = cgfloat1
                        var cgfloat2 = CGFloat()
                        if self.educationArr.count > 0{
                            for section in 0...(self.educationArr.count) - 1 {
                                let height = self.calculateHeight(inString:  (((self.educationArr as NSArray).object(at: section) as! NSDictionary).value(forKey: "description") as! String))
                                cgfloat2 = cgfloat2 + height + 10
                            }
                        }
                        print(cgfloat2)
                        self.tableViewEducationHeight.constant = cgfloat2
                        var cgfloat3 = CGFloat()
                        if self.industryArr.count > 0{
                            for section in 0...(self.industryArr.count) - 1 {
                                let height = self.calculateHeight(inString:  (((self.industryArr as NSArray).object(at: section) as! NSDictionary).value(forKey: "description") as! String))
                                //  print(height)
                                cgfloat3 = cgfloat3 + height + 10

                            }
                        }
                         self.tableViewIndustryHeight.constant = cgfloat3

                        var cgfloat4 = CGFloat()
                        if self.realStateArr.count > 0{
                            for section in 0...(self.industryArr.count) - 1 {
                                let height = self.calculateHeight(inString:  (((self.realStateArr as NSArray).object(at: section) as! NSDictionary).value(forKey: "description") as! String))
                                //  print(height)
                                cgfloat4 = cgfloat4 + height + 10
                            }
                        }
                         self.tableViewRealStateHeight.constant = cgfloat4

                        var cgfloat5 = CGFloat()
                        if self.languageArr.count > 0{
                            let int: Int32 = Int32((self.languageArr.count) * 17 - 10 )
                            cgfloat5 = CGFloat(int)
                        }
                        self.tableViewLanguage.layer.borderWidth = 0.5
                        self.tableViewLanguage.layer.borderColor = UIColor.lightGray.cgColor
                        self.languageView.layer.borderWidth =  0.5
                         self.languageView.layer.borderColor =  UIColor.lightGray.cgColor
                        
                       // self.tableViewLanguageHeight.constant = cgfloat5
                        self.tableViewEducation.reloadData()
                        self.tableView.reloadData()
                         self.tableViewLanguage.reloadData()
                         self.tableViewIndustry.reloadData()
                         self.tableViewRealState.reloadData()
                    })
                    
                    if ((((dict as NSDictionary).value(forKey: "response") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "bookmark") as! NSArray).count > 0{
                        self.lblAddBookmark.text = "BookMarked"
                        for section in 0...((((dict as NSDictionary).value(forKey: "response") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "bookmark") as! NSArray).count  - 1 {
                            self.bookmarkArr.append(BookMark.init(id: (((((dict as NSDictionary).value(forKey: "response") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "bookmark") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "bookmark_id") as! String, postText: "", bookmarkText: "", date: ""))
                        }
                    }
                    else{
                        self.lblAddBookmark.text = "BookMark"
                    }
                }else{
                    //Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: (response?.value(forKey: "error") as! String))
                }
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
    
    @IBAction func btnAddBookmark(_ sender: UIButton) {
        
        if self.lblAddBookmark.text == "BookMarked" {
            unBookMarkAPI()
        }
        else{
            
            addBookMarkAPI()
        }
        
    }
    // MARK: - addBookMarkAPI Method
    func addBookMarkAPI(){
        self.bookmarkArr.removeAll()
        SKActivityIndicator.spinnerColor(UIColor.darkGray)
        SKActivityIndicator.show("Loading...")
        print(agentID)
        print(postID)
        let parameters: Parameters = [
            "bookmark_type":"2",
            "bookmark_item_id":agentID,
            "receiver_id":agentID,
            "receiver_role":"4",
            "sender_id":Model.sharedInstance.userID,
            "sender_role":Model.sharedInstance.userRole,
            "bookmark_item_parent_id":postID
        ]
        
        print(parameters)
        
        Webservice.apiPost1(apiURl:  "http://92agents.com/api/Bookmark", parameters: parameters, headers: nil) { (response:[String : Any], error:NSError?) in
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
                if ((dict as NSDictionary).value(forKey: "status") as? String == "100"){
                self.lblAddBookmark.text = "BookMarked"
                    var catID = String()
                    catID = String((dict as NSDictionary).value(forKey: "bookmark_id") as! NSInteger)
                    print("\(catID)")
                    self.bookmarkArr.append(BookMark.init(id: "\(catID)", postText: "", bookmarkText: "", date: ""))
                   // Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: ((dict as NSDictionary).value(forKey: "response") as! String))
                    
                }else{
                    Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: ((dict as NSDictionary).value(forKey: "error") as! String))
                }
            }
        }
        
    }
    // MARK: - unBookMarkAPI Method
    func unBookMarkAPI(){
        SKActivityIndicator.spinnerColor(UIColor.darkGray)
        SKActivityIndicator.show("Loading...")
        print(agentID)
        print(postID)
        let parameters: Parameters = [
            "bookmark_id":self.bookmarkArr[0].id
        ]
        print(parameters)
        
        Webservice.apiPost1(apiURl:  "http://92agents.com/api/deleteBookmark", parameters: parameters, headers: nil) { (response:[String : Any], error:NSError?) in
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
                if ((dict as NSDictionary).value(forKey: "status") as? String == "100"){
                    self.lblAddBookmark.text = "BookMark"
                   // Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: ((dict as NSDictionary).value(forKey: "response") as! String))
                    
                }else{
                    //Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: ((dict as NSDictionary).value(forKey: "error") as! String))
                }
            }
        }
        
    }
    
    @IBAction func btnSelectJob(_ sender: UIButton) {
       selectJobAPI()
    }
    // MARK: - selectJobAPI Method
    func selectJobAPI(){
        SKActivityIndicator.spinnerColor(UIColor.darkGray)
        SKActivityIndicator.show("Loading...")
        print(agentID)
        print(postID)
        let parameters: Parameters = [
            "agent_id": agentID,
            "post_id": postID
        ]
        print(parameters)
        
        Webservice.apiPost1(apiURl:  "http://92agents.com/api/appliedagents", parameters: parameters, headers: nil) { (response:[String : Any], error:NSError?) in
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
                if ((dict as NSDictionary).value(forKey: "status") as? String == "100"){
                   
                    self.applied_user_id = ((dict as NSDictionary).value(forKey: "applied_user_id") as? String)!
                    self.applied_post = ((dict as NSDictionary).value(forKey: "applied_post") as? String)!
                    if self.applied_post == "1" && self.applied_user_id == self.agentID{
                        self.lblPostName.isHidden = false
                        self.lblPostName.text = "Selected Agent This Post \(self.poatName)"
                        self.postView.isHidden = true
                        self.postViewHeight.constant = 0
                    }
                    else if self.applied_post == "1" && self.applied_user_id == self.agentID{
                        self.postView.isHidden = true
                        self.postViewHeight.constant = 0
                    }
                    else if self.applied_post == "2" && self.applied_user_id == self.agentID{
                        self.postView.isHidden = false
                        self.postViewHeight.constant = 40
                    }
                }else{
                    //Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: ((dict as NSDictionary).value(forKey: "error") as! String))
                }
            }
        }
        
    }
    @IBAction func btnNotesClose(_ sender: UIButton) {
        self.notePostView.isHidden = true
        self.blurView.isHidden = true
        self.tableView.isHidden = false
        self.tagListView.isHidden = false
    }
    
    @IBAction func btnSave(_ sender: UIButton) {
        self.notePostView.isHidden = true
        self.blurView.isHidden = true
        self.tableView.isHidden = false
        self.tagListView.isHidden = false
         addNotesAPI()
    }
    @IBAction func btnNotes(_ sender: UIButton) {
        self.tableView.isHidden = true
        self.tagListView.isHidden = true
        self.blurView.isHidden = false
        self.notePostView.isHidden = false
        
    }
    // MARK: - addNotesAPI Method
    func addNotesAPI(){
        SKActivityIndicator.spinnerColor(UIColor.darkGray)
        SKActivityIndicator.show("Loading...")
        print(agentID)
        print(postID)
        let parameters: Parameters = [
            "notes_type":"5",
            "notes":self.notesTextView.text!,
            "notes_item_id":Model.sharedInstance.userID,
            "notes_item_parent_id":postID,
            "receiver_id":agentID,
            "receiver_role":"4",
            "sender_id":Model.sharedInstance.userID,
            "sender_role":Model.sharedInstance.userRole,
        ]
        
        print(parameters)
        
        Webservice.apiPost1(apiURl:  "http://92agents.com/api/addNotes", parameters: parameters, headers: nil) { (response:[String : Any], error:NSError?) in
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
                if ((dict as NSDictionary).value(forKey: "status") as? String == "100"){
                  //  self.lblAddBookmark.text = "BookMarked"
                    //Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: ((dict as NSDictionary).value(forKey: "response") as! String))
                    
                }else{
                   // Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: ((dict as NSDictionary).value(forKey: "error") as! String))
                }
            }
        }
    }
    //MARK: CollectionView Delegate and Data Source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if selection == "proposal" {
            return self.proposalArr.count
        }
        else if selection == "Files"{
            return self.fileArr.count
        }
        return 0
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath as IndexPath) as! SharedProposalCollectionViewCell
        
        if selection == "proposal" {
            if (self.proposalArr as NSArray).count > 0{
                cell.lblPostTitle.text =  (((self.proposalArr as NSArray).object(at: indexPath.row) as! NSDictionary).value(forKey: "proposals_title") as! String)
            }
        }
        else if selection == "Files"{
            cell.lblPostTitle.text =  (((self.fileArr as NSArray).object(at: indexPath.row) as! NSDictionary).value(forKey: "attachments") as! String)
        }
        cell.btnBookmark.tag = indexPath.row
        cell.btnSearch.tag = indexPath.row
        cell.btnNotes.tag = indexPath.row
        cell.btnNotes.addTarget(self,action:#selector(buttonNotesTapped(sender:)), for: .touchUpInside)
        cell.btnSearch.addTarget(self,action:#selector(buttonSearchTapped(sender:)), for: .touchUpInside)
        cell.btnBookmark.addTarget(self,action:#selector(buttonBookmarkTapped(sender:)), for: .touchUpInside)
        return cell
    }
    
    @IBAction func btnRegister(_ sender: UIButton) {
        
    }
    @objc func buttonNotesTapped(sender : UIButton){
       
    }
    @objc func buttonSearchTapped(sender : UIButton){
        let signupVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SharedProposalViewController") as! SharedProposalViewController
        
        if selection == "proposal" {
          signupVC.urlString = (((self.proposalArr as NSArray).object(at: sender.tag) as! NSDictionary).value(forKey: "proposals_attachments") as! String)
        }
        else if selection == "Files"{
             signupVC.urlString = (((self.fileArr as NSArray).object(at: sender.tag) as! NSDictionary).value(forKey: "attachments") as! String)
        }
        self.navigationController?.pushViewController(signupVC, animated: true)
    }
    @objc func buttonBookmarkTapped(sender : UIButton){
        
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return minimumLineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return minimumInteritemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //let marginsAndInsets = inset * 2 + collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right + minimumInteritemSpacing * CGFloat(cellsPerRow - 1)
        let itemWidth = (collectionView.bounds.size.width / 2 - 20)
        return CGSize(width: itemWidth, height: 200)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    //MARK: for askedQuestion Button Action
    @IBAction func btnAskedQuestion(_ sender: UIButton) {
        if self.quesArr.count > 0{
             self.viewAskedQues.isHidden = false
        }
    }
    @IBAction func btnAskedQues(_ sender: UIButton) {
        self.viewAskedQues.isHidden = true
    }
    
    @IBAction func btnAskedQuesSend(_ sender: UIButton) {
    }
    
    @IBAction func btnAskedQuesNotes(_ sender: UIButton) {
    }
}
extension AgentDetailViewController: UITableViewDataSource {
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView{
            if (self.get_dest ).count > 0{
                return  self.get_dest.count
            }
            else{
                return 0
            }
        }
        else  if tableView == tableViewEducation  {
            if (self.educationArr ).count > 0{
                return  self.educationArr.count
            }
            else{
                return 0
            }
        }
        else  if tableView == tableViewIndustry  {
            if (self.industryArr ).count > 0{
                return  self.industryArr.count
            }
            else{
                return 0
            }
        }
        else  if tableView == tableViewRealState  {
            if (self.realStateArr ).count > 0{
                return  self.realStateArr.count
            }
            else{
                return 0
            }
        }
        else  if tableView == tableViewLanguage  {
            if (self.languageArr ).count > 0{
                return  self.languageArr.count
            }
            else{
                return 0
            }
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell1 = AgentDetailTableViewCell()
        if tableView == self.tableView{
            cell1  = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as! AgentDetailTableViewCell
        if self.get_dest .count > 0{
            cell1.lblPostName.text = (((self.get_dest as NSArray).object(at: indexPath.row) as! NSDictionary).value(forKey: "post") as! String)
            cell1.lblDate.text = "\((((self.get_dest as NSArray).object(at: indexPath.row) as! NSDictionary).value(forKey: "from") as! String))\("-") \((((self.get_dest as NSArray).object(at:indexPath.row) as! NSDictionary).value(forKey: "to") as! String))"
            cell1.lblOrgName.text = (((self.get_dest as NSArray).object(at: indexPath.row) as! NSDictionary).value(forKey: "organization") as! String)
            cell1.lblDetail.text = (((self.get_dest as NSArray).object(at: indexPath.row) as! NSDictionary).value(forKey: "description") as! String)
        }
    }
        else  if tableView == tableViewEducation  {
             let cell : AgentDetailTableViewCell = tableViewEducation.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as! AgentDetailTableViewCell
            cell.lblPostName.text = (((self.educationArr as NSArray).object(at: indexPath.row) as! NSDictionary).value(forKey: "degree") as! String)
            cell.lblDate.text = "\((((self.educationArr as NSArray).object(at: indexPath.row) as! NSDictionary).value(forKey: "from") as! String))\("-") \((((self.get_dest as NSArray).object(at:indexPath.row) as! NSDictionary).value(forKey: "to") as! String))"
            cell.lblOrgName.text = (((self.educationArr as NSArray).object(at: indexPath.row) as! NSDictionary).value(forKey: "school") as! String)
            cell.lblDetail.text = (((self.educationArr as NSArray).object(at: indexPath.row) as! NSDictionary).value(forKey: "description") as! String)
            return cell
        }
        else  if tableView == tableViewIndustry  {
            let cell : AgentDetailTableViewCell = tableViewIndustry.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as! AgentDetailTableViewCell
            cell.lblPostName.text = (((self.industryArr as NSArray).object(at: indexPath.row) as! NSDictionary).value(forKey: "post") as! String)
            cell.lblDate.text = "\((((self.industryArr as NSArray).object(at: indexPath.row) as! NSDictionary).value(forKey: "from") as! String))\("-") \((((self.industryArr as NSArray).object(at:indexPath.row) as! NSDictionary).value(forKey: "to") as! String))"
            cell.lblOrgName.text = (((self.industryArr as NSArray).object(at: indexPath.row) as! NSDictionary).value(forKey: "organization") as! String)
            cell.lblDetail.text = (((self.industryArr as NSArray).object(at: indexPath.row) as! NSDictionary).value(forKey: "description") as! String)
            return cell
        }
        else  if tableView == tableViewRealState  {
            let cell : AgentDetailTableViewCell = tableViewRealState.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as! AgentDetailTableViewCell
            cell.lblPostName.text = (((self.realStateArr as NSArray).object(at: indexPath.row) as! NSDictionary).value(forKey: "degree") as! String)
            cell.lblDate.text = "\((((self.realStateArr as NSArray).object(at: indexPath.row) as! NSDictionary).value(forKey: "from") as! String))\("-") \((((self.realStateArr as NSArray).object(at:indexPath.row) as! NSDictionary).value(forKey: "to") as! String))"
            cell.lblOrgName.text = (((self.realStateArr as NSArray).object(at: indexPath.row) as! NSDictionary).value(forKey: "school") as! String)
            cell.lblDetail.text = (((self.realStateArr as NSArray).object(at: indexPath.row) as! NSDictionary).value(forKey: "description") as! String)
            return cell
        }
        else  if tableView == tableViewLanguage  {
           let cell = tableViewLanguage.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LanguageTableViewCell
            cell.lblLanguage.text = " \((((self.languageArr as NSArray).object(at: indexPath.row) as! NSDictionary).value(forKey: "language") as! String))"
             cell.lblSpeak.text = " \((((self.languageArr as NSArray).object(at: indexPath.row) as! NSDictionary).value(forKey: "speak") as! String))"
             cell.lblRead.text = " \((((self.languageArr as NSArray).object(at: indexPath.row) as! NSDictionary).value(forKey: "read") as! String))"
             cell.lblWrite.text = " \((((self.languageArr as NSArray).object(at: indexPath.row) as! NSDictionary).value(forKey: "write") as! String))"
            return cell
        }
        return cell1
    }
}

extension AgentDetailViewController: UITableViewDelegate {
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
