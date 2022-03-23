//
//  UIViewController+Extension.swift
//  MyGamesLibrary
//
//  Created by Kel_Jellysh on 20/02/2022.
//

import UIKit
import CoreData

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
            self.dismiss(animated: true, completion: nil)
        }))
          self.present(alert, animated: true)
      }
    
    func errorAlert(_ message: String, _ controller: UIViewController) {
        let c = UIAlertController(title: "Une erreur est survenue", message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        c.addAction(ok)
        controller.present(c, animated: true, completion: nil)
    }
}


