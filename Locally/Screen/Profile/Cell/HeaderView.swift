//
//  HeaderView.swift
//  Locally
//
//  Created by Ali Emre Değirmenci on 17.07.2019.
//  Copyright © 2019 Ali Emre Değirmenci. All rights reserved.
//

import UIKit

class HeaderView: UIView {
    
    @IBOutlet weak var headerImageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("HeaderView", owner: self, options: nil)
        addSubview(headerImageView)
        headerImageView.frame = self.bounds
        headerImageView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
}
