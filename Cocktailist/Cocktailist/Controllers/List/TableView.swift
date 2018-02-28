//
//  TableView.swift
//  Cocktailist
//
//  Created by Mauricio Chirino on 28/2/18.
//  Copyright © 2018 Mauricio Chirino. All rights reserved.
//

import UIKit

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
        let infoTuple: (String, UIImage?) = (drinkList!.drinks[indexPath.row].id, cache.object(forKey: drinkList!.drinks[indexPath.row].image.absoluteString as NSString))
        performSegue(withIdentifier: Constants.UI.detailsSegue, sender: infoTuple)
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let imageLoadOperation = imageLoadOperations[indexPath] else {
            return
        }
        imageLoadOperation.cancel()
        imageLoadOperations.removeValue(forKey: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailView = segue.destination as? DetailController, let cocktailInfo = sender as? (String, UIImage?) else { return }
        detailView.cocktailId = cocktailInfo.0
        detailView.cocktailImage = cocktailInfo.1
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

