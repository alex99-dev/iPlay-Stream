//
//  VideoStruct.swift
//  iPlay Stream
//
//  Created by Buliga Alexandru on 19.03.2021.
//
import UIKit


class VideoData  {
    var name: String
    var url: String
    var thumb: UIImage
    var favStatus: Bool
    var favImgStatus: UIImage?
    
    
    
    init(nume:String, addr:String, favStatus: Bool, thumbnail : UIImage, status_fav_img:UIImage?)
    {
        self.name = nume
        self.url = addr
        self.favStatus = favStatus
        self.thumb = thumbnail
        self.favImgStatus = status_fav_img
    }
    
    
    func getName() -> String
    {
        return name
    }
    
}

var VideoStruct = [VideoData]()
var VideosSample = [VideoData]()




