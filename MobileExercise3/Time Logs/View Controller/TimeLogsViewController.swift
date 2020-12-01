//
//  TimeLogsTableViewController.swift
//  MobileExercise3
//
//  Created by Charmagne Adonis on 11/19/20.
//  Copyright © 2020 Charmagne Adonis. All rights reserved.
//

import UIKit

class TimeLogsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var timeLogs: [TimeLogDetails] = []
    var userID: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadTimeLogsData()
    }

    func loadTimeLogsData() {
        //creating URLRequest
        let url = URL(string: "http://13.228.251.27:8080/MobileAppTraining/AppTrainingGetTimeLogs.htm")!

        //setting the method to post
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        //creating the post parameter by concatenating the keys and values from text field
        let postData = "userID=" + userID
//        print ("Post Data Check: \(postData)")

        //adding the parameters to request body
        request.httpBody = postData.data(using: String.Encoding.utf8)

        //creating a task to send the post request
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
         data, response, error in
            
            guard let data = data else {
                DispatchQueue.main.async {
                    self.createErrorAlert(message: error!.localizedDescription)
                }
                
                return
            }
            
            if let response = response as? HTTPURLResponse {
                guard (200...299).contains(response.statusCode) else {
                    print ("\(response.statusCode) - \(HTTPURLResponse.localizedString(forStatusCode: response.statusCode))")
                    
                    DispatchQueue.main.async {
                        self.createErrorAlert(message: "\(response.statusCode) - \(HTTPURLResponse.localizedString(forStatusCode: response.statusCode))")
                    }
                    
                    return
                }
                
                guard let mime = response.mimeType, mime == "application/json" else {
                    print("Wrong MIME type!")
                    
                    DispatchQueue.main.async {
                        self.createErrorAlert(message: "Received non-JSON response")
                    }
                    
                    return
                }
            }
            
            do {
                let connection = try JSONDecoder().decode(TimeLogResponse.self, from: data)
                print (connection)

                guard let timeLogs = connection.timeLogs else {
                    guard let message = connection.message else { return }

                    DispatchQueue.main.async {
                        self.createErrorAlert(message: message)
                    }

                    return
                }
                
                self.timeLogs = timeLogs
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            
            }
                
            catch let DecodingError.dataCorrupted(context) {
                print(context)
                self.createErrorAlert(message: "A context error occurred.")
                
            } catch let DecodingError.keyNotFound(key, context) {
                print("Key '\(key)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
                self.createErrorAlert(message: "Key '\(key)' not found:")
            
            } catch let DecodingError.valueNotFound(value, context) {
                print("Value '\(value)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
                self.createErrorAlert(message: "Value '\(value)' not found:")
            
            } catch let DecodingError.typeMismatch(type, context)  {
                print("Type '\(type)' mismatch:", context.debugDescription)
                print("codingPath:", context.codingPath)
                self.createErrorAlert(message: "Type '\(type)' mismatch:")
            
            } catch {
                print("error: ", error)
                self.createErrorAlert(message: error.localizedDescription)
            }
        }

        //executing the task
        task.resume()
    }
    
    func createErrorAlert(message: String?) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)

        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(okAction)

        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func successUnwindToTimeLogsViewController ( _ seg: UIStoryboardSegue) {
        loadTimeLogsData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAddTimeLog" {
            let navVC = segue.destination as! UINavigationController
            let addTimeLog = navVC.viewControllers.first as! AddTimeLogViewController
            addTimeLog.userID = userID
        }
        
        if segue.identifier == "toTimeLogDetails",
            let timeLogDetails = segue.destination as? TimeLogDetailsViewController,
            let indexPath = tableView.indexPathForSelectedRow {
            timeLogDetails.timeLog = self.timeLogs[indexPath.row]
        }
    }
}

// MARK: - Table view data source

extension TimeLogsViewController: UITableViewDataSource, UITableViewDelegate  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return timeLogs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let timeLogs = self.timeLogs[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimeLogsCell") as! TimeLogsCell
        
        cell.setDetails(timeLogs: timeLogs)
        
        return cell
        
//        if cell.timeInLabel.text == "N/A" {
//            cell.timeInLabel.textColor = UIColor.red
//        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimeLogsHeaderCell") as! TImeLogsHeaderCell
        cell.backgroundColor = UIColor.white
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 0.5
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
}
