//
//  ColorPickerViewController.swift
//  Check This
//
//  Created by Luis M Gonzalez on 7/11/18.
//  Copyright © 2018 Luis M Gonzalez. All rights reserved.
//

import UIKit

protocol ColorPickerDelegate: class {
    
    /// Assigns the newColorHex of the color the user selects to the given
    /// category.
    func didPickNewColorFor(_ category: Category, newColorHex: String)
    
}

class ColorPickerViewController: UIViewController {
    
    weak var delegate: ColorPickerDelegate!
    
    /// The category that the user selected to edit its color.
    var selectedCategory: Category!
    
    /// Color hex of the selected category color.
    var selectedColorHex: String!
    
    /// Array of all the color buttons that a user can pick from for the category.
    @IBOutlet var colorButtons: [ColorPickerScreenColorButton]!
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackgroundColorsToColorButtons()
        selectedColorHex = selectedCategory.colorHexValue
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        view.layoutIfNeeded()
        Utilities.setUpBlueNavBarFor(self)
        selectCurrentCategoryColorButton()
        addCheckmarkToSelectedColorButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        /* If device is in landscape when the user navigates to the
         ColorPickerVC, the checkmark on the selected color has the wrong
         dimensions. This implementation will change the checkmark dimensions
         visibly to the user. */
        if UIDevice.current.orientation.isLandscape {
            removePreviousCheckmarks()
            addCheckmarkToSelectedColorButton()
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        /* Animates the selected color button's checkmark so that it has the right
         dimensions and location when the user changes the device orientation. */
        coordinator.animate(alongsideTransition: { (_) in
            self.removePreviousCheckmarks()
            self.addCheckmarkToSelectedColorButton()
        }, completion: nil)
    }
    
    // MARK: - IBActions
    
    /// Called when user taps the done button. Dismisses Color Picker screen.
    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    /// Called when user touches a color button. Gives user haptic feedback and
    /// assigns the color that user selects to selected category.
    @IBAction func didSelectColor(_ sender: ColorPickerScreenColorButton) {
        let hapticGenerator = UISelectionFeedbackGenerator()
        hapticGenerator.selectionChanged()
        deselectAllColorButtons()
        removePreviousCheckmarks()
        selectedColorHex = sender.backgroundColor?.hexValue() ?? UIColor.flatBlue.hexValue()
        sender.isSelected = true
        addCheckmarkToSelectedColorButton()
        delegate.didPickNewColorFor(selectedCategory, newColorHex: selectedColorHex)
    }
    
    // MARK: - Modify User Interface Methods
    
    /// Removes all checkmarks from the superview.
    func removePreviousCheckmarks() {
        if let checkmark = view.viewWithTag(100) {
            checkmark.removeFromSuperview()
        }
    }
    
    /// Adds a checkmark to the center of the selected color button.
    func addCheckmarkToSelectedColorButton() {
        for button in colorButtons where button.isSelected {
            let checkmark = UIImageView(image: UIImage(named: "Checkmark"))
            checkmark.tag = 100
            checkmark.frame.size = CGSize(width: button.frame.width/2, height: button.frame.height/2)
            checkmark.center = button.convert(button.center, from: button.superview)
            button.addSubview(checkmark)
        }
    }
    
    /// Sets the background color to all the color buttons in the ColorPicker
    /// screen.
    func setBackgroundColorsToColorButtons() {
        var index = 0
        for button in colorButtons {
            button.backgroundColor = UIColor(hexString: Utilities.colorOptions[index])
            index += 1
        }
    }
    
    // MARK: - Selection Of Color Buttons Methods
    
    /// Selects the color button that has a background color that matches the
    /// selected category color.
    func selectCurrentCategoryColorButton() {
        for button in colorButtons {
            if button.backgroundColor?.hexValue().lowercased() == selectedColorHex.lowercased() {
                button.isSelected = true
                break
            }
        }
    }
    
    /// Deselects all color buttons.
    func deselectAllColorButtons() {
        for button in colorButtons {
            button.isSelected = false
        }
    }
    
}
