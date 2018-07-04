//
//  RoundedTextField.swift
//  FoodPin
//
//  Created by 许有红 on 2018/6/25.
//  Copyright © 2018 EmptyWlaker. All rights reserved.
//

import UIKit

class RoundedTextField: UITextField {

    let padding = UIEdgeInsetsMake(0, 10, 0, 10)
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = 5.0
        self.clipsToBounds = true
    }
}
