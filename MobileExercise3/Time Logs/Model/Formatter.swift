//
//  Formatter.swift
//  MobileExercise3
//
//  Created by Charmagne Adonis on 11/27/20.
//  Copyright © 2020 Charmagne Adonis. All rights reserved.
//

import Foundation

struct Formatter {
    var date: String?
    var time: String?
    
    func dateFormatter() -> String {
        guard let date = date else { return "" }
        
        let dateFormatter = DateFormatter()
       
        dateFormatter.dateFormat = "MM/dd/yyyy"
        guard let dateOriginalFormat = dateFormatter.date(from: date) else { return "" }
        
        dateFormatter.dateFormat = "MMMM d"
        return dateFormatter.string(from: dateOriginalFormat)
    }
    
    func timeFormatter () -> String {
        guard let time = time else { return "" }
        
        let timeFormatter = DateFormatter()
        
        timeFormatter.dateFormat = "HH:mm:ss"
        guard let timeOriginalFormat = timeFormatter.date(from: time) else { return "" }
        
        timeFormatter.dateFormat = "h:mm a"
        return timeFormatter.string(from: timeOriginalFormat)
    }
}
