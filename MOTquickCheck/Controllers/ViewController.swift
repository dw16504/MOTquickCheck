//
//  ViewController.swift
//  MOTquickCheck
//
//  Created by Douglas Webb on 12/3/24.
//

import UIKit
import CoreLocation

// Global Stuff

var motModel = MOTModel()
var currentTimeDate: Date =  Date()
let responseDateFormater = DateFormatter()


class ViewController: UIViewController, UITextFieldDelegate, SegmentListDelegate, CLLocationManagerDelegate {
 
    let locationManager = CLLocationManager()
    let geocoder = CLGeocoder()
    
    
    func didUpdateValue(_ value: MOTModel) {
        
        numberOFSegmentsLabel.text = String(value.numberOfSegments)
        totalFlightTImeLabel.text = value.totalFlightTimeAsString
        
    }
    
    
    // This section gets location and processes Time zone data.

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        geocoder.reverseGeocodeLocation(locations.last!){ placemarks, error in
            
            if let placemark = placemarks?.first{
                motModel.currentTimeZone = placemark.timeZone?.description ?? "error writing TimeZone"
            }else{
                print("ERROR 2: Unable to assign timezone to placemark")
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print("ERROR 3: Unable to determine Location")
    }
    
    
    
    
//This function customizes the Data Entry Keyboard
    // Im going to try the Duty on block first and then see if i cant make this a reusable function.
    
    func setupTextField(targetField : UITextField) {
        targetField.keyboardType = .numberPad
        
        let customButton = UIButton(type: .system)
        customButton.setTitle("Enter", for: .normal)
        customButton.addTarget(self, action: #selector(dismissKeyboard), for: .touchUpInside)

        // Style The custom button
        customButton.layer.borderWidth = 1.0
        customButton.layer.borderColor = UIColor.systemBlue.cgColor
        customButton.layer.cornerRadius = 4.0
        customButton.frame.size.width = 100
        customButton.backgroundColor = UIColor.clear //COLOR FIX
        
        let customBarButton = UIBarButtonItem(customView: customButton)
   
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
    
        let flexSpace = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil
        )
        
        toolbar.items = [flexSpace, customBarButton, flexSpace]
        targetField.inputAccessoryView = toolbar
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    // Stuff that happens when view opens.
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        
        
        
        
        print("The current timezone set by the user is: \(Calendar.current.timeZone)")
        print("The TimeZone from current Location os: \(motModel.currentTimeZone)")
        
        responseDateFormater.timeZone = Calendar.current.timeZone
        
        // TAG 2
        ReserveStartEntry.delegate = self
        setupTextField(targetField: ReserveStartEntry)
        
        // TAG 3
        dutyOnEntry.delegate = self
        setupTextField(targetField: dutyOnEntry)
        
        // TAG 4
        actualBlockOutEntry.delegate = self
        setupTextField(targetField: actualBlockOutEntry)
        
        //TAG 5
        projectedBlockEntry.delegate = self
        setupTextField(targetField: projectedBlockEntry)
        
        //TAG 6
        bufferEntry.delegate = self
        setupTextField(targetField: bufferEntry)
        
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
            AclimatedLabel.text = "Aclimated to Base"
        }else{
            AclimatedLabel.text = "Unaclimated"
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
        setTimeOption(motModel.useUTC)
        
    }
    
    @IBOutlet weak var timeSelectorLabel: UILabel!
    
    @IBOutlet weak var currentTimeLabel: UILabel!
    
    @IBOutlet weak var currentTime: UILabel! // set to TAG 0
    
    @IBOutlet weak var ReserveStartLabel: UILabel!
    
    @IBOutlet weak var ReserveStartEntry: UITextField! //set to TAG 2
    
    @IBOutlet weak var dutyOnEntry: UITextField! // set to TAG 3
    
    @IBOutlet weak var actualBlockOutEntry: UITextField! //set to TAG 4
    
    @IBOutlet weak var projectedBlockEntry: UITextField! // set to TAG 5
    
    @IBOutlet weak var bufferEntry: UITextField! // set to TAG 6
    
    
   // Action that goes to MOTController
    @IBAction func MOTselector(_ sender: Any) {
    
        performSegue(withIdentifier: "gotoMOTcontroller", sender: self)
       
    }
    
    
    
   
    
    
    func textFieldDidEndEditing(_ textField: UITextField){
        
        do{
            let responseX = try timeValidator(stringInput: textField.text ?? "")
            responseDateFormater.dateFormat = "HH:mm"
            let stringEntered = (responseDateFormater.string(from: responseX))
          
            
            switch textField.tag{
                
            case 2:
                motModel.reserveStart = responseX
            case 3:
                motModel.dutyOn = responseX
            case 4:
                motModel.actualBlockOut = responseX
            case 5:
                motModel.actualBlockOut = responseX
            case 6:
                motModel.buffer = responseX
            default:
                print("Error: no update was made in the DidEndEditing Switch statement")
                
            }
            
            print("The last two values to be checked ActualBlock  \(motModel.timeAsString(motModel.actualBlockOut)) and buffer \(motModel.timeAsString(motModel.buffer))")
            
            
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


