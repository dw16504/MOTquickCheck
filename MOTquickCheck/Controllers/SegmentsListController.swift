//
//  SegmentsListController.swift
//  MOTquickCheck
//
//  Created by Douglas Webb on 2/17/25.
//

import UIKit

var segmentDataSource = [SegmentModel]()


// This protocol defines what the secondary view can tell the main view
// I have updated the name and the value Type to an MOTModel
protocol SegmentListDelegate: AnyObject {
    func didUpdateValue(_ value: MOTModel)
}


func addSegment(){
    
    segmentDataSource.append(SegmentModel(isFocused: true, isErrored: false, segmentNumber: 1, segmentDescription: "Flight \(segmentDataSource.count+1)", segmentTimeAsAString: "BLK Time", segmentColor: UIColor.lightGray, segmentInSeconds: 0, segmentTime: nil))
    
   
}



class SegmentListController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentTotalLabel: UILabel?
    @IBOutlet weak var errorLabel: UILabel!
    
    weak var delegate: SegmentListDelegate?
    
    
     
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSegment()
        
        errorLabel.text = ""
        segmentTotalLabel!.text = motModel.timeAsString(motModel.totalFlightTime!)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        
        
        
        
        
        
    }
    
    
    @IBAction func Return(_ sender: UIButton) {
        
        // Pressing the back button stores the data in the model.
    
        motModel.numberOfSegments = segmentDataSource.count
        
        print("THe Exit Button Was pressed")
        print("The number of segments in the model is: \(motModel.numberOfSegments)")
        
        
        // This is trying to use the Delegate method.
        delegate?.didUpdateValue(motModel)
        
        self.dismiss(animated: true)
    }
    
    @IBAction func AddSegment(_ sender: UIButton) {
        
        addSegment()
        tableView.reloadData()
        
    }
    
    @IBAction func ClearAll(_ sender: UIButton) {
        print("Clear All Pressed")
        segmentDataSource.removeAll()
        tableView.reloadData()
    }
    
}


// MARK: - Table view features


protocol CellButtonDelegate{
    
    func didSegmentDeletedAction(with title: UIButton)
    
}

class SegmentCell: UITableViewCell {
    
    var delegate: CellButtonDelegate?
    
    @IBOutlet var segmentTimeLable: UILabel?
    @IBOutlet var deleteButton: UIButton?
    @IBOutlet weak var segmentTime: UITextField!
    
    func setupTextField() {
        segmentTime.keyboardType = .numberPad
        
        let customButton = UIButton(type: .system)
        customButton.setTitle("Enter", for: .normal)
        customButton.addTarget(self, action: #selector(dismissKeyboard), for: .touchUpInside)

        // Style your custom button
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
        segmentTime.inputAccessoryView = toolbar
    }
    
    @objc func dismissKeyboard() {
        segmentTime.resignFirstResponder()
        // Call the existing segmentUpdate method to handle the logic
        segmentUpdate(segmentTime)
    }
    
    @IBAction func segmentUpdate(_ sender: UITextField) {
        print("update Segment Selected!!!!!!!!!!!!")
        
        //This does not do anything yet, if it's not needed delete this action and make set
        //The UI to not be user interactive.
        
        // You can add your segment update logic here
        // The text field value is available as sender.text
    }

    @IBAction func segmentDeleted(_ sender: UIButton) {
        delegate?.didSegmentDeletedAction(with: sender)
    }
}



extension SegmentListController: UITableViewDataSource, UITableViewDelegate, CellButtonDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return segmentDataSource.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SegmentCell
        
        cell.delegate = self
        cell.setupTextField()
        cell.segmentTime.delegate = self
        cell.segmentTimeLable!.text = segmentDataSource[indexPath.row].segmentDescription
        cell.segmentTime.text = segmentDataSource[indexPath.row].segmentTimeAsAString
        cell.segmentTime.placeholder = segmentDataSource[indexPath.row].segmentTimeAsAString
        
        cell.segmentTime.textColor = UIColor.lightGray
        cell.deleteButton?.tag = indexPath.row
        cell.segmentTime.tag = indexPath.row
        
        if segmentDataSource[indexPath.row].isFocused == true{
            
            cell.segmentTime.becomeFirstResponder()
        }
         
        
        cell.segmentTime.keyboardType = .numberPad
        
        
        if segmentDataSource[indexPath.row].isErrored{
            cell.backgroundColor = UIColor.systemYellow
        }else{
            cell.backgroundColor = UIColor.white
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print ("The user Selected the Cell at index row \(segmentDataSource[indexPath.row])")
        
        
        let selIndex = tableView.indexPathForSelectedRow
        print("The index path at the selected row is \(selIndex)")
        
    }
    
    func didSegmentDeletedAction(with: UIButton) {
        print("Buton actioned from delegate, the title parameter is \(with.tag)")
        segmentDataSource.remove(at: with.tag)
        
        tableView.reloadData()
        
    }
    
    
}

// MARK: - Input field properties

extension SegmentListController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        

        do{
            try segmentTimeValidator(input:textField.text!, segment: textField.tag)
            
            segmentTotalLabel!.text = SegmentTotaler()
            tableView.reloadData()
            
        }catch segmentEntryError.entryTooLong(let atSegment, let errorDescription){
            
            errorLabel.text = errorDescription
            segmentDataSource[atSegment].isErrored = true
            tableView.reloadData()
            
        }catch segmentEntryError.notANumber(let atSegment, let errorDescription){
            
            errorLabel.text = errorDescription
            segmentDataSource[atSegment].isErrored = true
            tableView.reloadData()
            
        }catch segmentEntryError.noEntry{
            print("From the view Controller, The entry has no information")
        }catch{
            print("Now for somthing completly different")
        }
        
    }
    
   func textFieldDidBeginEditing(_ textField: UITextField) {
        print("The textfield did begin editing!")
        
       textField.text = ""
    }
    
    
    
    
    
}


