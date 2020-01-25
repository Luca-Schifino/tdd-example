//
//  RatingCollectionViewCell.swift
//  TDD Example
//
//  Created by Luca Schifino on 25/01/20.
//  Copyright © 2020 lucass. All rights reserved.
//

import UIKit

class RatingCollectionViewCell: NibRegistrableCollectionViewCell {

    // MARK: IBOutlets
    @IBOutlet weak var selectView: UIView! {
        didSet {
            selectView.layer.cornerRadius = selectView.frame.height/2
            selectView.clipsToBounds = true
            selectView.layer.borderWidth = 1
            selectView.layer.borderColor = deselectedColor.cgColor
            selectView.backgroundColor = .white
        }
    }
    
    @IBOutlet weak var gradeLabel: UILabel!
    
    // MARK: Variables
    private let selectedColor = UIColor.lightGray
    private let deselectedColor = UIColor.lightGray
    
    // MARK: Custom methods
    func configure(grade: Int, selected: Bool) {
        gradeLabel.text = "\(grade)"
        selectView.backgroundColor = selected ? selectedColor : .white
        selectView.layer.borderColor = selected ? selectedColor.cgColor : deselectedColor.cgColor
    }
}
