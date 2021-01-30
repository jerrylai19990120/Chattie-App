//
//  ChatVC.swift
//  Chattie
//
//  Created by Jerry Lai on 2021-01-27.
//  Copyright © 2021 Jerry Lai. All rights reserved.
//

import UIKit

class ChatVC: UIViewController {
    
    
    @IBOutlet weak var channelNameLabel: UILabel!
    @IBOutlet weak var menuBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())

        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.userDataDidChange(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.channelSelected(_:)), name: NOTIF_CHANNEL_SELECTED, object: nil)
        
        if AuthService.instance.isLoggedIn {
            AuthService.instance.findUserByEmail { (success) in
                if success {
                    NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
                }
            }
            
        }
        
    }
    
    @objc func channelSelected(_ notif: Notification){
        updateWithChannel()
    }
    
    func updateWithChannel(){
        let name = MessageService.instance.selectedChannel?.channelTitle ?? ""
        channelNameLabel.text = "#\(name)"
    }
    
    @objc func userDataDidChange(_ notif: Notification){
        if AuthService.instance.isLoggedIn {
            onLoginGetMessages()
            self.channelNameLabel.text = "Chattie"
        } else {
            channelNameLabel.text = "Please Log In"
        }
    }
    
    func onLoginGetMessages(){
        MessageService.instance.findAllChannel { (success) in
            if success {
                
            }
        }
    }
    

}
