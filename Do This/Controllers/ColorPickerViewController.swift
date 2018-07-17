//
//  ColorPickerViewController.swift
//  Do This
//
//  Created by Luis M Gonzalez on 7/11/18.
//  Copyright © 2018 Luis M Gonzalez. All rights reserved.
//

import UIKit

protocol ColorPickerDelegate: class {
    func didPickNewColor(colorHex: String)
}

class ColorPickerViewController: UIViewController {

    weak var delegate: ColorPickerDelegate!
    var selectedColorHex: String!
    var colorButtons: [ColorButton] {
        var buttons: [ColorButton] = []
        for verticalStackView in view.subviews {
            for rowOfButtons in verticalStackView.subviews {
                for button in rowOfButtons.subviews {
                    if let button = button as? ColorButton {
                        buttons.append(button)
                    }
                }
            }
        }
        return buttons
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Utilities.setUpBlueNavBarFor(self)
        assignBackgroundColorsTo(colorButtons)
        addCheckmarkToSelectedColorButton()
    }
    
    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didSelectColor(_ sender: ColorButton) {
        selectedColorHex = sender.backgroundColor?.hexValue()
        delegate.didPickNewColor(colorHex: selectedColorHex)
        addCheckmarkToSelectedColorButton()
    }
    
    func assignBackgroundColorsTo(_ colorButtons: [ColorButton]) {
        for button in colorButtons {
            ColorPickerUtilities.setBackgroundColorFor(button)
        }
    }
    
    func addCheckmarkToSelectedColorButton() {
        // TODO: Implement method
    }
        
}
