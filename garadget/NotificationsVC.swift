//
//  NotificationsVC.swift
//  garadget
//
//  Created by Stephen Madsen on 3/4/16.
//  Copyright © 2016 SynapticSwitch,LLC. All rights reserved.
//

import UIKit

class NotificationsVC: UIViewController
{
    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews(){
        let scrollSize = CGSizeMake(0, myView.frame.height)
        scrollView.contentSize = scrollSize
    }

    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
