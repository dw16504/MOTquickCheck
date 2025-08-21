//
//  SegmentTimeValidator.swift
//  MOTquickCheck
//
//  Created by Douglas Webb on 4/17/25.
//

import Foundation



enum segmentEntryError: Error {
    
    case entryTooLong(atSegmet: Int, errorDescription: String)
    case notANumber(atSegment: Int, errorDescription: String)
    case noEntry
    
}


func segmentTimeValidator(input: String, segment: Int) throws{
   
    let entryLength = input.count
    
    if entryLength > 4 {
        print("The error was thrown for row number \(segment)")
        throw segmentEntryError.entryTooLong(atSegmet: segment, errorDescription: "Entry is not a time")
        
    }
    
    for character in input{
        
        if character.isNumber == false{
            
            throw segmentEntryError.notANumber(atSegment: segment, errorDescription: "Entry is not a Number")
            
        }
        
    }
      
    
    var minutesEntry = input.suffix(2)
    var hoursEntry = ""
    
    if input == ""{
        print("There is no data entered")
        
        throw segmentEntryError.noEntry
        
    }
    
    
    if entryLength == 4 {
        hoursEntry = String(input.prefix(2))
    }else if entryLength == 2{
        hoursEntry = ""
    }else if entryLength == 1{
        minutesEntry = "0" + input
        print("A single didget entry was made!")
    }else{
        hoursEntry = String(input[input.startIndex])
    }
    
    print("The entered time is \(hoursEntry):\(minutesEntry)")
    
    segmentDataSource[segment].segmentTimeAsAString = ("\(hoursEntry):\(minutesEntry)")
    
    //This creates the Date/Time entry into the segment struct:
    
    segmentDataSource[segment].segmentTime = Calendar.current.date(from: DateComponents(hour: Int(hoursEntry),minute: Int(minutesEntry)))!
    segmentDataSource[segment].segmentInSeconds = ((((Int(hoursEntry) ?? 0) * 60 * 60)) + (Int(minutesEntry)! * 60))
    
    segmentDataSource[segment].isErrored = false
    
    
    
    print("The value entered in segment date is: \(segmentDataSource[segment].segmentTime)")
    print("This is the value decoded: \(Calendar.current.dateComponents([.hour,.minute], from: segmentDataSource[segment].segmentTime!))")
    
    
    
}

func clearTheSelectedTextField(segment:Int){
    
    print("Clear The Text Field was called on \(segment)")
    segmentDataSource[segment].segmentTimeAsAString = ""
    
}

	
