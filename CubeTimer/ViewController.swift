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
        
        animationStop()
    }
    
    func animationStop() {
        let image = UIImage(named: "cube_stop")
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 0 , y: 0, width:
            256.0 , height: 192.0)
        
        cubeView.addSubview(imageView)
    }
    
    func animationStart() {
        //gif 이미지 처리
        if #available(iOS 9.0, *) {
            if let asset = NSDataAsset(name: "cube") {
                let data = asset.data
                _ = try? JSONSerialization.jsonObject(with: data, options: [])
                
                let gifImage = UIImage.gifImageWithData(data)
                let imageView = UIImageView(image: gifImage)
                imageView.frame = CGRect(x: 0 , y: 0, width:
                    256.0 , height: 192.0)
                
                cubeView.addSubview(imageView)
            }
        } else {
            // Fallback on earlier versions
        }
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
