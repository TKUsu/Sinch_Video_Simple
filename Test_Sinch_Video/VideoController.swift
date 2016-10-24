//
//  VideoController.swift
//  Test_Sinch_Video
//
//  Created by sujustin on 2016/10/23.
//  Copyright © 2016年 sujustin. All rights reserved.
//

import UIKit

class VideoController: UIViewController, SINCallDelegate {

    @IBOutlet weak var callStateLabel: UILabel!
    @IBOutlet weak var answerButton: UIButton!
    @IBOutlet weak var declineButton: UIButton!
    @IBOutlet weak var endCallButton: UIButton!
    @IBOutlet weak var calloutButtin: UIButton!
    @IBOutlet weak var remoteVideoView: UIView!
    @IBOutlet weak var localVideoView: UIView!
    var call: SINCall!;
    private var users: [String: String]!
    
    var currentUserId: String! {
        didSet {
            let manager = SINClientManager.sharedManager
            self.users = manager.users
            self.users.removeValue(forKey: self.currentUserId)
        }
    }
    
//    func audioController() -> SINAudioController {
//        return (UIApplication.shared.delegate! as! AppDelegate).client!.audioController()
//    }
    
    func videoController() -> SINVideoController {
        return (UIApplication.shared.delegate! as! AppDelegate).client!.videoController()
    }
    
    func setCall(notification: Notification) {
        self.call = notification.object as! SINCall
        self.call.delegate = self
    }
    // MARK: - UIViewController Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.callStateLabel.text = ""
        self.declineButton.isHidden = true
        self.answerButton.isHidden = true
        self.endCallButton.isHidden = true
        
        ///??????
        self.currentUserId = SINClientManager.sharedManager.currentClient!.userId
        
        self.navigationItem.title = SINClientManager.sharedManager.users[currentUserId]
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.didReceiveIncomingCall(_:)), name: .didReceiveIncomingCall, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        SINClientManager.sharedManager.logout()
        
        NotificationCenter.default.removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didReceiveIncomingCall(_ notification: Notification) {
        let call = notification.object as! SINCall
        call.delegate = self
        self.showIncomingCallView(call)
    }
    
    func showIncomingCallView(_ call: SINCall) {
        if self.call.direction == .incoming {
            self.callStateLabel.text = ""
            self.declineButton.isHidden = false
            self.answerButton.isHidden = false
            self.endCallButton.isHidden = true
        }else {
            self.callStateLabel.text = "calling..."
            self.declineButton.isHidden = true
            self.answerButton.isHidden = true
            self.endCallButton.isHidden = false
        }
        if (self.call.details.isVideoOffered) {
            self.localVideoView.addSubview(self.videoController().localView())
        }
    }

    // MARK: - Call Actions
    
    @IBAction func callout(_ sender: AnyObject) {
        var userID:String!
        for value in users{
            userID = value.value
        }
//        print(userID)
        
        if let client = SINClientManager.sharedManager.currentClient {
            
            if let call = client.call().callUser(withId: userID) {
                call.delegate = self
                //self.call = call
                self.showIncomingCallView(call)
            }
        }
    }
    
    @IBAction func accept(_ sender: AnyObject) {
        self.call.answer()
    }
    
    @IBAction func decline(_ sender: AnyObject) {
        self.call.hangup()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func hangup(_ sender: AnyObject) {
        self.call.hangup()
        self.dismiss(animated: true, completion: nil)
    }
    // MARK: - SINCallDelegate
    
    func callDidProgress(_ call: SINCall) {
        self.callStateLabel.text = "ringing..."
    }
    
    func callDidEstablish(_ call: SINCall) {
        self.endCallButton.isHidden = false;
        self.answerButton.isHidden = true;
        self.declineButton.isHidden = true;
    }
    
    func callDidEnd(_ call: SINCall) {
        self.dismiss(animated: true, completion: nil)
        self.videoController().remoteView().removeFromSuperview()
    }
    
    func callDidAddVideoTrack(_ call: SINCall) {
        self.remoteVideoView.addSubview(self.videoController().remoteView())
    }
    // MARK: - Sounds
    
    func path(forSound soundName: String) -> String {
        return NSURL(fileURLWithPath: Bundle.main.resourcePath!).appendingPathComponent(soundName)!.absoluteString
    }
}
