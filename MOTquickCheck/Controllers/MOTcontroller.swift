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
        MustDutyOffat.text = timeAsStringLocal(motModel.mustDutyOffat)
        dutyTimeReminingLabel.text = timeAsStringLocal(motModel.dutyTimeRemaining)
        maxFlightTimeLabel.text = intervalAsString(motModel.maxFligtTIme)
        dutyBasedMot.text = timeAsStringUTC(motModel.dutyBasedMOT)
        DutyOnTime.text = motModel.timeAsString(motModel.dutyOn)
        availableTaxiTime.text = intervalAsString(motModel.flightTimeRemaining)
        
    }
    
    
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var numberOfSegments: UILabel!
    @IBOutlet weak var totalFlightTIme: UILabel!
    @IBOutlet weak var MaXDutyPeriodLabel: UILabel!
    @IBOutlet weak var DutyOnLabel: UILabel!    // This may need to togel depending on UTC or local
    @IBOutlet weak var DutyOnTime: UILabel!
    @IBOutlet weak var MustDutyOffat: UILabel!
    @IBOutlet weak var dutyTimeReminingLabel: UILabel!
    
    @IBOutlet weak var maxFlightTimeLabel: UILabel!
    
    @IBOutlet weak var flightTimeRemainingLablel: UILabel!
    @IBOutlet weak var dutyBasedMot: UILabel!

    @IBOutlet weak var availableTaxiTime: UILabel!
    
    
    
    @IBAction func returnToMainPage(_ sender: Any) {
        
        self.dismiss(animated: true)
        
    }
}
