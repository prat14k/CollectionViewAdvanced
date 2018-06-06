//
//  StringExtension.swift
//  AdvancedExercise1
//
//  Created by Prateek Sharma on 5/31/18.
//  Copyright © 2018 Prateek Sharma. All rights reserved.
//

import Foundation


extension String {
    static var randomUpperCaseLetter: String {
        let char = 65 + arc4random_uniform(26)
        return String(Character(Unicode.Scalar(char)!))
    }
    
    static func random(letters n: Int) -> [String] {
        var array = [String]()
        for _ in 0..<n {
            array.append(String.randomUpperCaseLetter)
        }
        return array
    }
}
