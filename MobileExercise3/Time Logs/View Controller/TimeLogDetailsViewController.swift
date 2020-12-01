//
//  TimeLogDetailsViewController.swift
//  MobileExercise3
//
//  Created by Charmagne Adonis on 11/23/20.
//  Copyright © 2020 Charmagne Adonis. All rights reserved.
//

import UIKit

class TimeLogDetailsViewController: UIViewController {
    
    @IBOutlet weak var timeInLabel: UILabel!
    @IBOutlet weak var timeOutLabel: UILabel!
    @IBOutlet weak var breakOutLabel: UILabel!
    @IBOutlet weak var breakInLabel: UILabel!
    var timeLog: TimeLogDetails!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let formatterForDate = Formatter(date: timeLog.date, time: nil)
        self.title = formatterForDate.dateFormatter()
        
        if let timeIn = timeLog.timeIn, timeIn != ""  {
            let formatterForTimeIn = Formatter(date: nil, time: timeIn)
            timeInLabel.text = formatterForTimeIn.timeFormatter()
        }
        
        else {
            timeInLabel.text = "N/A"
            timeInLabel.textColor = UIColor.red
        }
        
        if let breakOut = timeLog.breakOut, breakOut != ""  {
            let formatterForTimeIn = Formatter(date: nil, time: breakOut)
            breakOutLabel.text = formatterForTimeIn.timeFormatter()
        }
        
        else {
            breakOutLabel.text = "N/A"
            breakOutLabel.textColor = UIColor.red
        }
        
        if let breakIn = timeLog.breakIn, breakIn != "" {
            let foramtterForTimeOut = Formatter(date: nil, time: breakIn)
            breakInLabel.text = foramtterForTimeOut.timeFormatter()
        }
        
        else {
            breakInLabel.text = "N/A"
            breakInLabel.textColor = UIColor.red
        }
        
        if let timeOut = timeLog.timeOut, timeOut != "" {
            let foramtterForTimeOut = Formatter(date: nil, time: timeOut)
            timeOutLabel.text = foramtterForTimeOut.timeFormatter()
        }
        
        else {
            timeOutLabel.text = "N/A"
            timeOutLabel.textColor = UIColor.red
        }
    }
}
