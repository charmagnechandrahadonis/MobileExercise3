//
//  SuccessPage.swift
//  MobileExercise1
//
//  Created by Charmagne Adonis on 10/22/20.
//  Copyright © 2020 Charmagne Adonis. All rights reserved.
//

import UIKit

class SuccessPageViewController: UIViewController {
    
    var employee = EmployeeDetails(userID: "", firstName: "", middleName: nil, lastName: "", idNumber: "", emailAddress: "", mobileNumber: "", landline: nil)
    
    @IBAction func okButton(_ sender: Any) {
        performSegue(withIdentifier: "unwindToProfile", sender: self)
    }
}
