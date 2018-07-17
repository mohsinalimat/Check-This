//
//  ColorPickerUtilities.swift
//  Do This
//
//  Created by Luis M Gonzalez on 7/16/18.
//  Copyright © 2018 Luis M Gonzalez. All rights reserved.
//

import UIKit

struct ColorPickerUtilities {
    
    static func setBackgroundColorFor(_ button: RoundButtonForColorChoices) { // swiftlint:disable:this cyclomatic_complexity function_body_length
        switch button.tag {
        case 1:
            button.backgroundColor = UIColor(hexString: CategoryColorHex.normalRed.rawValue)
        case 2:
            button.backgroundColor = UIColor(hexString: CategoryColorHex.pink.rawValue)
        case 3:
            button.backgroundColor = UIColor(hexString: CategoryColorHex.purple.rawValue)
        case 4:
            button.backgroundColor = UIColor(hexString: CategoryColorHex.deepPurple.rawValue)
        case 5:
            button.backgroundColor = UIColor(hexString: CategoryColorHex.blue.rawValue)
        case 6:
            button.backgroundColor = UIColor(hexString: CategoryColorHex.lightRed.rawValue)
        case 7:
            button.backgroundColor = UIColor(hexString: CategoryColorHex.lightPink.rawValue)
        case 8:
            button.backgroundColor = UIColor(hexString: CategoryColorHex.lightPurple.rawValue)
        case 9:
            button.backgroundColor = UIColor(hexString: CategoryColorHex.lightDeepPurple.rawValue)
        case 10:
            button.backgroundColor = UIColor(hexString: CategoryColorHex.lightBlue.rawValue)
        case 11:
            button.backgroundColor = UIColor(hexString: CategoryColorHex.cyan.rawValue)
        case 12:
            button.backgroundColor = UIColor(hexString: CategoryColorHex.teal.rawValue)
        case 13:
            button.backgroundColor = UIColor(hexString: CategoryColorHex.green.rawValue)
        case 14:
            button.backgroundColor = UIColor(hexString: CategoryColorHex.lime.rawValue)
        case 15:
            button.backgroundColor = UIColor(hexString: CategoryColorHex.yellow.rawValue)
        case 16:
            button.backgroundColor = UIColor(hexString: CategoryColorHex.lightCyan.rawValue)
        case 17:
            button.backgroundColor = UIColor(hexString: CategoryColorHex.lightTeal.rawValue)
        case 18:
            button.backgroundColor = UIColor(hexString: CategoryColorHex.lightGreen.rawValue)
        case 19:
            button.backgroundColor = UIColor(hexString: CategoryColorHex.lightLime.rawValue)
        case 20:
            button.backgroundColor = UIColor(hexString: CategoryColorHex.lightYellow.rawValue)
        case 21:
            button.backgroundColor = UIColor(hexString: CategoryColorHex.amber.rawValue)
        case 22:
            button.backgroundColor = UIColor(hexString: CategoryColorHex.orange.rawValue)
        case 23:
            button.backgroundColor = UIColor(hexString: CategoryColorHex.deepOrange.rawValue)
        case 24:
            button.backgroundColor = UIColor(hexString: CategoryColorHex.brown.rawValue)
        case 25:
            button.backgroundColor = UIColor(hexString: CategoryColorHex.blueGray.rawValue)
        case 26:
            button.backgroundColor = UIColor(hexString: CategoryColorHex.lightAmber.rawValue)
        case 27:
            button.backgroundColor = UIColor(hexString: CategoryColorHex.lightOrange.rawValue)
        case 28:
            button.backgroundColor = UIColor(hexString: CategoryColorHex.lightDeepOrange.rawValue)
        case 29:
            button.backgroundColor = UIColor(hexString: CategoryColorHex.lightBrown.rawValue)
        case 30:
            button.backgroundColor = UIColor(hexString: CategoryColorHex.lightBlueGray.rawValue)
        default:
            fatalError()
        }
    }
    
}
