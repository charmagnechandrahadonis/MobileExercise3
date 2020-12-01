//
//  TimeLogResponse.swift
//  MobileExercise3
//
//  Created by Charmagne Adonis on 11/19/20.
//  Copyright © 2020 Charmagne Adonis. All rights reserved.
//

import Foundation

struct TimeLogResponse: Decodable {
    let status: String
    let message: String?
    let timeLogs: [TimeLogDetails]?
}
