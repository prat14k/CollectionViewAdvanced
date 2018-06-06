//
//  Validator.swift
//  AdvancedExercise1
//
//  Created by Prateek Sharma on 6/6/18.
//  Copyright © 2018 Prateek Sharma. All rights reserved.
//

import UIKit

struct ValidationFields {
    let text: String?
    let settingName: String
}

protocol Validator: Parser { }
extension Validator {
    
    func validate(text: String?, with settingName: String) throws  {
        guard let value = parseInput(for: text), value > 0.0  else { throw ConfigurationError.wrongInput(settings: settingName) }
    }
    
    func validate(fields: [ValidationFields]) throws {
        var invalidFieldNames: String?
        
        for field in fields {
            do { try validate(text: field.text, with: field.settingName) }
            catch ConfigurationError.wrongInput(let setting) { invalidFieldNames = "\(invalidFieldNames ?? "")\(setting), " }
            catch { print("Unknown error \(error.localizedDescription)") }
        }
        invalidFieldNames?.removeLast(2)
        if invalidFieldNames != nil { throw ConfigurationError.wrongInput(settings: invalidFieldNames!) }
    }
    
}

protocol Parser { }
extension Parser {
    func parseInput(for text: String?) -> Double? {
        return Double(text ?? "")
    }
}
