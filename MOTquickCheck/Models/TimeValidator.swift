//
//  TimeValidator.swift
//  MOTquickCheck
//
//  Created by Douglas Webb on 8/4/25.
//

import Foundation

enum TimeValidatorError: Error{
    
    case entryTooLong(errorDecription: String)
    case notANumber(errorDescription: String)
    case noEntry(errorDescriptiopn: String)
}



func timeValidator(stringInput: String) throws -> Date {
    
    let inputCharacterLength = stringInput.count
    
    // Check to see if the Entry is more than 4 Characters.
    
    if inputCharacterLength > 4{
        throw TimeValidatorError.entryTooLong(errorDecription: "There are too many charagter to be a time")
    }
    
    // Check to see if all Characters are Numbers.
    
    for character in stringInput{
        if character.isNumber == false{
            throw TimeValidatorError.notANumber(errorDescription: "Not A Number")
        }
    }
    
    // Makes sure the Entry is not blank
    
    if stringInput == ""{
        
        throw TimeValidatorError.noEntry(errorDescriptiopn: "No Input Entry")
    }
    
    
    // Assigne the Hours and minutes variable, sets minutes and initializes hours.
    
    var minutesEntry = stringInput.suffix(2)
    var hoursEntry = ""
    
    if inputCharacterLength == 4 {
        hoursEntry = String(stringInput.prefix(2))
    }else if inputCharacterLength == 2{
        hoursEntry = ""
    }else if inputCharacterLength == 1{
        minutesEntry = "0" + stringInput
        // covers a single digit entry
    }else{
        hoursEntry = String(stringInput[stringInput.startIndex])
    }
    
    
    let returnTime = Calendar.current.date(from: DateComponents(hour: Int(hoursEntry),minute: Int(minutesEntry)))!
    let returnTimeInSeconds = ((((Int(hoursEntry) ?? 0) * 60 * 60)) + (Int(minutesEntry)! * 60))
    
    
    
    
    print("The Time entered is: \(hoursEntry):\(minutesEntry)")
    
    
    
    
    return returnTime
    
}
