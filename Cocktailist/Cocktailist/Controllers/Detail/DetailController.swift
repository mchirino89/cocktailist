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
    var cocktailId = ""
    var cocktailImage: UIImage? = nil
    var currentTask: URLSessionTask!
    
    override func viewDidLoad() {
        drinkImageView.image = cocktailImage ?? #imageLiteral(resourceName: "cocktailPlaceholder")
        defineShadow()
//        getDrinkDetails()
        readLocalFile(resource: Constants.json.details, type: Constants.json.type)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        currentTask.cancel()
    }
    
    private func readLocalFile(resource: String, type: String) {
        let decoder = JSONDecoder()
        do {
            guard let file = Bundle.main.url(forResource: resource, withExtension: type) else {
                print("No file found")
                return
            }
            let data = try Data(contentsOf: file)
            let decoded = try decoder.decode(DrinkDetails.self, from: data)
            setInterface(drinkData: decoded.drinks.first!)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func setInterface(drinkData: [String: String?]) {
        
    }
    
    private func getDrinkDetails() {
        let decoder = JSONDecoder()
        currentTask = URLSession.shared.dataTask(with: Constants.network.URLs.cocktailURL.appendingPathComponent(cocktailId), completionHandler: { [unowned self] dataRetrieved, response, error in
            if let error = error {
                print(error.localizedDescription)
            } else if let data = dataRetrieved, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                do {
                    let decoded = try decoder.decode(DrinkDetails.self, from: data)
                    DispatchQueue.main.async {
                        self.setInterface(drinkData: decoded.drinks.first!)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        })
        currentTask.resume()
    }
    
    private func defineShadow() {
        typealias shadow = Design.shadow
        backgroundView.layer.shadowColor = shadow.color
        backgroundView.layer.shadowRadius = shadow.radius
        backgroundView.layer.shadowOpacity = shadow.opacity
        backgroundView.layer.shadowOffset = shadow.offset
    }
    
}
