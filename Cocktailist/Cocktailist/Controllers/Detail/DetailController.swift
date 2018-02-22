//
//  DetailController.swift
//  Cocktailist
//
//  Created by Mauricio Chirino on 21/2/18.
//  Copyright © 2018 Mauricio Chirino. All rights reserved.
//

import UIKit

class DetailController: UIViewController {
    
    var cocktailId = 0
    
    override func viewDidAppear(_ animated: Bool) {
        print("Selected cocktail: \(cocktailId)")
    }
    
}
