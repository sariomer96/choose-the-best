//
//  TopRatedViewCell.swift
//  quiz
//
//  Created by Omer on 14.11.2023.
//

import UIKit
import Cosmos

class TopRatedViewCell: UITableViewCell {

    @IBOutlet weak var startViews: CosmosView!
    @IBOutlet weak var topImageView: UIImageView!
    @IBOutlet weak var categoryNameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    var rating = 0

}
