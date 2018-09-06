//
//  ViewController.swift
//  92Agents
//
//  Created by Apple on 14/06/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import LNSideMenu

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var barButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
         self.navigationController?.navigationBar.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func btnLogin(_ sender: UIButton) {
       let signupVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SelectLoginViewController") as! SelectLoginViewController
        self.navigationController?.pushViewController(signupVC, animated: true)
    }
    @IBAction func btnRegister(_ sender: UIButton) {
        let signupVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SelectRegistrationViewController") as! SelectRegistrationViewController
        self.navigationController?.pushViewController(signupVC, animated: true)
    }
   
}

