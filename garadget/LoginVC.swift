//
//  LoginVC.swift
//  garadget
//
//  Created by Stephen Madsen on 3/10/16.
//  Copyright © 2016 Stephen Madsen. All rights reserved.
//

import UIKit

class LoginVC: UIViewController
{

    @IBOutlet weak var usernameOutlet: UITextField!
    
    @IBOutlet weak var passwordOutlet: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do view setup here.                
    }
    
    override func viewDidAppear(animated: Bool)
    {
    }
    
    @IBAction func loginAction(sender: AnyObject)
    {
        self.loginParticle()
    }
    
    func loginParticle()
    {
        SparkCloud.sharedInstance().loginWithUser(usernameOutlet.text!, password: passwordOutlet.text!) { (error:NSError?) -> Void in
        
            if let e=error
            {
                print("Wrong credentials or no internet connectivity, please try again")
            }
            else
            {
                //print("Logged in")
                
                self.performSegueWithIdentifier("showDoorsVC", sender: self)                                
            }
        }
    }
}
