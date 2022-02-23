//
//  UIViewController+Extension.swift
//  MyGamesLibrary
//
//  Created by Kel_Jellysh on 20/02/2022.
//

import UIKit

extension UIViewController {
    //MARK: Pop-Up Alert 
    func showAlertMessage(title: String, message: String) {
          let alert = UIAlertController(title: "\(title)", message: "\(message)", preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
          self.present(alert, animated: true)
      }
    
    func showAlertMessageBeforeToDismiss(title: String, message: String) {
          let alert = UIAlertController(title: "\(title)", message: "\(message)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { UIAlertAction in
            self.dismiss(animated: true)
        }))
          self.present(alert, animated: true)
      }
}
