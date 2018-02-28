//
//  SearchFeature.swift
//  Cocktailist
//
//  Created by Mauricio Chirino on 28/2/18.
//  Copyright © 2018 Mauricio Chirino. All rights reserved.
//

import UIKit

extension ListController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        toggleSearch(isHidden: true)
        searchBar.resignFirstResponder()
        drinkList!.drinks = drinksBackUp
        cocktailTableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        drinkList!.drinks = !searchText.isEmpty ? drinkList!.drinks.filter { $0.name.contains(searchText) } : drinksBackUp
        cocktailTableView.reloadData()
    }
    
}
