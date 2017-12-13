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

    //let voice view appear
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
                self.audioEngine.inputNode.removeTap(onBus: 0)
                self.audioEngine.inputNode.reset()
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
                    if self.authorized == true {
                        try! self.getInput()
                    }
                    self.authorized = true
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
                self.audioEngine.inputNode.removeTap(onBus: 0)
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
        self.audioEngine.inputNode.removeTap(onBus: 0)
        self.audioEngine.inputNode.reset()
        self.audioEngine.stop()
        self.recognitionRequest?.endAudio()
        self.recognitionTask?.finish()
        voiceCommandHandler()
        
    }
    
    /*
     * exits the voiceUI
     */
    @objc func cancelVoice() {
        command = ""
        self.voiceTextView?.text = command
        self.voiceUIView?.isHidden = true
        self.voiceCancelTransparentView?.isHidden = true
    }
    
    /*
     * run function is called everytime the voice button is clicked (touchDown)
     * this will make the voice UI components appear
     */
    @objc func run() {
        voiceCancelTransparentView!.isHidden = false
        voiceUIView?.isHidden = false
        voiceTextView?.isHidden = false
        command = ""
        self.voiceTextView?.text = ""
    }

    /*
     * this is the list of possible trigger words for adding sets
     */
    enum AddSet: String {
        case Add = "Add"
        case Create = "Create"
        case Make = "Make"
        static let triggerWords = [Add, Create, Make]
    }
    
    /*
     * this is the list of possible trigger words for deleting sets
     */
    enum DeleteSet: String {
        case Delete = "Delete"
        case Remove = "Remove"
        static let triggerWords = [Delete, Remove]
    }
    
    /*
     * the voice commandHandler will find the trigger word and
     * execute the proper actions according to the command
     */
    func voiceCommandHandler() {
        var match = false
        if (command != "") {
            self.commandWord = command.components(separatedBy: " ").first!
            
            for trigger in AddSet.triggerWords {
                if trigger.rawValue == commandWord {
                    match = true
                    voiceCommandExecutor(input: "AddSet")
                    break
                }
            }
            
            if match == false {
                for trigger in DeleteSet.triggerWords {
                    if trigger.rawValue == commandWord {
                        match = true
                        voiceCommandExecutor(input: "DeleteSet")
                        break
                    }
                }
            }

            if match == false {
                showAlertMessage(messageHeader: "Error!", messageBody: "Please try again with a valid command!")
            }
        }
    }
    /*
     * the voice command executor will execute the command
     * based off of the trigger word
     * @param input is the enum from the voice command handler
     */
    func voiceCommandExecutor(input: String) {
        //find length of first word and add a whitespace
        if command.components(separatedBy: " ").count > 1 {
            let offset = commandWord.characters.count + 1
            let index = command.index(command.startIndex, offsetBy: offset)
            //target is the text that follows the triggerword
            var target: String = command.substring(from: index)
            switch input {
            case "AddSet":
                print("add")
                print(target)
                let setName = target.capitalized
                if self.applicationDelegate.dict_Flashcards[setName] != nil {
                    showAlertMessage(messageHeader: "Error!", messageBody: "The name already exists! Please enter a different one.")
                } else {
                    self.applicationDelegate.dict_Flashcards.setValue([:] as NSMutableDictionary, forKey: setName)
                    flashcards = applicationDelegate.dict_Flashcards.allKeys as! [String]
                    flashcards.sort{ $0 < $1 }
                    self.FlashcardsCollectionView.reloadData()
                    self.applicationDelegate.dict_Images.setValue([:] as NSMutableDictionary, forKey: setName)
                }
            //deleting set
            case "DeleteSet":
                print("delete")
                for dict in applicationDelegate.dict_Flashcards {
                    if target == (dict.key as! String).lowercased() {
                        target = dict.key as! String
                    }
                }
                self.applicationDelegate.dict_Flashcards.removeObject(forKey: target)
                flashcards = applicationDelegate.dict_Flashcards.allKeys as! [String]
                flashcards.sort{ $0 < $1 }
                self.FlashcardsCollectionView.reloadData()
                self.applicationDelegate.dict_Images.removeObject(forKey: target)
            default:
                showAlertMessage(messageHeader: "Error!", messageBody: "Please try again.")
            }
        } else {
            showAlertMessage(messageHeader: "Error!", messageBody: "Please try again.")
        }
    }
}
