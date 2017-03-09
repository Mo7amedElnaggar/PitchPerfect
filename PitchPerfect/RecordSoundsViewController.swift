//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Mohamed El-Naggar on 3/9/17.
//  Copyright © 2017 Mohamed El-Naggar. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController , AVAudioRecorderDelegate {
    
    @IBOutlet weak var tapToRecord: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    
    // initial status to RecordButton , stopRecordButton and tapToRecord
    // when app is Start
    func initial(){
        tapToRecord.text = "Tap To Record"
        recordButton.isEnabled = true // initially recordButton must be 'ENABLED'
        stopRecordButton.isEnabled = false // must be false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // When our View Controller Appears 
        // you should call 'initial' function for Starting our Application
        initial()
    }
    @IBAction func recordAudio(_ sender: Any) {
        // should change 'recordButton' status from isEnabled --> false
        recordButton.isEnabled = false
        // should change 'stopRecordButton' --> true
        stopRecordButton.isEnabled = true
        // change the text of 'tapToRecord' Label
        tapToRecord.text = "stop"
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory , .userDomainMask, true)[0] as String
        let recordName = "recordedAudio.wav"
        let pathArray = [dirPath , recordName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopRecordAudio(_ sender: Any) {
        // should change 'recordButton' status from isEnabled --> true
        recordButton.isEnabled = true
        // should change 'stopRecordButton' --> false
        stopRecordButton.isEnabled = false
        // change the text of 'tapToRecord' Label
        tapToRecord.text = "Tap To Record"
        // stop Recording
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            // Alert Message That There is Exist Error in Recording Audio
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
    
}

