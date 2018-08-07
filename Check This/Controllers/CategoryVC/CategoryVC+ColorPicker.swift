//
//  CategoryVC+ColorPicker.swift
//  Check This
//
//  Created by Luis M Gonzalez on 7/11/18.
//  Copyright © 2018 Luis M Gonzalez. All rights reserved.
//

extension CategoryVC: ColorPickerDelegate {
    
    func didPickNewColorFor(_ category: Category, newColorHex: String) {
        edit(category: category, newColorHex: newColorHex)
    }

}
