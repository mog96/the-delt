//
//  PhotoVideoCell.swift
//  XCHAT
//
//  Created by Mateo Garcia on 3/15/16.
//  Copyright (c) 2015 Mateo Garcia. All rights reserved.
//

import UIKit
import AVKit
import MediaPlayer

@objc protocol PhotoVideoCellDelegate {
    func presentVideoDetailViewController(videoFile file: PFFile)
}

class PhotoVideoCell: UITableViewCell {
    
    @IBOutlet weak var controlsView: UIView!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var videoPlayerView: UIView!
    
    var videoPlayer: MPMoviePlayerController?
    var videoUrl: NSURL?
    
    weak var delegate: PhotoVideoCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        self.photoImageView.image = nil
    }
    
    func setUpCell(photo: NSMutableDictionary?) {
        self.videoPlayer = nil
        
        if let photo = photo {
            
            // Video.
            if let file = photo.valueForKey("videoFile") as? PFFile {
                let pfImageView = PFImageView()
                
                // Temp image.
                pfImageView.image = UIImage(named: "ROONEY")
                
                // Load thumbnail image.
                pfImageView.file = photo.valueForKey("imageFile") as? PFFile
                pfImageView.loadInBackground { (image: UIImage?, error: NSError?) -> Void in
                    if let error = error {
                        // Log details of the failure
                        print("Error: \(error) \(error.userInfo)")
                        
                    } else {
                        self.photoImageView.image = image
                    }
                }
                
                self.videoUrl = NSURL(string: file.url!)!
                
                // Enable cell tap.
                let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "onControlsViewTapped")
                self.controlsView.addGestureRecognizer(tapGestureRecognizer)
                
            // Photo.
            } else {
                let file = photo.valueForKey("imageFile") as! PFFile
                let pfImageView = PFImageView()
                
                // JUST FOR LOLZ
                pfImageView.image = UIImage(named: "ROONEY")
                
                pfImageView.file = file
                pfImageView.loadInBackground { (image: UIImage?, error: NSError?) -> Void in
                    if let error = error {
                        // Log details of the failure
                        print("Error: \(error) \(error.userInfo)")
                        
                    } else {
                        self.photoImageView.image = image
                    }
                }
            }
            
        } else {
            
            // Error.
            self.photoImageView.backgroundColor = UIColor.redColor()
        }
    }
    
    
    // MARK: - Actions
    
    func onControlsViewTapped() {
        if self.photoImageView.hidden {
            self.videoFinished()
            
        } else {
            if self.videoPlayer == nil {
                self.addVideoPlayer(contentUrl: self.videoUrl!, containerView: self.videoPlayerView, preview: self.photoImageView)
            }
            self.videoPlayer?.play()
            self.photoImageView.hidden = true
        }
    }
    
    
    // MARK: - Video Player
    
    func addVideoPlayer(contentUrl contentUrl: NSURL, containerView: UIView, preview: UIImageView?) {
        self.videoPlayer = MPMoviePlayerController(contentURL: contentUrl)
        self.videoPlayer!.view.frame = CGRectMake(0, 0, containerView.frame.width, containerView.frame.height)
        
        self.videoPlayer!.controlStyle = .None
        self.videoPlayer!.scalingMode = MPMovieScalingMode.AspectFit
        self.videoPlayer!.contentURL = contentUrl
        self.videoPlayer!.backgroundView.backgroundColor = UIColor.clearColor()
        self.videoPlayer!.shouldAutoplay = true
        
        // NSNotificationCenter.defaultCenter().addObserver(self, selector: "videoSizeAvailable", name: MPMovieNaturalSizeAvailableNotification, object: self.videoPlayer)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "videoFinished", name: MPMoviePlayerPlaybackDidFinishNotification, object: self.videoPlayer)
        
        containerView.addSubview(self.videoPlayer!.view)
        self.videoPlayer!.view.autoPinEdgesToSuperviewEdges()
        
        // Disable pinch gesture.
        for view in self.videoPlayer!.view.subviews {
            for gestureRecognizer in view.gestureRecognizers! {
                if gestureRecognizer.isKindOfClass(UIPinchGestureRecognizer) {
                    view.removeGestureRecognizer(gestureRecognizer)
                }
            }
        }
    }
    
    func videoSizeAvailable() {
        print("SIZE AVILABLE")
    }
    
    func removeVideoPlayer() {
        
        print("REMOVING PLAYER")
        
        self.videoFinished()
        self.videoPlayer = nil
        if let recognizers = self.controlsView.gestureRecognizers {
            for recognizer in recognizers {
                controlsView.removeGestureRecognizer(recognizer)
            }
        }
    }
    
    func videoFinished() {
        self.photoImageView.hidden = false
        self.videoPlayer?.stop()
        self.videoPlayer?.currentPlaybackTime = 0
    }
    
}