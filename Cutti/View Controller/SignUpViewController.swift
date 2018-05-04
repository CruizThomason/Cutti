//
//  BarberSignUpViewController.swift
//  Cutti
//
//  Created by cruizthomason on 5/3/18.
//  Copyright © 2018 Cruiz. All rights reserved.
//

import UIKit
import MapKit

class SignUpViewController: ShiftableViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var addressForBusinessTextField: UITextField!
    @IBOutlet weak var nameOfBusinessTextField: UITextField!
    @IBOutlet weak var barberProfileImage: UIImageView!
    
    
    var locationManager = CLLocationManager()
    var authorizationStatus: CLAuthorizationStatus?
    var currentLocation: CLLocation?
    var isABarber = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        requestAuthorization()
        
        usernameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPassword.delegate = self
        addressForBusinessTextField.delegate = self
        nameOfBusinessTextField.delegate = self
        
    }
    @IBAction func barberProfileImage(_ sender: Any) {
        
    }
    
    @IBAction func yesButtonTapped(_ sender: Any) {
        isABarber = true
    }
    
    @IBAction func noButtonTapped(_ sender: Any) {
        isABarber = false
    }
    
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        guard let email = emailTextField.text,
            let username = usernameTextField.text,
            let password = passwordTextField.text,
            let confirmPassword = confirmPassword.text else { return }
        
        guard password == confirmPassword else {
            
            presentSimpleAlert(title: "Unable to match Password", message: "Password does not match with Confirm Password. Please try again.")
            return
            
        }
        guard email.contains("@") && email.contains(".") else {
            presentSimpleAlert(title: "Invalid Email", message: "Please enter in a valid email address.")
            
            return
        }
        
        activityIndicator.startAnimating()
        
        guard let location = currentLocation else { return }
        
        if isABarber {
            
            
            BarberController.shared.createBarberWith(username: username, email: email, latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, password: password) { (success) in
                
                DispatchQueue.main.async {
                    if !success {
                        self.activityIndicator.stopAnimating()
                        
                        self.presentSimpleAlert(title: "Unable to create an account", message: "Make sure you have a network connection, and please try again.")
                        self.activityIndicator.stopAnimating()
                    } else {
                        self.performSegue(withIdentifier: "toProfileVC", sender: self)
                        
                    }
                }
            }
        } else {
            ClientController.shared.createClientWith(username: username, email: email, password: password) { (success) in
                DispatchQueue.main.async {
                    if !success {
                        self.activityIndicator.stopAnimating()
                        
                        self.presentSimpleAlert(title: "Unable to create an account", message: "Make sure you have a network connection, and please try again.")
                        self.activityIndicator.stopAnimating()
                    } else if success == true {
                        self.performSegue(withIdentifier: "toProfileVC", sender: self)
                    }
                    return
                    
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestAuthorization()
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        authorizationStatus = status
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last
    }
    
    func requestAuthorization() {
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else {
            authorizationStatus = CLLocationManager.authorizationStatus()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
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
