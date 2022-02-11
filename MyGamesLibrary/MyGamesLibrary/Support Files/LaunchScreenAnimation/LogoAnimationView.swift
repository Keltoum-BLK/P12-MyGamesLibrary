//
//  LogoAnimationView.swift
//  MyGameStore
//
//  Created by Kel_Jellysh on 07/02/2022.
//

import Foundation
import SwiftyGif

class LogoAnimationView: UIView {

    let logoGifImageView: UIImageView = {
       guard let gifImage = try? UIImage(gifName: "logoGif.gif") else {
           return UIImageView()
       }
       return UIImageView(gifImage: gifImage, loopCount: 2)
   }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        backgroundColor = .white
        addSubview(logoGifImageView)
        logoGifImageView.layer.borderColor = UIColor.white.cgColor
        logoGifImageView.layer.borderWidth = 10
        logoGifImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            logoGifImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            logoGifImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            logoGifImageView.widthAnchor.constraint(equalToConstant: 300),
            logoGifImageView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
}
