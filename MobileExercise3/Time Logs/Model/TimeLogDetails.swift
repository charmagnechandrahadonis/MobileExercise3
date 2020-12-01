//
//  TimeLogs.swift
//  MobileExercise3
//
//  Created by Charmagne Adonis on 11/19/20.
//  Copyright © 2020 Charmagne Adonis. All rights reserved.
//

import Foundation

struct TimeLogDetails: Decodable {
    let date: String
    let timeIn: String?
    let breakOut: String?
    let breakIn: String?
    let timeOut: String?
}
