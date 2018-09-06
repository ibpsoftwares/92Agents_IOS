//
//  SelectLoginViewController.swift
//  92Agents
//
//  Created by Apple on 14/06/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class SelectLoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
     //MARK: ButtonAction To Call ViewController
    @IBAction func btnSeller(_ sender: UIButton) {
         Model.sharedInstance.userRole = "3"
        
        let signupVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SellerLoginViewController") as! SellerLoginViewController
        self.navigationController?.pushViewController(signupVC, animated: true)
    }
    @IBAction func btnBuyer(_ sender: UIButton) {
         Model.sharedInstance.userRole = "2"
        let signupVC = UIStoryboard(name: "Buyer", bundle: nil).instantiateViewController(withIdentifier: "BuyerLoginViewController") as! BuyerLoginViewController
        self.navigationController?.pushViewController(signupVC, animated: true)
    }
    @IBAction func btnAgent(_ sender: UIButton) {
         Model.sharedInstance.userRole = "4"
        Model.sharedInstance.user = "Agents"
        let signupVC = UIStoryboard(name: "Agents", bundle: nil).instantiateViewController(withIdentifier: "AgentsLoginViewController") as! AgentsLoginViewController
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
