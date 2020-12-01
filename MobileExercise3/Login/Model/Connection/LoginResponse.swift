//
//  LoginResponseStruct.swift
//  MobileExercise2
//
//  Created by Charmagne Adonis on 11/13/20.
//  Copyright © 2020 Charmagne Adonis. All rights reserved.
//

import Foundation

struct LoginResponse: Decodable {
    let status: String
    let message: String?
    let user: EmployeeDetails?
}
