//
//  HomeCollectionViewControllerVoice.swift
//  Flashcards
//
//  Created by Timothy Tran on 11/28/17.
//  Copyright © 2017 Timothy Tran. All rights reserved.
//

import UIKit
import Foundation
import Speech
import AVFoundation

extension HomeViewController {

    
    func voiceUIViewAppear() {
        voiceUIView?.isHidden = false
    }

    
    
    /*
     * this function starts/stops recording when the button is held down/released
     */
    @objc func record(gesture: UILongPressGestureRecognizer) {
        if (!(voiceUIView?.isHidden)!) {
            if (gesture.state == .began) {
                voiceButton?.alpha = 0.5
                startRecording()
            } else if (gesture.state == .ended){
                voiceButton?.alpha = 1.0
                stopRecording()
            }
        }
    }
    
    
    /*
     * this fuctions requests authorization and uses the getInput method
     * to start recording
     */
    func startRecording() {
        speechRecognizer.delegate = self
        SFSpeechRecognizer.requestAuthorization { authStatus in
            OperationQueue.main.addOperation {
                switch authStatus {
                case .authorized:
                    try! self.getInput()
                case .denied:
                    self.voiceButton?.isHidden = true
                case .restricted:
                    self.voiceButton?.isHidden = true
                case .notDetermined:
                    self.voiceButton?.isHidden = true
                }
            }
        }
    }
    
    
    /*
     * this function gets the best transcription for when the user
     * speaks into the device
     */
    func getInput() throws {
        if let recognitionTask = recognitionTask {
            recognitionTask.cancel()
            self.recognitionTask = nil
        }
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(AVAudioSessionCategoryRecord)
        try audioSession.setMode(AVAudioSessionModeMeasurement)
        try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        let inputNode = audioEngine.inputNode
        guard let recognitionRequest = recognitionRequest else { fatalError("Unable to created a SFSpeechAudioBufferRecognitionRequest object") }
        
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
            var isFinal = false;
            if let result = result {
                self.command = result.bestTranscription.formattedString
                self.voiceTextView?.text = self.command
                isFinal = result.isFinal
            }
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                self.recognitionRequest = nil
                self.recognitionTask = nil
            }
        }
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        try audioEngine.start()
    }
    
    /*
     * this function stops recording and will execute the command
     * using the voiceCommandHandler
     */
    func stopRecording() {
        audioEngine.inputNode.removeTap(onBus: 0)
        self.audioEngine.stop()
        self.recognitionRequest?.endAudio()
        self.recognitionTask?.finish()
        //voiceCommandHandler()
    }
    
    
    
}
