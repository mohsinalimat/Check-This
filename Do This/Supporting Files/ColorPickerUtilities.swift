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
            button.backgroundColor = UIColor(hexString: CategoryColor.normalRed.rawValue)
        case 2:
            button.backgroundColor = UIColor(hexString: CategoryColor.pink.rawValue)
        case 3:
            button.backgroundColor = UIColor(hexString: CategoryColor.purple.rawValue)
        case 4:
            button.backgroundColor = UIColor(hexString: CategoryColor.deepPurple.rawValue)
        case 5:
            button.backgroundColor = UIColor(hexString: CategoryColor.blue.rawValue)
        case 6:
            button.backgroundColor = UIColor(hexString: CategoryColor.lightRed.rawValue)
        case 7:
            button.backgroundColor = UIColor(hexString: CategoryColor.lightPink.rawValue)
        case 8:
            button.backgroundColor = UIColor(hexString: CategoryColor.lightPurple.rawValue)
        case 9:
            button.backgroundColor = UIColor(hexString: CategoryColor.lightDeepPurple.rawValue)
        case 10:
            button.backgroundColor = UIColor(hexString: CategoryColor.lightBlue.rawValue)
        case 11:
            button.backgroundColor = UIColor(hexString: CategoryColor.cyan.rawValue)
        case 12:
            button.backgroundColor = UIColor(hexString: CategoryColor.teal.rawValue)
        case 13:
            button.backgroundColor = UIColor(hexString: CategoryColor.green.rawValue)
        case 14:
            button.backgroundColor = UIColor(hexString: CategoryColor.lime.rawValue)
        case 15:
            button.backgroundColor = UIColor(hexString: CategoryColor.yellow.rawValue)
        case 16:
            button.backgroundColor = UIColor(hexString: CategoryColor.lightCyan.rawValue)
        case 17:
            button.backgroundColor = UIColor(hexString: CategoryColor.lightTeal.rawValue)
        case 18:
            button.backgroundColor = UIColor(hexString: CategoryColor.lightGreen.rawValue)
        case 19:
            button.backgroundColor = UIColor(hexString: CategoryColor.lightLime.rawValue)
        case 20:
            button.backgroundColor = UIColor(hexString: CategoryColor.lightYellow.rawValue)
        case 21:
            button.backgroundColor = UIColor(hexString: CategoryColor.amber.rawValue)
        case 22:
            button.backgroundColor = UIColor(hexString: CategoryColor.orange.rawValue)
        case 23:
            button.backgroundColor = UIColor(hexString: CategoryColor.deepOrange.rawValue)
        case 24:
            button.backgroundColor = UIColor(hexString: CategoryColor.brown.rawValue)
        case 25:
            button.backgroundColor = UIColor(hexString: CategoryColor.blueGray.rawValue)
        case 26:
            button.backgroundColor = UIColor(hexString: CategoryColor.lightAmber.rawValue)
        case 27:
            button.backgroundColor = UIColor(hexString: CategoryColor.lightOrange.rawValue)
        case 28:
            button.backgroundColor = UIColor(hexString: CategoryColor.lightDeepOrange.rawValue)
        case 29:
            button.backgroundColor = UIColor(hexString: CategoryColor.lightBrown.rawValue)
        case 30:
            button.backgroundColor = UIColor(hexString: CategoryColor.lightBlueGray.rawValue)
        default:
            fatalError()
        }
    }
    
}
