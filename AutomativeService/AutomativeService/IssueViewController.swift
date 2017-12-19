//
//  IssueViewController.swift
//  AutomativeService
//
//  Created by Sergey Morenko on 12/11/17.
//  Copyright © 2017 Sergey Morenko. All rights reserved.
//

import UIKit

extension UITextView: UITextViewDelegate {
    
    override open var bounds: CGRect {
        didSet {
            self.resizePlaceholder()
        }
    }
    
    public var placeholder: String? {
        get {
            var placeholderText: String?
            
            if let placeholderLbl = self.viewWithTag(50) as? UILabel {
                placeholderText = placeholderLbl.text
            }
            
            return placeholderText
        }
        set {
            if let placeholderLbl = self.viewWithTag(50) as! UILabel? {
                placeholderLbl.text = newValue
                placeholderLbl.sizeToFit()
            } else {
                self.addPlaceholder(newValue!)
            }
        }
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        if let placeholderLbl = self.viewWithTag(50) as? UILabel {
            placeholderLbl.isHidden = self.text.count > 0
        }
    }
    
    private func resizePlaceholder() {
        if let placeholderLbl = self.viewWithTag(50) as! UILabel? {
            let x = self.textContainer.lineFragmentPadding
            let y = self.textContainerInset.top - 2
            let width = self.frame.width - (x * 2)
            let height = placeholderLbl.frame.height
            
            placeholderLbl.frame = CGRect(x: x, y: y, width: width, height: height)
        }
    }
    
    private func addPlaceholder(_ placeholderText: String) {
        let placeholderLbl = UILabel()
        
        placeholderLbl.text = placeholderText
        placeholderLbl.sizeToFit()
        
        placeholderLbl.font = self.font
        placeholderLbl.textColor = UIColor.lightGray
        placeholderLbl.tag = 50
        
        placeholderLbl.isHidden = self.text.count > 0
        
        self.addSubview(placeholderLbl)
        self.resizePlaceholder()
        self.delegate = self
    }
}

class IssueViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    private let _contactPreferencePicker = UIPickerView()
    private let _datePicker = UIDatePicker()
    private var onComplete: ((_ issue: IssueEntity) -> Void)? = nil
    private var _inputIssue: IssueEntity?
    
    @IBOutlet weak var _tbEstimate: UITextField!
    @IBOutlet weak var _btSave: UIBarButtonItem!
    @IBOutlet weak var _tbFirstName: UITextField!
    @IBOutlet weak var _tbLastName: UITextField!
    @IBOutlet weak var _tbPhone: UITextField!
    @IBOutlet weak var _tbEmail: UITextField!
    @IBOutlet weak var _tbContactPreference: UITextField!
    @IBOutlet weak var _tbVehicleColor: UITextField!
    @IBOutlet weak var _tbVehiclePC: UITextField!
    @IBOutlet weak var _tbVehicleMake: UITextField!
    @IBOutlet weak var _tbVehicleModel: UITextField!
    @IBOutlet weak var _tbVehicleVIN: UITextField!
    @IBOutlet weak var _tbWorkNeeded: UITextView!
    @IBOutlet weak var _tbDaysNeeded: UITextField!
    
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        return dateFormatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _contactPreferencePicker.delegate = self
        _contactPreferencePicker.dataSource = self
        
        _tbContactPreference.inputView = _contactPreferencePicker
        createDatePicker()
        updateFields()
        _tbWorkNeeded.placeholder = "Work needed"
    }
    
    func createDatePicker() {
        _datePicker.datePickerMode = .date
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(estimateDateSelected))
        toolbar.setItems([doneButton], animated: false)
        _tbEstimate.inputAccessoryView = toolbar
        _tbEstimate.inputView = _datePicker
    }
    
    @objc func estimateDateSelected() {
        _tbEstimate.text = dateFormatter.string(from: _datePicker.date)
        self.view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ContactPreference.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        _tbContactPreference.text = ContactPreference.items[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return ContactPreference.items[row]
    }
    
    public func setup(issue: IssueEntity?, onComplete: @escaping (_ issue: IssueEntity) -> Void) -> Void {
        self.onComplete = onComplete
        _inputIssue = issue
    }
    
    @IBAction func onSaveClicked(_ sender: Any) {
        
        var hasError = false
 
        if Int(_tbDaysNeeded.text!) == nil {
            errorHighlightTextField(_tbDaysNeeded)
            hasError = true
        }
        
        if hasError {
            return
        }
        
        
        let issue = IssueEntity(dayNeeded: Int(_tbDaysNeeded.text!)! , estimate: Date())

        issue.firstName = _tbFirstName.text ?? ""
        issue.lastName = _tbLastName.text ?? ""
        issue.email = _tbEmail.text ?? ""
        issue.phone = _tbPhone.text ?? ""
        issue.vehicleColor = _tbVehicleColor.text ?? ""
        issue.vehiclePC = _tbVehiclePC.text ?? ""
        issue.vehicleMake = _tbVehicleMake.text ?? ""
        issue.vehicleModel = _tbVehicleModel.text ?? ""
        issue.vehicleVIN = _tbVehicleVIN.text ?? ""
        issue.workNeeded = _tbWorkNeeded.text ?? ""
        
        if let onComplete  = onComplete {
            onComplete(issue)
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onCancelClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    private func updateFields() -> Void {
        guard let issue = _inputIssue else {
            return
        }
        
        _tbEstimate.text = dateFormatter.string(from: issue.estimate)
        _tbFirstName.text = issue.firstName
        _tbLastName.text = issue.lastName
        _tbPhone.text = issue.phone
        _tbEmail.text = issue.email
        _tbContactPreference.text = issue.contactPreference.rawValue
        _tbVehicleMake.text = issue.vehicleMake
        _tbVehiclePC.text = issue.vehiclePC
        _tbVehicleVIN.text = issue.vehicleVIN
        _tbVehicleColor.text = issue.vehicleColor
        _tbVehicleModel.text = issue.vehicleModel
        _tbWorkNeeded.text = issue.workNeeded
        _tbDaysNeeded.text = String(issue.dayNeeded)
    }
    
    
    // When focussed - show gray border
    func highlightSelectedTextField(_ textfield: UITextField){
        textfield.layer.borderColor = UIColor.gray.cgColor
        textfield.layer.borderWidth = 1
        textfield.layer.cornerRadius = 5
    }
    
    // Text Field is empty - show red border
    func errorHighlightTextField(_ textField: UITextField){
        textField.layer.borderColor = UIColor.red.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 5
    }
    
    // Text Field is NOT empty - show gray border with 0 border width
    func removeErrorHighlightTextField(_ textField: UITextField){
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.borderWidth = 0
        textField.layer.cornerRadius = 5
    }
}
