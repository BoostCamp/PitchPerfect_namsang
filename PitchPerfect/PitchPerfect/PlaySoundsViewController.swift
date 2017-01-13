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
    @IBOutlet weak var remainTimeLabel: UILabel! // duration, 남은 재생 시간
    @IBOutlet weak var stopButton: UIButton!
    
    var recordedAudioURL: URL!
    var audioFile: AVAudioFile!
    var audioEngine: AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var stopTimer: Timer!
    var remainTimer: Timer! // 남은 시간 타이머
    var audioPlayer: AVAudioPlayer! // 남은 시간을 위함
    var recordedFilePlayTime: Int!
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

        // playback
        configureUI(.playing)
        
        do {
            //recordedAudioURL의 컨텐츠를 가지는 AVAudioPlayer 생성
          audioPlayer = try AVAudioPlayer(contentsOf: recordedAudioURL as URL)
        } catch let error {
            showAlert(Alerts.AudioPlayerError, message: String(describing: error))
        }
        self.recordedFilePlayTime = Int(audioPlayer.duration) //recordedAudioURL로 duration을 구함.
        
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
            showAlert("FileManager", message: String(describing: error))
        }
    }
    
    // MARK: general functions
    
    func calRemainTime(){
        if recordedFilePlayTime < 1 {
            // 재생시간이 0으로 갈 때, Timer를 invalidate 시킴.
            self.remainTimer.invalidate()
        } else {
            let hour: String = String(format: "%02d", self.recordedFilePlayTime / 3600)
            let minute: String = String(format: "%02d", self.recordedFilePlayTime % 3600 / 60)
            let second: String = String(format: "%02d", self.recordedFilePlayTime % 60)
            
            //AVAudioPlayer.duration으로 얻은 녹음 파일 플레이 시간을 시, 분, 초로 계산해서 Label에 표시
            self.remainTimeLabel.text = "\(hour):\(minute):\(second)"
            self.recordedFilePlayTime = self.recordedFilePlayTime - 1 // 1씩 값을 감소하여
        }
    }
}
