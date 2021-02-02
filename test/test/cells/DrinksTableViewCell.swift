//
//  DrinksTableViewCell.swift
//  test
//
//  Created by User on 20.11.2020.
//

import UIKit

class DrinksTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var cocktailImage: UIImageView!
    @IBOutlet private weak var cocktailLabel: UILabel!
    
    func customizeCell(drinks: Drink) {
        cocktailLabel.text = drinks.strDrink
        
        guard let stringUrl = drinks.strDrinkThumb else { return }
        guard let url = URL(string: stringUrl) else { return }
        cocktailImage.load(url: url)
    }
    
    override func prepareForReuse() {
        cocktailImage.image = nil
    }
}

extension UIImageView {
    func load(url: URL) {
        let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        activityIndicator.center = CGPoint(x:self.frame.width/2,
                                           y: self.frame.height/2)
        self.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                        activityIndicator.stopAnimating()
                        activityIndicator.isHidden = true
                    }
                }
            }
        }
    }
}
