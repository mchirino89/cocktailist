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
    @IBOutlet weak var initLoadView: UIView!
    private var drinkList: DrinkList?
    private let decoder = JSONDecoder()
    fileprivate let imageLoadQueue = OperationQueue()
    fileprivate var imageLoadOperations = [IndexPath: ImageLoadOperation]()
    private let cache = NSCache<NSString, UIImage>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        readJSONList()
        getCocktailList()
        clearNavigationBar()
        polishCells()
    }

    fileprivate func getCachedDrinkImage(at key: NSString) -> UIImage? {
        guard let cachedVersion = cache.object(forKey: key) else { return nil }
        return cachedVersion
    }
    
    fileprivate func setCachedDrinkImage(_ key: NSString, _ image: UIImage) {
        cache.setObject(image, forKey: key)
    }
    
    fileprivate func queueDrinkImage(for cell: CocktailTableViewCell, at index: IndexPath) {
        let currentURL = drinkList!.drinks[index.row].image
        guard let cachedImage = getCachedDrinkImage(at: currentURL.absoluteString as NSString) else {
            if let imageLoadOperation = imageLoadOperations[index],
                let image = imageLoadOperation.image {
                setDrinkImage(cell, image, currentURL.absoluteString)
            } else {
                let imageLoadOperation = ImageLoadOperation(url: currentURL)
                imageLoadOperation.completionHandler = { [unowned self] (image) in
                    self.setDrinkImage(cell, image, currentURL.absoluteString)
                    self.cache.setObject(image, forKey: currentURL.absoluteString as NSString)
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
    }
    
    private func polishCells() {
        cocktailTableView.separatorStyle = .none
    }
    
    private func readJSONList() {
        do {
            guard let file = Bundle.main.url(forResource: Constants.json.file, withExtension: Constants.json.type) else {
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
        guard let rootURL = URL(string: Constants.network.rootURL) else { return }
        URLSession.shared.dataTask(with: rootURL, completionHandler: { [unowned self] dataRetrieved, response, error in
            if let error = error {
                print(error.localizedDescription)
            } else if let data = dataRetrieved, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                do {
                    self.drinkList = try self.decoder.decode(DrinkList.self, from: data)
                    DispatchQueue.main.async {
                        self.cocktailTableView.reloadData()
                        self.cocktailTableView.reloadRows(at: self.cocktailTableView.indexPathsForVisibleRows!, with: .middle)
                        UIView.animate(withDuration: Constants.animation.duration, animations: {
                            self.initLoadView.alpha = Constants.animation.fadeOut
                        }, completion: { _ in
                            self.view.sendSubview(toBack: self.initLoadView)
                        })
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }).resume()
    }

}

extension ListController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Constants.units.tableSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let drinks = drinkList?.drinks else { return 0 }
        return drinks.count
    }
}

extension ListController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.cell.height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cell.name) as! CocktailTableViewCell
        cell.setDrink(cellDrink: drinkList!.drinks[indexPath.row], index: indexPath)
        queueDrinkImage(for: cell, at: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constants.UI.detailsSegue, sender: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let imageLoadOperation = imageLoadOperations[indexPath] else {
            return
        }
        imageLoadOperation.cancel()
        imageLoadOperations.removeValue(forKey: indexPath)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailView = segue.destination as? DetailController, let cocktailId = sender as? Int else { return }
        detailView.cocktailId = cocktailId
    }
    
}

extension ListController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if let _ = imageLoadOperations[indexPath] {
                return
            }
            let imageLoadOperation = ImageLoadOperation(url: drinkList!.drinks[indexPath.row].image)
            imageLoadQueue.addOperation(imageLoadOperation)
            imageLoadOperations[indexPath] = imageLoadOperation
        }
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            guard let imageLoadOperation = imageLoadOperations[indexPath] else {
                return
            }
            imageLoadOperation.cancel()
            imageLoadOperations.removeValue(forKey: indexPath)
        }
    }
}

