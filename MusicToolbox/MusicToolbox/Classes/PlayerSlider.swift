//
//  PlayerSlider.swift
//  MusicToolbox
//
//  Created by Zachary lineman on 3/5/20.
//  Copyright © 2020 Zachary lineman. All rights reserved.
//

import UIKit

class PlayerSlider: UISlider {
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
       var newBounds = super.trackRect(forBounds: bounds)
       newBounds.size.height = 12
       return newBounds
    }
}
