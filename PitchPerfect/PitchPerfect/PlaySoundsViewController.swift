//
//  PlaySoundsViewController.swift
//  PitchPerfect
//
//  Created by 남상욱 on 2017. 1. 11..
//  Copyright © 2017년 nam. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    
    @IBOutlet weak var snailButton: UIButton! // Slow sound
    @IBOutlet weak var chipmunkButton: UIButton! // High-pitched sound
    @IBOutlet weak var rabbitButton: UIButton! // Fast sound
    @IBOutlet weak var vaderButton: UIButton! // Low-pitched sound
    @IBOutlet weak var echoButton: UIButton! // Echo sound
    @IBOutlet weak var reverbButton: UIButton! // Reverb sound
    @IBOutlet weak var stopButton: UIButton!
    
    var recordedAudioURL: URL!
    var audioFile: AVAudioFile!
    var audioEngine: AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var stopTimer: Timer!
    
    
    enum ButtonType: Int {
        case slow = 0, fast, chipmunk, vader, echo, reverb
    }
    
    // MARK: IBAction functions for audio effects
    
    @IBAction func playSoundForButton(_ sender: UIButton){
        switch(ButtonType(rawValue: sender.tag)!){
        case .slow:
            playSound(rate: 0.5)
        case .fast:
            playSound(rate: 1.5)
        case .chipmunk:
            playSound(pitch: 1000)
        case .vader:
            playSound(pitch: -1000)
        case .echo:
            playSound(echo: true)
        case .reverb:
            playSound(reverb: true)
        }
        
        configureUI(.playing)
    }
    
    @IBAction func stopButtonPressed(_ sender: AnyObject){
        
        stopAudio()
    }
    
    // MARK: ViewController Lifecycle override method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAudio()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureUI(.notPlaying)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("viewDidDisappear in playSoundsView")
        let fileManager = FileManager.default
        do {
            try fileManager.removeItem(atPath: recordedAudioURL.absoluteString)
        } catch let error {
            print("Deleting Error : \(error)")
        }
    }
}
