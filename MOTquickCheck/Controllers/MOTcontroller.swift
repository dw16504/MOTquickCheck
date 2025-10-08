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
        
        numberOfSegments.text = String(motModel.numberOfSegments)
        totalFlightTIme.text = motModel.totalFlightTimeAsString
        MaXDutyPeriodLabel.text = motModel.timeAsString(motModel.maxDutyPeriod)
        MustDutyOffat.text = timeAsStringLocal(motModel.mustDutyOffat)
        dutyTimeReminingLabel.text = timeAsStringLocal(motModel.dutyTimeRemaining)
        
        DutyOnTime.text = motModel.timeAsString(motModel.dutyOn)
        
        
    }
    @IBOutlet weak var numberOfSegments: UILabel!
    @IBOutlet weak var totalFlightTIme: UILabel!
    @IBOutlet weak var MaXDutyPeriodLabel: UILabel!
    @IBOutlet weak var DutyOnLabel: UILabel!    // This may need to togel depending on UTC or local
    @IBOutlet weak var DutyOnTime: UILabel!
    @IBOutlet weak var MustDutyOffat: UILabel!
    @IBOutlet weak var dutyTimeReminingLabel: UILabel!
    @IBOutlet weak var dutyBasedMot: UILabel!
    
    
    @IBAction func returnToMainPage(_ sender: Any) {
        
        self.dismiss(animated: true)
        
    }
}
