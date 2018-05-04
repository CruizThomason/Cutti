//
//  ProfileViewController.swift
//  Cutti
//
//  Created by cruizthomason on 4/30/18.
//  Copyright © 2018 Cruiz. All rights reserved.
//

import UIKit

class ClientProfileViewController: UIViewController {

    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var client: Client?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViews()
    }
    
    func updateViews() {
        
        guard let currentClient = ClientController.shared.currentClient else { return }
        
        welcomeLabel.text = "Welcome, \(currentClient.username)!"
        
        
    }
    
    func updateViewForCellWith(image: UIImage) {
        
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
