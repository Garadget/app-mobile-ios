//
//  WebVC.swift
//  garadget
//
//  Created by Stephen Madsen on 4/12/16.
//  Copyright © 2016 Stephen Madsen. All rights reserved.
//

//import Cocoa

class WebVC: UIViewController
{

    @IBOutlet weak var web_view_outlet: UIWebView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let url = NSURL (string: "http://community.garadget.com/?ref=webapp&page=settings");
        let requestObj = NSURLRequest(URL: url!);
        web_view_outlet.loadRequest(requestObj);
    }
}
