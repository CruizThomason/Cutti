//
//  BarberDetailViewController.swift
//  Cutti
//
//  Created by cruizthomason on 4/24/18.
//  Copyright © 2018 Cruiz. All rights reserved.
//

import UIKit

class BarberProfileViewController: UIViewController {

    @IBOutlet weak var barberProfileImageView: UIImageView!
    @IBOutlet weak var barberNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    func updateViews() {
        if let currentBarber = BarberController.shared.currentBarber {
            barberNameLabel.text = currentBarber.username
        }
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
