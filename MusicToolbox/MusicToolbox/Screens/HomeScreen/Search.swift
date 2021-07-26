//
//  SearchScreen.swift
//  MusicToolbox
//
//  Created by Zachary lineman on 3/10/20.
//  Copyright © 2020 Zachary lineman. All rights reserved.
//

extension MainScreen: UISearchBarDelegate, UISearchControllerDelegate {
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        switch segment.titleForSegment(at: selectedSeg) {
        case "Playlists":
            let searchText = searchBar.text!.lowercased()
            sortedPlaylist.removeAll()
            
            if searchText != "" {
                for playlist in playlistList {
                    let name = playlist.value(forProperty: MPMediaPlaylistPropertyName) as! String
                    if name.lowercased().contains(searchText) {
                        sortedPlaylist.append(playlist)
                    }
                }
            } else {
                getPlaylists()
                
            }
            
            sortedPlaylist.removeDuplicates()
            tableView.reloadData()
        case "Songs":
            let searchText = searchBar.text!.lowercased()
            sortedSongs.removeAll()
            
            if searchText != "" {
                for song in songList {
                    if song.title!.lowercased().contains(searchText) || song.artist!.lowercased().contains(searchText) || song.albumTitle!.lowercased().contains(searchText) {
                        sortedSongs.append(song)
                    }
                }
            } else {
                getSongs()
                
            }
            
            sortedSongs.removeDuplicates()
            tableView.reloadData()
        case "Albums":
            let searchText = searchBar.text!.lowercased()
            sortedAlbums.removeAll()
            
            if searchText != "" {
                for album in albumsList {
                    if album.albumName.lowercased().contains(searchText) || album.albumArtist.lowercased().contains(searchText) {
                        sortedAlbums.append(album)
                    }
                }
            } else {
                getAlbums()
                
            }
            tableView.reloadData()

            //sortedAlbums.removeDuplicates()
        case "Artists":
            let searchText = searchBar.text!.lowercased()
            sortedArtists.removeAll()
            
            if searchText != "" {
                for artist in artistList {
                    if artist.artistName.lowercased().contains(searchText) {
                        sortedArtists.append(artist)
                    }
                }
            } else {
                getArtists()
                
            }
            tableView.reloadData()

            //sortedArtists.removeDuplicates()
        default:
            break
        }

    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dismissKeyboard()
        switch segment.titleForSegment(at: selectedSeg) {
        case "Playlists":
            getPlaylists()

        case "Songs":
            getSongs()

        case "Albums":
            getAlbums()

        case "Artists":
            getArtists()

        default:
            break
        }
        tableView.reloadData()
        searchBar.text = ""
        dismiss(animated: true) {
            
        }
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dismissKeyboard()
        if searchBar.text == "" {
            getArtists()
            getAlbums()
            getSongs()
            getPlaylists()
        }
        tableView.reloadData()
        
    }
}

extension RangeReplaceableCollection where Element: Hashable {
    var orderedSet: Self {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
    mutating func removeDuplicates() {
        var set = Set<Element>()
        removeAll { !set.insert($0).inserted }
    }
}
/*

    

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedSongs.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell1", for: indexPath) as! HomeCell1
        
        cell.setup(song: sortedSongs[indexPath.row])

        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentSong = sortedSongs[indexPath.row]
        play(selectedItem: currentSong)
        performSegue(withIdentifier: "player", sender: self)

    }
    
    func play(selectedItem: MPMediaItem) {
        if (!selectedItem.isCloudItem) {
            let song = MPMediaQuery.songs().items!
            let collection = MPMediaItemCollection(items: song)
            let descriptor = MPMusicPlayerMediaItemQueueDescriptor(itemCollection: collection)
            
            descriptor.startItem = selectedItem
            
            if selectedItem != boxPlayer.nowPlayingItem {
                boxPlayer.setQueue(with: descriptor)

                boxPlayer.play()
            }
        }
        if boxPlayer.nowPlayingItem != nil {
            currentSong = boxPlayer.nowPlayingItem!
        }
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func getSongs() {
        let songsQuery: MPMediaQuery = MPMediaQuery.songs()
        let songsArray: [MPMediaItem] = songsQuery.items!
        let songsNSArray : NSArray = NSArray(array: songsArray)
        
        let descriptor: NSSortDescriptor = NSSortDescriptor(key: MPMediaItemPropertyTitle, ascending: true)
        let sortedResults: NSArray = songsNSArray.sortedArray(using: [descriptor]) as NSArray
        let array: [MPMediaItem] = sortedResults.compactMap({ $0 as? MPMediaItem })
        for item in array {
            switch UserDefaults.standard.value(forKey: "cloudItems?") as! Bool {
            case true:
                self.mediaList.append(item)

            case false:
                if item.isCloudItem == false {
                    self.mediaList.append(item)

                 }
            }
        }
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let searchText = searchBar.text
        sortedSongs.removeAll()
        
        if searchText != "" {
            // || song.genre!.contains(searchText!) || song.lyrics!.contains(searchText!)
            for song in mediaList {
                if song.title!.contains(searchText!) || song.artist!.contains(searchText!) || song.albumTitle!.contains(searchText!) {
                    sortedSongs.append(song)
                }
            }
        } else {
            createList()
            
        }
        
        sortedSongs.removeDuplicates()
        tableView.reloadData()
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dismissKeyboard()
        sortedSongs.removeAll()
        tableView.reloadData()
        searchBar.text = ""
        dismiss(animated: true) {
            
        }
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dismissKeyboard()
        tableView.reloadData()
        
    }
}

extension RangeReplaceableCollection where Element: Hashable {
    var orderedSet: Self {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
    mutating func removeDuplicates() {
        var set = Set<Element>()
        removeAll { !set.insert($0).inserted }
    }
}

*/
