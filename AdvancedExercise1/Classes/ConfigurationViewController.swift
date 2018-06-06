//
//  ConfigurationViewController.swift
//  AdvancedExercise1
//
//  Created by Prateek Sharma on 5/30/18.
//  Copyright © 2018 Prateek Sharma. All rights reserved.
//

import UIKit


enum ConfigurationError: Error {
    case wrongInput(settings: String)
    case validation(error: String)
}

protocol ConfigurablesProtocol: NSObjectProtocol {
    func update(animationDuration: TimeInterval, gridCellSize: CGSize, minHorizontalSpacing: CGFloat, minVerticalSpacing: CGFloat)
}


class ConfigurationViewController: UIViewController {

    weak var delegate: ConfigurablesProtocol?
    
    @IBOutlet weak private var animationDurationTextField: UITextField!
    @IBOutlet weak private var gridCellWidthTextField: UITextField!
    @IBOutlet weak private var gridCellHeightTextField: UITextField!
    @IBOutlet weak private var minHorizontalSpacingTextField: UITextField!
    @IBOutlet weak private var minVerticalSpacingTextField: UITextField!
    
    private var animationDuration: TimeInterval!
    private var gridCellSize: CGSize!
    private var minimumHorizontalSpacing: CGFloat!
    private var minimumVerticalSpacing: CGFloat!

    
    private enum TextFieldNames {
        static let animationDuration = "Animation Duration"
        static let gridCellWidth = "Cell's Width"
        static let gridCellHeight = "Cell's Height"
        static let minHorizontalSpacing = "Minimum Horizontal Spacing"
        static let minVerticalSpacing = "Minimum Vertical Spacing"
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presetValues()
        setKeyboardHideGesture()
    }
    func set(animationDuration: TimeInterval, gridCellSize: CGSize, minHorizontalSpacing: CGFloat, minVerticalSpacing: CGFloat) {
        self.animationDuration = animationDuration
        self.gridCellSize = gridCellSize
        self.minimumHorizontalSpacing = minHorizontalSpacing
        self.minimumVerticalSpacing = minVerticalSpacing
    }
    
}

extension ConfigurationViewController {
    
    private func setKeyboardHideGesture(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGesture)
    }
    private func presetValues() {
        animationDurationTextField.text = "\(animationDuration ?? 0)"
        gridCellWidthTextField.text = String(format: "%.2f", (gridCellSize ?? CGSize.zero).width)
        gridCellHeightTextField.text = String(format: "%.2f", (gridCellSize ?? CGSize.zero).height)
        minHorizontalSpacingTextField.text = "\(minimumHorizontalSpacing ?? 0)"
        minVerticalSpacingTextField.text = "\(minimumVerticalSpacing ?? 0)"
    }
    
    private func updateSavedSettings() {
        animationDuration = parseInput(for: animationDurationTextField.text) ?? 0
        gridCellSize = CGSize(width: parseInput(for: gridCellWidthTextField.text) ?? 0, height: parseInput(for: gridCellHeightTextField.text) ?? 0)
        minimumHorizontalSpacing = CGFloat(parseInput(for: minHorizontalSpacingTextField.text) ?? 0)
        minimumVerticalSpacing = CGFloat(parseInput(for: minVerticalSpacingTextField.text) ?? 0)
    }
    
}


extension ConfigurationViewController: Validator {
    
    private func createValidationFields() -> [ValidationFields] {
        return [
            ValidationFields(text: animationDurationTextField.text, settingName: TextFieldNames.animationDuration),
            ValidationFields(text: gridCellWidthTextField.text, settingName: TextFieldNames.gridCellWidth),
            ValidationFields(text: gridCellHeightTextField.text, settingName: TextFieldNames.gridCellHeight),
            ValidationFields(text: minHorizontalSpacingTextField.text, settingName: TextFieldNames.minHorizontalSpacing),
            ValidationFields(text: minVerticalSpacingTextField.text, settingName: TextFieldNames.minVerticalSpacing)
        ]
    }
    
}

extension ConfigurationViewController {
    
    @IBAction private func backButtonTapped() {
        do {
            try validate(fields: createValidationFields())
            updateSavedSettings()
            delegate?.update(animationDuration: animationDuration, gridCellSize: gridCellSize, minHorizontalSpacing: minimumHorizontalSpacing, minVerticalSpacing: minimumVerticalSpacing)
            navigationController?.popViewController(animated: true)
        }
        catch ConfigurationError.wrongInput(let invalidInputSettings) { showInvalidInputAlert(textFieldNames: invalidInputSettings) }
        catch {
            presentSimpleAlert(title: "Error", message: error.localizedDescription)
        }
    }
    
    @objc private func hideKeyboard() {
        self.view.endEditing(true)
    }

}

extension ConfigurationViewController {
    
    private func showInvalidInputAlert(textFieldNames: String) {
        presentSimpleAlert(title: "Wrong Values Set", message: "\(textFieldNames) have wrong values set. Please correct them")
    }
    
}
