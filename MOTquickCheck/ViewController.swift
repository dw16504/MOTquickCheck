//
//  ViewController.swift
//  MOTquickCheck
//
//  Created by Douglas Webb on 12/3/24.
//

import UIKit

var motModel = MOTModel()
//var currentTime: Date =  now()

class ViewController: UIViewController, UITextFieldDelegate {
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dutyOnEntry.delegate = self
        actualBlockOutEntry.delegate = self
        
        
    }

    
    @IBAction func segmentsSelector(_ sender: UISegmentedControl) {
        
        motModel.numberOfSegments = sender.selectedSegmentIndex + 1
    
        generateSegmentDataSource(numberOfSegments: sender.selectedSegmentIndex)
        
        performSegue(withIdentifier: "gotoSegmentList", sender: self)
        
    }
    
    
    
    @IBOutlet weak var AugmentedLabel: UILabel!
    
    @IBAction func AugmentedSelector(_ sender: UISwitch) {
        
        motModel.augmented.toggle()
        
        if motModel.augmented == true{
            AugmentedLabel.text = "Augmented"
        }else{
            AugmentedLabel.text = "Un-Augmented"
        }
        
        
    }
    
    @IBAction func restFaciitySelector(_ sender: UISegmentedControl) {
        print("The segment was changed to \(sender.selectedSegmentIndex+1)")
        
        motModel.restFacility = sender.selectedSegmentIndex+1
        
        
    }
  
    
    
    @IBOutlet weak var AclimatedLabel: UILabel!
    @IBAction func AclimatedToggel(_ sender: UISwitch) {
        
        motModel.aclimated.toggle()
        
        if motModel.aclimated == true{
            AclimatedLabel.text = "Aclimated"
        }else{
            AclimatedLabel.text = "UnAclimated"
        }
        
    }
    
 
    
    
    @IBOutlet weak var lineHolderLabel: UILabel!
    @IBAction func LineHolderToggel(_ sender: Any) {
        
        motModel.lineHolder.toggle()
        
        
        if motModel.lineHolder == true{
            ReserveStartLabel.textColor = .systemGray4
            ReserveStartEntryLabel.isEnabled = false
            ReserveStartEntryLabel.textColor = .systemGray4
            lineHolderLabel.text = "Line Holder"
            
        }else{
            ReserveStartLabel.textColor = .systemGray
            ReserveStartEntryLabel.isEnabled = true
            ReserveStartEntryLabel.textColor = .systemGray
            lineHolderLabel.text = "Reserve"
        }
        
    }
    
    @IBOutlet weak var currentTime: UILabel!
    
    @IBOutlet weak var ReserveStartLabel: UILabel!
    
    
    // both action and output.. This block uses a direct access process for getting the data from the textField
    @IBOutlet weak var ReserveStartEntryLabel: UITextField!
    @IBAction func ReserveStartEntry(_ sender: UITextField) {
        
        let enteredData = ReserveStartEntryLabel.text
        
        do{
            try print(timeValidator(stringInput: enteredData ?? ""))
        }catch {
            print(error)
        }
        
    }
    
    @IBOutlet weak var actualBlockOutEntry: UITextField!
    
    @IBAction func MOTselector(_ sender: Any) {
    
        performSegue(withIdentifier: "gotoMOTcontroller", sender: self)
    }
    
    
    
    // This one will use the didFinishEditign method as suggested in the documentation.
    @IBOutlet weak var dutyOnEntry: UITextField! // set to TAG3
    
    
    func textFieldDidEndEditing(_ textField: UITextField){
        
        print("The data entered into the textfield is: \(textField.text)")
        print("The tag of the tex field used is: \(textField.tag)")
        
    }
    
}


