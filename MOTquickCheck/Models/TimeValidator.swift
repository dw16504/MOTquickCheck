//
//  TimeValidator.swift
//  MOTquickCheck
//
//  Created by Douglas Webb on 8/4/25.
//

import Foundation

// basic date defaults
var components = DateComponents()
let now = Date()
//let calendar = Calendar.current

enum TimeValidatorError: Error{
    
    case entryTooLong(errorDecription: String)
    case notANumber(errorDescription: String)
    case noEntry(errorDescriptiopn: String)
}


//This defines the return data type for the time Procesor, it needs to account for both a date and a time interval.

enum ProcessedTime {
    
    case dateReturned(Date)
    case intervalReturned(TimeInterval)
    
}

// so the mission is to take the textfield entered and put it into a function
// the function should take three arguments, string entry, the yag, and the timezone.

// ** when the function wtites to update the time, you will probalky need antoher call to address when the
// ** timezone is changed from the UI after the time is entered, perhaps a separate function?


func timeProcessor(entryString: String, tag: Int, timeZone: TimeZone) throws -> ProcessedTime{
    
    //STEP ONE: CLEAN DATA
    
    // Check to see if its a base entry, and if so change it.
    
    let pattern = #"^\d{1,2}:\d{2}$"#
    var entryStringA = ""

    if entryString.range(of: pattern, options: .regularExpression) != nil {
        entryStringA = entryString.replacingOccurrences(of: ":", with: "")
        print(entryString) // "1245"
    }else{
        entryStringA = entryString
    }
    
    // TODO: you may want to run some check data here!
    
    let inputCharacterLength = entryStringA.count
    if inputCharacterLength > 4{
        throw TimeValidatorError.entryTooLong(errorDecription: "There are too many charagter to be a time")
    }
    
    // Check to see if all Characters are Numbers.
    
    for character in entryStringA{
        if character.isNumber == false{
            throw TimeValidatorError.notANumber(errorDescription: "Not A Number")
        }
    }
    
    // Makes sure the Entry is not blank
    
    if entryStringA == ""{
        throw TimeValidatorError.noEntry(errorDescriptiopn: "No Input Entry")
    }
    
    //STEP TWO: EXTRACT COMPONENTS TO BUID DATE
    
    var minutesEntry = entryStringA.suffix(2)
    var hoursEntry = ""
    
    if inputCharacterLength == 4 {
        hoursEntry = String(entryStringA.prefix(2))
    }else if inputCharacterLength == 2{
        hoursEntry = ""
    }else if inputCharacterLength == 1{
        minutesEntry = "0" + entryStringA
        // covers a single digit entry
    }else{
        hoursEntry = String(entryStringA[entryStringA.startIndex])
    }
    
    
    if tag <= 4{
        
        // okay lets build a date object for duty on. The duty on time is a local time, so we need to know what time zone they
        // duty onm it, thats what the Dutyon time zone entry is for, use that one (DutyOnTimezone).
        
        components.timeZone = timeZone  // from function parameter
        components.year = calendar.component(.year, from: now)
        components.month = calendar.component(.month, from: now)
        components.day = calendar.component(.day, from: now)
        components.hour = Int(hoursEntry)
        components.minute = Int(minutesEntry)
        
        let returningDate = calendar.date(from: components)   //this makes the date, it does not consider tag yet.
        
        //this is where I'd like to assigne the values to the MOT Model besed on the tag value passed in by this function.
        
        switch tag{
            
        case 2:
            motModel.reserveStart = returningDate! //Date
        case 3:
            
            print("****The Value being created in the validator for dutyOn is \(returningDate)")
            
            motModel.dutyOn = returningDate! //Date
        case 4:
            motModel.actualBlockOut = returningDate!  //Date
            //        case 5:
            //            motModel.projcetedBlock = responseY //Interval
            //        case 6:
            //            motModel.taxiIn = responseY //Interval
        default:
            print("Error: no update was made in the DidEndEditing Switch statement")
            
        }
        
        
        
        return .dateReturned(returningDate!)
        
    }else{
        // do intervall stuff here
        
        let hoursSEC = (Double(hoursEntry) ?? 0) * 3600
        let minutesSEC = Double(minutesEntry)! * 60
        let returnTimeInSeconds = hoursSEC + minutesSEC as TimeInterval
        
        switch tag{
            
        case 5:
            motModel.projcetedBlock = returnTimeInSeconds //Interval
        case 6:
            motModel.taxiIn = returnTimeInSeconds //Interval
        default:
            print("Error: no update was made in the DidEndEditing Switch statement")
            
        }
        
        
        return .intervalReturned(returnTimeInSeconds)
        
        //TODO: this is where you left off, you need to accept the interval return value in view controller and
        // you need to set the values in the model.
        
        
        //VERY IMPORTANT: YOU still havent undpated the model values, the app wont work.
        
        //VERY IMPORTANT, DOnt forget that youre gonna need to adjust that time at the beginning of the duty on
        //hash table in the mot model.
        
    }
    
    
    
    
    func timeValidator(stringInput: String) throws -> Date {
        
        //var calendar = Calendar.current // redundant, its a global variable now.
        calendar.timeZone = motModel.baseTimeZone  // ← Use BASE timezone for extraction
        
        let components = Calendar.current.dateComponents([.year,.month,.day], from: Date())
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
        
        
        let returnTime = calendar.date(from: DateComponents(
            year: components.year,
            month: components.month,
            day: components.day,
            hour: Int(hoursEntry),
            minute: Int(minutesEntry),
        ))!
        
        return returnTime.addingTimeInterval(motModel.deltaTime)
        
    }
    
    
    
    func timeValidatorForIntervals(stringInput: String, tag: Int) throws -> TimeInterval {
        
        
        // We have added a tag argument to the function, fix the argument all to take that value, add the second section of
        // the switch statement above to complete this fiunction for intervals.
        
        
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
        
        let hoursSEC = (Double(hoursEntry) ?? 0) * 3600
        let minutesSEC = Double(minutesEntry)! * 60
        
        //let returnTime = Calendar.current.date(from: DateComponents(hour: Int(hoursEntry),minute: Int(minutesEntry)))!
        let returnTimeInSeconds = hoursSEC + minutesSEC as TimeInterval
        
        
        print("The Time INTERVAL entered is: \(hoursEntry):\(minutesEntry)")
        
        return returnTimeInSeconds
        
        
        
    }
}
