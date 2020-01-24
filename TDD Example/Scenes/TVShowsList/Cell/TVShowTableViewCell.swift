//
//  TVShowTableViewCell.swift
//  TDD Example
//
//  Created by Luca Schifino on 24/01/20.
//  Copyright © 2020 lucass. All rights reserved.
//

import UIKit

class TVShowTableViewCell: NibRegistrableTableViewCell {

    // MARK: IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var ratingLabel: UILabel!
    
    // MARK: Functions
    func configure(tvshow: TVShow, rating: Double?) {
        titleLabel.text = tvshow.title
        ratingLabel.text = "\(rating ?? 0)"
        ratingLabel.isHidden = rating == nil
    }
}
