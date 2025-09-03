//
//  SegmentsListController.swift
//  MOTquickCheck
//
//  Created by Douglas Webb on 2/17/25.
//

import UIKit

var segmentDataSource = [SegmentModel]()

func addSegment(){
    
    segmentDataSource.append(SegmentModel(isErrored: false, segmentNumber: 1, segmentDescription: "Flight \(segmentDataSource.count+1)", segmentTimeAsAString: "BLK Time", segmentColor: UIColor.lightGray, segmentInSeconds: 0, segmentTime: nil))
    
    
}




class SegmentListController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentTotalLabel: UILabel?
    @IBOutlet weak var errorLabel: UILabel!
    
    
    
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
        
        self.dismiss(animated: true)
    }
    
}


// MARK: - Table view features


protocol CellButtonDelegate{
    
    func didSegmentDeletedAction(with title: UIButton)
    
}

// Delegator (Parent)  class, defines the delegate property, then calls the function, this is the class that wants somthing done.

class SegmentCell: UITableViewCell {
    
    var delegate: CellButtonDelegate?
    
    @IBOutlet var segmentTimeLable: UILabel?
    
    @IBAction func segmentUpdate(_ sender: UITextField) {
        print("update Segment Selected")
        
        //This does not do anything yet, if it's not needed delete thios action and make set
        //The UI to not be user interactive.
        
    }

    @IBAction func segmentDeleted(_ sender: UIButton) {
        
        delegate?.didSegmentDeletedAction(with: sender)
        
    }
    
    @IBOutlet var deleteButton: UIButton?
    @IBOutlet weak var segmentTime: UITextField!
}






// Delegate (Child) Class, conforms to the protocol and defines the function called by the parent.
extension SegmentListController: UITableViewDataSource, UITableViewDelegate, CellButtonDelegate{
    
    //the dataSource Protocol lets it get the data, the Delegate allows interactiion (you can click
    //on it.
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return segmentDataSource.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //At this particular row, what kind of cell do we want to return
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SegmentCell
        
        // "cell" is the reuse identifier that was input on the storyboard
        // I think index path is returned from the above callback and cycles through the table
        
        
        cell.delegate = self
        cell.segmentTime.delegate = self
        //cell.segmentTimeLable?.text = "test"
        cell.segmentTimeLable!.text = segmentDataSource[indexPath.row].segmentDescription
        cell.segmentTime.text = segmentDataSource[indexPath.row].segmentTimeAsAString
        cell.segmentTime.textColor = UIColor.lightGray
        cell.deleteButton?.tag = indexPath.row
        cell.segmentTime.tag = indexPath.row
        
        if segmentDataSource[indexPath.row].isErrored{
            cell.backgroundColor = UIColor.systemYellow
        }else{
            cell.backgroundColor = UIColor.white
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print ("The user Selected the Cell at index row \(segmentDataSource[indexPath.row])")
        
        //TODO: - pick it up here
        
        //print ("The tag at the selected row is \(String(tableView))")
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
        print("The textfield did End editing!")
        
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
            print("From the view Controller, Th entry has no information")
        }catch{
            print("Now for somthing completly different")
        }
        
        //segmentTotalLabel!.text = SegmentTotaler()
        //tableView.reloadData()
    }
    
   func textFieldDidBeginEditing(_ textField: UITextField) {
        print("The textfield did begin editing!")
        
       textField.text = ""
    }
    
    
    
    
    
}


