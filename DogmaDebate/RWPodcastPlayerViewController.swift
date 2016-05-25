//
//  RWPodcastPlayerViewController.swift
//  DogmaDebate
//
//  Created by Rondale Williams on 12/22/15.
//  Copyright © 2015 RondaleWilliams. All rights reserved.
//

import UIKit
import AVFoundation

class RWPodcastPlayerViewController : UIViewController {
    
    var podcast: RWPodcast?
    var isPlaying: Bool = false
    var isPaused: Bool = false
    private var seconds = 0.0
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var podcastDescription: UITextView!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var timeDurationLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    
    var player: AVPlayer?
    var trackTime:CMTime?
    
    private var kRateDidChangeKVO = 0
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBarHidden = false
        let leftBarButtonItem = UIBarButtonItem(title: "Back", style: .Plain, target: self, action: #selector(RWPodcastPlayerViewController.dismiss))
        navigationItem.backBarButtonItem = leftBarButtonItem
        navigationController?.navigationBar.translucent = false
        navigationItem.title = "Dogma Debate"
        navigationController!.navigationBar.barTintColor = UIColor.blackColor()
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationController?.navigationBar.titleTextAttributes =  [NSForegroundColorAttributeName : UIColor.whiteColor()]
        setUpPodcastDetails()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func dismiss() {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func rewind(sender: AnyObject) {
        let thirtySecondsBack = CMTimeMake(30, 1)
        if let trackTime =  self.trackTime {
            player?.seekToTime(CMTimeSubtract(trackTime, thirtySecondsBack))
        }
    }
    
    @IBAction func stop(sender: AnyObject) {
        player?.pause()
        isPaused = true
    }
    
    @IBAction func play(sender: AnyObject) {
        
        if isPlaying == false {
            if let podcastUrl = podcast?.url {
                let url = NSURL(string: podcastUrl)
                if let audioUrl = url {
                    
                    let audioPlayer = AVPlayer(URL:audioUrl)
                    player = audioPlayer
                    player?.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions(rawValue: 0), context: nil)
                }
                
            }
        } else if isPaused == true {
            player?.play()
        } else {
            player?.pause()
        }
        
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        if let keyPath = keyPath {
            if (object === self.player) && (keyPath == "status")  {
                
                if player?.status == AVPlayerStatus.ReadyToPlay {
                    isPlaying = true
                    player?.play()
                    
                    if let duration = player?.currentItem?.asset.duration {
                        let secs = CMTimeGetSeconds(duration)
                        self.slider.maximumValue = Float(secs)
                        timeDurationLabel.text = setUpPodcastDuration(secs)
                        
                    }
                    
                    player?.addPeriodicTimeObserverForInterval(CMTimeMake(1, 1), queue: nil) { (time) -> Void in
                        self.trackTime = time
                        self.seconds = CMTimeGetSeconds(time)
                        self.timerLabel.text = self.setUpPodcastTimer(self.seconds)
                        self.slider.value = Float(self.seconds)
                        print("\(self.slider.value)")
                    }

                    if let time = player?.currentItem?.duration.seconds {
                    let number = NSNumber(double: time)
                    slider.setValue(number.floatValue, animated: true)
                    }
                    
                }
                
                
                if self.player?.status == AVPlayerStatus.Failed {
                }
                
            }
            
        }
        
    }
    
    @IBAction func fastForward(sender: AnyObject) {
        let addedTime =  CMTimeMake(30, 1)
        if let trackTime = self.trackTime {
            player?.seekToTime(CMTimeAdd(trackTime, addedTime))
        }
    }
    
    func setUpPodcastDetails() {
        titleLabel.text = podcast?.title
        podcastDescription.text = podcast?.podcastDescription
    }
    
    func setUpPodcastDuration(seconds: Double) -> String {
        let (hrs, min) = modf(seconds / 3600)
        let (mins, _) = modf(min * 60)
        let string = NSString(format: "%.02d:%.02d:%.02d", Int(hrs), Int(mins), Int(00))
        
        return string as String
    }
    
    func setUpPodcastTimer(seconds:Double) -> String {
        var mins = 0.0
        var hours = 0.0
        var countedSeconds = 0.0
         var secs = 0.0
        
        while countedSeconds <= seconds {
            secs++
            
            if countedSeconds % 60.0 == 0 && countedSeconds > 0 {
                mins++
                secs = 0.0
            }
            
            
            if countedSeconds % 3600 == 0 && countedSeconds > 0 {
                hours++
                mins = 0.0
            }
            
             countedSeconds++
        }
        
        
       return NSString(format: "%.02d:%.02d:%.02d", Int(hours), Int(mins), Int(secs)) as String
    }
    
}
