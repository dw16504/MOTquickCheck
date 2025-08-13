//
//  Untitled.swift
//  MOTquickCheck
//
//  Created by Douglas Webb on 2/17/25.
//
import Foundation

struct MOTModel{
    
    var totalFlightTImeAsString :String{
        
        //A Calculated Property!
        
        let hoursString = (Calendar.current.dateComponents([.hour], from: totalFlightTime!))
        let minuteString = (Calendar.current.dateComponents([.minute], from: totalFlightTime!))
        
        let formattedMinutes = String(format: "%02d",  minuteString.minute ?? "00" )
        
        return ("\(hoursString.hour!):\(formattedMinutes)")
    }
    
    
    var augmented :Bool = false
    var restFacility :Int = 1
    var aclimated :Bool = true
    var numberOfSegments: Int = 0
    var totalFlightTime = Calendar.current.date(from: DateComponents(hour: 0, minute: 0))
    var lineHolder :Bool = false
}
