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
    
    @IBOutlet weak var ratingLabel: MarginLabel! {
        didSet {
            ratingLabel.layer.cornerRadius = 4
            ratingLabel.clipsToBounds = true
            ratingLabel.insets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        }
    }
    
    // MARK: Functions
    func configure(tvshow: TVShow, rating: Int?) {
        titleLabel.text = tvshow.title
        ratingLabel.isHidden = rating == nil
        if let rating = rating {
            ratingLabel.text = "\(rating)"
            switch rating {
            case 1..<5:
                ratingLabel.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            case 5..<7:
                ratingLabel.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
            case 7...10:
                ratingLabel.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            default:
                break
            }
        }
    }
}
