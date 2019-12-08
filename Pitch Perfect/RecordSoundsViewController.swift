//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Aly Essam on 6/28/19.
//  Copyright © 2019 Aly Essam. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordLable: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    // MARK: Properties
    var audioRecorder: AVAudioRecorder!
    enum recordingState { case recording, stopRecording } // This enum to configure UI

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI(.stopRecording) //Cofigure UI : Enable Record, Disable Stop, Update recordLable
    }


    @IBAction func startRecording(_ sender: Any) {
        configureUI(.recording)    //Cofigure UI : Enable Stop, Disable Record, Update recordLable
    
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self

        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }
    @IBAction func stopRecording(_ sender: Any) {
        configureUI(.stopRecording) //Cofigure UI : Enable Record, Disable Stop, Update recordLable
        audioRecorder.stop()
        
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        }

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! playSoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
    // MARK: UI Functions
    
    func configureUI(_ recordState: recordingState) {
        switch(recordState) {
        case .recording:
            recordLable.text = "Recording in progress"
            recordButton.isEnabled = false
            stopButton.isEnabled = true
        case .stopRecording:
            recordLable.text = "Tap to Record"
            recordButton.isEnabled = true
            stopButton.isEnabled = false
        }
    }
}

