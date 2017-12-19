//
//  IssueEntity.swift
//  AutomativeService
//
//  Created by Sergey Morenko on 12/11/17.
//  Copyright © 2017 Sergey Morenko. All rights reserved.
//

import Foundation

enum ContactPreference: String {
    case any, call, text, email
    
    static var count: Int {
        return 4
    }
    
    static var items: [String]{
        return ["any", "cell", "text", "email"]
    }
}

final class IssueEntity {
    var id: Int64
    var firstName = ""
    var lastName = ""
    var phone = ""
    var email = ""
    var vehicleColor = ""
    var vehiclePC = ""
    var vehicleMake = ""
    var vehicleModel = ""
    var vehicleVIN = ""
    var workNeeded = ""
    var dayNeeded: Int
    var estimate: Date
    var contactPreference = ContactPreference.any
    
    var isNew: Bool {
        return id == 0
    }
    
    init(id: Int64 = 0, dayNeeded: Int, estimate: Date) {
        self.id = id
        self.dayNeeded = dayNeeded
        self.estimate = estimate
    }
}
