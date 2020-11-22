//
//  DrinksTableViewCell.swift
//  test
//
//  Created by User on 20.11.2020.
//

import UIKit

class DrinksTableViewCell: UITableViewCell {

    @IBOutlet weak var cocktailImage: UIImageView!
    @IBOutlet weak var cocktailLabel: UILabel!
    
    func customizeCell(drinks: DrinkModel) {
        cocktailLabel.text = drinks.drinkName
        
        guard let url = URL(string: drinks.drinkImage) else { return }
        cocktailImage.load(url: url)
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
