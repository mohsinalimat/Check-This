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
        frame.size = CGSize(width: 50, height: 50)
        layer.cornerRadius = frame.size.height / 2
    }

}
