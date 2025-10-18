//
//  Untitled.swift
//  MOTquickCheck
//
//  Created by Douglas Webb on 2/17/25.
//
import Foundation

var calendar = Calendar.current

//This is a method that takes a raw Date Time and Converts it to a useable String,

//TODO: GIVE THIS FUNCTION AN INPUT PARAMETER THAT WILL RETURN ANY TIME VALUE IN THE MODEL AS A STRING INSTEAD OF JUST

//TOTAL FLIGHT TIME.

let zeroValueTime = convertToDate(hours: 0, minutes: 0)



//MARK: - ConversionFunctions:

func timeAsStringLocal(_ timeToConvert: Date) -> String{
  
    
    let hoursString = (Calendar.current.dateComponents([.hour], from: timeToConvert))
    let minuteString = (Calendar.current.dateComponents([.minute], from: timeToConvert))
    let formattedMinutes = String(format: "%02d",  minuteString.minute ?? "00" )
    return ("\(hoursString.hour!):\(formattedMinutes)")
}

func timeAsStringUTC(_ timeToConvert: Date) -> String{
 
    let calendar = Calendar(identifier: .gregorian)
    var utcCalendar = calendar
    utcCalendar.timeZone = TimeZone(secondsFromGMT: 0)!
    
    
   
    //var calendar = Calendar.current
    //calendar.timeZone = TimeZone(identifier: "UTC")!
    let hoursString = (utcCalendar.dateComponents([.hour], from: timeToConvert))
    let minuteString = (utcCalendar.dateComponents([.minute], from: timeToConvert))
    
    let formattedMinutes = String(format: "%02d",  minuteString.minute ?? 0 )
    return ("\(hoursString.hour!):\(formattedMinutes)")
}

func intervalAsString(_ timeToConvert: TimeInterval) -> String{
    
    print("The value received for time interval is: \(timeToConvert)")
    
    
    let minutes = Int(timeToConvert.remainder(dividingBy: 3600)/60)
    let hours = Int(timeToConvert / 3600)
    
    let formattedHours = String(format: "%02d", hours)
    let formattedMinutes = String(format: "%02d",  minutes )
    
    return ("\(formattedHours):\(formattedMinutes)")
}




func convertToDate(hours: Int, minutes: Int) -> Date{
    // This is one of three places that assign a date to a time object, it pulls a new time object
    // This seems bug prone to me.
    
    let components = Calendar.current.dateComponents([.year,.month,.day], from: Date())
    return Calendar.current.date(from: DateComponents(year: components.year,
                                                      month: components.month,
                                                      day: components.day,
                                                      hour: Int(hours),minute: Int(minutes)))!
}


func convertToInterval(TimeOject:Date) -> TimeInterval{
    
    let TimeConversionA = calendar.dateComponents([.hour, .minute], from: TimeOject)
    return TimeInterval(((TimeConversionA.hour ?? 0) * 3600) + ((TimeConversionA.minute ?? 0) * 60))
    
}





struct MOTModel{
    
    
    
    //let calendar = Calendar.current
    let components = Calendar.current.dateComponents([.year,.month,.day], from: Date())
    
    
    //TODO: Duplicate code, second function is used in the segment time totaler, It may be able to comout out of the Model
    
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
    
    
    var currentTime :Date = Date()
    var locationKnown :Bool = false
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
    var projcetedBlock :TimeInterval = 0 //TAG 5
    var taxiIn :TimeInterval = 0 //TAG 6
    var totalFlightTime = Calendar.current.date(from: DateComponents(hour: 0, minute: 0))
    
    
    //calculated Properties
    
    var maxDutyPeriod: TimeInterval {
        
        // This is one of three places that assign a date to a time object, it pulls a new time object
        // This seems bug prone to me.
        
        var tableOneLine = 1
        var dutyTableEntryTime = Calendar.current.date(from: DateComponents(year: components.year,
                                                                            month:components.month,
                                                                            day: components.day,
                                                                            hour: 0,
                                                                            minute: 0))
        var deltaTime = 0.0
        
        if motModel.currentTimeZone == motModel.baseTimeZone {
            dutyTableEntryTime = motModel.dutyOn
        }else{
            deltaTime = Double(motModel.currentTimeZone.secondsFromGMT() - motModel.baseTimeZone.secondsFromGMT())
            dutyTableEntryTime = motModel.dutyOn.addingTimeInterval(deltaTime)
            
            print("the location is different and a delta time has been applied")
            
        }
        
        
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
        
            //return Calendar.current.date(from: DateComponents(hour: 9, minute: 0))!
            return (9 * 3600) + (0 * 60) as TimeInterval
            
        }else if tableOneLine == 2 && motModel.numberOfSegments <= 4{
            //return Calendar.current.date(from: DateComponents(hour: 10, minute: 0))!
            return (10 * 3600) + (0 * 60) as TimeInterval
        }else if tableOneLine == 2 && motModel.numberOfSegments > 4{
            //return Calendar.current.date(from: DateComponents(hour: 9, minute: 0))!
            return (9 * 3600) + (0 * 60) as TimeInterval
            
        }else if tableOneLine == 3 && motModel.numberOfSegments <= 4{
            //return Calendar.current.date(from: DateComponents(hour: 12, minute: 0))!
            return (12 * 3600) + (0 * 60) as TimeInterval

        }else if tableOneLine == 3 && motModel.numberOfSegments == 5 {
            //return Calendar.current.date(from: DateComponents(hour: 11, minute: 30))!
            return (11 * 3600) + (30 * 60) as TimeInterval
            
        }else if tableOneLine == 3 && motModel.numberOfSegments == 6{
            //return Calendar.current.date(from: DateComponents(hour: 11, minute: 0))!
            return (11 * 3600) + (0 * 60) as TimeInterval
            
        }else if tableOneLine == 3 && motModel.numberOfSegments >= 7{
            //return Calendar.current.date(from: DateComponents(hour: 10, minute: 30))!
            return (10 * 3600) + (30 * 60) as TimeInterval
            
        }else if tableOneLine == 4 && motModel.numberOfSegments <= 2{
            //return Calendar.current.date(from: DateComponents(hour: 13, minute: 0))!
            return (13 * 3600) + (0 * 60) as TimeInterval
            
        }else if tableOneLine == 4 && (motModel.numberOfSegments >= 3 && motModel.numberOfSegments <= 4){
            //return Calendar.current.date(from: DateComponents(hour: 12, minute: 0))!
            return (12 * 3600) + (0 * 60) as TimeInterval
            
        }else if tableOneLine == 4 && motModel.numberOfSegments == 5{
            //return Calendar.current.date(from: DateComponents(hour: 11, minute: 30))!
            return (11 * 3600) + (30 * 60) as TimeInterval
            
        }else if tableOneLine == 4 && motModel.numberOfSegments == 6{
            //return Calendar.current.date(from: DateComponents(hour: 11, minute: 0))!
            return (11 * 3600) + (0 * 60) as TimeInterval
            
        }else if tableOneLine == 4 && motModel.numberOfSegments >= 7{
            //return Calendar.current.date(from: DateComponents(hour: 10, minute: 30))!
            return (10 * 3600) + (30 * 60) as TimeInterval
            
        }else if tableOneLine == 5 && motModel.numberOfSegments <= 2{
            //return Calendar.current.date(from: DateComponents(hour: 14, minute: 0))!
            return (14 * 3600) + (0 * 60) as TimeInterval
            
        }else if tableOneLine == 5 && (motModel.numberOfSegments >= 3 && motModel.numberOfSegments <= 4){
            //return Calendar.current.date(from: DateComponents(hour: 13, minute: 0))!
            return (13 * 3600) + (0 * 60) as TimeInterval
            
        }else if tableOneLine == 5 && motModel.numberOfSegments == 5{
            //return Calendar.current.date(from: DateComponents(hour: 12, minute: 30))!
            return (12 * 3600) + (30 * 60) as TimeInterval
            
        }else if tableOneLine == 5 && motModel.numberOfSegments == 6{
            //return Calendar.current.date(from: DateComponents(hour: 12, minute: 0))!
            return (12 * 3600) + (0 * 60) as TimeInterval
            
        }else if tableOneLine == 5 && motModel.numberOfSegments >= 7{
            //return Calendar.current.date(from: DateComponents(hour: 11, minute: 30))!
            return (11 * 3600) + (30 * 60) as TimeInterval
            
        }else if tableOneLine == 6 && motModel.numberOfSegments <= 4{
            //return Calendar.current.date(from: DateComponents(hour: 13, minute: 0))!
            return (13 * 3600) + (0 * 60) as TimeInterval
            
        }else if tableOneLine == 6 && motModel.numberOfSegments == 5{
            //return Calendar.current.date(from: DateComponents(hour: 12, minute: 30))!
            return (12 * 3600) + (30 * 60) as TimeInterval
            
        }else if tableOneLine == 6 && motModel.numberOfSegments == 6{
            //return Calendar.current.date(from: DateComponents(hour: 12, minute: 0))!
            return (12 * 3600) + (0 * 60) as TimeInterval
            
        }else if tableOneLine == 6 && motModel.numberOfSegments >= 7{
            //return Calendar.current.date(from: DateComponents(hour: 11, minute: 30))!
            return (11 * 3600) + (30 * 60) as TimeInterval
            
        }else if tableOneLine == 7 && motModel.numberOfSegments <= 4{
            //return Calendar.current.date(from: DateComponents(hour: 12, minute: 0))!
            return (12 * 3600) + (0 * 60) as TimeInterval
            
        }else if tableOneLine == 7 && motModel.numberOfSegments == 5{
            //return Calendar.current.date(from: DateComponents(hour: 11, minute: 30))!
            return (11 * 3600) + (30 * 60) as TimeInterval
            
        }else if tableOneLine == 7 && motModel.numberOfSegments == 6{
            //return Calendar.current.date(from: DateComponents(hour: 11, minute: 0))!
            return (10 * 3600) + (0 * 60) as TimeInterval
            
        }else if tableOneLine == 7 && motModel.numberOfSegments >= 7{
            //return Calendar.current.date(from: DateComponents(hour: 10, minute: 30))!
            return (10 * 3600) + (30 * 60) as TimeInterval
            
        }else if tableOneLine == 8 && motModel.numberOfSegments <= 2{
            //return Calendar.current.date(from: DateComponents(hour: 12, minute: 0))!
            return (12 * 3600) + (0 * 60) as TimeInterval
            
        }else if tableOneLine == 8 && (motModel.numberOfSegments >= 3 && motModel.numberOfSegments <= 4){
            //return Calendar.current.date(from: DateComponents(hour: 11, minute: 0))!
            return (11 * 3600) + (0 * 60) as TimeInterval
            
        }else if tableOneLine == 8 && motModel.numberOfSegments == 5{
            //return Calendar.current.date(from: DateComponents(hour: 10, minute: 0))!
            return (10 * 3600) + (0 * 60) as TimeInterval
            
        }else if tableOneLine == 8 && motModel.numberOfSegments >= 6{
            //return Calendar.current.date(from: DateComponents(hour: 9, minute: 0))!
            return (9 * 3600) + (0 * 60) as TimeInterval
            
        }else if tableOneLine == 9 && motModel.numberOfSegments <= 2{
            //return Calendar.current.date(from: DateComponents(hour: 11, minute: 0))!
            return (11 * 3600) + (0 * 60) as TimeInterval
            
        }else if tableOneLine == 9 && (motModel.numberOfSegments >= 3 && motModel.numberOfSegments <= 4){
            //return Calendar.current.date(from: DateComponents(hour: 10, minute: 0))!
            return (10 * 3600) + (0 * 60) as TimeInterval
            
        }else if tableOneLine == 9 && motModel.numberOfSegments >= 5{
            //return Calendar.current.date(from: DateComponents(hour: 9, minute: 0))!
            return (9 * 3600) + (0 * 60) as TimeInterval
            
        }else if tableOneLine == 10 && motModel.numberOfSegments <= 3{
            //return Calendar.current.date(from: DateComponents(hour: 10, minute: 0))!
            return (10 * 3600) + (0 * 60) as TimeInterval
            
        }else if tableOneLine == 10 && (motModel.numberOfSegments >= 4 && motModel.numberOfSegments <= 6){
            //return Calendar.current.date(from: DateComponents(hour: 9, minute: 0))!
            return (9 * 3600) + (0 * 60) as TimeInterval
            
        }else if tableOneLine == 10 && motModel.numberOfSegments >= 7 {
            //return Calendar.current.date(from: DateComponents(hour: 0, minute: 0))!
            return (0 * 3600) + (0 * 60) as TimeInterval
        }
        
        //return Calendar.current.date(from: DateComponents(hour: 0, minute: 0))! // zero Value
        return (0 * 3600) + (0 * 60) as TimeInterval // zero valu default
    }
    
    
    
    // Duty Time Remaining
    
    var mustDutyOffat :Date{
        //duty on plus max duty
        return dutyOn.addingTimeInterval(maxDutyPeriod)
        
    }
    
    
    
    
    
    // Duty Time Remaining
    
    var dutyTimeRemaining :Date{
        
        //must duty off minus current time?
        //TODO: This may need capture logic for for "Must Duty off times" that not in range.
        
        return motModel.mustDutyOffat - (convertToInterval(TimeOject: Date())) // IMPORTANT: This calls a new current time.
        
        
    }
    
    //MARK: TODO fix this for intervals
    // Duty Based MOT:
    //Must Duty Off at(date) - Projected Block(interval) - TaxiIn(interval)
    var dutyBasedMOT :Date{
        
        //let projectedBlockInterval = -(convertToInterval(TimeOject: motModel.projcetedBlock))
        let projectedBlockInterval = -motModel.projcetedBlock
        //let bufferInterval = -(convertToInterval(TimeOject: motModel.buffer))
        let bufferInterval = -motModel.taxiIn
        return (motModel.mustDutyOffat.addingTimeInterval(projectedBlockInterval)).addingTimeInterval(bufferInterval)
    }
    
    //Max FLight Time
    //Determined From aclimated report time
    var maxFligtTIme :Date{
        
        if (motModel.dutyOn >= convertToDate(hours: 5, minutes: 00)) && (motModel.dutyOn <= convertToDate(hours: 19, minutes: 59)){
            // 0000 - 0459 8 hours Max flight
            return convertToDate(hours: 9, minutes: 0)
        }else{
            return convertToDate(hours: 8, minutes: 0)
        }
    }
    
    //flight time Remaining
    //Max flight time less (-) totalFLight time
    
    var flightTimeRemaining :Date{
        
        let totalFlightTimeAsInterval = -(convertToInterval(TimeOject: motModel.totalFlightTime!))
        return motModel.maxFligtTIme.addingTimeInterval(totalFlightTimeAsInterval)
    }
    
}


