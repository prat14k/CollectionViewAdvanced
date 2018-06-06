//
//  ArrayExtension.swift
//  AdvancedExercise1
//
//  Created by Prateek Sharma on 6/6/18.
//  Copyright © 2018 Prateek Sharma. All rights reserved.
//

import Foundation


extension Array {
    
    mutating func insert(items: [Element], startingFrom offset: Int = 0) -> Bool{
        guard offset >= 0, offset <= count  else { return false }
        insert(contentsOf: items, at: offset)
        return true
    }
    
    mutating func delete(elements n: Int, startingFrom offset: Int = 0) -> Bool{
        guard offset >= 0, offset < count, (offset + n - 1) < count  else { return false }
        removeSubrange(offset..<(offset+n))
        return true
    }
    
    mutating func update(at index: Int, with element: Element) -> Bool {
        guard count > index  else { return false }
        self[index] = element
        return true
    }
    
}



extension Array where Element: Equatable {
    
    mutating func move(from oldIndex: Int, to newIndex: Int) -> Bool {
        guard newIndex >= 0, newIndex < count, oldIndex < newIndex else { return false }
        let element = remove(at: oldIndex)
        insert(element, at: newIndex)
        return true
    }
    
}
