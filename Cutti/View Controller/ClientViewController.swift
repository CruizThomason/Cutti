//
//  ClientViewController.swift
//  Cutti
//
//  Created by cruizthomason on 4/20/18.
//  Copyright © 2018 Cruiz. All rights reserved.
//

import UIKit

class ClientViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(segueToProfileVC), name: ClientController.shared.currentClientWasSetNotification, object: nil)
    }
    
    @objc func segueToProfileVC() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "toProfileVC", sender: self)
        }
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        
        guard let email = emailTextField.text,
            let username = usernameTextField.text else { return }
        
        activityIndicator.startAnimating()
        
        ClientController.shared.createClientWith(username: username, email: email) { (success) in
            
            self.activityIndicator.stopAnimating()
            
            if !success {
                DispatchQueue.main.async {
                    self.presentSimpleAlert(title: "Unable to create an account", message: "Make sure you have a network connection, and please try again.")
                    self.activityIndicator.stopAnimating()
                }
                return
            }
        }
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        
        guard ClientController.shared.currentClient == nil else { segueToProfileVC(); return }
        
        activityIndicator.startAnimating()
        
        ClientController.shared.fetchCurrentClient { (success) in
            
            if !success {
                
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    
                    self.presentSimpleAlert(title: "No iCloud account configured", message: "Please sign into iCloud in your device's settings and try again.")
                }
                return
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
