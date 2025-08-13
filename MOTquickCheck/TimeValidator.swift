//
//  TimeValidator.swift
//  MOTquickCheck
//
//  Created by Douglas Webb on 8/4/25.
//

import Foundation

enum TimeValidatorError: Error{
    
    case entryTooLong(errorDecription: String)
}



func timeValidator(stringInput: String) throws -> Date {
    
    let inputCharacterLength = stringInput.count
    
    if inputCharacterLength > 4{
        throw TimeValidatorError.entryTooLong(errorDecription: "There are too many charagter to be a time")
    }
    
    
    
    
    
    return Date.now
}
