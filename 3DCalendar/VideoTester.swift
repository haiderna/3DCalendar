//
//  VideoTester.swift
//  3DCalendar
//
//  Created by Najia Haider on 3/14/19.
//  Copyright © 2019 Najia Haider. All rights reserved.
//

import UIKit
import AVKit

class VideoTester: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.purple
        setupVideo()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupVideo() {
        let extraView = UIView(frame: self.frame)
        extraView.backgroundColor = UIColor.orange
        let videoURL = URL(string: "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")
        let player = AVPlayer(url: videoURL!)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = extraView.bounds
        extraView.layer.addSublayer(playerLayer)
        self.addSubview(extraView)
        player.play()
    }
    
    func setupImage() {
        let image = UIImage(named: "chao")
        let imageView = UIImageView(image: image)
        imageView.frame = self.bounds
        self.addSubview(imageView)
    }

}
