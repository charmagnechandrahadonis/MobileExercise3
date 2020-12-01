//
//  ViewController.swift
//  MobileExercise1
//
//  Created by Charmagne Adonis on 10/20/20.
//  Copyright © 2020 Charmagne Adonis. All rights reserved.
//

import SafariServices
import UIKit

class LoginViewController: UIViewController {

    // MARK: Properties
    @IBOutlet weak var userIDInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet var keyboardToolbar: UIToolbar!
    var employee = EmployeeDetails(userID: "", firstName: "", middleName: nil, lastName: "", idNumber: "", emailAddress: "", mobileNumber: "", landline: nil)
    var userID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        
        userIDInput.inputAccessoryView = keyboardToolbar
        passwordInput.inputAccessoryView = keyboardToolbar
    }
    
    // MARK: Actions
    @IBAction func login(_ sender: Any) {
        let child = SpinnerViewController()
        createSpinnerView(with: child)
        
        guard
            let userID = userIDInput.text, let password = passwordInput.text,
            userID != "" && password != ""
            
        else {
            removeSpinnerView(from: child)
            errorLabel.text = "Please enter your User ID and Password."
            errorLabel.backgroundColor = UIColor.white
            return
        }
        
        self.userID = userID
                    
        //creating URLRequest
        let url = URL(string: "http://13.228.251.27:8080/MobileAppTraining/AppTrainingLogin.htm")!

        //setting the method to post
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        //creating the post parameter by concatenating the keys and values from text field
        let postData = "userID=" + userID + "&password=" + password

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
            
//            guard let responseData = String(data: data, encoding: String.Encoding.utf8) else { return }
//
//            if let httpResponse = response as? HTTPURLResponse {
//                print(httpResponse.statusCode)
//                print (HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode))
//            }
//
//            guard let responseData = String(data: data, encoding: String.Encoding.utf8) else { return }
            
//            guard let response = response as? HTTPURLResponse else {
//                print ("Cannot create HTTPURLResponse")
//                return
//            }
                        
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
                let connection = try JSONDecoder().decode(LoginResponse.self, from: data)
                print (connection)

                guard let user = connection.user else {
                    guard let message = connection.message else { return }

                    DispatchQueue.main.async {
                        self.removeSpinnerView(from: child)
                        self.errorLabel.text = message
                        self.errorLabel.backgroundColor = UIColor.white
                    }

                    return
                }

                self.employee = user
                
                DispatchQueue.main.async {
                    self.removeSpinnerView(from: child)
                    self.performSegue(withIdentifier: "toTabBarController", sender: self)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toTabBarController" {
            let tabVC = segue.destination as! UITabBarController
            
            let timeLogNavVC = tabVC.viewControllers?[0] as! UINavigationController
            let timeLog = timeLogNavVC.viewControllers.first as! TimeLogsViewController
            timeLog.userID = userID
            
            let profileNavVC = tabVC.viewControllers?[3] as! UINavigationController
            let profilePage = profileNavVC.viewControllers.first as! ProfilePageViewController
            profilePage.employee = employee
        }
    }

    @IBAction func openWebpage(_ sender: Any) {
        openLink("http://www.terasystem.com")
    }
    
    @IBAction func didClick(_ sender: Any) {
        view.endEditing(true)
    }
    
    @IBAction func unwindToLogin( _ seg: UIStoryboardSegue) {
        userIDInput.text = ""
        passwordInput.text = ""
        errorLabel.text = ""
    }
    
    private func openLink(_ stringURL: String) {
        guard let url = URL(string: stringURL) else {
            return
        }

        // Present SFSafariViewController
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true, completion: nil)
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

// MARK: UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
