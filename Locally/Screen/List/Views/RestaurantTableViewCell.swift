//
//  RestaurantTableViewCell.swift
//  Locally
//
//  Created by Ali Emre Değirmenci on 6.07.2019.
//  Copyright © 2019 Ali Emre Değirmenci. All rights reserved.
//

import UIKit
import AlamofireImage

class RestaurantTableViewCell: UITableViewCell {

    @IBOutlet weak var cardContainerView: ShadowView!
    @IBOutlet weak var restaurantImageView: UIImageView!
    @IBOutlet weak var makerImageView: UIImageView!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var restaurantType: UILabel!

    let cornerRadius : CGFloat = 10.0

    override func awakeFromNib() {
        super.awakeFromNib()

        // Initialization code
        cardContainerView.layer.cornerRadius = cornerRadius
        func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            if traitCollection.userInterfaceStyle == .light {
                print("Light mode")
                cardContainerView.backgroundColor = UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 1.0) /* #f7f7f7 */
            } else {
                print("Dark mode")
                cardContainerView.backgroundColor = UIColor(red: 28/255, green: 28/255, blue: 30/255, alpha: 1.0) /* #1c1c1e */
            }
        }

        cardContainerView.layer.shadowColor = UIColor.gray.cgColor
        cardContainerView.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        cardContainerView.layer.shadowRadius = 15.0
        cardContainerView.layer.shadowOpacity = 0.9

        // setting shadow path in awakeFromNib doesn't work as the bounds / frames of the views haven't got initialized yet
        // at this point the cell layout position isn't known yet

        restaurantImageView.layer.cornerRadius = cornerRadius
        restaurantImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(with viewModel: RestaurantListViewModel) {
        // For background thread
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.async {
                self.restaurantImageView.af_setImage(withURL: viewModel.imageUrl)
                self.restaurantNameLabel.text = viewModel.name
                self.locationLabel.text = "\(viewModel.formattedDistance) m"
            }
        }
        if let restaurantType: String = String(viewModel.categories[0].title) {
            self.restaurantType.text = restaurantType
        }
        //        restaurantType.text = "\(viewModel.categories.description)"
    }

}
