//
//  ViewController.swift
//  CubeTimer
//
//  Created by JUN HO CHOI on 2018. 1. 17..
//  Copyright © 2018년 Leotek. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var displayTimerLabel: UILabel!
    @IBOutlet var thisView: UIView!
    @IBOutlet weak var cubeView: UIView!
    
    private var stopImage : UIImage?
    private var stopImageView : UIImageView?
    
    private var startImage : UIImage?
    private var startImageView : UIImageView?
    
    
    var counter = 0.0 {
        didSet{
            if counter >= 3600.0 {
                counter = 0.0
            }
            
            let min = Int(counter / 60.0)
            let sec = Int(counter) % 60
            let dot = Int(counter * 100) % 100
            displayTimerLabel.text = String(format: "%02d:%02d.%02d", min, sec, dot)
        }
    }
    var timer = Timer()
    var isPlaying = false {
        didSet {
            if isPlaying {
                animationStart()
            } else {
                animationStop()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture) )
        longPress.minimumPressDuration = 0.5
        
        let taps = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        
        self.thisView.gestureRecognizers = [longPress,taps]
        
        loadanimationImage()
        
        animationStop()
    }
    
    func loadanimationImage() {
        stopImage = UIImage(named: "cube_stop")
        stopImageView = UIImageView(image: stopImage)
        stopImageView?.frame = CGRect(x: 0 , y: 0, width:
            256.0 , height: 192.0)
        
        if #available(iOS 9.0, *) {
            if let asset = NSDataAsset(name: "cube") {
                let data = asset.data
                _ = try? JSONSerialization.jsonObject(with: data, options: [])
                
                startImage = UIImage.gifImageWithData(data)
                startImageView = UIImageView(image: startImage)
                startImageView?.frame = CGRect(x: 0 , y: 0, width:
                    256.0 , height: 192.0)
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    
    func animationStop() {
        cubeView.addSubview(stopImageView!)
    }
    
    func animationStart() {
        for view in cubeView.subviews {
            view.removeFromSuperview()
        }
        cubeView.addSubview(startImageView!)
    }
    
    @objc func handleTapGesture(recoginzer: UILongPressGestureRecognizer) {
        stop()
    }

    @objc func handleLongPressGesture(recoginzer: UILongPressGestureRecognizer) {
        reset()
    }

    func start() {
        if isPlaying {
            return
        }
        
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(UpdateTimer), userInfo: nil, repeats: true)
        
        isPlaying = true
    }
    
    func stop() {
        timer.invalidate()
        isPlaying = false
    }
    
    func reset() {
        timer.invalidate()
        isPlaying = false
        counter = 0.0
    }
    
    @objc func UpdateTimer() {
        counter = counter + 0.01
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        start()
    }
}
