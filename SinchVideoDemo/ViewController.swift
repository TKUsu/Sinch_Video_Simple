//
//  ViewController.swift
//  SinchVideoDemo
//
//  Created by 默司 on 2016/10/25.
//  Copyright © 2016年 默司. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(clientDidStart(_:)), name: .clientDidStart, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    func clientDidStart(_ notification: Notification) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "VideoViewController") as! VideoViewController
        if let client = notification.object as? SINClient {
            vc.userId = client.userId
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func user1(_ sender: Any) {
        let _ = SINClientManager.shared.client(withUserId: "user1")
    }

    @IBAction func user2(_ sender: Any) {
        let _ = SINClientManager.shared.client(withUserId: "user2")
    }

}

