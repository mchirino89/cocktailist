//
//  ViewController.swift
//  Cocktailist
//
//  Created by Mauricio Chirino on 20/2/18.
//  Copyright © 2018 Mauricio Chirino. All rights reserved.
//

import UIKit

class ListController: UIViewController {

    @IBOutlet weak var cocktailTableView: UITableView!
    @IBOutlet weak var filterBarButton: UIBarButtonItem!
    @IBOutlet weak var drinkSearchBar: UISearchBar!
    @IBOutlet weak var searchBarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var initLoadView: UIView!
    private let decoder = JSONDecoder()
    let imageLoadQueue = OperationQueue()
    let cache = NSCache<NSString, UIImage>()
    var imageLoadOperations = [IndexPath: ImageLoadOperation]()
    var drinkList: DrinkList?
    var drinksBackUp: [Drink] = []
    typealias animate = Design.animation
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        readJSONList()
        getCocktailList()
        clearNavigationBar()
        polishCells()
    }

    @IBAction func filterCocktailsAction(_ sender: UIBarButtonItem) {
        toggleSearch(isHidden: searchBarHeightConstraint.constant == animate.visible)
    }
    
    func toggleSearch(isHidden: Bool) {
        searchBarHeightConstraint.constant = isHidden ? animate.fadeOut : animate.visible
        if searchBarHeightConstraint.constant == animate.visible {
            drinkSearchBar.becomeFirstResponder()
        } else {
            drinkSearchBar.resignFirstResponder()
        }
        UIView.animate(withDuration: animate.duration, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    fileprivate func getCachedDrinkImage(at key: NSString) -> UIImage? {
        guard let cachedVersion = cache.object(forKey: key) else { return nil }
        return cachedVersion
    }
    
    fileprivate func setCachedDrinkImage(_ key: NSString, _ image: UIImage) {
        cache.setObject(image, forKey: key)
    }
    
    func queueDrinkImage(for cell: CocktailTableViewCell, at index: IndexPath) {
        let currentURL = drinkList!.drinks[index.row].image
        guard let cachedImage = getCachedDrinkImage(at: currentURL.absoluteString as NSString) else {
            if let imageLoadOperation = imageLoadOperations[index],
                let image = imageLoadOperation.image {
                setDrinkImage(cell, image, currentURL.absoluteString)
                setCachedDrinkImage(currentURL.absoluteString as NSString, image)
            } else {
                let imageLoadOperation = ImageLoadOperation(url: currentURL)
                imageLoadOperation.completionHandler = { [unowned self] (image) in
                    self.setDrinkImage(cell, image, currentURL.absoluteString)
                    self.setCachedDrinkImage(currentURL.absoluteString as NSString, image)
                    self.imageLoadOperations.removeValue(forKey: index)
                }
                imageLoadQueue.addOperation(imageLoadOperation)
                imageLoadOperations[index] = imageLoadOperation
            }
            return
        }
        setDrinkImage(cell, cachedImage, currentURL.absoluteString)
    }
    
    private func setDrinkImage(_ cell: CocktailTableViewCell, _ image: UIImage, _ url: String) {
        if cell.drinkImageURL == url {
            cell.thumbnailImageView.setImage(image)
            cell.loadFinished()
        }
    }
    
    private func clearNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        drinkSearchBar.backgroundImage = UIImage()
    }
    
    private func polishCells() {
        cocktailTableView.separatorStyle = .none
    }
    
    private func readJSONList() {
        do {
            guard let file = Bundle.main.url(forResource: Constants.json.list, withExtension: Constants.json.type) else {
                print("No json file found")
                return
            }
            let data = try Data(contentsOf: file)
            drinkList = try decoder.decode(DrinkList.self, from: data)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func getCocktailList() {
        URLSession.shared.dataTask(with: Constants.network.URLs.root, completionHandler: { [unowned self] dataRetrieved, response, error in
            if let error = error {
                print(error.localizedDescription)
            } else if let data = dataRetrieved, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                do {
                    self.drinkList = try self.decoder.decode(DrinkList.self, from: data)
                    self.drinksBackUp = self.drinkList!.drinks
                    DispatchQueue.main.async {
                        self.cocktailTableView.reloadData()
                        self.cocktailTableView.reloadRows(at: self.cocktailTableView.indexPathsForVisibleRows!, with: .middle)
                        UIView.animate(withDuration: animate.duration, animations: {
                            self.initLoadView.alpha = animate.fadeOut
                        }, completion: { _ in
                            self.view.sendSubview(toBack: self.initLoadView)
                            self.filterBarButton.isEnabled = true
                        })
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }).resume()
    }

}
