//
//  ViewController.swift
//  EggTimer
//
//  Created by Angela Yu on 08/07/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//
//  Enhanced by Ryan ginnow on 04/17/2022
//  Enhancements: Colored progress bar, stop timer button, and added alarm

import UIKit
import Foundation
import AVFoundation

class ViewController: UIViewController {
   
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var stopButton: UIButton!
    
    // Switch the eggTimes array for testing shorter times
    // let eggTimes = ["Soft": 5, "Medium": 7, "Hard": 12]
    let eggTimes = ["Soft": 300, "Medium": 420, "Hard": 720]
    
    var player: AVAudioPlayer!
    var timer = Timer()
    var totalTime = 0
    var secondsPassed = 0
    
    @IBAction func hardnessSelected(_ sender: UIButton) {
        let hardness = sender.currentTitle!
        
        timer.invalidate()
        totalTime = eggTimes[hardness]!
        stopButton.isHidden = false
        progressBar.isHidden = false
        
        titleLabel.text = "Timing \(hardness) eggs..."
        progressBar.progress = 0.0
        secondsPassed = 0
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [self] timer in
            secondsPassed += 1
            
            let percentProgressed = Float(secondsPassed) / Float(totalTime)
            progressBar.progress = percentProgressed
            
            // Change color of progress bar based on the percentage
            if(percentProgressed == 1.0) {
                progressBar.progressTintColor = UIColor.systemGreen
            } else if(percentProgressed < 1.0 && percentProgressed > 0.50) {
                progressBar.progressTintColor = UIColor.systemYellow
            } else {
                progressBar.progressTintColor = UIColor.systemRed
            }
            
            if(secondsPassed == totalTime) {
                timer.invalidate()
                titleLabel.text = "Done!"
                stopButton.isHidden = true
                playAlarm()
            }
        }
        
    }
    
    @IBAction func stopTimer(_ sender: UIButton) {
        timer.invalidate()
        totalTime = 0
        secondsPassed = 0
        progressBar.progress = 0.0
        progressBar.isHidden = true
        
        titleLabel.text = "How do you like your eggs?"
        stopButton.isHidden = true
    }
    
    func playAlarm() {
        let url = Bundle.main.url(forResource: "alarm_sound", withExtension: "mp3")
        player = try! AVAudioPlayer(contentsOf: url!)
        player.play()
    }
    
}
