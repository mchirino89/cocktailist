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
    @IBOutlet weak var infoLoadingView: UIView!
    @IBOutlet weak var drinkImageLoadingView: UIView!
    
    fileprivate let imageLoadQueue = OperationQueue()
    var cocktailId = ""
    var cocktailImage: UIImage? = nil
    var currentTask: URLSessionTask!
    
    override func viewDidLoad() {
        defineShadow()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        drinkImageView.image = cocktailImage ?? #imageLiteral(resourceName: "cocktailPlaceholder")
        preparationTextView.text = Constants.UI.preparation
        getDrinkDetails()
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
            setInterface(drinkData: decoded.drinksDetails.first!)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func setInterface(drinkData: [String: String?]) {
        typealias info = Constants.drinkInfo
        var i = 1
        var measures = ""
//        setImageDrink(imageURL: URL(string: drinkData[info.image.rawValue]!!)!)
        while i < Constants.units.ingredientsCount {
            if let ingredientN = drinkData["\(info.ingredient.rawValue)\(i)"], ingredientN != nil {
                if !ingredientN!.isEmpty {
                    let measureN = drinkData["\(info.measure.rawValue)\(i)"] ?? ""
                    measures.append("\(measureN ?? "") - \(ingredientN ?? "")\n")
                }
            }
            i+=1
        }
        DispatchQueue.main.async { [unowned self] in
            self.title = drinkData[info.title.rawValue] ?? "Drink \(self.cocktailId)"
            self.ingredientsTextView.text = measures
            self.preparationTextView.text.append(drinkData[info.instructions.rawValue]! ?? "")
            self.infoLoadingView.isHidden = true
        }
    }
    
    private func setImageDrink(imageURL: URL?) {
        if drinkImageView.image == #imageLiteral(resourceName: "cocktailPlaceholder") {
            guard let properURL = imageURL else {
                drinkImageView.setImage(#imageLiteral(resourceName: "cocktailPlaceholder"))
                hideLoadingViewForImage()
                return
            }
            let imageLoadOperation = ImageLoadOperation(url: properURL)
            imageLoadOperation.completionHandler = {  (image) in
                self.drinkImageView.setImage(image)
                self.hideLoadingViewForImage()
            }
            imageLoadQueue.addOperation(imageLoadOperation)
            
        } else {
            hideLoadingViewForImage()
        }
    }
    
    private func hideLoadingViewForImage() {
        DispatchQueue.main.async {
            self.drinkImageLoadingView.isHidden = true
        }
    }
    
    private func getDrinkDetails() {
        let decoder = JSONDecoder()
        typealias urls = Constants.network.URLs
        let queryItems = [URLQueryItem(name: urls.queryName, value: cocktailId)]
        var cocktailDetails = URLComponents(string: urls.cocktailURL)
        cocktailDetails?.queryItems = queryItems
        currentTask = URLSession.shared.dataTask(with: cocktailDetails!.url!, completionHandler: { [unowned self] dataRetrieved, response, error in
            if let error = error {
                print(error.localizedDescription)
            } else if let data = dataRetrieved, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                do {
                    let decoded = try decoder.decode(DrinkDetails.self, from: data)
                    DispatchQueue.main.async {
                        self.setInterface(drinkData: decoded.drinksDetails.first!)
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
