//
//  MessageCell.swift
//  Chattie
//
//  Created by Jerry Lai on 2021-01-30.
//  Copyright © 2021 Jerry Lai. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {
    
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userImg: CircleImage!
    
    @IBOutlet weak var messageBodyLbl: UILabel!
    @IBOutlet weak var timeStamp: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(message: Message){
        messageBodyLbl.text = message.message
        userName.text = message.userName
        
        userImg.image = UIImage(named: message.userAvatar)
        userImg.backgroundColor = UserDataService.instance.returnUIColor(components: message.userAvatarColor)
    }

}
