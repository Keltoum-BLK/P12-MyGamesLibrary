//
//  File.swift
//  MyGameStore
//
//  Created by Kel_Jellysh on 07/02/2022.
//

import Foundation
import UIKit

extension UILabel {
    //MARK: Method to get margins in an UILabel
    func setMargins(margin: CGFloat = 20) {
        if let textString = self.text {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.firstLineHeadIndent = margin
            paragraphStyle.headIndent = margin
            paragraphStyle.tailIndent = -margin
            let attributedString = NSMutableAttributedString(string: textString)
            attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
            attributedText = attributedString
        }
    }
}
