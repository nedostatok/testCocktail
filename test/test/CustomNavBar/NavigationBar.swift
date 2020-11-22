//
//  NavigationBar.swift
//  test
//
//  Created by User on 20.11.2020.
//

import UIKit

@objc protocol NavigationBarDelegate: class {
    @objc optional func leftAction()
}

@IBDesignable
class NavigationBar: UIView {
    
    weak var delegate: NavigationBarDelegate?
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var leftButton: UIButton!

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        let bundle = Bundle(for: NavigationBar.self)
        bundle.loadNibNamed("NavigationBar", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    @IBAction func goBack(_ sender: UIButton) {
        delegate?.leftAction?()
    }
    

}
