//
//  BarberViewController.swift
//  Cutti
//
//  Created by cruizthomason on 4/20/18.
//  Copyright © 2018 Cruiz. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        
        guard email.contains("@") && email.contains(".") else {
            presentSimpleAlert(title: "Invalid Email", message: "Please enter in a valid email address.")
            
            return
        }
        
        BarberController.shared.fetchBarberWithEmailPassword(email: email, password: password) { (success) in
            if success == false {
                DispatchQueue.main.async {
                self.presentSimpleAlert(title: "Wrong Email or Password", message: "Entered wrong email or password. Please try again.")
                }
            } else {
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "toProfileVC", sender: self)
                }
            }
        }
    }
    
    func presentSimpleAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        
        alert.addAction(dismissAction)
        
        self.present(alert, animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
