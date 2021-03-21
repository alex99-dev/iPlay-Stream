//
//  VideoPlayer.swift
//  iPlay Stream
//
//  Created by Buliga Alexandru on 20.03.2021.
//



import Foundation
import UIKit
import AVKit


class VideoPlayer: ViewController
{
    var nume: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("MESSAGE:",nume!)
        
        if let url = URL(string:nume!)
        {
            let player = AVPlayer(url: url)
            let controller=AVPlayerViewController()
            controller.player=player
            controller.view.frame = self.view.frame
            self.view.addSubview(controller.view)
            self.addChild(controller)
            player.play()
        }
        
    }
    
}

