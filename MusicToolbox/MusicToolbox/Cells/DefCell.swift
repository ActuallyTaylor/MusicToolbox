//
//  DefCell.swift
//  MusicToolbox
//
//  Created by Zachary lineman on 1/6/20.
//  Copyright © 2020 Zachary lineman. All rights reserved.
//

import UIKit

class DefCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var fooView: UIImageView!
    
    override func awakeFromNib() {
        fooView.layer.cornerRadius = 15
    }
}
