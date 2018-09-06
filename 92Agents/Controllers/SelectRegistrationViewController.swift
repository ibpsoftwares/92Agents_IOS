//
//  SelectRegistrationViewController.swift
//  92Agents
//
//  Created by Apple on 19/06/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class SelectRegistrationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
     //MARK: Button Action to call ViewController
    @IBAction func btnBecomeSeller(_ sender: UIButton) {
         Model.sharedInstance.userRole = "3"
        let signupVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SellerRegistrationViewController") as! SellerRegistrationViewController
        self.navigationController?.pushViewController(signupVC, animated: true)
    }
    @IBAction func btnBecomeBuyer(_ sender: UIButton) {
         Model.sharedInstance.userRole = "2"
        let signupVC = UIStoryboard(name: "Buyer", bundle: nil).instantiateViewController(withIdentifier: "BuyerRegistrationViewController") as! BuyerRegistrationViewController
        self.navigationController?.pushViewController(signupVC, animated: true)
    }
    @IBAction func btnBecomeAgent(_ sender: UIButton) {
         Model.sharedInstance.userRole = "4"
        let signupVC = UIStoryboard(name: "Agents", bundle: nil).instantiateViewController(withIdentifier: "RegistrationViewController") as! RegistrationViewController
        self.navigationController?.pushViewController(signupVC, animated: true)
    }
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
