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
    
    // MARK: - Lifecycle Methods
    
    override func viewWillAppear(_ animated: Bool) {
        Utilities.setUpBlueNavBarFor(self)
        setBackgroundColorsToColorButtons()
        selectCurrentCategoryColorButton()
        addCheckmarkToSelectedColorButton()
    }
    
    // MARK: - IBActions
    
    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didSelectColor(_ sender: ColorButton) {
        deselectAllColorButtons()
        removePreviousCheckmarks()
        selectedColorHex = sender.backgroundColor?.hexValue()
        sender.isSelected = true
        addCheckmarkToSelectedColorButton()
        delegate.didPickNewColor(colorHex: selectedColorHex)
    }
    
    // MARK: - Adding And Removing Checkmarks Methods
    
    func removePreviousCheckmarks() {
        if let checkmark = view.viewWithTag(100) {
            checkmark.removeFromSuperview()
        }
    }
    
    func addCheckmarkToSelectedColorButton() {
        let checkmark = UIImageView(image: UIImage(named: "Checkmark"))
        checkmark.frame.size = CGSize(width: 25, height: 25)
        checkmark.tag = 100
        for button in colorButtons where button.isSelected {
            checkmark.center = button.convert(button.center, from: button.superview)
            button.addSubview(checkmark)
        }
    }
    
    // MARK: - Other Methods
    
    func setBackgroundColorsToColorButtons() {
        for button in colorButtons {
            ColorPickerUtilities.setBackgroundColorFor(button)
        }
    }
    
    func selectCurrentCategoryColorButton() {
        for button in colorButtons {
            if button.backgroundColor?.hexValue().lowercased() == selectedColorHex.lowercased() {
                button.isSelected = true
                break
            }
        }
    }
    
    func deselectAllColorButtons() {
        for button in colorButtons {
            button.isSelected = false
        }
    }
    
}
