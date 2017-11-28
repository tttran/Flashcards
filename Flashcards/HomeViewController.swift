//
//  HomeCollectionViewController.swift
//  Flashcards
//
//  Created by Timothy Tran on 11/24/17.
//  Copyright © 2017 Timothy Tran. All rights reserved.
//

import UIKit
import Speech

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, SFSpeechRecognizerDelegate {

    //variables for voice control
    let screenSize: CGRect = UIScreen.main.bounds
    @IBOutlet weak var voiceButton = UIButton()
    var speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!
    var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask: SFSpeechRecognitionTask?
    var audioEngine = AVAudioEngine()
    var transcription = SFTranscription()
    var command = ""
   
    @IBOutlet weak var voiceUIView = UIView()
    @IBOutlet weak var voiceCancelTransparentView = UIView()
    @IBOutlet weak var voiceTextView = UITextView()

    
    
    let applicationDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet var FlashcardsCollectionView: UICollectionView!
    
    var flashcards = [String]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        FlashcardsCollectionView.delegate = self
        flashcards = applicationDelegate.dict_Flashcards.allKeys as! [String]
        flashcards.sort{ $0 < $1 }
        voiceUIView?.isHidden = false
        voiceCancelTransparentView?.isHidden = true
        
        //voice button modifications
        voiceButton?.backgroundColor = UIColor.black
        voiceButton?.layer.cornerRadius = 0.5 * (voiceButton?.bounds.size.width)!
        let rec = UILongPressGestureRecognizer(target: self, action: #selector(record))
        rec.minimumPressDuration = 0.2
        voiceButton?.addGestureRecognizer(rec)
        
        self.view.addSubview(voiceButton!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        //return flashcards.count
        return 20
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
       // let cellNumber = (indexPath as NSIndexPath).row

        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cardCell", for: indexPath) as! FlashcardsCollectionViewCell
        //cell.title.text = flashcards[cellNumber]
        // Configure the cell
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
