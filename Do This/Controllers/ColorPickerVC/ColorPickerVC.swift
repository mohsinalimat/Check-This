//
//  ColorPickerViewController.swift
//  Do This
//
//  Created by Luis M Gonzalez on 7/11/18.
//  Copyright © 2018 Luis M Gonzalez. All rights reserved.
//

import UIKit

protocol ColorPickerDelegate: class {
    func didPickNewColorFor(_ category: Category, newColorHex: String)
}

class ColorPickerViewController: UIViewController {

    weak var delegate: ColorPickerDelegate!
    var selectedCategory: Category!
    var selectedColorHex: String!
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
        coordinator.animate(alongsideTransition: { (_) in
            // Updates checkmark when user changes device orientation.
            self.removePreviousCheckmarks()
            self.addCheckmarkToSelectedColorButton()
        }, completion: nil)
    }
    
    // MARK: - IBActions
    
    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
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
    
    func removePreviousCheckmarks() {
        if let checkmark = view.viewWithTag(100) {
            checkmark.removeFromSuperview()
        }
    }
    
    func addCheckmarkToSelectedColorButton() {
        for button in colorButtons where button.isSelected {
            let checkmark = UIImageView(image: UIImage(named: "Checkmark"))
            checkmark.tag = 100
            checkmark.frame.size = CGSize(width: button.frame.width/2, height: button.frame.height/2)
            checkmark.center = button.convert(button.center, from: button.superview)
            button.addSubview(checkmark)
        }
    }
    
    func setBackgroundColorsToColorButtons() {
        var index = 0
        for button in colorButtons {
            button.backgroundColor = UIColor(hexString: Utilities.colorOptions[index])
            index += 1
        }
    }
    
    // MARK: - Selection Of Color Buttons Methods
    
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
