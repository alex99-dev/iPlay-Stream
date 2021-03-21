//
//  FavouriteViewController.swift
//  iPlay Stream
//
//  Created by Buliga Alexandru on 19.03.2021.
//


import UIKit
import AVFoundation
import Network
@available(iOS 12.0, *)

var favVideosNames = [String]()
var favVideos: [VideoData] = []
var cellIndex = 0

class FavouriteViewController: UIViewController{
    
    @IBOutlet var table: UITableView!
    var noFavChsLbl : UILabel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noFavLBL()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }
    
}


extension FavouriteViewController: UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favVideos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let video = favVideos[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell") as! CustomCell
        
        cell.setVideoData(video: video)
        return cell
        
    }
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        cellIndex = indexPath.row
        print("Ai ales:",  cellIndex)
        performSegue(withIdentifier: "VideoPlayerSegue2", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "VideoPlayerSegue2"
        {
            let name: String = VideoStruct[cellIndex].url
            let destinationVC = segue.destination as! VideoPlayer
            destinationVC.nume = name
        }
        
        if segue.identifier == "settingsSegue2"
        {
            _ = segue.destination as! SettingsController
        }
        
    }
    
    
    
    
    func loadData()
    {
        print("Loading favourite videos...")
        
        if let getFavTVideo = UserDefaults.standard.array(forKey: "favoritesVideos") as? [String]
        {favVideosNames = getFavTVideo}
        
        favVideos.removeAll()
        
        
        
        if(favVideosNames.count>0)
        {
            for favCh in favVideosNames
            {
                if let index = VideoStruct.firstIndex(where: { $0.name == favCh })
                {
                    favVideos.append(VideoStruct[index])
                }
            }
            
            self.noFavChsLbl!.isHidden = true
        }
        if(favVideos.count == 0)
        {
            self.noFavChsLbl!.isHidden = false
        }
        
        
        self.table.reloadData()
    }
    
    
    
    func noFavLBL()
    {
        noFavChsLbl = UILabel(frame: CGRect( x: 0, y: 0, width: 200, height: 50))
        self.view.addSubview(noFavChsLbl!)
        noFavChsLbl!.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 30)
        noFavChsLbl!.textColor = .darkGray
        noFavChsLbl!.translatesAutoresizingMaskIntoConstraints = false
        noFavChsLbl!.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        noFavChsLbl!.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        noFavChsLbl!.text = "No Favorites"
        noFavChsLbl!.textAlignment = .center;
        noFavChsLbl!.layer.shadowColor = UIColor.black.cgColor
        noFavChsLbl!.layer.shadowRadius = 1.0
        noFavChsLbl!.layer.shadowOpacity = 1.0
        noFavChsLbl!.layer.shadowOffset = CGSize(width: 1, height: 1)
        noFavChsLbl!.layer.masksToBounds = true
        
    }
    
    func addImage()
    {
        
        
        //Image
        let mainImageView = UIImageView(image:#imageLiteral(resourceName: "fav_false"))
        self.view.addSubview(mainImageView)
        
        mainImageView.translatesAutoresizingMaskIntoConstraints = false
        mainImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mainImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        mainImageView.contentMode = .scaleAspectFit
    }
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        //noFavChsLbl!.removeFromSuperview()
        print("Screen ROTATE")
        // noFavLBL()
        
    }
    
}


