//
//  ProfilePage.swift
//  MobileExercise1
//
//  Created by Charmagne Adonis on 10/21/20.
//  Copyright © 2020 Charmagne Adonis. All rights reserved.
//

import UIKit

class ProfilePageViewController: UIViewController {
    
    // MARK: Properties
    @IBOutlet weak var firstNameInitialLabel: UILabel!
    @IBOutlet weak var lastNameInitialLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userIDLabel: UILabel!
    @IBOutlet weak var emailAddressLabel: UILabel!
    @IBOutlet weak var mobileNumberLabel: UILabel!
    @IBOutlet weak var roundedRectangle: UIView!
    @IBOutlet weak var circle: UIView!
    var employee: EmployeeDetails!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        drawShapes()
        displayText()
    }
    
    // MARK: Actions
    @IBAction func logout(_ sender: Any) {
        performSegue(withIdentifier: "unwindToLogin", sender: self)
    }
    
    @IBAction func unwindToProfile( _ seg: UIStoryboardSegue) {
        if let sourceViewController = seg.source as? SuccessPageViewController {
            employee = sourceViewController.employee
        }
        
        displayText()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toUpdateProfile" {
            let navVC = segue.destination as! UINavigationController
            let updateProfile = navVC.viewControllers.first as! UpdateProfileViewController
            
            updateProfile.employee = employee
        }
    }
    
    // MARK: Shapes
    func drawShapes() {
        roundedRectangle.layer.borderWidth = 1
        roundedRectangle.layer.borderColor = UIColor.lightGray.cgColor
        roundedRectangle.layer.cornerRadius = 10
        
        circle.layer.cornerRadius = circle.frame.size.width/2
    }
    
    // MARK: Text Display
    
    func displayText() {
         let emailSplit = employee.emailAddress.components(separatedBy: "@")
        let maskedEmail = employee.emailAddress.replacingOccurrences(of: emailSplit[0].suffix(5), with: "*****")

        let mobileFormat = formatNumber(with: "+XX XXX XXX XXXX", phone: employee.mobileNumber)
//        let maskedDigits = mobileFormat[(mobileFormat.index(mobileFormat.startIndex, offsetBy: 8)) ..< (mobileFormat.index(mobileFormat.startIndex, offsetBy: 11))]
//        let maskedMobile = mobileFormat.replacingOccurrences(of: maskedDigits, with: "***")
        
        let firstMaskedDigit = employee.mobileNumber.index(mobileFormat.startIndex, offsetBy: 8, limitedBy: mobileFormat.endIndex) ?? mobileFormat.startIndex
        let lastMaskedDigit = employee.mobileNumber.index(mobileFormat.startIndex, offsetBy: 11, limitedBy: mobileFormat.endIndex) ?? mobileFormat.endIndex
        let maskedDigits = firstMaskedDigit ..< lastMaskedDigit
        let maskedMobile = mobileFormat.replacingOccurrences(of: mobileFormat[maskedDigits], with: "***")
        
        userIDLabel.text = employee.idNumber
        emailAddressLabel.text = maskedEmail
        mobileNumberLabel.text = maskedMobile
                
        addInitials()
        addFullName()
    }
    
    func addInitials() {
        if let firstNameInitial = employee.firstName.first {
            firstNameInitialLabel.text = "\(firstNameInitial.uppercased())"
        }
        
        else {
            firstNameInitialLabel.text = ""
        }
        
        if let lastNameInitial = employee.lastName.first {
            lastNameInitialLabel.text = "\(lastNameInitial.uppercased())"
        }
        
        else {
            lastNameInitialLabel.text = ""
        }
    }
    
    func addFullName() {
        guard
            let middleName = employee.middleName,
            middleName != ""
            
        else {
            nameLabel.text = "\(employee.firstName.uppercased()) \(employee.lastName.uppercased())"
            return
        }

        nameLabel.text = "\(employee.firstName.uppercased()) \(middleName.uppercased()) \(employee.lastName.uppercased())"
    }
    
    func formatNumber(with mask: String, phone: String) -> String {
        let numbers = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var index = numbers.startIndex // numbers iterator

        // iterate over the mask characters until the iterator of numbers ends
        for ch in mask where index < numbers.endIndex {
            if ch == "X" {
                // mask requires a number in this place, so take the next one
                result.append(numbers[index])

                // move numbers iterator to the next index
                index = numbers.index(after: index)

            } else {
                result.append(ch) // just append a mask character
            }
        }
        return result
    }
}
