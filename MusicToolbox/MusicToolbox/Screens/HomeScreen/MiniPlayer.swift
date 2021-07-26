//
//  MiniPlayer.swift
//  MusicToolbox
//
//  Created by Zachary lineman on 3/6/20.
//  Copyright © 2020 Zachary lineman. All rights reserved.
//

import Foundation

extension MainScreen {
    @objc func createMiniPlayer() {
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height - 75
        
        customView.frame = CGRect(x: 20, y: screenHeight, width: screenWidth - 40, height: 60)
        customView.backgroundColor = .secondarySystemBackground
        imageView.frame = CGRect(x: 20, y: 7.5, width: 45, height: 45)
        miniPlayerImage.frame = CGRect(x: 0, y: 0, width: 45, height: 45)
        miniPlayerImage.layer.borderColor = UIColor.black.cgColor
        miniPlayerImage.clipsToBounds = true
        
        miniPlayerImage.layer.cornerRadius = 15
        customView.layer.cornerRadius = 25
        
        titleText.frame = CGRect(x: 75, y: 10, width: screenWidth - 220, height: 20)
        titleText.backgroundColor = UIColor.clear
        titleText.font = UIFont.boldSystemFont(ofSize: 19)
        
        artistText.frame = CGRect(x: 75, y: 30, width: screenWidth - 220, height: 20)
        artistText.backgroundColor = UIColor.clear
        artistText.font = artistText.font?.withSize(13.0)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(self.openPlayer))
        swipeUp.direction = UISwipeGestureRecognizer.Direction.up
        customView.addGestureRecognizer(swipeUp)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.openPlayer))

        customView.addGestureRecognizer(tap)
        
        pauseButton.frame = CGRect(x: customView.frame.width - 75, y: 15, width: 25, height: 30)
        if player.playbackState == .playing {
            pauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        } else if player.playbackState == .paused {
            pauseButton.setImage(UIImage(named: "pause.fill"), for: .normal)
            
        }
        
        pauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        pauseButton.addTarget(self, action: #selector(self.playPause), for: .touchUpInside)
        
        forwardButton.frame = CGRect(x: customView.frame.width - 40, y: 17, width: 35, height: 25)
        forwardButton.setImage(UIImage(systemName: "forward.fill"), for: .normal)
        forwardButton.addTarget(self, action: #selector(self.forwardAction), for: .touchUpInside)
        
        if player.nowPlayingItem != nil {
            titleText.text = (player.nowPlayingItem?.title)!
            artistText.text = player.nowPlayingItem?.artist
            miniPlayerImage.image = player.nowPlayingItem?.artwork?.image(at: CGSize(width: 50, height: 50))
            
        } else {
            miniPlayerImage.image = UIImage(named: "NotFound")
            titleText.text = "No music playing"
            artistText.text = "No music playing"
            
        }
        
        self.customView.addSubview(forwardButton)
        self.customView.addSubview(pauseButton)
        self.customView.addSubview(artistText)
        self.customView.addSubview(titleText)
        self.imageView.addSubview(miniPlayerImage)
        self.customView.addSubview(imageView)
        self.navigationController?.view.addSubview(customView)
        
    }
    
    @objc func updateMiniPlayer() {
        if let artwork = currentSong.artwork {
            miniPlayerImage.image = artwork.image(at: CGSize(width: 300, height: 300)) ?? UIImage(named: "NotFound")
        }
        titleText.text = currentSong.title
        artistText.text = currentSong.artist
        
        if player.nowPlayingItem == nil {
            miniPlayerImage.image = UIImage(named: "NotFound")
            titleText.text = "No music playing"
            artistText.text = "No music playing"
            
        }
        
        if player.playbackState == .playing {
            pauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        } else if player.playbackState == .paused {
            pauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            
        }
        
    }
    
    @objc func playPause() {
        if player.playbackState == .playing {
            pauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            player.pause()
            
        } else if player.playbackState == .paused {
            pauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            player.play()
        }
        
        if player.nowPlayingItem == nil {
            playAll()
        }
        tableView.reloadData()
    }
    
    @objc func forwardAction() {
        player.skipToNextItem()
    }
    
    func playAll() {
         let collection = MPMediaItemCollection.init(items: songList)
         let descriptor = MPMusicPlayerMediaItemQueueDescriptor(itemCollection: collection)
         
         player.setQueue(with: descriptor)
         player.prepareToPlay()
         
         player.play()
         currentSong = player.nowPlayingItem!
     }
}
