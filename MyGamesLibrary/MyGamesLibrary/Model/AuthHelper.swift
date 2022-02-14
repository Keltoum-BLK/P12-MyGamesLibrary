//
//  AuthHelper.swift
//  mon jardin secret
//
//  Created by matthieu passerel on 04/09/2019.
//  Copyright © 2019 matthieu passerel. All rights reserved.
//

import UIKit
import LocalAuthentication

class AuthHelper {
    
   static func startAuth(_ completion: ((_ success: Bool, _ errStr: String?)-> Void)?) {
        let context = LAContext()
        let policy: LAPolicy = .deviceOwnerAuthentication
        let reason = "Accéder à My Games Library"
        var error: NSError?
        if context.canEvaluatePolicy(policy, error: &error) {
            context.evaluatePolicy(policy, localizedReason: reason) { (success, err) in
                DispatchQueue.main.async {
                    if err != nil {
                        completion?(false, err!.localizedDescription)
                    }
                    if success == true {
                        completion?(true, nil)
                        
                    }
                }
            }
        } else {
            completion?(false, "Nous ne pouvons pas procéder à l'auth")
        }
    }
}
