//
//  SegmentModel.swift
//  MOTquickCheck
//
//  Created by Douglas Webb on 2/20/25.
//
import UIKit

struct SegmentModel{
    
    var isErrored: Bool
    var segmentNumber: Int
    var segmentDescription: String
    var segmentTimeAsAString: String
    var segmentColor: UIColor
    var segmentInSeconds: Int
    var segmentTime: Date?
    
}



// These are two different things, dont get confused....


    
//    func generateSegmentDataSource(numberOfSegments: Int){
//        
//        segmentDataSource = [SegmentModel]()
//        
//        for item in (0...numberOfSegments){
//            
//            segmentDataSource.append(SegmentModel(isErrored: false, segmentNumber: item, segmentDescription: "Segment \(item + 1)", segmentTimeAsAString: "BLK Time", segmentColor: UIColor.lightGray, segmentInSeconds: 0, segmentTime: nil))
//            
//        }
//        
//    }
    

