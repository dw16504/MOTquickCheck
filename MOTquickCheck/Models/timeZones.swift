//
//  timeZones.swift
//  MOTquickCheck
//
//  Created by Douglas Webb on 11/15/25.
//

struct TimeZoneInfo {
    let name: String       // Max 25 characters
    let utcOffset: Int     // Offset from UTC in hours

    init(name: String, utcOffset: Int) {
        precondition(name.count <= 25, "Time zone name must be 25 characters or less.")
        self.name = name
        self.utcOffset = utcOffset
    }
}

func offsetAsString(offset: Int)-> String{
    
    return "\(String(offset)):00"
    
}



// Common global time zones (hard-coded).
// NOTE: Some regions that use half-hour offsets are approximated
// to the nearest hour because utcOffset is an Int.
let TimeZonesOptions: [TimeZoneInfo] = [
    // UTC / reference
    TimeZoneInfo(name: "UTC", utcOffset: 0),

    // North America
    TimeZoneInfo(name: "Pacific/Honolulu", utcOffset: -10),
    TimeZoneInfo(name: "America/Anchorage", utcOffset: -9),
    TimeZoneInfo(name: "America/Los_Angeles", utcOffset: -8),
    TimeZoneInfo(name: "America/Phoenix", utcOffset: -7),
    TimeZoneInfo(name: "America/Denver", utcOffset: -7),
    TimeZoneInfo(name: "America/Chicago", utcOffset: -6),
    TimeZoneInfo(name: "America/New_York", utcOffset: -5),
    TimeZoneInfo(name: "America/Toronto", utcOffset: -5),
    TimeZoneInfo(name: "Atlantic/Aruba", utcOffset: -4),
    TimeZoneInfo(name: "America/Sao_Paulo", utcOffset: -3),

    // Europe
    TimeZoneInfo(name: "Europe/London", utcOffset: 0),
    TimeZoneInfo(name: "Europe/Reykjavik", utcOffset: 0),
    TimeZoneInfo(name: "Europe/Berlin", utcOffset: 1),
    TimeZoneInfo(name: "Europe/Paris", utcOffset: 1),
    TimeZoneInfo(name: "Europe/Madrid", utcOffset: 1),
    TimeZoneInfo(name: "Europe/Rome", utcOffset: 1),
    TimeZoneInfo(name: "Europe/Athens", utcOffset: 2),
    TimeZoneInfo(name: "Europe/Moscow", utcOffset: 3),

    // Africa / Middle East
    TimeZoneInfo(name: "Africa/Lagos", utcOffset: 1),
    TimeZoneInfo(name: "Africa/Johannesburg", utcOffset: 2),
    TimeZoneInfo(name: "Asia/Jerusalem", utcOffset: 2),
    TimeZoneInfo(name: "Asia/Riyadh", utcOffset: 3),
    TimeZoneInfo(name: "Asia/Dubai", utcOffset: 4),

    // Asia
    TimeZoneInfo(name: "Asia/Karachi", utcOffset: 5),
    TimeZoneInfo(name: "Asia/Kolkata", utcOffset: 5),   // actual is +5:30
    TimeZoneInfo(name: "Asia/Dhaka", utcOffset: 6),
    TimeZoneInfo(name: "Asia/Bangkok", utcOffset: 7),
    TimeZoneInfo(name: "Asia/Jakarta", utcOffset: 7),
    TimeZoneInfo(name: "Asia/Shanghai", utcOffset: 8),
    TimeZoneInfo(name: "Asia/Singapore", utcOffset: 8),
    TimeZoneInfo(name: "Asia/Hong_Kong", utcOffset: 8),
    TimeZoneInfo(name: "Asia/Tokyo", utcOffset: 9),
    TimeZoneInfo(name: "Asia/Seoul", utcOffset: 9),

    // Oceania
    TimeZoneInfo(name: "Australia/Brisbane", utcOffset: 10),
    TimeZoneInfo(name: "Australia/Sydney", utcOffset: 10),
    TimeZoneInfo(name: "Pacific/Noumea", utcOffset: 11),
    TimeZoneInfo(name: "Pacific/Auckland", utcOffset: 12)
]
