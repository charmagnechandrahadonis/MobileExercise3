//
//  DataHolder.swift
//  MobileExercise2
//
//  Created by Charmagne Adonis on 11/13/20.
//  Copyright © 2020 Charmagne Adonis. All rights reserved.
//

import Foundation

struct EmployeeDetails: Decodable {
    let userID: String
    let firstName: String
    let middleName: String?
    let lastName: String
    let idNumber: String
    let emailAddress: String
    let mobileNumber: String
    let landline: String?
}
