//
//  ViewController.swift
//  Test_Sinch_Video
//
//  Created by sujustin on 2016/10/23.
//  Copyright © 2016年 sujustin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var nameLabel: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func login(_ sender: AnyObject) {
        let manager = SINClientManager.sharedManager
//        let name = self.nameLabel.text;
        
        if let username = (sender as? UIButton)?.title(for: .normal), let userId = manager.getUserId(withUsername: username), manager.client(withUserId: userId) != nil {
            //開始觀察
            NotificationCenter.default.addObserver(self, selector: #selector(self.clientDidStart(_:)), name: .clientDidStart, object: nil)
        }
    }
    
    func clientDidStart(_ notification: Notification) {
        self.performSegue(withIdentifier: "Login", sender: self)
        
        NotificationCenter.default.removeObserver(self)
    }


}

