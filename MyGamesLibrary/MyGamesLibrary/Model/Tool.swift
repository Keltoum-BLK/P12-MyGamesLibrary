//
//  Tool.swift
//  MyGamesLibrary
//
//  Created by Kel_Jellysh on 12/02/2022.
//

import Foundation
import UIKit

class Tool {
    
    static let shared = Tool()
    
    func setUpShadowCell(color: CGColor, cell: UITableViewCell) {
        cell.layer.shadowOpacity = 1
        cell.layer.shadowColor = color
        cell.layer.shadowOffset = CGSize(width: 0, height: 5)
        cell.layer.shadowRadius = 5
        cell.selectionStyle = .none
    }
}
