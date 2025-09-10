//
//  ViewController.swift
//  MOTquickCheck
//
//  Created by Douglas Webb on 12/3/24.
//

import UIKit

var motModel = MOTModel()
var currentTimeDate: Date =  Date()
let responseDateFormater = DateFormatter()


class ViewController: UIViewController, UITextFieldDelegate, SegmentListDelegate {
    
    func didUpdateValue(_ value: MOTModel) {
        
        numberOFSegmentsLabel.text = String(value.numberOfSegments)
        totalFlightTImeLabel.text = value.totalFlightTimeAsString
        
    }
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        responseDateFormater.timeZone = Calendar.current.timeZone

        ReserveStartEntry.delegate = self
        dutyOnEntry.delegate = self
        actualBlockOutEntry.delegate = self
        projectedBlockEntry.delegate = self
        bufferEntry.delegate = self
        
        responseDateFormater.dateFormat = "HH:mm"
        currentTime.text = responseDateFormater.string(from: currentTimeDate)
        
        numberOFSegmentsLabel.text = String(motModel.numberOfSegments)
        
        setTimeOption(motModel.useUTC)
        
    }
    
    

    @IBAction func AddBlockButton(_ sender: UIButton) {
        
        let secondaryVC = storyboard!.instantiateViewController(withIdentifier: "SegmentListID") as! SegmentListController
        
        secondaryVC.delegate = self
        present(secondaryVC, animated: true)
        
    }
    

    
    @IBOutlet weak var numberOFSegmentsLabel: UILabel!
    
    @IBOutlet weak var totalFlightTImeLabel: UILabel!
    
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
            ReserveStartEntry.isEnabled = false
            ReserveStartEntry.textColor = .systemGray4
            lineHolderLabel.text = "Line Holder"
            
        }else{
            ReserveStartLabel.textColor = .systemGray
            ReserveStartEntry.isEnabled = true
            ReserveStartEntry.textColor = .systemGray
            lineHolderLabel.text = "Reserve"
        }
        
    }
    
    @IBAction func useUTCSelector(_ sender: UISwitch) {
        
        motModel.useUTC.toggle()
        
        print("Use UTC is set to: \(motModel.useUTC)")
        
        setTimeOption(motModel.useUTC)
        
    }
    
    @IBOutlet weak var timeSelectorLabel: UILabel!
    
    @IBOutlet weak var currentTimeLabel: UILabel!
    
    @IBOutlet weak var currentTime: UILabel!
    
    @IBOutlet weak var ReserveStartLabel: UILabel!
    
   // @IBOutlet weak var ReserveStartEntry: UITextField!
    @IBOutlet weak var ReserveStartEntry: UITextField!
    
    @IBOutlet weak var dutyOnEntry: UITextField! // set to TAG3
    
    @IBOutlet weak var actualBlockOutEntry: UITextField!
    
    @IBOutlet weak var projectedBlockEntry: UITextField!
    
    @IBOutlet weak var bufferEntry: UITextField!
    
    
    
    @IBAction func MOTselector(_ sender: Any) {
        
        print("Go to Mot Selector")
        
        print(motModel)
    
        performSegue(withIdentifier: "gotoMOTcontroller", sender: self)
        
        
    }
    
    
    
   
    
    
    func textFieldDidEndEditing(_ textField: UITextField){
        
        do{
            let responseX = try timeValidator(stringInput: textField.text ?? "")
            responseDateFormater.dateFormat = "HH:mm"
            let stringEntered = (responseDateFormater.string(from: responseX))
            
            print("The Tag associated with the entry field is \(textField.tag)")
            
            
            // I THINK THIS IS WHERE I NEED TO ASSIGN VALUES ?
            
            textField.text = stringEntered
            
        }catch{
            print(error)
        }
        
    }
    
    func setTimeOption(_ input: Bool){
        if input == false{
            responseDateFormater.timeZone = Calendar.current.timeZone
            timeSelectorLabel.text = "Local Time"
            currentTimeLabel.text = responseDateFormater.timeZone.description
            
            currentTime.text = responseDateFormater.string(from: currentTimeDate)
            
        }else{
            responseDateFormater.timeZone = TimeZone(abbreviation: "UTC")
            timeSelectorLabel.text = "UTC"
            currentTimeLabel.text = "Time UTC:"
            
            currentTime.text = responseDateFormater.string(from: currentTimeDate)
        }
    }
    
    
    
}


