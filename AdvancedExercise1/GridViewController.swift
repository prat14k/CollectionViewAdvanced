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
    
    private var minimumLineSpacing: CGFloat = 10
    private var minimumInterimSpace: CGFloat = 10
    private var animationDuration: TimeInterval = 0.5
    
    private let sectionTopInsetSpace: CGFloat = 10
    private let sectionBottomInsetSpace: CGFloat = 10
    private let sectionLeftInsetSpace: CGFloat = 10
    private let sectionRightInsetSpace: CGFloat = 10
    
    var collectionViewDB = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
    
    var cellWidth: CGFloat!
    var cellHeight: CGFloat!
    
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let configurationVC = segue.destination as? ConfigurationViewController {
            configurationVC.animationDuration = animationDuration
            configurationVC.elementSize = CGSize(width: cellWidth, height: cellHeight)
            configurationVC.minimumHorizontalSpacing = minimumInterimSpace
            configurationVC.minimumVerticalSpacing = minimumLineSpacing

            configurationVC.delegate = self
        }
    }
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        gridCollectionView.invalidateIntrinsicContentSize()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if cellWidth == nil || cellHeight == nil {
            calculateCellsDefaultSize()
        }
        
    }
    
    private func calculateCellsDefaultSize(){
        let defaultColumns:CGFloat = (UIDevice.current.orientation == UIDeviceOrientation.portrait || UIDevice.current.orientation == UIDeviceOrientation.portraitUpsideDown) ? 2 : 13
        let totalElementsFloat = CGFloat(collectionViewDB.count)
        cellWidth = (gridCollectionView.bounds.width - sectionLeftInsetSpace - sectionRightInsetSpace - (minimumInterimSpace * (defaultColumns - 1))) / defaultColumns
        cellHeight = ((gridCollectionView.bounds.height - sectionTopInsetSpace - sectionBottomInsetSpace - (minimumLineSpacing * (ceil(totalElementsFloat / defaultColumns) - 1))) * CGFloat(defaultColumns)) / totalElementsFloat
        gridCollectionView.reloadData()
    }

}

extension GridViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (cellWidth == nil || cellHeight == nil) ? 0 : collectionViewDB.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LetterCollectionCell.identifier, for: indexPath) as! LetterCollectionCell
        cell.setup(text: collectionViewDB[indexPath.row % collectionViewDB.count])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionViewDB.remove(at: indexPath.row)
        collectionView.deleteItems(at: [indexPath])
    }
}

extension GridViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: cellHeight)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return minimumLineSpacing
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return minimumInterimSpace
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: sectionTopInsetSpace, left: sectionLeftInsetSpace, bottom: sectionBottomInsetSpace, right: sectionRightInsetSpace)
    }
    
}


extension GridViewController: ConfigurablesProtocol {
    
    func setSettings(animationDuration: TimeInterval, elementSize: CGSize, horizontalSpacing: CGFloat, verticalSpacing: CGFloat) {
        self.animationDuration = animationDuration
        cellHeight = elementSize.height
        cellWidth = elementSize.width
        minimumInterimSpace = horizontalSpacing
        minimumLineSpacing = verticalSpacing
        
        gridCollectionView.invalidateIntrinsicContentSize()
        gridCollectionView.reloadData()
    }
    
}

extension String {
    
    static var randomLetter: String {
        let char = 65 + arc4random_uniform(26)
        return String(Character(Unicode.Scalar(char)!))
    }
    
}


extension GridViewController {
    
    // Insert 3 items at the end
    @IBAction func operation1(_ sender: UIBarButtonItem!) {
        let count = collectionViewDB.count
        collectionViewDB.append(contentsOf: [String.randomLetter,String.randomLetter,String.randomLetter])
        gridCollectionView.insertItems(at: [IndexPath(item: count, section: 0),IndexPath(item: count + 1, section: 0),IndexPath(item: count + 2, section: 0)])
    }
    // Delete 3 items at the end
    @IBAction func operation2(_ sender: UIBarButtonItem) {
        let count = collectionViewDB.count
        guard count >= 3  else { return }
        collectionViewDB.removeLast(3)
        gridCollectionView.deleteItems(at: [IndexPath(item: count - 3, section: 0),IndexPath(item: count - 2, section: 0),IndexPath(item: count - 1, section: 0)])
    }
    // Update item at index 2
    @IBAction func operation3(_ sender: UIBarButtonItem) {
        guard collectionViewDB.count >= 2  else { return }
        collectionViewDB[1] = String.randomLetter
        gridCollectionView.reloadItems(at: [IndexPath(item: 1, section: 0)])
    }
    // Move item "e" to the end
    @IBAction func operation4(_ sender: UIBarButtonItem) {
        guard let index = collectionViewDB.index(of: "e") else { return }
        collectionViewDB.append(collectionViewDB.remove(at: index))
        gridCollectionView.moveItem(at: IndexPath(item: index, section: 0), to: IndexPath(item: collectionViewDB.count - 1, section: 0))
    }
    // Delete 3 items at the beginning, then insert 3 items at the end
    @IBAction func operation5(_ sender: UIBarButtonItem) {
        let count = collectionViewDB.count
        guard count >= 3  else { return }
        collectionViewDB.removeFirst(3)
        gridCollectionView.deleteItems(at: [IndexPath(item: 0, section: 0), IndexPath(item: 1, section: 0), IndexPath(item: 2, section: 0),])
        operation1(nil)
    }
    // Insert 3 items at the end, then delete 3 items at the beginning
    @IBAction func operation6(_ sender: UIBarButtonItem) {
        operation1(nil)
        collectionViewDB.removeFirst(3)
        gridCollectionView.deleteItems(at: [IndexPath(item: 0, section: 0), IndexPath(item: 1, section: 0), IndexPath(item: 2, section: 0),])
    }
    
}

