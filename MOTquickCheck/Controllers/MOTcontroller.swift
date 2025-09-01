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
        print("Total Flight time as String: \(motModel.totalFlightTimeAsString)")
        totalFlightTIme.text = motModel.totalFlightTimeAsString
    
        print("The Duty on time is \(motModel.dutyOn)")
        
    }
    @IBOutlet weak var numberOfSegments: UILabel!
    @IBOutlet weak var totalFlightTIme: UILabel!
    
    @IBAction func returnToMainPage(_ sender: Any) {
        
        self.dismiss(animated: true)
        
    }
}
