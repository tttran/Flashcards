//
//  TestingViewController.swift
//  Flashcards
//
//  Created by Julian Nguyen on 12/6/17.
//  Copyright © 2017 Timothy Tran. All rights reserved.
//

import UIKit

class TestingViewController: UIViewController, UITextFieldDelegate {
    
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
    
    var termsCorrect:Int = 0
    var currentTermIndex:Int = 0
    var guessIsCorrect = false
    
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
        nextTermButton.isUserInteractionEnabled = false
        
        enterTermTextField.becomeFirstResponder()
        self.enterTermTextField.delegate = self
    }
    
    // Methods to check if Text Field is empty and appropriately disable/enable Next Term Button
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (enterTermTextField!.text != "") {
            nextTermButton.isUserInteractionEnabled = true
            nextTermButton.backgroundColor = UIColor(red: 98.0/255.0, green: 123.0/255.0, blue: 180.0/255.0, alpha: 1.0)
        }
        else {
            nextTermButton.isUserInteractionEnabled = false
            nextTermButton.backgroundColor = UIColor(red: 196.0/255.0, green: 206.0/255.0, blue: 227.0/255.0, alpha: 1.0)
        }
    }
    
    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        if (enterTermTextField!.text != "") {
            nextTermButton.isUserInteractionEnabled = true
            nextTermButton.backgroundColor = UIColor(red: 98.0/255.0, green: 123.0/255.0, blue: 180.0/255.0, alpha: 1.0)
        }
        else {
            nextTermButton.isUserInteractionEnabled = false
            nextTermButton.backgroundColor = UIColor(red: 196.0/255.0, green: 206.0/255.0, blue: 227.0/255.0, alpha: 1.0)
        }
    }
    
    // This method is called when the user taps Return on the keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        nextTermButton.sendActions(for: .touchUpInside)
        
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func nextButtonTapped(_ sender: UIButton) {
        
        // 1. Get the information of the first word from the randomized set.
        let word = listOfWords[currentTermIndex]
        termLabel!.text = word
        wordInfoToPass = termsDict[word] as! [String]
        
        // 2. Determine the similarity between user input and definition. >= 40% is considered a correct answer.
        let userGuess = enterTermTextField!.text
        let levDistance = levenshtein(aStr: wordInfoToPass[1].lowercased(), bStr: userGuess!.lowercased())
        var levPercent = 0.00
        if (wordInfoToPass[1].count >= (userGuess?.count)!) {
            levPercent = Double(levDistance) / Double(wordInfoToPass[1].count)
        } else if ((userGuess?.count)! > wordInfoToPass[1].count) {
            levPercent = Double(levDistance) / Double((userGuess?.count)!)
        }
        if (levPercent >= 0.40) {
            guessIsCorrect = true
        } else {
            guessIsCorrect = false
        }

        
        if (currentTermIndex <= listOfWords.count - 1) {
            currentTermIndex += 1
        }
        
        
        
        termsCorrect += 1
        let progress = Float(termsCorrect)/Float(listOfWords.count)
        progressBar.setProgress(progress, animated: true)
    }
    
    
    // Min: 0, Max: Length of the longer string
    func levenshtein(aStr: String, bStr: String) -> Int {
        let a = Array(aStr.utf8)
        let b = Array(bStr.utf8)
        
        let dist = Array2D(cols: a.count + 1, rows: b.count + 1)
        
        for i in 1...a.count {
            dist[i, 0] = i
        }
        
        for j in 1...b.count {
            dist[0, j] = j
        }
        
        for i in 1...a.count {
            for j in 1...b.count {
                if a[i-1] == b[j-1] {
                    dist[i, j] = dist[i-1, j-1]  // noop
                } else {
                    dist[i, j] = Swift.min(
                        dist[i-1, j] + 1,  // deletion
                        dist[i, j-1] + 1,  // insertion
                        dist[i-1, j-1] + 1  // substitution
                    )
                }
            }
        }
        return dist[a.count, b.count]
    }
    
    /*
     * 2d array used for the levenshtein algorithm
     */
    
    class Array2D {
        var cols:Int, rows:Int
        var matrix: [Int]
        
        init(cols:Int, rows:Int) {
            self.cols = cols
            self.rows = rows
            matrix = Array(repeating:0, count:cols*rows)
        }
        
        subscript(col:Int, row:Int) -> Int {
            get {
                return matrix[cols * row + col]
            }
            set {
                matrix[cols*row+col] = newValue
            }
        }
        
        func colCount() -> Int {
            return self.cols
        }
        
        func rowCount() -> Int {
            return self.rows
        }
    }
}
