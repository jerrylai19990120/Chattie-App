//
//  RoundedButton.swift
//  Chattie
//
//  Created by Jerry Lai on 2021-01-28.
//  Copyright © 2021 Jerry Lai. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedButton: UIButton {

    @IBInspectable var cornerRadius: CGFloat = 5.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    override func awakeFromNib() {
        self.setUpViews()
    }
    
    func setUpViews(){
        self.layer.cornerRadius = cornerRadius
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.setUpViews()
    }

}
