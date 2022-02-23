//
//  UIImageView+Extension.swift
//  MyGamesLibrary
//
//  Created by Kel_Jellysh on 14/02/2022.
//
import UIKit
let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
  func cacheImage(urlString: String){
    let url = URL(string: urlString)
    
    image = nil
    
    if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
        self.image = imageFromCache
        return
    }
      guard let urlImage = url else { return }
    URLSession.shared.dataTask(with: urlImage) {
        data, response, error in
        if data != nil {
              DispatchQueue.main.async {
                  guard let imageData = data else { return }
                  guard  let imageToCache = UIImage(data: imageData) else { return }
                  imageCache.setObject(imageToCache, forKey: urlString as AnyObject)
                  self.image = imageToCache
              }
          }
     }.resume()
  }
}
