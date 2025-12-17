//
//  Untitled.swift
//  MOTquickCheck
//
//  Created by Douglas Webb on 2/17/25.
//
import Foundation

var calendar = Calendar.current


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
    
        let totalSeconds = Int(timeToConvert.rounded())      // avoid fractional-second quirks
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60 // 0...59

        return String(format: "%02d:%02d", hours, minutes)}




func convertToDate(hours: Int, minutes: Int) -> Date{
    
    let components = Calendar.current.dateComponents([.year,.month,.day], from: Date())
    
    //should work
    //return Calendar.current.date(from: DateComponents(timeZone: motModel.baseTimeZone,
//                                                      year: components.year,
//                                                      month: components.month,
//                                                      day: components.day,
//                                                      hour: Int(hours),minute: Int(minutes)))!
//
    return Calendar.current.date(from: DateComponents(
                                                      year: components.year,
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
    
//    var totalFlightTimeAsString :String{
//        
//        let hoursString = (Calendar.current.dateComponents([.hour], from: totalFlightTime!))
//        let minuteString = (Calendar.current.dateComponents([.minute], from: totalFlightTime!))
//        let formattedMinutes = String(format: "%02d",  minuteString.minute ?? "00" )
//        return ("\(hoursString.hour!):\(formattedMinutes)")
//    }
    
    func timeAsString(_ timeToConvert: Date) -> String{
        
        let hoursString = (Calendar.current.dateComponents([.hour], from: timeToConvert))
        let minuteString = (Calendar.current.dateComponents([.minute], from: timeToConvert))
        let formattedMinutes = String(format: "%02d",  minuteString.minute ?? "00" )
        return ("\(hoursString.hour!):\(formattedMinutes)")
    }
    
    
    var startTimeZone = 7
    var dutyOnTimeZone = 7
    
    var currentTime :Date = Date()
    var locationKnown :Bool = false
    //var baseTimeZone :TimeZone = Calendar.current.timeZone
    
    var baseTimeZone: TimeZone {
        return TimeZone(secondsFromGMT: TimeZonesOptions[startTimeZone].utcOffset * 3600)!
    }

    var dutyOnTimezone: TimeZone {
        return TimeZone(secondsFromGMT: TimeZonesOptions[dutyOnTimeZone].utcOffset * 3600)!
    }

    
    
    var currentTimeZone :TimeZone = Calendar.current.timeZone // defaults to user defined
    var augmented :Bool = false
    var restFacility :Int = 1

    var lineHolder :Bool = false
    
    var numberOfSegments: Int = 1
    var reserveStart :Date = zeroValueTime //TAG 2
    var dutyOn :Date = zeroValueTime //TAG 3
    var actualBlockOut :Date = zeroValueTime //TAG 4
    var projcetedBlock :TimeInterval = 0 //TAG 5
    var taxiIn :TimeInterval = 0 //TAG 6
    var totalFlightTimeAsInterval: TimeInterval = 0.0
    
    // MARK: -- Under constructioon. Attempting to set an offset from base time property.
    
    var deltaTime: TimeInterval {
        
        if motModel.startTimeZone == motModel.dutyOnTimeZone{
            return 0.0
        }else{
           
        return Double(TimeZonesOptions[motModel.startTimeZone].utcOffset - TimeZonesOptions[motModel.dutyOnTimeZone].utcOffset) * 3600
    
        }
    }
    
    
    
    
    //calculated Properties
    
    var maxDutyPeriod: TimeInterval {
        
        var tableOneLine = 1
        
        
        //these two lines are part of the problem
        
        //let dutyTableEntryTime = motModel.dutyOn.addingTimeInterval(deltaTime)
        let dutyTableEntryTime = motModel.dutyOn
        
        print("duty on time is: \(timeAsString(motModel.dutyOn))")
        print("The delta time is: \(deltaTime)")
        print("The Duty table entry time is \(timeAsString(dutyTableEntryTime))")
        
        
        if (dutyTableEntryTime >= convertToDate(hours: 00, minutes: 00)) && dutyTableEntryTime  <= convertToDate(hours: 03, minutes: 59){
            //0000 - 0359 Local
            tableOneLine = 1
        }else if (dutyTableEntryTime >= convertToDate(hours: 04, minutes: 00)) && dutyTableEntryTime  <= convertToDate(hours: 04, minutes: 59){
            //0400 - 0459
            tableOneLine = 2
        }else if (dutyTableEntryTime >= convertToDate(hours: 05, minutes: 00)) && dutyTableEntryTime  <= convertToDate(hours: 05, minutes: 59){
            //0500 - 0559
            tableOneLine = 3
        }else if (dutyTableEntryTime >= convertToDate(hours: 06, minutes: 00)) && dutyTableEntryTime  <= convertToDate(hours: 06, minutes: 59){
            //0600 - 0659
            tableOneLine = 4
        }else if (dutyTableEntryTime >= convertToDate(hours: 07, minutes: 00)) && dutyTableEntryTime  <= convertToDate(hours: 11, minutes: 59){
            //0700 - 1159
            tableOneLine = 5
        }else if (dutyTableEntryTime >= convertToDate(hours: 12, minutes: 00)) && dutyTableEntryTime  <= convertToDate(hours: 12, minutes: 59){
            //1200 - 1259
            tableOneLine = 6
        }else if (dutyTableEntryTime >= convertToDate(hours: 13, minutes: 00)) && dutyTableEntryTime  <= convertToDate(hours: 16, minutes: 59){
            //1300 -1659
            tableOneLine = 7
        }else if (dutyTableEntryTime >= convertToDate(hours: 17, minutes: 00)) && dutyTableEntryTime  <= convertToDate(hours: 21, minutes: 59){
            //1700 - 2159
            tableOneLine = 8
        }else if (dutyTableEntryTime >= convertToDate(hours: 22, minutes: 00)) && dutyTableEntryTime  <= convertToDate(hours: 22, minutes: 59){
            //2200 - 2259
            tableOneLine = 9
        }else if (dutyTableEntryTime >= convertToDate(hours: 23, minutes: 00)) && dutyTableEntryTime  <= convertToDate(hours: 23, minutes: 59){
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
        
        return dutyOn.addingTimeInterval(maxDutyPeriod).addingTimeInterval(deltaTime)
        
    }
    
    
    
    
    
    // Duty Time Remaining
    
    var dutyTimeRemaining :Date{
        
        //must duty off minus current time?
        //TODO: This may need capture logic for for "Must Duty off times" that not in range.
        
        return motModel.mustDutyOffat - (convertToInterval(TimeOject: Date())) // IMPORTANT: This calls a new current time.
        
        
    }
    
    // Duty Based MOT:
    //Must Duty Off at(date) - Projected Block(interval) - TaxiIn(interval)
    var dutyBasedMOT :Date{
        
        //let projectedBlockInterval = -(convertToInterval(TimeOject: motModel.projcetedBlock))
        let projectedBlockInterval = -motModel.projcetedBlock
        //let bufferInterval = -(convertToInterval(TimeOject: motModel.buffer))
        let bufferInterval = -motModel.taxiIn
        return (motModel.mustDutyOffat.addingTimeInterval(projectedBlockInterval)).addingTimeInterval(bufferInterval)
    }
    
    var extendableToMOT :Date{
        
        //dutyBasedMOT + 2 hours.
        
        return dutyBasedMOT.addingTimeInterval(3600 * 2)
        
    }
    
    
    
    
    
    
    //Max FLight Time
    //Determined From aclimated report time
    var maxFligtTIme :TimeInterval{
        
        if (motModel.dutyOn >= convertToDate(hours: 5, minutes: 00)) && (motModel.dutyOn <= convertToDate(hours: 19, minutes: 59)){
            // 0000 - 0459 8 hours Max flight
            return TimeInterval(9 * 3600)
        }else{
            return TimeInterval(8 * 3600)
        }
    }
    
    //flight time Remaining
    //Max flight time less (-) totalFLight time
    
    var flightTimeRemaining :TimeInterval{
        
        return maxFligtTIme - totalFlightTimeAsInterval - projcetedBlock - taxiIn
    }
    
    var RAPFDP :TimeInterval{
        
        // this is the maximum reserve + FDP period as defined in FOM 1.38.7
        
        let conditionA :TimeInterval = 57600.0  // Maximum 16 hours
        let conditionB :TimeInterval = motModel.maxDutyPeriod + 14400.0 // FDP + 4 hours
        
        return min(conditionA,conditionB)
        
    }
    
    var response :String{
        
        if dutyBasedMOT <= currentTime{
            
            return "For Departure Planning: Do not block out if either MOT is expectd to be exceeded"
        }else{
            
            return "Error: check response conditions"
        }
        
        
        
    }
    

    
}


