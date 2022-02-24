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
    
    func setUpShadowTableCell(color: CGColor, cell: UITableViewCell) {
        cell.layer.shadowOpacity = 1
        cell.layer.shadowColor = color
        cell.layer.shadowOffset = CGSize(width: 0, height: 5)
        cell.layer.shadowRadius = 5
        cell.selectionStyle = .none
    }
    
    func setUpShadowView(color: CGColor, view: UIView) {
        view.layer.shadowOpacity = 1
        view.layer.shadowColor = color
        view.layer.shadowOffset = CGSize(width: 5, height: 5)
        view.layer.shadowRadius = 5
    }
    func setUpShadowCollectionCell(color: CGColor, cell: UICollectionViewCell) {
        cell.layer.shadowOpacity = 1
        cell.layer.shadowColor = color
        cell.layer.shadowOffset = CGSize(width: 0, height: 3)
        cell.layer.shadowRadius = 5
    }
    
    func getDoubleToString(number : Double?)-> (String) {
        //convert a Int? to String
        // unwrapped the optional with a guard let syntax
        guard let fullNumber = number  else { return "N/A"}
        let numberValue = Int(fullNumber)
        //convert a Int? to String
        let ID = String(numberValue)
        
        return ID
    }
}
