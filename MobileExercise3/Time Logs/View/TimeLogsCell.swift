//
//  TimeLogsCell.swift
//  MobileExercise3
//
//  Created by Charmagne Adonis on 11/21/20.
//  Copyright © 2020 Charmagne Adonis. All rights reserved.
//

import UIKit

class TimeLogsCell: UITableViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeInLabel: UILabel!
    @IBOutlet weak var timeOutLabel: UILabel!
    
    func setDetails (timeLogs: TimeLogDetails) {
        let formatterForDate = Formatter(date: timeLogs.date, time: nil)
        dateLabel.text = formatterForDate.dateFormatter()
        
        if let timeIn = timeLogs.timeIn, timeIn != ""  {
            let formatterForTimeIn = Formatter(date: nil, time: timeIn)
            timeInLabel.text = formatterForTimeIn.timeFormatter()
        }
        
        else {
            timeInLabel.text = "N/A"
            timeInLabel.textColor = UIColor.red
        }
        
        if let timeOut = timeLogs.timeOut, timeOut != "" {
            let foramtterForTimeOut = Formatter(date: nil, time: timeOut)
            timeOutLabel.text = foramtterForTimeOut.timeFormatter()
        }
        
        else {
            timeOutLabel.text = "N/A"
            timeOutLabel.textColor = UIColor.red
        }
    }

    override func prepareForReuse() {
        timeInLabel.textColor = UIColor.black
        timeOutLabel.textColor = UIColor.black
    }
}
