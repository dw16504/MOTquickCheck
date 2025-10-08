//
//  SegmentTotaler.swift
//  MOTquickCheck
//
//  Created by Douglas Webb on 4/25/25.
//

import Foundation

//This function cycles through the SegmentDataSource Array and returns a total to be input into the total segment time UI
//Label as well as the MOT Model.


func SegmentTotaler() -> String{
    
    var runningSegmentTotal = Calendar.current.date(from: DateComponents(hour: 0, minute: 0))
    
    
    for item in segmentDataSource{
        runningSegmentTotal = runningSegmentTotal?.addingTimeInterval(TimeInterval(item.segmentInSeconds))
        print ("\(item.segmentDescription)  ", terminator: "")
        print ("\(item.segmentTimeAsAString)  ", terminator: "")
        print (item.segmentInSeconds)
        
        motModel.totalFlightTime = runningSegmentTotal
        
    }
    
    
    // !!! TODO: I belive this may be able to transfter to a function in the model (This is duplicate code)
    
    let hoursString = (Calendar.current.dateComponents([.hour], from: runningSegmentTotal!))
    let minuteString = (Calendar.current.dateComponents([.minute], from: runningSegmentTotal!))
    
    let formattedMinutes = String(format: "%02d",  minuteString.minute ?? "00" )
    
    //return ("\(hoursString.hour!):\(minuteString.minute!)")
    return ("\(hoursString.hour!):\(formattedMinutes)")}
