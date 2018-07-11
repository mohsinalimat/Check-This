//
//  CategoryViewController+ColorPicker.swift
//  Do This
//
//  Created by Luis M Gonzalez on 7/11/18.
//  Copyright © 2018 Luis M Gonzalez. All rights reserved.
//

import UIKit

// MARK: - Color Picker Delegate Methods

extension CategoryViewController: ColorPickerDelegate {
    
    func didPickNewColor(color: UIColor) {
        print("color.hexValue(): \(color.hexValue())")
    }

}
