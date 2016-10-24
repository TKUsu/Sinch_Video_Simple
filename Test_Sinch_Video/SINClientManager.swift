//
//  SINClientManager.swift
//  WebRTC
//
//  Created by sujustin on 2016/10/22.
//  Copyright © 2016年 sujustin. All rights reserved.
//

import UIKit

class SINClientManager: NSObject {
    static let sharedManager = SINClientManager()
    
    private weak var appDelegate: AppDelegate!
    
    var currentClient: SINClient? {
        get {
            return appDelegate.client
        }
    }
    
    private override init() {
        super.init()
        
        self.appDelegate = UIApplication.shared.delegate as! AppDelegate
    }
    
//    var users = ["su": "すばる", "rem": "レム", "ram": "ラム", "em": "エミリア"]
    
    var users = ["User1": "User1", "User2": "User2"]
    
    //利用 userId 進行 client 初始化
    func client(withUserId userId: String) -> SINClient? {
        if self.appDelegate.client == nil {
            if let client = Sinch.client(withApplicationKey: "2b15b697-b2cd-432b-804a-1d4a168f0c99", applicationSecret: "5XMWJIdf5EmeaigFAY6kaw==", environmentHost: "sandbox.sinch.com", userId: userId) {
                
                client.setSupportCalling(true)
                //client.setSupportMessaging(true)
                client.setSupportActiveConnectionInBackground(true)
                
                client.enableManagedPushNotifications()
                
                client.delegate = self.appDelegate
                client.call().delegate = self.appDelegate
                //client.messageClient().delegate = self.appDelegate
                
                client.start()
                client.startListeningOnActiveConnection()
                
                self.appDelegate.client = client
            }
        }
        
        return self.appDelegate.client
    }
    
    func logout() {
        if let client = self.appDelegate.client {
            client.stopListeningOnActiveConnection()
            client.terminate()
        }
        
        self.appDelegate.client = nil
    }
    
    func getUserId(withUsername username: String) -> String? {
        let keys = Array(users.keys)
        
        for key in keys {
            if users[key] == username {
                return key
            }
        }
        
        return nil
    }
    
    func getUsername(withUserId userId: String) -> String? {
        return users[userId]
    }
}
