//
//  SINClientManager.swift
//  SinchVideoDemo
//
//  Created by 默司 on 2016/10/25.
//  Copyright © 2016年 默司. All rights reserved.
//

import UIKit

let users = ["user1", "user2"]

class SINClientManager: NSObject, SINClientDelegate, SINCallClientDelegate {
    static let shared = SINClientManager()
    
    var client: SINClient?
    
    
    private override init() {
        super.init()
        
    }
    
    func client(withUserId userId: String) -> SINClient? {
        if self.client == nil {
            if let client = Sinch.client(withApplicationKey: "2b15b697-b2cd-432b-804a-1d4a168f0c99", applicationSecret: "5XMWJIdf5EmeaigFAY6kaw==", environmentHost: "sandbox.sinch.com", userId: userId) {
                
                client.setSupportCalling(true)
                
                //client.setSupportMessaging(true)
                //client.setSupportActiveConnectionInBackground(true)
                //client.enableManagedPushNotifications()
                
                client.delegate = self
                client.call().delegate = self
                //client.messageClient().delegate = self.appDelegate
                
                client.start()
                client.startListeningOnActiveConnection()
                
                self.client = client
            }
        }
        
        return self.client
    }
    
    func logout() {
        if let client = self.client {
            client.stopListeningOnActiveConnection()
            client.terminate()
        }
        
        self.client = nil
    }
    
    func clientDidStart(_ client: SINClient!) {
        print("clientDidStart")
        NotificationCenter.default.post(name: .clientDidStart, object: client)
    }
    
    func clientDidStop(_ client: SINClient!) {
        print("clientDidStop")
    }
    
    func clientDidFail(_ client: SINClient!, error: Error!) {
        print("clientDidFail")
    }
    
    func client(_ client: SINCallClient!, didReceiveIncomingCall call: SINCall!) {
        print("didReceiveIncomingCall")
        NotificationCenter.default.post(name: .didReceiveIncomingCall, object: call)
    }
}

extension Notification.Name {
    static let clientDidStart = Notification.Name("SINCLIENT_DID_START")
    static let didReceiveIncomingCall = Notification.Name("SINCLIENT_DID_RECEIVE_INCOMING_CALL")
}
