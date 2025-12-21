//
//  ViewController.swift
//  MOTquickCheck
//
//  Created by Douglas Webb on 12/3/24.
//

import UIKit
import CoreLocation

// Global Stuff

var companyBlue = (hex:"#00b1fc",rgb:"rgb(0, 178, 255)")
var companyPurple = (hex:"#551cc7",rgb:"rgb(85, 28, 199)")


var motModel = MOTModel()

let responseDateFormater = DateFormatter()


class ViewController: UIViewController, UITextFieldDelegate, SegmentListDelegate, CLLocationManagerDelegate {
 
    let locationManager = CLLocationManager()
    let geocoder = CLGeocoder()
    
    
    //stuff that happens whem the motModel changes
    
    func didUpdateValue(_ value: MOTModel) {
        
        numberOFSegmentsLabel.text = String(value.numberOfSegments)
        //totalFlightTImeLabel.text = value.totalFlightTimeAsString
        totalFlightTImeLabel.text = intervalAsString(value.totalFlightTimeAsInterval)
    }
    
    
    // This section gets location and processes Time zone data.

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        geocoder.reverseGeocodeLocation(locations.last!){ placemarks, error in
            
            if let placemark = placemarks?.first{
                motModel.currentTimeZone = placemark.timeZone!
                print(motModel.currentTimeZone)
            }else{
                print("ERROR 2: Unable to assign timezone to placemark")
                print(error as Any)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print("ERROR 3: Unable to determine Location")
    }
    
    
    
    
//This function customizes the Data Entry Keyboard
   
    
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
        
        
        responseDateFormater.timeZone = Calendar.current.timeZone
        
        selectedTimeZoneOutlet.text = TimeZonesOptions[motModel.startTimeZone].name
        selectedOffsetOutlet.text = offsetAsString(offset:(TimeZonesOptions[motModel.startTimeZone].utcOffset))
        
        dutyOnTimeZoneOutlet.text = TimeZonesOptions[motModel.dutyOnTimeZone].name
        dutyOnOffsetOutlet.text = offsetAsString(offset: TimeZonesOptions[motModel.dutyOnTimeZone].utcOffset)
        
        
        // TAG 2
        ReserveStartEntry.delegate = self
        setupTextField(targetField: ReserveStartEntry)
        
        // TAG 3
        dutyOnEntry.delegate = self
        setupTextField(targetField: dutyOnEntry)
        
        //TAG 5
        projectedBlockEntry.delegate = self
        setupTextField(targetField: projectedBlockEntry)
        
        //TAG 6
        bufferEntry.delegate = self
        setupTextField(targetField: bufferEntry)
        
        responseDateFormater.dateFormat = "HH:mm"
        
        numberOFSegmentsLabel.text = String(motModel.numberOfSegments)
        
        
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
    
    @IBOutlet weak var AugmentedOutlet: UISwitch!
    
    func SetAugmentedLabel(){
        
        
        
    }
    
    
    @IBAction func restFaciitySelector(_ sender: UISegmentedControl) {
        motModel.restFacility = sender.selectedSegmentIndex+1
    }
  
    @IBOutlet weak var restFacilityOutlet: UISegmentedControl!
   
    @IBAction func aclimatedHelpPressed(_ sender: UIButton) {
        print("Aclimated help pressed")
    }
    
    @IBAction func aclimatedUpPressed(_ sender: UIButton) {
        motModel.startTimeZone += 1
        selectedTimeZoneOutlet.text = TimeZonesOptions[motModel.startTimeZone].name
        selectedOffsetOutlet.text = offsetAsString(offset: TimeZonesOptions[motModel.startTimeZone].utcOffset)
    }
    
    @IBAction func AclimatedDownPressed(_ sender: UIButton) {
        
        motModel.startTimeZone -= 1
        selectedTimeZoneOutlet.text = TimeZonesOptions[motModel.startTimeZone].name
        selectedOffsetOutlet.text = offsetAsString(offset: TimeZonesOptions[motModel.startTimeZone].utcOffset)
        
    }
    
    
    @IBOutlet weak var selectedTimeZoneOutlet: UILabel!
    
    @IBOutlet weak var selectedOffsetOutlet: UILabel!
    
    
    
    
    @IBOutlet weak var lineHolderLabel: UILabel!
    
    @IBOutlet weak var lineHolderSwitchOutlet: UISwitch!
    @IBAction func LineHolderToggel(_ sender: Any) {
        
        motModel.lineHolder.toggle()
        setReserveCondition()
        
    }
    
    func setReserveCondition(){
        
        if motModel.lineHolder == true{
            ReserveStartLabel.textColor = .systemGray4
            ReserveStartEntry.isEnabled = false
            ReserveStartEntry.textColor = .systemGray4
            lineHolderLabel.text = "Line Holder"
            motModel.reserveStart = zeroValueTime
            ReserveStartEntry.text = timeAsStringLocal(motModel.reserveStart)
            
        }else{
            ReserveStartLabel.textColor = .systemGray
            ReserveStartEntry.isEnabled = true
            ReserveStartEntry.textColor = .systemGray
            lineHolderLabel.text = "Reserve"
        }
    }
    
    
   
    @IBOutlet weak var ReserveStartLabel: UILabel!
    
    @IBOutlet weak var ReserveStartEntry: UITextField! //set to TAG 2
    
    @IBOutlet weak var dutyOnEntry: UITextField! // set to TAG 3
    
    
    @IBAction func dutyOnSelectorUp(_ sender: UIButton) {
        
        motModel.dutyOnTimeZone += 1
        
        dutyOnTimeZoneOutlet.text = TimeZonesOptions[motModel.dutyOnTimeZone].name
        dutyOnOffsetOutlet.text = offsetAsString(offset: TimeZonesOptions[motModel.dutyOnTimeZone].utcOffset)

    }
    
    @IBAction func duyOnSelectoprDown(_ sender: UIButton) {
        
        motModel.dutyOnTimeZone -= 1
        
        dutyOnTimeZoneOutlet.text = TimeZonesOptions[motModel.dutyOnTimeZone].name
        dutyOnOffsetOutlet.text = offsetAsString(offset: TimeZonesOptions[motModel.dutyOnTimeZone].utcOffset)
        
    }
    
    
    @IBOutlet weak var dutyOnTimeZoneOutlet: UILabel!
    
    @IBOutlet weak var dutyOnOffsetOutlet: UILabel!
    
    
    @IBOutlet weak var projectedBlockEntry: UITextField! // set to TAG 5
    
    @IBOutlet weak var bufferEntry: UITextField! // set to TAG 6
    
    
   // Action that goes to MOTController
    @IBAction func MOTselector(_ sender: Any) {
            motModel.currentTime = Date()  //reset Current Time before segue
            performSegue(withIdentifier: "gotoMOTcontroller", sender: self)
       
    }
    
    // Action to reset Data
    @IBAction func ResetButton(_ sender: UIButton) {
        
        motModel.numberOfSegments = 1
        segmentDataSource.removeAll()
        
        DispatchQueue.main.async {
            self.totalFlightTImeLabel.text = intervalAsString(motModel.totalFlightTimeAsInterval)
            
        }
        
        
        numberOFSegmentsLabel.text = String(motModel.numberOfSegments)
        motModel.totalFlightTimeAsInterval = TimeInterval(0.0)
        
        motModel.augmented = false
        AugmentedOutlet.isOn = false
        AugmentedLabel.text = "Un-Augmented"
        
        
        motModel.restFacility = 1
        restFacilityOutlet.selectedSegmentIndex = 0
        
        motModel.lineHolder = false
        lineHolderSwitchOutlet.isOn = false
        setReserveCondition()
        
        motModel.reserveStart = zeroValueTime
        ReserveStartEntry.text = timeAsStringLocal(motModel.reserveStart)
        
        motModel.dutyOn = zeroValueTime
        dutyOnEntry.text = timeAsStringLocal(motModel.dutyOn)
        
        motModel.projcetedBlock = TimeInterval(0.0)
        projectedBlockEntry.text = intervalAsString(motModel.projcetedBlock)
        
        motModel.taxiIn = TimeInterval(0.0)
        bufferEntry.text = intervalAsString(motModel.taxiIn)
    
        
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
        
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField){
      
        //TODO: there is an extranupuse variable, startime, duty time and dutyontime! see remarks in validator.
        //TODO: rename these variables after you get it saved.
        
        do{
            
            let returnFromValidator = try timeProcessor(entryString: textField.text!, tag: textField.tag, timeZone: motModel.dutyOnTimezone)
      
            let responsFormater = DateFormatter()
            responsFormater.dateFormat = "HH:mm"
            responsFormater.timeZone = motModel.dutyOnTimezone
            
            if case .dateReturned(let date) = returnFromValidator {
                print("it was a date, and the value is \(date) ")
                
                textField.text = responsFormater.string(from: date)
                
            }else if case .intervalReturned(let timeInterval) = returnFromValidator {
                print("it was an interval and the value is \(timeInterval)")
                
                textField.text = intervalAsString(timeInterval)
                
                //TODO:
                //Interal return locgic goes here
                
            }
                
            
            
        }catch{
            print(error)
        }
        
        
        
        
        // so the mission is to take the textfield entered and put it into a function
        // the function should take three arguments, string entry, the yag, and the timezone.
        
        // ** when the function wtites to update the time, you will probalky need antoher call to address when the
        // ** timezone is changed from the UI after the time is entered, perhaps a separate function?
        
        
//
//        do{
//            var responseX :Date = Date()
//            
//            var responseY :TimeInterval = 3600.01 // make these better defaults
//            var stringEntered = "Validator Error"
//            
//            // This is executed for dates
//            if textField.tag <= 4{
//                let responseX = try timeValidator(stringInput: textField.text ?? "")
//                responseDateFormater.dateFormat = "HH:mm"
//                stringEntered = (responseDateFormater.string(from: responseX))
//                
//                
//            }else if textField.tag > 4{
//                responseY = try timeValidatorForIntervals(stringInput: textField.text ?? "")
//                stringEntered = intervalAsString(responseY)
//                
//                
//            }
//            
//            switch textField.tag{
//                
//            case 2:
//                motModel.reserveStart = responseX //Date
//            case 3:
//                motModel.dutyOn = responseX //Date
//            case 4:
//                motModel.actualBlockOut = responseX  //Date
//            case 5:
//                motModel.projcetedBlock = responseY //Interval
//            case 6:
//                motModel.taxiIn = responseY //Interval
//            default:
//                print("Error: no update was made in the DidEndEditing Switch statement")
//                
//            }
//            
//            textField.text = stringEntered
//            
//        }catch{
//            print(error)
//        }
//        
//        
//        
//        
   }
    
}


