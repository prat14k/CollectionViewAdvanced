//
//  ConfigurationViewController.swift
//  AdvancedExercise1
//
//  Created by Prateek Sharma on 5/30/18.
//  Copyright © 2018 Prateek Sharma. All rights reserved.
//

import UIKit


protocol ConfigurablesProtocol: NSObjectProtocol {
    func setSettings(animationDuration: TimeInterval, elementSize: CGSize, horizontalSpacing: CGFloat, verticalSpacing: CGFloat)
}


class ConfigurationViewController: UIViewController {

    enum TagValues: Int {
        case animationDurationTextField
        case elementCellWidthTextField
        case elementCellHeightTextField
        case horizontalSpacingTextField
        case verticalSpacingTextField
    }
    
    
    
    
    @IBOutlet weak private var animationDurationTextField: UITextField! {
        didSet {  animationDurationTextField.tag = TagValues.animationDurationTextField.rawValue  }
    }
    @IBOutlet weak private var elementCellWidthTextField: UITextField! {
        didSet {  elementCellWidthTextField.tag = TagValues.elementCellWidthTextField.rawValue  }
    }
    @IBOutlet weak private var elementCellHeightTextField: UITextField! {
        didSet {  elementCellHeightTextField.tag = TagValues.elementCellHeightTextField.rawValue  }
    }
    @IBOutlet weak private var horizontalSpacingTextField: UITextField! {
        didSet {  horizontalSpacingTextField.tag = TagValues.horizontalSpacingTextField.rawValue  }
    }
    @IBOutlet weak private var verticalSpacingTextField: UITextField! {
        didSet {  verticalSpacingTextField.tag = TagValues.verticalSpacingTextField.rawValue  }
    }
    
    
    weak var delegate: ConfigurablesProtocol?
    
    var animationDuration: TimeInterval!
    var elementSize: CGSize!
    var minimumHorizontalSpacing: CGFloat!
    var minimumVerticalSpacing: CGFloat!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setPreviousValues()
        setKeyboardHideGesture()
        setBackButton()
    }
    
    
    func setBackButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "< Back", style: .plain, target: self, action: #selector(backButtonTapped))
    }
    
    @objc func backButtonTapped() {
        
        if isSettingsValid() {
            delegate?.setSettings(animationDuration: animationDuration, elementSize: elementSize, horizontalSpacing: minimumHorizontalSpacing, verticalSpacing: minimumVerticalSpacing)
            navigationController?.popViewController(animated: true)
        }
    }
    
    func setKeyboardHideGesture(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGesture)
    }
    
    
    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    
    func setPreviousValues() {
        animationDurationTextField.text = "\(animationDuration ?? 0)"
        elementCellWidthTextField.text = String(format: "%.2f", (elementSize ?? CGSize.zero).width)
        elementCellHeightTextField.text = String(format: "%.2f", (elementSize ?? CGSize.zero).height)
        horizontalSpacingTextField.text = "\(minimumHorizontalSpacing ?? 0)"
        verticalSpacingTextField.text = "\(minimumVerticalSpacing ?? 0)"
    }
    
}


extension ConfigurationViewController: UITextFieldDelegate {
    
    func showAlertView(textFieldNames: String) {
        let alertController = UIAlertController(title: "Wrong Values Set", message: "\(textFieldNames) have wrong values set. We have reset it to the default values", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    func isSettingsValid() -> Bool {
        var textFieldNames: String!
        if !isInputValid(textField: animationDurationTextField) {
            textFieldNames = "Animation Duration"
        }
        else {
           animationDuration = Double(animationDurationTextField.text!)
        }
        if !isInputValid(textField: elementCellWidthTextField) {
            textFieldNames = textFieldNames + "," + "Element Width"
        }
        else {
            elementSize.width = CGFloat(Double(elementCellWidthTextField.text!)!)
        }
        if !isInputValid(textField: elementCellHeightTextField) {
            textFieldNames = textFieldNames + "," + "Element Height"
        }
        else {
            elementSize.height = CGFloat(Double(elementCellHeightTextField.text!)!)
        }
        if !isInputValid(textField: horizontalSpacingTextField) {
            textFieldNames = textFieldNames + "," + "Minimum Horizontal Spacing"
        }
        else {
            minimumHorizontalSpacing = CGFloat(Double(horizontalSpacingTextField.text!)!)
        }
        if !isInputValid(textField: verticalSpacingTextField) {
            textFieldNames = textFieldNames + "," + "Minimum Vertical Spacing"
        }
        else {
            minimumVerticalSpacing = CGFloat(Double(verticalSpacingTextField.text!)!)
        }
        
        if textFieldNames == nil {
            return true
        } else {
            showAlertView(textFieldNames: textFieldNames)
            return false
        }
    }
    
    func isInputValid(textField: UITextField) -> Bool {
        return Double(textField.text!) != nil
    }
    
}



