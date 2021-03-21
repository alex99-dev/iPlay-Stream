//
//  CustomCell.swift
//  iPlay Stream
//
//  Created by Buliga Alexandru on 19.03.2021.
//

import UIKit


class CustomCell: UITableViewCell {
    
    @IBOutlet weak var cellChFavStatus: UIButton!
    @IBOutlet weak var cellChThumb: UIImageView!
    @IBOutlet weak var cellChName: UILabel!
    var link: ViewController?
    
    
    func setVideoData(video: VideoData)
    {
        cellChName.text = video.name
        cellChThumb.image = video.thumb
        if (cellChFavStatus != nil)
        {
            cellChFavStatus.setImage(video.favImgStatus, for: UIControl.State.init())
            cellChFavStatus.addTarget(self, action: #selector (MarkChAsFavourite), for: .touchUpInside)
        }
    }
    
    
    
    
    
    @objc private func MarkChAsFavourite()
    {
        link?.MarkChAsFav(cell: self)
    }
    
}
