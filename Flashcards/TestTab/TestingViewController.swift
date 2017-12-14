//
//  TestingViewController.swift
//  Flashcards
//
//  Created by Julian Nguyen on 12/6/17.
//  Copyright © 2017 Timothy Tran. All rights reserved.
//

import UIKit

class TestingViewController: UIViewController {
    
    /*
     -----------------------------------
     MARK: - Variables
     -----------------------------------
     */
    
    // Variables passed in from TestModeViewController
    var setPassed:String = ""
    var selectedRow:Int = 0
    
    let applicationDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var flashcards: NSDictionary = NSDictionary()
    var termsDict: NSDictionary = NSDictionary()
    var termDict: NSDictionary = NSDictionary()
    var listOfWords = [String]()
        
    var words: NSDictionary = NSDictionary()
    var wordInfoToPass = [String]()
    
    var termsCorrect:Int = 0;
    var currentTermIndex:Int = 0;
    
    @IBOutlet var nextTermButton: UIButton!
    @IBOutlet var enterTermTextField: UITextField!
    @IBOutlet var progressBar: UIProgressView!
    @IBOutlet var termLabel: UILabel!
    
    /*
     -----------------------------------
     MARK: - viewDidLoad, didReceiveMemory Warning
     -----------------------------------
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        flashcards = applicationDelegate.dict_Flashcards as NSDictionary
        termsDict = (flashcards[setPassed] as! NSDictionary)
        listOfWords = termsDict.allKeys as! [String]
        listOfWords.sort{ $0 < $1 }
        listOfWords.shuffle()
        
        termLabel.text = listOfWords[0]
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.ultraLight)]
        
        self.navigationItem.title = String(termsCorrect) + "/" + String(listOfWords.count)
        
        nextTermButton.backgroundColor = UIColor(red: 98/255, green: 123/255, blue: 180/255, alpha: 1.0)
        
        enterTermTextField.becomeFirstResponder()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func nextButtonTapped(_ sender: UIButton) {
        
        if (currentTermIndex <= listOfWords.count - 1) {
            currentTermIndex += 1
        }
        
        let word = listOfWords[currentTermIndex]
        termLabel!.text = word
        wordInfoToPass = termsDict[word] as! [String]
        
        
        
        termsCorrect += 1
        let progress = Float(termsCorrect)/Float(listOfWords.count)
        progressBar.setProgress(progress, animated: true)
    }
}
