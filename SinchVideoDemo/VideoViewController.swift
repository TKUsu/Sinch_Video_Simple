//
//  VideoViewController.swift
//  SinchVideoDemo
//
//  Created by 默司 on 2016/10/25.
//  Copyright © 2016年 默司. All rights reserved.
//

import UIKit

class VideoViewController: UIViewController, SINCallDelegate {

    @IBOutlet weak var localView: UIView!
    @IBOutlet weak var remoteView: UIView!
    
    var userId: String! {
        didSet {
            let i = users.index(of: userId)
            
            if(i == 0) {
                targetId = users[1]
            } else {
                targetId = users[0]
            }
        }
    }
    var targetId: String!
    
    var call: SINCall?
    var incomingCall: SINCall?
    
    var videoController: SINVideoController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        videoController = SINClientManager.shared.client?.videoController();
        
        if let lv = videoController?.localView() {
            lv.contentMode = .scaleAspectFill
            lv.frame = self.localView.bounds
            self.localView.addSubview(lv)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveIncomingCall(_:)), name: .didReceiveIncomingCall, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func callout(_ sender: Any) {
        if let client = SINClientManager.shared.client?.call() {
            if let call = client.callUserVideo(withId: targetId) {
                call.delegate = self
                
                self.call = call
                
                
            }
        }
    }
    
    @IBAction func hangup(_ sender: Any) {
        self.call?.hangup()
    }
    
    func didReceiveIncomingCall(_ notification: Notification) {
        if let call = notification.object as? SINCall {
            self.incomingCall = call
            
            call.answer()
        }
    }
    
    func callDidEnd(_ call: SINCall!) {
        videoController?.localView().removeFromSuperview()
        videoController?.remoteView().removeFromSuperview()
    }
    
    func callDidProgress(_ call: SINCall!) {
        
    }
    
    func callDidEstablish(_ call: SINCall!) {
        
    }
    
    func callDidAddVideoTrack(_ call: SINCall!) {
        if let rv = videoController?.remoteView() {
            rv.contentMode = .scaleAspectFill
            rv.frame = self.remoteView.bounds
            self.remoteView.addSubview(rv)
        }
    }
    
    func call(_ call: SINCall!, shouldSendPushNotifications pushPairs: [Any]!) {
        
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
