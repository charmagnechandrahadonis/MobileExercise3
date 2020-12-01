//
//  AddTimeLogViewController.swift
//  MobileExercise3
//
//  Created by Charmagne Adonis on 11/24/20.
//  Copyright © 2020 Charmagne Adonis. All rights reserved.
//

import UIKit

class AddTimeLogViewController: UIViewController {

    @IBOutlet weak var typePicker: UITextField!
    @IBOutlet var keyboardToolbar: UIToolbar!
    var selectedType: String?, selectedTypeIndex: Int?, userID: String!
    var typeList = ["", "Time In", "Break Out", "Break In", "Time Out"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        
        typePicker.inputAccessoryView = keyboardToolbar
        
        createPickerView()
    }
    
    func createPickerView() {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        typePicker.inputView = pickerView
    }

    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didClick(_ sender: Any) {
        view.endEditing(true)
    }
    
    @IBAction func done(_ sender: Any) {
        let child = SpinnerViewController()
        createSpinnerView(with: child)
        
        guard let selectedTypeIndex = selectedTypeIndex else {
            createErrorAlert(message: "Please make sure to choose a type.", child: child)
            return
        }
        
        //creating URLRequest
        let url = URL(string: "http://13.228.251.27:8080/MobileAppTraining/AppTrainingAddTimeLog.htm")!

        //setting the method to post
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        //creating the post parameter by concatenating the keys and values from text field
        let postData = "userID=" + userID + "&type=" + String(selectedTypeIndex)
//        print ("Post Data Check: \(postData)")

        //adding the parameters to request body
        request.httpBody = postData.data(using: String.Encoding.utf8)

        //creating a task to send the post request
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
         data, response, error in
            
            guard let data = data else {
                DispatchQueue.main.async {
                    self.createErrorAlert(message: error!.localizedDescription, child: child)
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
                let connection = try JSONDecoder().decode(AddTimeLogResponse.self, from: data)
//                print (connection)

                guard connection.status == "0" else {
                    DispatchQueue.main.async {
                        self.createErrorAlert(message: connection.message, child: child)
                    }
                                        
                    return
                }
                
                DispatchQueue.main.async {
                    self.removeSpinnerView(from: child)
                    self.performSegue(withIdentifier: "toAddTimeLogSuccess", sender: self)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAddTimeLogSuccess" {
            let addTimeLogSuccess = segue.destination as! AddTimeLogSuccessViewController
            addTimeLogSuccess.userID = userID
            addTimeLogSuccess.selectedType = selectedType

            let currentDate = Date()
            let format = DateFormatter()
            format.timeZone = .current
            format.dateFormat = "h:mm a"
            let dateString = format.string(from: currentDate)
            
            addTimeLogSuccess.timeInputted = dateString
        }
    }
}

// MARK: UIViewPicker and TextField Delegates

extension AddTimeLogViewController: UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        typeList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return typeList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedType = typeList[row] // selected item
        typePicker.text = selectedType
        selectedTypeIndex = row
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
}
