//
//  LoginViewController.swift
//  MyCardBook
//
//  Created by Yurii Vients on 10/30/17.
//  Copyright © 2017 Yurii Vients. All rights reserved.
//

import UIKit
import LocalAuthentication

class LoginViewController: UIViewController {
    
        @IBOutlet private weak var backgroundImageView: UIImageView!
        @IBOutlet private weak var loginView: UIView!
    
        @IBOutlet private weak var emailTextField: UITextField!
        @IBOutlet private weak var passwordTextField: UITextField!
    
        var blurEffectView: UIVisualEffectView?
        var isAuthenticated: Bool? = false
        var user : String?
        override func viewDidLoad() {
            super.viewDidLoad()
            
            loginView.layer.cornerRadius = 20
            backgroundEffect()
            loginView.isHidden = true
            authenticateWithTouchID()
        }
    
        func backgroundEffect()  {
            backgroundImageView.image = UIImage(named: "cloud")
    
            let blurEffect = UIBlurEffect(style: .dark)
            blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView?.frame = view.bounds
    
            backgroundImageView.addSubview(blurEffectView!)
        }
    
        override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
             blurEffectView?.frame = view.bounds
        }
    
        func authenticateWithTouchID() {
            // Get the local authentication context.
            let localAuthContext = LAContext()
            let reasonText = "Authentication is required to sign in CardBook"
            var authError: NSError?
            if !localAuthContext.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics,
                                                    error: &authError) {
    
                if let error = authError {
                    print(error.localizedDescription)
                  
                }
                
                    showLoginMenu()
//
            }
    
        // Perform the Touch ID authentication
        localAuthContext.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: reasonText, reply: { (success: Bool, error: Error?) -> Void in
    
            // Failure workflow
            if !success {
                    if let error = error {
                        switch error {
                        case LAError.authenticationFailed:
                            print("Authentication failed")
                        case LAError.passcodeNotSet:
                                print("Passcode not set")
                        case LAError.systemCancel:
                            print("Authentication was canceled by system")
                        case LAError.userCancel:
                            print("Authentication was canceled by the user")
                        case LAError.touchIDNotEnrolled:
                            print("Authentication could not start because Touch ID has no enrolled fingers.")
                        case LAError.touchIDNotAvailable:
                            print("Authentication could not start because Touch ID is not available.")
                        case LAError.userFallback:
                            print("User tapped the fallback button (Enter Password).")
                        default:
                            print(error.localizedDescription)
                        }
        }
    
            // Fallback to password authentication
                OperationQueue.main.addOperation({
                    self.showLoginMenu()

                })
            } else if success {
    
            // Success workflow
        print("Successfully authenticated")
               
                OperationQueue.main.addOperation({
                self.performSegue(withIdentifier: "showHomeScreen", sender: self.user)
                    
            })
    
            }})
    
    }
    
        func showLoginMenu() {
            // Move the login view off screen
            loginView.isHidden = false
            loginView.transform = CGAffineTransform(translationX: 0, y: -700)
    
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
    
                self.loginView.transform = CGAffineTransform.identity
    
            }, completion: nil)
    
        }
    func authenticate() {
        
        if emailTextField.text == "vients" && passwordTextField.text == "1234" {
            
            self.performSegue(withIdentifier: "showHomeScreen", sender: nil)
            
            
        }
        else {
            // Shake to indicate wrong login ID/password
            loginView.transform = CGAffineTransform(translationX: 25, y: 0)
            UIView.animate(withDuration: 0.2, delay: 0.0, usingSpringWithDamping:
                0.15, initialSpringVelocity: 0.3, options: .curveEaseInOut, animations: {
                    self.loginView.transform = CGAffineTransform.identity
            }, completion: nil)
        }
    }
        @IBAction func authenticateWithPassword(_ sender: Any) {
            authenticate()
            
        }
}


