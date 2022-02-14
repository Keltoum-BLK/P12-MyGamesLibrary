//
//  CustomLayout.swift
//  MyGamesLibrary
//
//  Created by Kel_Jellysh on 14/02/2022.
//

import UIKit

class CustomLayout {
     
    func setUp(height: CGFloat, width: CGFloat) -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: width, height: height)
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 20
        return layout
    }
}
