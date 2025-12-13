//
//  MOTcontroller.swift
//  MOTquickCheck
//
//  Created by Douglas Webb on 7/21/25.
//

import Foundation


import UIKit

class MOTcontroller: UIViewController {
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        currentTimeLabel.text = timeAsStringLocal(motModel.currentTime)
        numberOfSegments.text = String(motModel.numberOfSegments)
        totalFlightTIme.text = intervalAsString(motModel.totalFlightTimeAsInterval + motModel.projcetedBlock + motModel.taxiIn)
        MaXDutyPeriodLabel.text = intervalAsString(motModel.maxDutyPeriod)
        MustDutyOffat.text = timeAsStringUTC(motModel.mustDutyOffat)
        dutyTimeReminingLabel.text = timeAsStringLocal(motModel.dutyTimeRemaining)
        maxFlightTimeLabel.text = intervalAsString(motModel.maxFligtTIme)
        dutyBasedMot.text = timeAsStringUTC(motModel.dutyBasedMOT)
        //DutyOnTime.text = motModel.timeAsString(motModel.dutyOn)
        ExtendableToLabel.text = timeAsStringUTC(motModel.extendableToMOT)
        availableTaxiTime.text = intervalAsString(motModel.flightTimeRemaining)
        
        
        // RESERVE RAP FDP Functionality
        
        
        if (motModel.lineHolder){
            
            // The Model is for a line holder
            RAPFDPlabel.textColor =  .systemGray4
            RAPFDP.textColor = .systemGray4
            RAPFDP.text = "NA"
            
            
        }else{
            // The Model is for a Reserve
            
            RAPFDPlabel.textColor = .systemGray
            RAPFDP.textColor = .systemGray
            RAPFDP.text = intervalAsString(motModel.RAPFDP)
            
        }
        
        
        
        
    }
    
    
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var numberOfSegments: UILabel!
    @IBOutlet weak var totalFlightTIme: UILabel!
    @IBOutlet weak var MaXDutyPeriodLabel: UILabel!
    @IBOutlet weak var DutyOnTime: UILabel! // remove this
    
    @IBOutlet weak var RAPFDPlabel: UILabel!
    
    @IBOutlet weak var RAPFDP: UILabel!
    
    
    
    @IBOutlet weak var MustDutyOffat: UILabel!
    @IBOutlet weak var dutyTimeReminingLabel: UILabel!
    
    @IBOutlet weak var maxFlightTimeLabel: UILabel!
    
    @IBOutlet weak var flightTimeRemainingLablel: UILabel!
    @IBOutlet weak var dutyBasedMot: UILabel!
    
    @IBOutlet weak var ExtendableToLabel: UILabel!
    
    

    @IBOutlet weak var availableTaxiTime: UILabel!
    
    
    
    @IBAction func returnToMainPage(_ sender: Any) {
        
        self.dismiss(animated: true)
        
    }
}
