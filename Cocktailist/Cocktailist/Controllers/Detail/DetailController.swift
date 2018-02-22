//
//  DetailController.swift
//  Cocktailist
//
//  Created by Mauricio Chirino on 21/2/18.
//  Copyright © 2018 Mauricio Chirino. All rights reserved.
//

import UIKit

class DetailController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var drinkImageView: UIImageView!
    @IBOutlet weak var ingredientsTextView: UITextView!
    @IBOutlet weak var preparationTextView: UITextView!
    var cocktailId = 0
    
    override func viewDidLoad() {
        defineShadow()
    }
    
    private func defineShadow() {
        typealias shadow = Design.shadow
        backgroundView.layer.shadowColor = shadow.color
        backgroundView.layer.shadowRadius = shadow.radius
        backgroundView.layer.shadowOpacity = shadow.opacity
        backgroundView.layer.shadowOffset = shadow.offset
    }
    
}
