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
        definePadding()
        defineShadow()
    }
    
    private func definePadding() {
        contentView.frame = UIEdgeInsetsInsetRect(contentView.frame, addPadding(top: .none, left: .medium, bottom: .minimum, right: .medium))
    }
    
    private func defineShadow() {
        typealias shadow = Design.shadow
        contentView.layer.shadowColor = shadow.color
        contentView.layer.shadowRadius = shadow.radius
        contentView.layer.shadowOpacity = shadow.opacity
        contentView.layer.shadowOffset = shadow.offset
    }
}
