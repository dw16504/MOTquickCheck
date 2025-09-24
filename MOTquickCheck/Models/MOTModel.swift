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

func convertToDate(hours: Int, minutes: Int) -> Date{
    
    return Calendar.current.date(from: DateComponents(hour: Int(hours),minute: Int(minutes)))!
}






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
    
    
    var baseTimeZone :TimeZone = Calendar.current.timeZone
    var currentTimeZone :TimeZone = Calendar.current.timeZone // defaults to user defined
    var augmented :Bool = false
    var restFacility :Int = 1
    var aclimated :Bool = true
    var lineHolder :Bool = false
    var useUTC :Bool = false
    var numberOfSegments: Int = 1
    var reserveStart :Date = Date() //TAG 2
    var dutyOn :Date = Date() //TAG 3
    var actualBlockOut :Date = Date() //TAG 4
    var projcetedBlock :Date = Date() //TAG 5
    var buffer :Date = Date() //TAG 6
    var totalFlightTime = Calendar.current.date(from: DateComponents(hour: 0, minute: 0))
    
    
    //calculated Properties
    
    var maxDutyPerod: Date {
        
        
        //This takes A local Duty on time and adjusts it, you may need to make another breakout
        //that checks for use of UTC time.
        
        var tableOneLine = 1
        var dutyTableEntryTime = Calendar.current.date(from: DateComponents(hour: 0, minute: 0))
        var deltaTime = 0.0
        
        if motModel.currentTimeZone == motModel.baseTimeZone {
            dutyTableEntryTime = motModel.dutyOn
        }else{
            deltaTime = Double(motModel.currentTimeZone.secondsFromGMT() - motModel.baseTimeZone.secondsFromGMT())
            dutyTableEntryTime = motModel.dutyOn.addingTimeInterval(deltaTime)
            
            print("the location is different and a delta time has been applied")
            
        }
        
        print("At the begining od the logic check: dutyOn is \(motModel.timeAsString(motModel.dutyOn))")
        
       
        
        if (dutyTableEntryTime! >= convertToDate(hours: 00, minutes: 00)) && dutyTableEntryTime!  <= convertToDate(hours: 03, minutes: 59){
            //0000 - 0359 Local
            tableOneLine = 1
        }else if (dutyTableEntryTime! >= convertToDate(hours: 04, minutes: 00)) && dutyTableEntryTime!  <= convertToDate(hours: 04, minutes: 59){
            //0400 - 0459
            tableOneLine = 2
        }else if (dutyTableEntryTime! >= convertToDate(hours: 05, minutes: 00)) && dutyTableEntryTime!  <= convertToDate(hours: 05, minutes: 59){
            //0500 - 0559
            tableOneLine = 3
        }else if (dutyTableEntryTime! >= convertToDate(hours: 06, minutes: 00)) && dutyTableEntryTime!  <= convertToDate(hours: 06, minutes: 59){
            //0600 - 0659
            tableOneLine = 4
        }else if (dutyTableEntryTime! >= convertToDate(hours: 07, minutes: 00)) && dutyTableEntryTime!  <= convertToDate(hours: 11, minutes: 59){
            //0700 - 1159
            tableOneLine = 5
        }else if (dutyTableEntryTime! >= convertToDate(hours: 12, minutes: 00)) && dutyTableEntryTime!  <= convertToDate(hours: 12, minutes: 59){
            //1200 - 1259
            tableOneLine = 6
        }else if (dutyTableEntryTime! >= convertToDate(hours: 13, minutes: 00)) && dutyTableEntryTime!  <= convertToDate(hours: 16, minutes: 59){
            //1300 -1659
            tableOneLine = 7
        }else if (dutyTableEntryTime! >= convertToDate(hours: 17, minutes: 00)) && dutyTableEntryTime!  <= convertToDate(hours: 21, minutes: 59){
            //1700 - 2159
            tableOneLine = 8
        }else if (dutyTableEntryTime! >= convertToDate(hours: 22, minutes: 00)) && dutyTableEntryTime!  <= convertToDate(hours: 22, minutes: 59){
            //2200 - 2259
            tableOneLine = 9
        }else if (dutyTableEntryTime! >= convertToDate(hours: 23, minutes: 00)) && dutyTableEntryTime!  <= convertToDate(hours: 23, minutes: 59){
            //2300 - 2359
            tableOneLine = 10
        }else{
            tableOneLine = 0
        }
        
       
        
        // Logic for Columns in table 1-8
        
        
        if tableOneLine == 1{
            return Calendar.current.date(from: DateComponents(hour: 9, minute: 0))!
        }else if tableOneLine == 1 && motModel.numberOfSegments <= 4{
            return Calendar.current.date(from: DateComponents(hour: 10, minute: 0))!
        }else if tableOneLine == 2 && motModel.numberOfSegments > 4{
            return Calendar.current.date(from: DateComponents(hour: 9, minute: 0))!
        }else if tableOneLine == 2 && motModel.numberOfSegments > 4{
            return Calendar.current.date(from: DateComponents(hour: 9, minute: 0))!
        }else if tableOneLine == 3 && motModel.numberOfSegments >= 4{
            print("I belive the function exited here")
            return Calendar.current.date(from: DateComponents(hour: 12, minute: 0))!
        }else if tableOneLine == 3 && motModel.numberOfSegments == 5 {
            return Calendar.current.date(from: DateComponents(hour: 11, minute: 30))!
        }else if tableOneLine == 3 && motModel.numberOfSegments == 6{
            return Calendar.current.date(from: DateComponents(hour: 11, minute: 0))!
        }else if tableOneLine == 3 && motModel.numberOfSegments >= 7{
            return Calendar.current.date(from: DateComponents(hour: 10, minute: 30))!
        }else if tableOneLine == 4 && motModel.numberOfSegments <= 2{
            return Calendar.current.date(from: DateComponents(hour: 13, minute: 0))!
        }else if tableOneLine == 4 && (motModel.numberOfSegments >= 3 && motModel.numberOfSegments <= 4){
            return Calendar.current.date(from: DateComponents(hour: 12, minute: 0))!
        }else if tableOneLine == 4 && motModel.numberOfSegments == 5{
            return Calendar.current.date(from: DateComponents(hour: 11, minute: 30))!
        }else if tableOneLine == 4 && motModel.numberOfSegments == 6{
            return Calendar.current.date(from: DateComponents(hour: 11, minute: 0))!
        }else if tableOneLine == 4 && motModel.numberOfSegments >= 7{
            return Calendar.current.date(from: DateComponents(hour: 10, minute: 30))!
        }else if tableOneLine == 5 && motModel.numberOfSegments <= 2{
            return Calendar.current.date(from: DateComponents(hour: 14, minute: 0))!
        }else if tableOneLine == 5 && (motModel.numberOfSegments >= 3 && motModel.numberOfSegments <= 4){
            return Calendar.current.date(from: DateComponents(hour: 13, minute: 0))!
        }else if tableOneLine == 5 && motModel.numberOfSegments == 5{
            return Calendar.current.date(from: DateComponents(hour: 12, minute: 30))!
        }else if tableOneLine == 5 && motModel.numberOfSegments == 6{
            return Calendar.current.date(from: DateComponents(hour: 12, minute: 0))!
        }else if tableOneLine == 5 && motModel.numberOfSegments >= 7{
            return Calendar.current.date(from: DateComponents(hour: 11, minute: 30))!
        }else if tableOneLine == 6 && motModel.numberOfSegments <= 4{
            return Calendar.current.date(from: DateComponents(hour: 13, minute: 0))!
        }else if tableOneLine == 6 && motModel.numberOfSegments == 5{
            return Calendar.current.date(from: DateComponents(hour: 12, minute: 30))!
        }else if tableOneLine == 6 && motModel.numberOfSegments == 6{
            return Calendar.current.date(from: DateComponents(hour: 12, minute: 0))!
        }else if tableOneLine == 6 && motModel.numberOfSegments >= 7{
            return Calendar.current.date(from: DateComponents(hour: 11, minute: 30))!
        }else if tableOneLine == 7 && motModel.numberOfSegments <= 4{
            return Calendar.current.date(from: DateComponents(hour: 12, minute: 0))!
        }else if tableOneLine == 7 && motModel.numberOfSegments == 5{
            return Calendar.current.date(from: DateComponents(hour: 11, minute: 30))!
        }else if tableOneLine == 7 && motModel.numberOfSegments == 6{
            return Calendar.current.date(from: DateComponents(hour: 11, minute: 0))!
        }else if tableOneLine == 7 && motModel.numberOfSegments >= 7{
            return Calendar.current.date(from: DateComponents(hour: 10, minute: 30))!
        }else if tableOneLine == 8 && motModel.numberOfSegments <= 2{
            return Calendar.current.date(from: DateComponents(hour: 12, minute: 0))!
        }else if tableOneLine == 8 && (motModel.numberOfSegments >= 3 && motModel.numberOfSegments <= 4){
            return Calendar.current.date(from: DateComponents(hour: 11, minute: 0))!
        }else if tableOneLine == 8 && motModel.numberOfSegments == 5{
            return Calendar.current.date(from: DateComponents(hour: 10, minute: 0))!
        }else if tableOneLine == 8 && motModel.numberOfSegments >= 6{
            return Calendar.current.date(from: DateComponents(hour: 9, minute: 0))!
        }else if tableOneLine == 9 && motModel.numberOfSegments <= 2{
            return Calendar.current.date(from: DateComponents(hour: 11, minute: 0))!
        }else if tableOneLine == 9 && (motModel.numberOfSegments >= 3 && motModel.numberOfSegments <= 4){
            return Calendar.current.date(from: DateComponents(hour: 10, minute: 0))!
        }else if tableOneLine == 9 && motModel.numberOfSegments >= 5{
            return Calendar.current.date(from: DateComponents(hour: 9, minute: 0))!
        }else if tableOneLine == 10 && motModel.numberOfSegments <= 3{
            return Calendar.current.date(from: DateComponents(hour: 10, minute: 0))!
        }else if tableOneLine == 10 && (motModel.numberOfSegments >= 4 && motModel.numberOfSegments <= 6){
            return Calendar.current.date(from: DateComponents(hour: 9, minute: 0))!
        }else if tableOneLine == 10 && motModel.numberOfSegments >= 7 {
            return Calendar.current.date(from: DateComponents(hour: 0, minute: 0))!
        }
        
        return Calendar.current.date(from: DateComponents(hour: 0, minute: 0))! // zero Value
    }
    
   
    
}


