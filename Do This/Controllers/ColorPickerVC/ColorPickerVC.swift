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
    @IBOutlet var colorButtons: [ColorButton]!
    
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
    
    // MARK: - IBActions
    
    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didSelectColor(_ sender: ColorButton) {
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
        let checkmark = UIImageView(image: UIImage(named: "Checkmark"))
        checkmark.frame.size = CGSize(width: 25, height: 25)
        checkmark.tag = 100
        for button in colorButtons where button.isSelected {
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
