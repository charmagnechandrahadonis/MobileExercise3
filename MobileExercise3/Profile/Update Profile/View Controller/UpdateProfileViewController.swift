//
//  UpdateProfile.swift
//  MobileExercise1
//
//  Created by Charmagne Adonis on 10/21/20.
//  Copyright © 2020 Charmagne Adonis. All rights reserved.
//

import UIKit

class UpdateProfileViewController: UIViewController, UITextFieldDelegate {

    // MARK: Properties
    @IBOutlet weak var userIDInput: UITextField!
    @IBOutlet weak var firstNameInput: UITextField!
    @IBOutlet weak var middleNameInput: UITextField!
    @IBOutlet weak var lastNameInput: UITextField!
    @IBOutlet weak var emailAddressInput: UITextField!
    @IBOutlet weak var mobileNumberInput: UITextField!
    @IBOutlet weak var landlineInput: UITextField!
    @IBOutlet weak var firstNameError: UILabel!
    @IBOutlet weak var lastNameError: UILabel!
    @IBOutlet weak var emailAddressError: UILabel!
    @IBOutlet weak var mobileNumberError: UILabel!
    @IBOutlet weak var keyboardToolbar: UIToolbar!
    @IBOutlet weak var scrollView: UIScrollView!
    var employee: EmployeeDetails!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        
        firstNameInput.inputAccessoryView = keyboardToolbar
        middleNameInput.inputAccessoryView = keyboardToolbar
        lastNameInput.inputAccessoryView = keyboardToolbar
        emailAddressInput.inputAccessoryView = keyboardToolbar
        mobileNumberInput.inputAccessoryView = keyboardToolbar
        landlineInput.inputAccessoryView = keyboardToolbar

        userIDInput.text = employee.idNumber
        firstNameInput.text = employee.firstName
        middleNameInput.text = employee.middleName
        lastNameInput.text = employee.lastName
        emailAddressInput.text = employee.emailAddress
        
        guard let landline = employee.landline else { return }
        
        mobileNumberInput.text = formatNumber(with: "+XX XXX XXX XXXX", phone: employee.mobileNumber)
        landlineInput.text = formatNumber(with: "+XX XX XXXX XXXX", phone: landline)
        
        NotificationCenter.default.addObserver(
          self,
          selector: #selector(keyboardWillShow(_:)),
          name: UIResponder.keyboardWillShowNotification,
          object: nil)

        NotificationCenter.default.addObserver(
          self,
          selector: #selector(keyboardWillHide(_:)),
          name: UIResponder.keyboardWillHideNotification,
          object: nil)
    }
    
    // MARK: UITextFieldDelegates
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        guard let text = textField.text else { return false }
        let newString = (text as NSString).replacingCharacters(in: range, with: string)

        if textField == mobileNumberInput {
            textField.text = formatNumber(with: "+XX XXX XXX XXXX", phone: newString)
            return false
        }

        if textField == landlineInput {
            textField.text = formatNumber(with: "+XX X XXXX XXXX", phone: newString)
            return false
        }

        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSuccess" {
            let successPage = segue.destination as! SuccessPageViewController
            
            successPage.employee = employee
        }
    }
    
    //MARK: Actions
    @IBAction func closeProfile(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didClick(_ sender: Any) {
        view.endEditing(true)
    }
    
    @IBAction func updateProfile(_ sender: Any) {
        let child = SpinnerViewController()
        createSpinnerView(with: child)
        
        guard
            let middleName = middleNameInput.text,
            let landline = landlineInput.text
        else {
            return
        }
        
        guard
            let firstName = firstNameInput.text, firstName != "",
            let lastName = lastNameInput.text, lastName != "",
            let emailAddress = emailAddressInput.text, emailAddress != "",
            let mobileNumber = mobileNumberInput.text, mobileNumber != ""
            
        else {
            
            if firstNameInput.text == "" {
                firstNameError.text = "This is a required field."
                firstNameError.textColor = UIColor.red
            }
            
            if lastNameInput.text == "" {
                lastNameError.text = "This is a required field."
                lastNameError.textColor = UIColor.red
            }
            
            if emailAddressInput.text == "" {
                emailAddressError.text = "This is a required field."
                emailAddressError.textColor = UIColor.red
            }
            
            if mobileNumberInput.text == "" {
                mobileNumberError.text = "This is a required field."
                mobileNumberError.textColor = UIColor.red
            }
            
            return
        }
        
        //creating URLRequest
        let url = URL(string: "http://13.228.251.27:8080/MobileAppTraining/AppTrainingUpdateProfile.htm")!

        //setting the method to post
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        //creating the post parameter by concatenating the keys and values from text field
        let postData = "userID=" + employee.userID + "&firstName=" + firstName + "&middleName=" + middleName + "&lastName=" + lastName + "&emailAddress=" + emailAddress + "&mobileNumber=" + mobileNumber + "&landline=" + landline
        
        //adding the parameters to request body
        request.httpBody = postData.data(using: String.Encoding.utf8)

        //creating a task to send the post request
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
         data, response, error in
            
            guard let data = data else {
                DispatchQueue.main.async {
                    self.createErrorAlert(message: error?.localizedDescription, child: child)
                }
                
                return
            }
            
            if let response = response as? HTTPURLResponse {
                guard (200...299).contains(response.statusCode) else {
                    print ("\(response.statusCode) - \(HTTPURLResponse.localizedString(forStatusCode: response.statusCode))")
                    
                    DispatchQueue.main.async {
                        self.createErrorAlert(message: "\(response.statusCode) - \(HTTPURLResponse.localizedString(forStatusCode: response.statusCode))", child: child)
                    }
                    
                    return
                }
                
                guard let mime = response.mimeType, mime == "application/json" else {
                    print("Wrong MIME type!")
                    
                    DispatchQueue.main.async {
                        self.createErrorAlert(message: "Received non-JSON response", child: child)
                    }
                    
                    return
                }
            }

            do {
                let connection = try JSONDecoder().decode(UpdateProfile.self, from: data)
                print (connection)
                
                guard connection.status == "0" else {
                    guard let message = connection.message else { return }
                    
                    DispatchQueue.main.async {
                        self.createErrorAlert(message: message, child: nil)
                    }
                                        
                    return
                }
                
                self.employee = EmployeeDetails(userID: self.employee.userID, firstName: firstName, middleName: middleName, lastName: lastName, idNumber: self.employee.idNumber, emailAddress: emailAddress, mobileNumber: mobileNumber, landline: landline)
                
                DispatchQueue.main.async {
                    self.removeSpinnerView(from: child)
                    self.performSegue(withIdentifier: "toSuccess", sender: self)
                }
                
            }

            catch let DecodingError.dataCorrupted(context) {
                print(context)
                self.createErrorAlert(message: "A context error occurred.", child: child)
                
            } catch let DecodingError.keyNotFound(key, context) {
                print("Key '\(key)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
                self.createErrorAlert(message: "Key '\(key)' not found:", child: child)
            
            } catch let DecodingError.valueNotFound(value, context) {
                print("Value '\(value)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
                self.createErrorAlert(message: "Value '\(value)' not found:", child: child)
            
            } catch let DecodingError.typeMismatch(type, context)  {
                print("Type '\(type)' mismatch:", context.debugDescription)
                print("codingPath:", context.codingPath)
                self.createErrorAlert(message: "Type '\(type)' mismatch:", child: child)
            
            } catch {
                print("error: ", error)
                self.createErrorAlert(message: error.localizedDescription, child: child)
            }
        }

        //executing the task
        task.resume()
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
    
    // MARK: Keyboard Adjust

    //1
    func adjustInsetForKeyboardShow(_ show: Bool, notification: Notification) {
      guard
        let userInfo = notification.userInfo,
        let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey]
          as? NSValue
        else {
          return
      }
        
      let adjustmentHeight = (keyboardFrame.cgRectValue.height + 20) * (show ? 1 : -1)
      scrollView.contentInset.bottom += adjustmentHeight
      scrollView.verticalScrollIndicatorInsets.bottom += adjustmentHeight
    }
      
    //2
    @objc func keyboardWillShow(_ notification: Notification) {
      adjustInsetForKeyboardShow(true, notification: notification)
    }
    @objc func keyboardWillHide(_ notification: Notification) {
      adjustInsetForKeyboardShow(false, notification: notification)
    }
    
    func createSpinnerView(with child: SpinnerViewController) {

        // add the spinner view controller
        addChild(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    func removeSpinnerView(from child: SpinnerViewController) {
        child.willMove(toParent: nil)
        child.view.removeFromSuperview()
        child.removeFromParent()
    }
    
    func createErrorAlert(message: String?, child: SpinnerViewController?) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)

        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) 
        alert.addAction(okAction)

        guard let child = child else { return }
        self.removeSpinnerView(from: child)
        self.present(alert, animated: true, completion: nil)
    }
}
