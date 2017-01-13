//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by 남상욱 on 2017. 1. 10..
//  Copyright © 2017년 nam. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    var audioRecorder: AVAudioRecorder!
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var resumeRecordingButton: UIButton!
    @IBOutlet weak var pauseRecordingButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    let STORYBOARD_SEGUE_IDENTIFIER_OF_STOP_RECORDING = "stopRecording"
    
    // 0: 초기셋팅(최초시작, 중지), 1: 녹음중, 2: 중지된, 3: 재개된
    enum RecordingState: Int {
        case initSetting = 0, recording, paused, resumed
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 최초 앱을 실행시키면 재시작, 일시정지, 중지 버튼을 숨김
        changeUIState(RecordingState.initSetting)
    }

    // MARK: ViewController Lifecycle override method
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    
    // MARK: IBAction functions for recording state

    
    @IBAction func recordAudio(_ sender: Any) {
        // 녹음 시작 버튼을 누르면 UI를 변경해 줍니다.
        changeUIState(RecordingState.recording)
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        
        let nowDate: String = getCurrentDate()
        let recordingName = "recordedVoice_" + nowDate + ".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
       
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        // 녹음을 마치면 UI 셋팅을 초기화 해줍니다.
        changeUIState(RecordingState.initSetting)
        audioRecorder.stop()
        
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    @IBAction func resumeRecording(_ sender: Any) {
        // 녹음을 재개하면 UI를 변경해 줍니다.
        changeUIState(RecordingState.resumed)
        // 녹음 재개
        audioRecorder.record()
    }
    
    @IBAction func pauseRecording(_ sender: Any) {
        // 녹음을 일시정지하면 UI를 변경해 줍니다.
        changeUIState(RecordingState.paused)
        // 녹음 일시정지
        audioRecorder.pause()
    }
    
    // MARK: audioRecorderDidFinishRecording of AVAudioRecorderDelegate
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: STORYBOARD_SEGUE_IDENTIFIER_OF_STOP_RECORDING, sender: audioRecorder.url)
        } else {
            print("recording was not successful")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == STORYBOARD_SEGUE_IDENTIFIER_OF_STOP_RECORDING {
            let playSoundsViewController = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsViewController.recordedAudioURL = recordedAudioURL
            
        }
    }
    
    // MARK: general function
    
    func getCurrentDate() -> String {
        let dateTime = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "YY-MM-DD_HH.mm.ss"
        let currentDate = formatter.string(from: dateTime)
        
        return currentDate
    }
    
    
    // 0: 초기셋팅(최초시작, 중지), 1: 녹음중, 2: 중지된, 3: 재개된
    func changeUIState(_ recordingState: RecordingState) {
        switch(recordingState) {
        case .initSetting: // 앱을 최초 실행 했을 때, 녹음을 끝마칠 때 셋팅
            recordingLabel.text = "Tap to Record"
            recordButton.isEnabled = true
            resumeRecordingButton.isHidden = true
            pauseRecordingButton.isHidden = true
            stopRecordingButton.isHidden = true
        case .recording: // 녹음 시작 버튼을 눌렀을 때
            recordingLabel.text = "Recording in Progress"
            recordButton.isEnabled = false
            resumeRecordingButton.isHidden = true
            pauseRecordingButton.isHidden = false
            stopRecordingButton.isHidden = false
        case .paused: // 녹음 일시정지 버튼을 눌렀을 때
            recordingLabel.text = "Recording has been paused"
            pauseRecordingButton.isHidden = true
            resumeRecordingButton.isHidden = false
        case .resumed: // 녹음 재개 버튼을 눌렀을 때
            recordingLabel.text = "Recording in Progress"
            pauseRecordingButton.isHidden = false
            resumeRecordingButton.isHidden = true
        }
    }
    
}

