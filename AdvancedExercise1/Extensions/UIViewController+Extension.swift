//
//  UIViewController+Extension.swift
//  AdvancedExercise1
//
//  Created by Prateek Sharma on 6/24/19.
//  Copyright © 2019 Prateek Sharma. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func presentSimpleAlert(title: String? = nil, message: String? = nil, animated: Bool = true) {
        let alertController = UIAlertController.create(title: title, message: message)
        present(alertController, animated: animated, completion: nil)
    }
    
}
