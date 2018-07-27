//
//  ColorButton.swift
//  Do This
//
//  Created by Luis M Gonzalez on 7/15/18.
//  Copyright © 2018 Luis M Gonzalez. All rights reserved.
//

import UIKit

@IBDesignable
class ColorButton: UIButton {

    override func layoutSubviews() {
        super.layoutSubviews()
        let width = superview!.frame.width/5 - 10
        let height = width
        frame.size = CGSize(width: width, height: height)
        layer.cornerRadius = frame.size.height / 2
    }
    
}
