//
//  UITextField+Extension.swift
//  MyGamesLibrary
//
//  Created by Kel_Jellysh on 16/02/2022.
//

import Foundation
import UIKit

extension UITextField {
    //MARK: Method to put placeholder text color in black
    func changeThePLaceholderFont(text: String, textField: UITextField) {
        let fontPlaceholderText = NSAttributedString(string: text, attributes: [NSAttributedString.Key.font: UIFont(name: "Menlo", size: 15) as Any, NSAttributedString.Key.foregroundColor: UIColor.gray])
            textField.attributedPlaceholder = fontPlaceholderText
    }
    
}
