//
//  ColorPickerScreenColorButton.swift
//  Check This
//
//  Created by Luis M Gonzalez on 7/15/18.
//  Copyright © 2018 Luis M Gonzalez. All rights reserved.
//

import UIKit

/// This is a round button used to display the color options the users can pick
/// in the ColorPicker screen for categories.
@IBDesignable
class ColorPickerScreenColorButton: UIButton {

    override func layoutSubviews() {
        super.layoutSubviews()
        guard let rowOfButtons = superview as? UIStackView else { fatalError() }
        let width = rowOfButtons.frame.width/CGFloat(rowOfButtons.subviews.count) - rowOfButtons.spacing
        let height = width
        frame.size = CGSize(width: width, height: height)
        layer.cornerRadius = frame.size.height / 2
    }
    
}
