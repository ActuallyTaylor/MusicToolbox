//
//  Artist.swift
//  MusicToolbox
//
//  Created by Zachary lineman on 1/6/20.
//  Copyright © 2020 Zachary lineman. All rights reserved.
//
//

import UIKit
import MediaPlayer

class Artist {
    var artistName: String
    var artistImage: UIImage

    init(Name:String,Image:UIImage) {
        self.artistName = Name
        self.artistImage = Image
        
    }
}
