//
//  TableViewFiles.swift
//  MusicToolbox
//
//  Created by Zachary lineman on 3/6/20.
//  Copyright © 2020 Zachary lineman. All rights reserved.
//


extension MainScreen {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch segment.titleForSegment(at: selectedSeg) {
        case "Playlists":
            return sortedPlaylist.count
            
        case "Songs":
            return sortedSongs.count
            
        case "Albums":
            return sortedAlbums.count
            
        case "Artists":
            return sortedArtists.count
            
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DefCell", for: indexPath) as! DefCell
        switch segment.titleForSegment(at: selectedSeg) {
        case "Playlists":
            if self.sortedPlaylist[indexPath.row].representativeItem?.artwork != nil {
                cell.fooView.image = sortedPlaylist[indexPath.row].representativeItem?.artwork?.image(at: CGSize(width: 50, height: 50))
            } else {
                cell.fooView.image = UIImage(named: "NotFound")!
            }
            cell.nameLabel.text = sortedPlaylist[indexPath.row].value(forProperty: MPMediaPlaylistPropertyName) as? String
            cell.descLabel.text = "Number of songs: \(sortedPlaylist[indexPath.row].count)"
        case "Songs":
            cell.nameLabel.text = sortedSongs[indexPath.row].title
            cell.descLabel.text = sortedSongs[indexPath.row].artist
            cell.fooView.image = sortedSongs[indexPath.row].artwork?.image(at: CGSize(width: 100, height: 100))
        case "Albums":
            cell.nameLabel.text = sortedAlbums[indexPath.row].albumName
            cell.descLabel.text = sortedAlbums[indexPath.row].albumArtist
            cell.fooView.image = sortedAlbums[indexPath.row].albumImage
        case "Artists":
            cell.nameLabel.text = sortedArtists[indexPath.row].artistName
            cell.fooView.image = sortedArtists[indexPath.row].artistImage
            cell.descLabel.text = ""
        default:
            break
        }
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch segment.titleForSegment(at: selectedSeg) {
        case "Playlists":
            player.shuffleMode = .songs
            playPlaylist(selectedPlaylist: sortedPlaylist[indexPath.row].value(forProperty: MPMediaPlaylistPropertyName) as! String)
            performSegue(withIdentifier: "player", sender: self)
        case "Songs":
            playSong(selectedItem: sortedSongs[indexPath.row])
            performSegue(withIdentifier: "player", sender: self)
            
        case "Albums":
            player.shuffleMode = .songs
            playAlbum(selectedAlbum: sortedAlbums[indexPath.row])
            performSegue(withIdentifier: "player", sender: self)

        case "Artists":
            player.shuffleMode = .songs
            playArtist(selectedArtist: sortedArtists[indexPath.row].artistName)
            performSegue(withIdentifier: "player", sender: self)
        default:
            break
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func createPopup() {
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        let cView = UIButton(frame: CGRect(x: (screenWidth / 2) - 50, y: screenHeight - 70, width: 100, height: 50))
        cView.backgroundColor = UIColor.systemGray6
        cView.layer.cornerRadius = 25
        cView.addTarget(self, action: #selector(self.openPlayer), for: .touchUpInside)
        cView.setTitle("^", for: .normal)
        
        self.navigationController?.view.addSubview(cView)
        
    }
    
    @objc func openPlayer() {
        performSegue(withIdentifier: "player", sender: self)
    }
}
