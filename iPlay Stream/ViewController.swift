//
//  ViewController.swift
//  iPlay Stream
//
//  Created by Buliga Alexandru on 18.03.2021.
//


import UIKit
import FirebaseDatabase


class ViewController: UIViewController{
    var image = UIImage()
    var numee: String?
    var favVideosNames : [String] = []
    var cellIndex = 0
    let heartFav = UIImage(systemName: "heart.fill")?.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
    let starNoFav = UIImage(systemName: "heart.fill")?.withTintColor(.lightGray, renderingMode: .alwaysOriginal)
    
    @IBOutlet var table: UITableView!
    @IBOutlet weak var addnewIPTV: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshTable), name: NSNotification.Name(rawValue: "refreshTable"), object: nil)
        
        
        
        if (VideosSample.count == 0)
        {
            VideosSample.append(VideoData(nume: "Sample 1", addr: "https://multiplatform-f.akamaihd.net/i/multi/will/bunny/big_buck_bunny_,640x360_400,640x360_700,640x360_1000,950x540_1500,.f4v.csmil/master.m3u8", favStatus: false, thumbnail: #imageLiteral(resourceName: "videoThumb"), status_fav_img: starNoFav ))
            VideosSample.append(VideoData(nume: "Sample 2", addr: "https://multiplatform-f.akamaihd.net/i/multi/april11/sintel/sintel-hd_,512x288_450_b,640x360_700_b,768x432_1000_b,1024x576_1400_m,.mp4.csmil/master.m3u8", favStatus: false, thumbnail: #imageLiteral(resourceName: "videoThumb"), status_fav_img: starNoFav ))
            VideosSample.append(VideoData(nume: "Sample 3", addr: "http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8", favStatus: false, thumbnail: #imageLiteral(resourceName: "videoThumb"),status_fav_img: starNoFav ))
            
            VideoStruct = VideosSample
        }
        
        
        
        if let getFavVideos = UserDefaults.standard.array(forKey: "favoritesVideos") as? [String]
        {favVideosNames = getFavVideos}
        
        
        
        
        for favVideo in favVideosNames
        {
            if let index = VideoStruct.firstIndex(where: { $0.name == favVideo })
            {
                favVideos.append(VideoStruct[index])
                VideoStruct[index].favStatus = true
                VideoStruct[index].favImgStatus = heartFav
            }
        }
    }
    
    
    
    @IBAction func addtofav(_ sender: Any) {
        print("AddToFav")
        saveUserData()
    }
    
}


extension ViewController: UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return VideoStruct.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let video = VideoStruct[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell") as! CustomCell
        
        cell.link = self
        
        cell.setVideoData(video: video)
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        cellIndex = indexPath.row
        print("Ai ales:",  indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            VideoStruct.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }}
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "VideoPlayerSegue"
        {
            let name: String = VideoStruct[cellIndex].url
            let destinationVC = segue.destination as! VideoPlayer
            destinationVC.nume = name
        }
        
        if segue.identifier == "settingsSegue"
        {
            _ = segue.destination as! SettingsController
        }
        
    }
    
    
    
    func MarkChAsFav(cell: UITableViewCell)
    {
        let indexPath = table.indexPath(for: cell)
        print(indexPath!.row)
        
        
        if (VideoStruct[indexPath!.row].favStatus == false)
        {
            VideoStruct[indexPath!.row].favImgStatus = heartFav
            VideoStruct[indexPath!.row].favStatus = true
            
            /// copiere video in lista de Favourite
            favVideosNames.append(VideoStruct[indexPath!.row].name)
            ///
        }
        else {
            VideoStruct[indexPath!.row].favImgStatus = starNoFav
            VideoStruct[indexPath!.row].favStatus = false
            
            
            
            ///sterge video din Favourite
            if let pozRemove = favVideosNames.firstIndex(where: { $0 == VideoStruct[indexPath!.row].name })
            {
                print("Sterg video de pe poz:",pozRemove)
                favVideosNames.remove(at: pozRemove)
            }
        }
        
        
        
        saveUserData()
        print("UPDATE lista de favourite")
        table.reloadData() //pt schimbare imagine as favourite
    }
    
    
    
    func saveUserData()
    {
        UserDefaults.standard.set(favVideosNames, forKey: "favoritesVideos")
        UserDefaults.standard.synchronize()
    }
    
    
    @IBAction func addIPTVSource(_ sender: Any) {
        
        let config = UIImage.SymbolConfiguration(pointSize: UIFont.systemFontSize, weight: .semibold, scale: .large)
        
        let urlIC = UIImage(systemName: "link.badge.plus", withConfiguration: config)
        let playlistIC = UIImage(systemName: "list.bullet", withConfiguration: config)
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet )
        alert.view.tintColor = UIColor(red: 0.13, green: 0.57, blue: 0.98, alpha: 1.00)
        
        
        let addUrlAction = UIAlertAction(title: "Add URL Stream", style: .default, handler: { (_) in
            print("Import URL")
            self.addIPTVUrl()
        })
        addUrlAction.setValue(urlIC, forKey: "image")
        alert.addAction(addUrlAction)
        
        
        
        
        let addUrlAction2 = UIAlertAction(title: "Import M3U Playlist", style: .default, handler: { (_) in
            print("Import Playlist")
            self.addIPTVPlaylist()
        })
        addUrlAction2.setValue(playlistIC, forKey: "image")
        alert.addAction(addUrlAction2)
        
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
            print("User click Cancel button")
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    
    
    
    func addIPTVUrl()
    {
        let alert = UIAlertController(title: "ADD URL STREAM", message: "Please input your information", preferredStyle: UIAlertController.Style.alert )
        alert.view.tintColor = UIColor(red: 0.13, green: 0.57, blue: 0.98, alpha: 1.00)
        
        
        let save = UIAlertAction(title: "Save", style: .default) { (alertAction) in
            let title = alert.textFields![0] as UITextField
            let adresa = alert.textFields![1] as UITextField
            
            
            
            if (title.text != "" && adresa.text != "")
            {
                if ((adresa.text!.starts(with: "https://")) || (adresa.text!.starts(with: "http://") ))
                {
                    let newVideo = VideoData(nume: title.text!, addr: adresa.text!, favStatus: false, thumbnail: #imageLiteral(resourceName: "videoThumb"), status_fav_img: self.starNoFav)
                    
                    VideoStruct.append(newVideo)
                    self.table.reloadData()
                }
                else{
                    let alert = UIAlertController(title: "Invalid URL", message: nil, preferredStyle: UIAlertController.Style.alert )
                    alert.view.tintColor = UIColor(red: 0.13, green: 0.57, blue: 0.98, alpha: 1.00)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Enter name"
            textField.textColor = .systemBlue
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Enter your .m3u8 File URL"
            textField.textColor = .systemBlue
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default) { (alertAction) in })
        alert.addAction(save)
        
        self.present(alert, animated:true, completion: nil)
    }
    
    
    
    
    
    func addIPTVPlaylist()
    {
        let alert = UIAlertController(title: "Import M3U Playlist", message: "Please input your information", preferredStyle: UIAlertController.Style.alert )
        alert.view.tintColor = UIColor(red: 0.13, green: 0.57, blue: 0.98, alpha: 1.00)
        
        let save = UIAlertAction(title: "Save", style: .default) { (alertAction) in
            let title = alert.textFields![0] as UITextField
            let adresa = alert.textFields![1] as UITextField
            
            if (title.text != "" && title.text != "")
            {
                if ((adresa.text!.starts(with: "https://")) || (adresa.text!.starts(with: "http://") ) && adresa.text!.hasSuffix(".m3u"))
                {
                    self.getIPTVPlaylistData(playlistString: adresa.text!)
                }
                else {
                    let alert = UIAlertController(title: "Invalid Playlist URL", message: nil, preferredStyle: UIAlertController.Style.alert )
                    alert.view.tintColor = UIColor(red: 0.13, green: 0.57, blue: 0.98, alpha: 1.00)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        
        
        alert.addTextField { (textField) in
            textField.placeholder = "Enter playlist name"
            textField.textColor = .systemBlue
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Enter your M3U playlist URL"
            textField.textColor = .systemBlue
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default) { (alertAction) in })
        alert.addAction(save)
        
        self.present(alert, animated:true, completion: nil)
    }
    
    
    
    
    
    func getIPTVPlaylistData(playlistString : String)
    {
        let url = URL(string: playlistString)
        let session = URLSession.shared
        
        let task = session.dataTask(with: url!) { data, response, error in
            if let error = error {
                print("EROARE!!! :\(error)")
            } else {
                
                if let data = data, let stringPlaylist = String(data: data, encoding: .utf8) {
                    self.getVideosFromPlaylistData(string: stringPlaylist)
                    
                    DispatchQueue.main.async {
                        self.table.reloadData()
                    }
                    
                } else {
                    print("Format playlist GRESIT")
                }
            }
        }
        task.resume()
        
    }
    
    
    
    
    
    
    func getVideosFromPlaylistData(string: String)
    {
        print("Geting videos from string : \(string)")
        string.enumerateLines { line, shouldStop in
            if line.hasPrefix("#EXTM3U"){print("It's a m3u playlist")}
            else if line.hasPrefix("#EXTINF:") {
                let infoLine = line.replacingOccurrences(of: "#EXTINF:", with: "")
                let infoItems = infoLine.components(separatedBy: ",")
                if let title = infoItems.last {
                    let newVideo = VideoData (nume: title, addr: "", favStatus: false, thumbnail: #imageLiteral(resourceName: "videoThumb"), status_fav_img: self.starNoFav)
                    VideoStruct.append(newVideo)
                }
            } else {
                if let video = VideoStruct.popLast() {
                    video.url = line
                    VideoStruct.append(video)
                }
            }
        }
    }
    
    @objc func refreshTable(){
        self.table.reloadData()
    }
    
    
}

