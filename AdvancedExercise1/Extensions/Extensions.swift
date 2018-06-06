//
//  Extensions.swift
//  AdvancedExercise1
//
//  Created by Prateek Sharma on 6/6/18.
//  Copyright © 2018 Prateek Sharma. All rights reserved.
//

import UIKit



extension IndexPath {
    
    static func create(n : Int = 1, startingFrom offset: Int = 0, section: Int = 0) -> [IndexPath] {
        var indexPaths = [IndexPath]()
        for i in 0..<n {
            indexPaths.append(IndexPath(item: (offset + i), section: section))
        }
        return indexPaths
    }
    
}


extension UIViewController {
    
    func presentSimpleAlert(title: String? = nil, message: String? = nil, animated: Bool = true) {
        let alertController = UIAlertController.create(title: title, message: message)
        present(alertController, animated: animated, completion: nil)
    }
    
}
