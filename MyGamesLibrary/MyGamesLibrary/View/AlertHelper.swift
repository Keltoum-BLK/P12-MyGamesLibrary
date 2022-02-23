//
//  AlertHelper.swift
//  mon jardin secret
//
//  Created by matthieu passerel on 04/09/2019.
//  Copyright © 2019 matthieu passerel. All rights reserved.
//

import UIKit

class AlertHelper {
    
    func errorAlert(_ message: String, _ controller: UIViewController) {
        let c = UIAlertController(title: "Une erreur est survenue", message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        c.addAction(ok)
        controller.present(c, animated: true, completion: nil)
    }
}
