//
//  UIImageView+Extension.swift
//  MyGamesLibrary
//
//  Created by Kel_Jellysh on 14/02/2022.
//
import UIKit

extension UIImageView {
    //MARK: convert url to imageView
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleToFill) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            DispatchQueue.main.async {
                guard
                    let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                    let mimeType = response?.mimeType, mimeType.hasPrefix(""),
                    let data = data, error == nil,
                    let image = UIImage(data: data)
                else { return }
                DispatchQueue.main.async() {
                    self?.image = image
                }
            }
        }.resume()
    }
    
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleToFill) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
    
}
