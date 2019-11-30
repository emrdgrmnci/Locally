//
//  Utilities.swift
//  Locally
//
//  Created by Ali Emre Değirmenci on 21.09.2019.
//  Copyright © 2019 Ali Emre Değirmenci. All rights reserved.
//

import Foundation
import UIKit

class Utilities {

    static func styleTextField(_ textfield:UITextField) {

        // Create the bottom line
        let bottomLine = CALayer()

        bottomLine.frame = CGRect(x: 0, y: textfield.frame.height - 2, width: textfield.frame.width, height: 2)

        bottomLine.backgroundColor = UIColor.init(red: 158/255, green: 155/255, blue: 155/255, alpha: 1).cgColor //gray

        // Remove border on text field
        textfield.borderStyle = .none

        // Add the line to the text field
        textfield.layer.addSublayer(bottomLine)

    }

    static func styleFilledButton(_ button:UIButton) {

        // Filled rounded corner style
        button.backgroundColor = UIColor.init(red: 19/255, green: 144/255, blue: 255/255, alpha: 1) //blue
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.white
    }

    static func styleHollowButton(_ button:UIButton) {

        // Hollow rounded corner style
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.white
    }

    static func isPasswordValid(_ password : String) -> Bool {
        let passwordRegex = "(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,}" //same as Obj-C
        let passwordTest = NSPredicate(format:"SELF MATCHES %@", passwordRegex)
        return passwordTest.evaluate(with: password)
    }
}

