//
//  CocktailCellTableViewCell.swift
//  Cocktailist
//
//  Created by Mauricio Chirino on 20/2/18.
//  Copyright © 2018 Mauricio Chirino. All rights reserved.
//

import UIKit

class CocktailCellTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var legendTextView: UITextView!
    @IBOutlet weak var thumbnailImageView: UIImageView!

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = UIEdgeInsetsInsetRect(contentView.frame, UIEdgeInsetsMake(0, 16, 8, 16))
        defineShadow()
    }
    
    private func defineShadow() {
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowRadius = 2
        contentView.layer.shadowOpacity = 0.25
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
    }
}
