//
//  FiltersTableViewCell.swift
//  test
//
//  Created by User on 20.11.2020.
//

import UIKit

class FiltersTableViewCell: UITableViewCell {

    @IBOutlet weak var filterLabel: UILabel!
    
    func customizeCell(filters: FilterModel) {
        filterLabel.text = filters.filterName
    }

}
