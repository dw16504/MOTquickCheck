//
//  Untitled.swift
//  MOTquickCheck
//
//  Created by Douglas Webb on 2/17/25.
//
import Foundation

 

//This is a method that takes a raw Date Time and Converts it to a useable String,

//TODO: GIVE THIS FUNCTION AN INPUT PARAMETER THAT WILL RETURN ANY TIME VALUE IN THE MODEL AS A STRING INSTEAD OF JUST
//TOTAL FLIGHT TIME.

struct MOTModel{
    
    var totalFlightTimeAsString :String{
        
        let hoursString = (Calendar.current.dateComponents([.hour], from: totalFlightTime!))
        let minuteString = (Calendar.current.dateComponents([.minute], from: totalFlightTime!))
        let formattedMinutes = String(format: "%02d",  minuteString.minute ?? "00" )
        return ("\(hoursString.hour!):\(formattedMinutes)")
    }
    
    func timeAsString(_ timeToConvert: Date) -> String{
        
        let hoursString = (Calendar.current.dateComponents([.hour], from: timeToConvert))
        let minuteString = (Calendar.current.dateComponents([.minute], from: timeToConvert))
        let formattedMinutes = String(format: "%02d",  minuteString.minute ?? "00" )
        return ("\(hoursString.hour!):\(formattedMinutes)")
    }
    
    
    
    
    
    var augmented :Bool = false
    var restFacility :Int = 1
    var aclimated :Bool = true
    var lineHolder :Bool = false
    var useUTC :Bool = false
    var numberOfSegments: Int = 0
    var reserveStart :Date = Date() //TAG 2
    var dutyOn :Date = Date() //TAG 3
    var actualBlockOut :Date = Date() //TAG 4
    var projcetedBlock :Date = Date() //TAG 5
    var buffer :Date = Date() //TAG 6
    var totalFlightTime = Calendar.current.date(from: DateComponents(hour: 0, minute: 0))
    
}


