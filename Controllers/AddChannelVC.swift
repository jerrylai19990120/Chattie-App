//
//  AddChannelVC.swift
//  Chattie
//
//  Created by Jerry Lai on 2021-01-29.
//  Copyright © 2021 Jerry Lai. All rights reserved.
//

import UIKit

class AddChannelVC: UIViewController {
    
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var channelName: UITextField!
    @IBOutlet weak var channelDesc: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        
    }


    @IBAction func closeBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createPressed(_ sender: Any) {
        guard let name = channelName.text, channelName.text != "" else {return}
        guard let desc = channelDesc.text, channelDesc.text != "" else {return}
        
        SocketService.instance.addChannel(name: name, desc: desc) { (success) in
            if success {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func setUpView(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(AddChannelVC.closeTap(_:)))
        
        bgView.addGestureRecognizer(tap)
        
        channelName.attributedPlaceholder = NSAttributedString(string: "name", attributes: [.foregroundColor: chattiePurplePlaceHolder])
        
        channelDesc.attributedPlaceholder = NSAttributedString(string: "description", attributes: [.foregroundColor: chattiePurplePlaceHolder])
    }
    
    @objc func closeTap(_ recognizer: UITapGestureRecognizer){
        dismiss(animated: true, completion: nil)
    }
    
}
