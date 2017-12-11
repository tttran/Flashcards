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
    var commandWord = ""
    var authorized = false
    @IBOutlet weak var voiceUIView = UIView()
    @IBOutlet weak var voiceCancelTransparentView = UIView()
    @IBOutlet weak var voiceTextView = UITextView()

    var editButton: UIBarButtonItem = UIBarButtonItem()
    
    let applicationDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet var FlashcardsCollectionView: UICollectionView!
    
    var flashcards = [String]()
    var setToPass = ""
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        FlashcardsCollectionView.delegate = self
        flashcards = applicationDelegate.dict_Flashcards.allKeys as! [String]
        flashcards.sort{ $0 < $1 }
        voiceUIView?.isHidden = true
        voiceCancelTransparentView?.isHidden = true
        voiceCancelTransparentView?.backgroundColor = UIColor.clear
        let cancel = UITapGestureRecognizer(target: self, action: #selector(cancelVoice))
        voiceCancelTransparentView?.addGestureRecognizer(cancel)
        
        
        //voice button modifications
        voiceButton?.layer.cornerRadius = 0.5 * (voiceButton?.bounds.size.width)!
        
        let rec = UILongPressGestureRecognizer(target: self, action: #selector(record))
        rec.minimumPressDuration = 0.2
        voiceButton?.addGestureRecognizer(rec)
        voiceButton?.addTarget(self, action: #selector(run), for: [.touchDown])

        //voiceButton?.isHidden = true
        editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(HomeViewController.editSet(_:)))
        let addButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(HomeViewController.addSet(_:)))
        self.navigationItem.rightBarButtonItem = addButton
        self.navigationItem.leftBarButtonItem = editButton
        
        
        
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
        return flashcards.count
        //return 20
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellNumber = (indexPath as NSIndexPath).row

        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cardCell", for: indexPath) as! FlashcardsCollectionViewCell
        cell.title.text = flashcards[cellNumber]
        // Configure the cell
    
        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cellNumber = (indexPath as NSIndexPath).row
        setToPass = flashcards[cellNumber]
        performSegue(withIdentifier: "ShowWords", sender: self)
    }
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "ShowWords" {
            let wordTableViewController: WordsTableViewController = segue.destination as! WordsTableViewController
            wordTableViewController.setPassed = setToPass
        }
    }
    
    @objc func editSet(_ sender: AnyObject) {
        performSegue(withIdentifier: "EditSet", sender: self)
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.leftBarButtonItem = editButton
    }
    
    @objc func addSet(_ sender: AnyObject) {
        
        performSegue(withIdentifier: "AddSet", sender: self)
        
    }
    
    @IBAction func unwindToHomeViewController (segue : UIStoryboardSegue) {
        

        if segue.identifier == "AddSet-Save" {
            let addSetViewController: AddSetViewController = segue.source as! AddSetViewController
            let setName = addSetViewController.addSetTextField.text
            if setName == "" {
                showAlertMessage(messageHeader: "Error!", messageBody: "Please enter a valid name.")
            } else if self.applicationDelegate.dict_Flashcards[setName] != nil {
                showAlertMessage(messageHeader: "Error!", messageBody: "The name already exists! Please enter a different one.")
            } else {
                self.applicationDelegate.dict_Flashcards.setValue([:] as NSMutableDictionary, forKey: setName!)
                flashcards = applicationDelegate.dict_Flashcards.allKeys as! [String]
                flashcards.sort{ $0 < $1 }
                //DispatchQueue.main.async {
                self.FlashcardsCollectionView.reloadData()
                //}
                
                self.applicationDelegate.dict_Images.setValue([:] as NSMutableDictionary, forKey: setName!)
            }
            
            
            
            
            //self.flashcards = self.applicationDelegate.dict_Flashcards as NSDictionary
            //self.words = (self.flashcards[self.setPassed] as! NSDictionary)
            //self.listOfWords = self.words.allKeys as! [String]
            //self.listOfWords.sort{ $0 < $1 }
            
            
        } else if segue.identifier == "RenameSet-Save" {
            let renameSetViewController: RenameSetViewController = segue.source as! RenameSetViewController
            let previousSetName = renameSetViewController.setToRename
            
            
            let newName = renameSetViewController.newNameTextField.text
            
            if newName == "" {
                showAlertMessage(messageHeader: "Error!", messageBody: "Please fill out all required fields.")
            } else if self.applicationDelegate.dict_Flashcards[newName] != nil {
                showAlertMessage(messageHeader: "Error!", messageBody: "The name already exists! Please enter a different one.")
            } else {
                let a = applicationDelegate.dict_Flashcards as NSDictionary
                let b = (a[previousSetName] as! NSDictionary)
                self.applicationDelegate.dict_Flashcards.removeObject(forKey: previousSetName)
                self.applicationDelegate.dict_Flashcards.setValue(b, forKey: newName!)
                
                flashcards = applicationDelegate.dict_Flashcards.allKeys as! [String]
                flashcards.sort{ $0 < $1 }
                self.FlashcardsCollectionView.reloadData()
                
                
                let c = applicationDelegate.dict_Images as NSDictionary
                let d = (c[previousSetName] as! NSDictionary)
                self.applicationDelegate.dict_Images.removeObject(forKey: previousSetName)
                self.applicationDelegate.dict_Images.setValue(d, forKey: newName!)
            }
            
            

        
        } else if segue.identifier == "DeleteSet" {
            let editSetViewController: EditSetViewController = segue.source as! EditSetViewController
            let setToDelete = flashcards[editSetViewController.setPickerView.selectedRow(inComponent: 0)]
            print(setToDelete)
            self.applicationDelegate.dict_Flashcards.removeObject(forKey: setToDelete)
            flashcards = applicationDelegate.dict_Flashcards.allKeys as! [String]
            flashcards.sort{ $0 < $1 }
            self.FlashcardsCollectionView.reloadData()
            
            
            self.applicationDelegate.dict_Images.removeObject(forKey: setToDelete)
            
        }
        
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
    
    func showAlertMessage(messageHeader header: String, messageBody body: String) {
        
        /*
         Create a UIAlertController object; dress it up with title, message, and preferred style;
         and store its object reference into local constant alertController
         */
        let alertController = UIAlertController(title: header, message: body, preferredStyle: UIAlertControllerStyle.alert)
        
        // Create a UIAlertAction object and add it to the alert controller
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        // Present the alert controller
        present(alertController, animated: true, completion: nil)
    }

}
