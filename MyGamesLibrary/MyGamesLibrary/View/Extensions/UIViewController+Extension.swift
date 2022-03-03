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
            self.dismiss(animated: true)
        }))
          self.present(alert, animated: true)
      }
    
    func errorAlert(_ message: String, _ controller: UIViewController) {
        let c = UIAlertController(title: "Une erreur est survenue", message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        c.addAction(ok)
        controller.present(c, animated: true, completion: nil)
    }
    
    func showToast(message: String, seconds: Double = 3.0) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.view.backgroundColor = .black
        alert.view.alpha = 0.6
        alert.view.layer.cornerRadius = 15
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            alert.dismiss(animated: true)
        }
    }
    
    func setupNavigationBack() {
        let backButton = UIBarButtonItem()
        backButton.image = UIImage(systemName: "arrowshape.turn.up.left.fill")
        navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
}


