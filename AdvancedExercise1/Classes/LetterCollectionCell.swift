//
//  LetterCollectionCell.swift
//  AdvancedExercise1
//
//  Created by Prateek Sharma on 5/30/18.
//  Copyright © 2018 Prateek Sharma. All rights reserved.
//

import UIKit

class LetterCollectionCell: UICollectionViewCell {
    
    static let identifier = "letterCell"
    
    @IBOutlet weak private var letterLabel: UILabel!
    
    
    func setup(text: String) {
        letterLabel.text = text
    }
    
}
