//
//  ColorPickerViewController.swift
//  Do This
//
//  Created by Luis M Gonzalez on 7/11/18.
//  Copyright © 2018 Luis M Gonzalez. All rights reserved.
//

import UIKit

protocol ColorPickerDelegate: class {
    func didPickNewColor(color: UIColor)
}

class ColorPickerViewController: UIViewController {

    weak var delegate: ColorPickerDelegate?
    var colorPickedHex: String?
    
    override func viewWillAppear(_ animated: Bool) {
        Utilities.setUpBlueNavBarFor(self)
        assignBackgroundColorsToColorButtons()
    }
    
    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    //    @IBAction colorPressed(_ sender: AnyObject) {
    //        TODO: Create real @IBAction to pass on the colorPickedByUserForCategory
    //        to the CategoryViewController and dismiss the ColorPickerViewController
    //    }
    
    func assignBackgroundColorsToColorButtons() {
        for verticalStackView in view.subviews {
            for rowOfButtons in verticalStackView.subviews {
                for button in rowOfButtons.subviews {
                    if let button = button as? RoundButtonForColorChoices {
                        ColorPickerUtilities.setBackgroundColorFor(button)
                    }
                }
            }
        }
    }
        
}
