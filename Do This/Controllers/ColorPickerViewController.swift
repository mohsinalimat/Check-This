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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

//    @IBAction colorPressed(_ sender: AnyObject) {
//        TODO: Create real @IBAction to pass on the colorPickedByUserForCategory
//        to the CategoryViewController and dismiss the ColorPickerViewController
//    }

}
