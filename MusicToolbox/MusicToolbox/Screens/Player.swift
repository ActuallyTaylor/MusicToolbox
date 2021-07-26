//
//  Player.swift
//  MusicToolbox
//
//  Created by Zachary lineman on 1/7/20.
//  Copyright © 2020 Zachary lineman. All rights reserved.
//

import UIKit
import MediaPlayer

var currentSong = MPMediaItem() {
    didSet {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "update"), object: nil)
    }
}

class Player: UITableViewController {
    
    @IBOutlet weak var songImage: UIImageView!
    @IBOutlet weak var songName: UILabel!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var timeLeft: UILabel!
    @IBOutlet weak var timeIn: UILabel!
    @IBOutlet weak var timeSlider: PlayerSlider!
    @IBOutlet weak var pausePlay: UIButton!
    @IBOutlet weak var forward: UIButton!
    @IBOutlet weak var backward: UIButton!
    @IBOutlet weak var headerView: UIView!
    
    var timer = Timer()
    var mediaList = [MPMediaItem]()
    
    override func viewDidLoad() {
        headerView.frame.size.height = self.view.frame.height
        tableView.bounces = false
        if player.nowPlayingItem != nil {
            currentSong = player.nowPlayingItem!
            getQueue()
            songImage.image = currentSong.artwork?.image(at: CGSize(width: 500, height: 500))
            songImage.layer.cornerRadius = 10
            songName.text = currentSong.title
            artistName.text = currentSong.artist
            timeSlider.maximumValue = Float(currentSong.playbackDuration)
            
        }
        timeSlider.setThumbImage(UIImage(), for: .normal)
        scheduledTimerWithTimeInterval()
        NotificationCenter.default.addObserver(self, selector: #selector(updateSong), name: NSNotification.Name(rawValue: "update"), object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(updateSong),name: .MPMusicPlayerControllerNowPlayingItemDidChange,object: nil)
    }
    
    @objc func updateSong() {
        if player.nowPlayingItem != nil {
            currentSong = player.nowPlayingItem!
        }
        
        songImage.image = currentSong.artwork?.image(at: CGSize(width: 500, height: 500))
        songName.text = currentSong.title
        artistName.text = currentSong.artist
        timeSlider.value = 0
        timeSlider.maximumValue = Float(currentSong.playbackDuration)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "update"), object: nil)

        getQueue()
    }
    
    func scheduledTimerWithTimeInterval(){
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.updateThings), userInfo: nil, repeats: true)
    }
    
    @objc func updateThings() {
        let timeInSong:Double = player.currentPlaybackTime
        let timeLeftInSong:Double = currentSong.playbackDuration - timeInSong
        
        timeIn.text = setTimerText(time: timeInSong)
        timeLeft.text = "-\(setTimerText(time: timeLeftInSong))"
        
        if player.playbackState == .playing {
            pausePlay.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            timeSlider.value = Float(player.currentPlaybackTime)
        } else if player.playbackState == .paused {
            pausePlay.setImage(UIImage(systemName: "play.fill"), for: .normal)
        }
    }
    
    func setTimerText(time: Double) -> String{
        //let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i", minutes, seconds)
    }
    
    @IBAction func backAction(_ sender: Any) {
        if player.currentPlaybackTime <= 5 {
            player.skipToPreviousItem()
        } else {
            player.currentPlaybackTime = 0
        }
    }
    
    @IBAction func forwardAction(_ sender: Any) {
        player.skipToNextItem()
        
    }
    
    @IBAction func playPauseAction(_ sender: Any) {
        if player.playbackState == .playing {
            pausePlay.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            player.pause()
            view.layoutIfNeeded()
        } else if player.playbackState == .paused {
            pausePlay.setImage(UIImage(systemName: "play.fill"), for: .normal)
            player.play()
        } else {
            pausePlay.setImage(UIImage(systemName: "play.fill"), for: .normal)
        }
    }
    
    @IBAction func valueChanged(_ sender: Any) {
        player.currentPlaybackTime = TimeInterval(timeSlider.value)
    }

    func getQueue() {
        mediaList.removeAll()
        let numberOfItems = player.numberOfItems()
        for i in 0..<numberOfItems {
            let item = player.nowPlayingItem(at: i)
            if i > player.indexOfNowPlayingItem {
                mediaList.append(item)
            }
        }
        tableView.reloadData()
    }
}


extension Player {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DefCell", for: indexPath) as! DefCell

        cell.nameLabel.text = mediaList[indexPath.row].title
        cell.descLabel.text = mediaList[indexPath.row].artist
        cell.fooView.image = mediaList[indexPath.row].artwork?.image(at: CGSize(width: 100, height: 100))
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mediaList.count
    }
}
