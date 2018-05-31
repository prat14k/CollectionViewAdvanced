//
//  ConfigurationViewController.swift
//  AdvancedExercise1
//
//  Created by Prateek Sharma on 5/30/18.
//  Copyright © 2018 Prateek Sharma. All rights reserved.
//

import UIKit


enum ConfigurationError: Error {
    case wrongInput(setting: String)
    case validation(String)
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
    
}

extension ConfigurationViewController {
    
    private func parseInput(for textField: UITextField) -> Double? {
        return Double(textField.text!)
    }
    
    private func validateAnimationDuration() throws {
        guard let value = parseInput(for: animationDurationTextField)  else { throw ConfigurationError.wrongInput(setting: TextFieldNames.animationDuration) }
        animationDuration = value
    }
    private func validateGridElementWidth() throws {
        guard let value = parseInput(for: gridCellWidthTextField)  else { throw ConfigurationError.wrongInput(setting: TextFieldNames.gridCellWidth) }
        gridCellSize.width = CGFloat(value)
    }
    private func validateGridElementHieght() throws {
        guard let value = parseInput(for: gridCellHeightTextField)  else { throw ConfigurationError.wrongInput(setting: TextFieldNames.gridCellHeight) }
        gridCellSize.height = CGFloat(value)
    }
    private func validateMinHorizontalSpacing() throws {
        guard let value = parseInput(for: minHorizontalSpacingTextField)  else { throw ConfigurationError.wrongInput(setting: TextFieldNames.minHorizontalSpacing) }
        minimumHorizontalSpacing = CGFloat(value)
    }
    private func validateMinVerticalSpacing() throws {
        guard let value = parseInput(for: minVerticalSpacingTextField)  else { throw ConfigurationError.wrongInput(setting: TextFieldNames.minVerticalSpacing) }
        minimumVerticalSpacing = CGFloat(value)
    }
    
}

extension ConfigurationViewController {
    
    private func validateSettings() throws {
        var invalidInputSettings: String!
    
        do { try validateAnimationDuration() }
        catch ConfigurationError.wrongInput(let setting) { invalidInputSettings = setting }
        catch {}
        do { try validateGridElementWidth() }
        catch ConfigurationError.wrongInput(let setting) { invalidInputSettings = invalidInputSettings + "," + setting }
        catch {}
        do { try validateGridElementHieght() }
        catch ConfigurationError.wrongInput(let setting) { invalidInputSettings = invalidInputSettings + "," + setting }
        catch {}
        do { try validateMinHorizontalSpacing() }
        catch ConfigurationError.wrongInput(let setting) { invalidInputSettings = invalidInputSettings + "," + setting }
        catch {}
        do { try validateMinVerticalSpacing() }
        catch ConfigurationError.wrongInput(let setting) { invalidInputSettings = invalidInputSettings + "," + setting }
        catch {}
        
        guard invalidInputSettings == nil  else { throw ConfigurationError.validation(invalidInputSettings) }
    }
    
}

extension ConfigurationViewController {
    
    @IBAction private func backButtonTapped() {
        do {
            try validateSettings()
            delegate?.update(animationDuration: animationDuration, gridCellSize: gridCellSize, minHorizontalSpacing: minimumHorizontalSpacing, minVerticalSpacing: minimumVerticalSpacing)
            navigationController?.popViewController(animated: true)
        }
        catch ConfigurationError.validation(let invalidInputSettings) { showInvalidInputAlert(textFieldNames: invalidInputSettings) }
        catch  {}
    }
    @objc private func hideKeyboard() {
        self.view.endEditing(true)
    }
    private func showInvalidInputAlert(textFieldNames: String) {
        present(UIAlertController.create(title: "Wrong Values Set", message: "\(textFieldNames) have wrong values set. We have reset it to the default values"), animated: true, completion: nil)
    }
    
}

