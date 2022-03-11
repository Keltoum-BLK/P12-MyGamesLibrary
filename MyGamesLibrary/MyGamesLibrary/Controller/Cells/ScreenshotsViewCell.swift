//
//  ScreenshotsViewCell.swift
//  MyGamesLibrary
//
//  Created by Kel_Jellysh on 24/02/2022.
//

import UIKit

class ScreenshotsViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var gameImage: UIImageView!
    
    func setup(screenshot: ShortScreenshot) {
        gameImage.cacheImage(urlString: screenshot.image ?? "no image")
        gameImage.layer.cornerRadius = 20
    }
}
