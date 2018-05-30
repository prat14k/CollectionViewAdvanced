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
    
    let totalElements = 26
    
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
        let floatingTotalElements = CGFloat(totalElements)
        cellWidth = (gridCollectionView.bounds.width - sectionLeftInsetSpace - sectionRightInsetSpace - (minimumInterimSpace * (defaultColumns - 1))) / defaultColumns
        cellHeight = ((gridCollectionView.bounds.height - sectionTopInsetSpace - sectionBottomInsetSpace - (minimumLineSpacing * (ceil(floatingTotalElements / defaultColumns) - 1))) * CGFloat(defaultColumns)) / floatingTotalElements
        gridCollectionView.reloadData()
    }

}

extension GridViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (cellWidth == nil || cellHeight == nil) ? 0 : totalElements
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let letter = String(Character((Unicode.Scalar(indexPath.row + 65))!))
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LetterCollectionCell.identifier, for: indexPath) as! LetterCollectionCell
        cell.setup(text: letter)
        return cell
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


extension GridViewController {
    
    @IBAction func operation1(_ sender: UIBarButtonItem) {
        
    }
    @IBAction func operation2(_ sender: UIBarButtonItem) {
        
    }
    @IBAction func operation3(_ sender: UIBarButtonItem) {
        
    }
    @IBAction func operation4(_ sender: UIBarButtonItem) {
        
    }
    @IBAction func operation5(_ sender: UIBarButtonItem) {
        
    }
    @IBAction func operation6(_ sender: UIBarButtonItem) {
        
    }
    
}

