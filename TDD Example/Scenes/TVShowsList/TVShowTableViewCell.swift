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
    
    // MARK: Functions
    func configure(tvshow: TVShow) {
        titleLabel.text = tvshow.title
    }
}
