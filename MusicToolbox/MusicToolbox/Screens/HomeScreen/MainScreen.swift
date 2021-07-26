//
//  MainScreen.swift
//  MusicToolbox
//
//  Created by Zachary lineman on 1/6/20.
//  Copyright © 2020 Zachary lineman. All rights reserved.
//

import UIKit
import MediaPlayer

var player: MPMusicPlayerController = MPMusicPlayerController.systemMusicPlayer

class MainScreen: UITableViewController {
    
    //MP Arrays
    var songList = [MPMediaItem]()
    var sortedSongs = [MPMediaItem]() // Sorted
    var playlistList = [MPMediaPlaylist]()
    var sortedPlaylist = [MPMediaPlaylist]() // Sorted
    var albumsList = [Album]()
    var sortedAlbums = [Album]() // Sorted
    var artistList = [Artist]()
    var sortedArtists = [Artist]() // Sorted
    
    //Other
    var selectedSeg = 0
    
    //Mini Player
    var customView = UIView()
    var miniPlayerImage = UIImageView()
    var imageView = UIView()
    var titleText = UILabel()
    var artistText = UILabel()
    var pauseButton = UIButton()
    var forwardButton = UIButton()
    var search = UISearchController(searchResultsController: nil)

    @IBOutlet weak var segment: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.searchController = search
        search.delegate = self
        search.searchBar.delegate = self
        search.searchBar.placeholder = "Search"
        
        MPMediaLibrary.requestAuthorization { (status) in
            if status == .authorized {
                DispatchQueue.main.async {
                    player.prepareToPlay()
                    self.getPlaylists()
                    self.getAlbums()
                    self.getArtists()
                    self.getSongs()
                }
            } else if status == .notDetermined {
                
            }
        }
        let bottomView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 60))
        bottomView.backgroundColor = .clear
        tableView.tableFooterView = bottomView
        createMiniPlayer()
        NotificationCenter.default.addObserver(self, selector: #selector(updateMiniPlayer), name: NSNotification.Name(rawValue: "update"), object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(self.endSong),name: .MPMusicPlayerControllerNowPlayingItemDidChange,object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        MPMediaLibrary.requestAuthorization { (status) in
            if status == .authorized {
                print("Authorized")
            }
        }
    }
    
    @IBAction func segmentChanged(_ sender: Any) {
        switch segment.selectedSegmentIndex {
        case 0:
            selectedSeg = 0
            self.navigationItem.title = segment.titleForSegment(at: 0)

        case 1:
            selectedSeg = 1
            self.navigationItem.title = segment.titleForSegment(at: 1)

        case 2:
            selectedSeg = 2
            self.navigationItem.title = segment.titleForSegment(at: 2)

        case 3:
            selectedSeg = 3
            self.navigationItem.title = segment.titleForSegment(at: 3)

        default:
            break
        }
        tableView.reloadData()
        
    }
    
    //MARK: Song Stuff
    func getSongs() {
        let songsQuery: MPMediaQuery = MPMediaQuery.songs()
        let songsArray: [MPMediaItem] = songsQuery.items!
        
        for song in songsArray {
            songList.append(song)
        }
        sortedSongs = songList
        tableView.reloadData()
    }
    
    func playSong(selectedItem: MPMediaItem) {
        let song = MPMediaQuery.songs().items!
        let collection = MPMediaItemCollection(items: song)
        let descriptor = MPMusicPlayerMediaItemQueueDescriptor(itemCollection: collection)
        
        descriptor.startItem = selectedItem
        
        if selectedItem != player.nowPlayingItem {
            player.setQueue(with: descriptor)
            player.shuffleMode = .off
            
            player.prepareToPlay()
            player.play()
        }
        if player.nowPlayingItem != nil {
            currentSong = player.nowPlayingItem!
        }
    }
    
    //MARK: Playlist Stuff
    func getPlaylists() {
        let myPlaylistQuery = MPMediaQuery.playlists()
        let playlists = myPlaylistQuery.collections
        let playlistNSArray : NSArray = NSArray(array: playlists!)
        
        let descriptor: NSSortDescriptor = NSSortDescriptor(key: MPMediaPlaylistPropertyName, ascending: true)
        let sortedResults: NSArray = playlistNSArray.sortedArray(using: [descriptor]) as NSArray
        let array: [MPMediaPlaylist] = sortedResults.compactMap({ $0 as? MPMediaPlaylist })
        
        for playlist in array {
            playlistList.append(playlist)
        }
        sortedPlaylist = playlistList
    }
    
    func playPlaylist(selectedPlaylist: String) {
        let query = MPMediaQuery.playlists()
        let predicate = MPMediaPropertyPredicate(value: selectedPlaylist, forProperty: MPMediaPlaylistPropertyName)
        
        query.addFilterPredicate(predicate)
        
        let descriptor = MPMusicPlayerMediaItemQueueDescriptor(query: query)
        
        player.setQueue(with: descriptor)
        player.prepareToPlay()
        player.play()
        
        if player.nowPlayingItem != nil {
            currentSong = player.nowPlayingItem!
        }
    }
    
    //MARK: Album Stuff
    func getAlbums() {
        let myAlbumQuery = MPMediaQuery.albums()
        let albums = myAlbumQuery.collections
        
        for album in albums! {
            let name = (album.representativeItem?.albumTitle)!
            let artist = (album.representativeItem?.albumArtist)!
            let image = (album.representativeItem?.artwork?.image(at: CGSize(width: 50, height: 50))) ?? UIImage(named: "NotFound")!
            let songs = album.items
            albumsList.append(Album.init(Name: name, Artist: artist, Image: image, Songs: songs))
        }
        
        sortedAlbums = albumsList
    }
    
    func playAlbum(selectedAlbum: Album) {
        let collection = MPMediaItemCollection.init(items: selectedAlbum.songList)
        let descriptor = MPMusicPlayerMediaItemQueueDescriptor(itemCollection: collection)
        
        player.setQueue(with: descriptor)
        player.prepareToPlay()
        player.play()
        
        currentSong = player.nowPlayingItem!
        
    }
    
    //Artist Stuff
    func getArtists() {
        let myArtistsQuery = MPMediaQuery.artists()
        let artists = myArtistsQuery.collections
        
        for artist in artists! {
            let artistName = artist.representativeItem?.artist!
            let image = artist.representativeItem?.artwork?.image(at: CGSize(width: 300, height: 300)) ?? UIImage(named: "NotFound")!
            artistList.append(Artist.init(Name: artistName!, Image: image))
            
        }
        sortedArtists = artistList
    }
    
    func playArtist(selectedArtist: String) {
        let query = MPMediaQuery.artists()
        let predicate = MPMediaPropertyPredicate(value: selectedArtist, forProperty: MPMediaItemPropertyArtist)
        
        query.addFilterPredicate(predicate)
        
        let descriptor = MPMusicPlayerMediaItemQueueDescriptor(query: query)
        
        player.setQueue(with: descriptor)
        player.prepareToPlay()
        player.play()
        
        if player.nowPlayingItem != nil {
            currentSong = player.nowPlayingItem!
            
        }
    }
    
    @objc func endSong() {
        if player.nowPlayingItem != nil {
            currentSong = player.nowPlayingItem!
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "update"), object: nil)
    }
}


