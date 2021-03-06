//
//  GridViewController.swift
//  AdvancedExercise1
//
//  Created by Prateek Sharma on 5/30/18.
//  Copyright © 2018 Prateek Sharma. All rights reserved.
//

import UIKit

class GridViewController: UIViewController {

    @IBOutlet weak private var gridCollectionView: UICollectionView!
    
    private var minVerticalSpace: CGFloat = 10
    private var minHorizontalSpace: CGFloat = 10
    private var animationDuration: TimeInterval = 0.5
    private var gridCellSize = CGSize(width: 200, height: 50)
    
    private var collectionViewDB = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        gridCollectionView.invalidateIntrinsicContentSize()
        gridCollectionView.reloadData()
    }
    
}


extension GridViewController: ConfigurablesProtocol {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifier.configurationVCSegue, let configurationVC = segue.destination as? ConfigurationViewController {
            configurationVC.set(animationDuration: animationDuration, gridCellSize: gridCellSize, minHorizontalSpacing: minHorizontalSpace, minVerticalSpacing: minVerticalSpace)
            configurationVC.delegate = self
        }
    }
    func update(animationDuration: TimeInterval, gridCellSize: CGSize, minHorizontalSpacing: CGFloat, minVerticalSpacing: CGFloat) {
        self.animationDuration = animationDuration
        self.gridCellSize = gridCellSize
        minHorizontalSpace = minHorizontalSpacing
        minVerticalSpace = minVerticalSpacing
        
        gridCollectionView.invalidateIntrinsicContentSize()
        gridCollectionView.reloadData()
    }
    
}


extension GridViewController {
    
    // Insert 3 items at the end
    @IBAction private func operation1() {
        insertInCollection(items: 3, startingFrom: collectionViewDB.count) ? () : presentSimpleAlert(title: "Error", message: "Operation Failed")
    }
    
    // Delete 3 items at the end
    @IBAction private func operation2() {
        deleteFromCollection(items: 3, startingFrom: collectionViewDB.count - 3) ? () : presentSimpleAlert(title: "Error", message: "Operation Failed")
    }
    
    // Update item at index 2
    @IBAction private func operation3() {
        updateItem(at: 2) ? () : presentSimpleAlert(title: "Error", message: "Operation Failed")
    }
    
    // Move item "e" to the end
    @IBAction private func operation4() {
        find(element: "e", andMoveTo: collectionViewDB.count - 1) ? () : presentSimpleAlert(title: "Error", message: "Operation Failed")
    }
    
    // Delete 3 items at the beginning, then insert 3 items at the end
    @IBAction private func operation5() {
        guard deleteFromCollection(items: 3)  else { return presentSimpleAlert(title: "Error", message: "Operation Delete Failed") }
        insertInCollection(items: 3, startingFrom: collectionViewDB.count) ? () : presentSimpleAlert(title: "Error", message: "Operation Insert Failed")
    }
    
    // Insert 3 items at the end, then delete 3 items at the beginning
    @IBAction private func operation6() {
        insertInCollection(items: 3, startingFrom: collectionViewDB.count) ? () : presentSimpleAlert(title: "Error", message: "Operation Insert Failed")
        deleteFromCollection(items: 3)  ? () : presentSimpleAlert(title: "Error", message: "Operation Delete Failed")
    }
    
    
    private func animateCollectionView(delay: TimeInterval = 0, changes: @escaping () -> (), completionHandler: ((Bool) -> ())? = nil) {
        UIView.animate(withDuration: animationDuration, delay: delay, options: [.curveLinear], animations: {
            changes()
        }, completion: completionHandler)
    }
    
}



extension GridViewController {
    
    private func insertInCollection(items n: Int = 1, startingFrom offset: Int = 0, section: Int = 0) -> Bool {
        let letters = String.random(letters: n)
        let indexPaths = IndexPath.create(n: n, startingFrom: offset, section: section)
        
        guard collectionViewDB.insert(items: letters, startingFrom: offset)  else { return false }
        
        animateCollectionView(changes: { [weak self] in
            self?.gridCollectionView.insertItems(at: indexPaths)
        })
        return true
    }
    
    
    private func deleteFromCollection(items n: Int = 1, startingFrom offset: Int = 0, section: Int = 0) -> Bool {
        let indexPaths = IndexPath.create(n: n, startingFrom: offset, section: section)
        
        guard collectionViewDB.delete(elements: n, startingFrom: offset)  else { return false }
        
        animateCollectionView(changes: { [weak self] in
            self?.gridCollectionView.deleteItems(at: indexPaths)
        })
        return true
    }
    
}

extension GridViewController {
    
    private func updateItem(at index: Int, section: Int = 0) -> Bool {
        guard collectionViewDB.update(at: index, with: String.randomUpperCaseLetter)  else { return false }
        
        animateCollectionView(changes: { [weak self] in
            self?.gridCollectionView.reloadItems(at: [IndexPath(item: index, section: section)])
        })
        return true
    }
    private func find(element: String, oldSection: Int = 0, andMoveTo newIndex: Int, newSection: Int = 0) -> Bool {
        
        guard let oldIndex = collectionViewDB.index(of: element), collectionViewDB.move(from: oldIndex, to: newIndex) else { return false }
        
        animateCollectionView(changes: { [weak self] in
            self?.gridCollectionView.moveItem(at: IndexPath(item: oldIndex, section: oldSection), to: IndexPath(item: newIndex, section: newSection))
        })
        return true
    }
    
}


extension GridViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewDB.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LetterCollectionCell.identifier, for: indexPath) as! LetterCollectionCell
        cell.setup(text: collectionViewDB[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        collectionViewDB.remove(at: indexPath.row)
        UIView.transition(with: cell!, duration: animationDuration, options: [.transitionFlipFromRight], animations: {
            collectionView.deleteItems(at: [indexPath])
        }, completion: nil)
    }
    
}

extension GridViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return gridCellSize
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return minVerticalSpace
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return minHorizontalSpace
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
}







