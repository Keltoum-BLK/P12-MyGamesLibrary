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
    
    //MARK: methods to add Gradient Layer
    func addGradientLayerInBackground(frame: CGRect, colors:[UIColor]){
        let gradient = CAGradientLayer()
        gradient.frame = frame
        gradient.startPoint = CGPoint(x: 1, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.colors = colors.map{$0.cgColor}
        gradient.locations = [0.5,1]
        self.layer.sublayers?.removeAll()
        gradient.removeFromSuperlayer()
        self.layer.insertSublayer(gradient, at: 0)
    }
}

