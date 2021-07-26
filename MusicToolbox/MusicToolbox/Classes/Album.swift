//
//  Album.swift
//  MusicToolbox
//
//  Created by Zachary lineman on 1/6/20.
//  Copyright © 2020 Zachary lineman. All rights reserved.
//


import Foundation
import UIKit
import MediaPlayer

class Album {
    var albumName: String
    var albumArtist: String
    var albumImage: UIImage
    var songList: [MPMediaItem]
    
    init(Name:String,Artist:String,Image:UIImage, Songs:[MPMediaItem]) {
        self.albumName = Name
        self.albumArtist = Artist
        self.albumImage = Image
        self.songList = Songs
        
    }
}
