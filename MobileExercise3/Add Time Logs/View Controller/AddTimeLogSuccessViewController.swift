//
//  AddTimeLogSuccessViewController.swift
//  MobileExercise3
//
//  Created by Charmagne Adonis on 11/24/20.
//  Copyright © 2020 Charmagne Adonis. All rights reserved.
//

import UIKit

class AddTimeLogSuccessViewController: UIViewController {

    @IBOutlet weak var type: UITextField!
    @IBOutlet weak var time: UITextField!
    var userID: String!, selectedType: String!, timeInputted: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        type.text = selectedType
        time.text = timeInputted
    }
    
    @IBAction func ok(_ sender: Any) {
        performSegue(withIdentifier: "successUnwindToTimeLogsViewController", sender: self)
    }
}
