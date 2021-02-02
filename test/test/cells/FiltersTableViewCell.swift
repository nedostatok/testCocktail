//
//  FiltersTableViewCell.swift
//  test
//
//  Created by User on 20.11.2020.
//

import UIKit

class FiltersTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var filterLabel: UILabel!
    
    func customizeCell(filters: DrinkFilter) {
        filterLabel.text = filters.strCategory
    }
}
