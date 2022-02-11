//
//  UIView+Extension.swift
//  MyGameStore
//
//  Created by Kel_Jellysh on 07/02/2022.
//

import Foundation
import UIKit

extension UIView {
    
    //MARK: COnstraints of GifImage
    func pinEdgesToSuperView() {
        guard let superView = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: superView.topAnchor).isActive = true
        trailingAnchor.constraint(equalTo: superView.trailingAnchor).isActive = true
        bottomAnchor.constraint(equalTo: superView.bottomAnchor).isActive = true
        leadingAnchor.constraint(equalTo: superView.leadingAnchor).isActive = true
    }
}
