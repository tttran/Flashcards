//
//  WordsTableViewController.swift
//  Flashcards
//
//  Created by Timothy Tran on 12/3/17.
//  Copyright © 2017 Timothy Tran. All rights reserved.
//

import UIKit

class WordsTableViewController: UITableViewController {


    @IBOutlet weak var wordsTableView: UITableView!
    var setPassed = ""
    var listOfWords = [String]()
    var words: NSDictionary = NSDictionary()
    var flashcards: NSDictionary = NSDictionary()
    var wordInfoToPass = [String]()

    
    var images: NSDictionary = NSDictionary()
    var words2: NSDictionary = NSDictionary()
    var listOfWords2 = [String]()

    let applicationDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        //self.navigationItem.leftBarButtonItem = self.editButtonItem

        let addButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(WordsTableViewController.addWord(_:)))
        //self.navigationItem.rightBarButtonItem = addButton
        self.navigationItem.rightBarButtonItems = [self.editButtonItem, addButton]
        
        
        
        flashcards = applicationDelegate.dict_Flashcards as NSDictionary
        words = (flashcards[setPassed] as! NSDictionary)
        listOfWords = words.allKeys as! [String]
        listOfWords.sort{ $0 < $1 }
        self.title = setPassed
        
        print(setPassed)
        
        images = applicationDelegate.dict_Images as NSMutableDictionary
        //print(images)
        //print(applicationDelegate.dict_Flashcards)
        words2 = images[setPassed] as! NSMutableDictionary
        listOfWords2 = words2.allKeys as! [String]
        listOfWords2.sort{ $0 < $1 }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return listOfWords.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WordCell", for: indexPath) as UITableViewCell
        
        let rowNumber = (indexPath as NSIndexPath).row
        cell.textLabel!.text = listOfWords[rowNumber]
        return cell
    }
 
    @objc func addWord(_ sender: AnyObject) {
        
        performSegue(withIdentifier: "AddWord", sender: self)
        
    }
    
    @IBAction func unwindToWordsTableViewController (segue : UIStoryboardSegue) {
        if segue.identifier == "AddWord-Save" {
            let addWordViewController: AddWordViewController = segue.source as! AddWordViewController
            //add code for words that don't work like misspelled words or no entry
            
            let appId = "4dabee4a"
            let appKey = "138e7213268de1f1f77485f34dea3371"
            let language = "en"
            let word = addWordViewController.newWordTextField.text
            let word_id = word?.lowercased()
            let url = URL(string: "https://od-api.oxforddictionaries.com:443/api/v1/entries/\(language)/\(word_id!)/definitions%3B%20lexicalCategory")
            var request = URLRequest(url: url!)
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue(appId, forHTTPHeaderField: "app_id")
            request.addValue(appKey, forHTTPHeaderField: "app_key")

            let session = URLSession.shared
            _ = session.dataTask(with: request, completionHandler: { data, response, error in
                if let _ = response,
                    let data = data,
                    let jsonData = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary {
                    let results = jsonData!["results"] as! NSArray
                    let lexicalEntries = results[0] as! NSDictionary
                    //print(lexicalEntries)

                    let entries = lexicalEntries["lexicalEntries"] as! NSArray
                    //print(entries[0])
                    let a = entries[0] as! NSDictionary
                    let b = a["entries"] as! NSArray
                    let c = b[0] as! NSDictionary
                    let d = c["senses"] as! NSArray
                    let e = d[0] as! NSDictionary
                    let f = e["definitions"] as! NSArray
                    let definition = f[0]
                    let partOfSpeech = a["lexicalCategory"] as! String

                    print(definition)
                    print(partOfSpeech)
                    
                    let newWordArray = [word!, definition as! String, partOfSpeech] as [String]
                    self.words.setValue(newWordArray, forKey: word!)
                    self.applicationDelegate.dict_Flashcards.setValue(self.words, forKey: self.setPassed)
                    self.flashcards = self.applicationDelegate.dict_Flashcards as NSDictionary
                    self.words = (self.flashcards[self.setPassed] as! NSDictionary)
                    self.listOfWords = self.words.allKeys as! [String]
                    self.listOfWords.sort{ $0 < $1 }
                    
                    DispatchQueue.main.async {
                        self.wordsTableView.reloadData()
                    }
                    let defaultImage = self.imageRotatedByDegrees(oldImage: #imageLiteral(resourceName: "AppIcon1024"), deg: -90)
                    let defaultData = UIImagePNGRepresentation(defaultImage) as NSData?
                    

                    self.words2.setValue(defaultData, forKey: word!)
                    self.applicationDelegate.dict_Images.setValue(self.words2, forKey: self.setPassed)
                    
                    
                    
                    
                } else {
                    self.showAlertMessage(messageHeader: "No results found!", messageBody: "Please try a different word.")
                }
            }).resume()

        } else if segue.identifier == "EditWord-Save" {
            print("made it")
            let editWordViewController: EditWordViewController = segue.source as! EditWordViewController

            let term = editWordViewController.termTextField.text
            let def = editWordViewController.defintionTextView.text
            let pos = editWordViewController.partOfSpeechTextfield.text
            
            if term == "" || def == "" || pos == "" {
                showAlertMessage(messageHeader: "Error!", messageBody: "Please fill out all fields!")
            } else {
                
                let wordToEdit = editWordViewController.editInfoPassed[0]
                var temp: NSMutableDictionary = words as! NSMutableDictionary
                temp.removeObject(forKey: wordToEdit)
                
                
                let newWordArray = [term, def, pos] as! [String]
                
                temp.setValue(newWordArray, forKey: editWordViewController.termTextField.text!)
                
                
                self.applicationDelegate.dict_Flashcards.setValue(temp, forKey: self.setPassed)
                self.flashcards = self.applicationDelegate.dict_Flashcards as NSDictionary
                self.words = (self.flashcards[self.setPassed] as! NSDictionary)
                self.listOfWords = self.words.allKeys as! [String]
                self.listOfWords.sort{ $0 < $1 }
                
                DispatchQueue.main.async {
                    self.wordsTableView.reloadData()
                }
                
                var temp2: NSMutableDictionary = words2 as! NSMutableDictionary
                var imageTemp = temp2[wordToEdit]
                temp2.removeObject(forKey: wordToEdit)
                temp2.setValue(imageTemp, forKey: term!)
                
                
                // self.words2.setValue(NSData.self, forKey: word!)
                self.applicationDelegate.dict_Images.setValue(temp2, forKey: self.setPassed)
                images = applicationDelegate.dict_Images as NSDictionary
                words2 = images[setPassed] as! NSDictionary
                listOfWords2 = words2.allKeys as! [String]
                listOfWords2.sort{ $0 < $1 }
            }
            
            
            
            
        }

    }
    
    // Informs the table view delegate that the specified row is selected.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let rowNumber = (indexPath as NSIndexPath).row
        let word = listOfWords[rowNumber]
        wordInfoToPass = words[word] as! [String]

        
        
        wordsTableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
        performSegue(withIdentifier: "ViewWord", sender: self)
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            
            // Delete the identified movie at row
            let val = (indexPath as NSIndexPath).row
            var temp: NSMutableDictionary = words as! NSMutableDictionary
            temp.removeObject(forKey: "\(listOfWords[val])")
            applicationDelegate.dict_Flashcards.setValue(temp, forKey: setPassed)
            
            
            var temp2: NSMutableDictionary = words2 as! NSMutableDictionary
            temp2.removeObject(forKey: "\(listOfWords[val])")
            applicationDelegate.dict_Images.setValue(temp2, forKey: setPassed)
            
            flashcards = applicationDelegate.dict_Flashcards as NSDictionary
            words = (flashcards[setPassed] as! NSDictionary)
            listOfWords = words.allKeys as! [String]
            listOfWords.sort{ $0 < $1 }
            
            
            wordsTableView.reloadData()
            
            
            
            
        }
        
        
        
        /*else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        } */
    }
 

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ViewWord" {
            let viewWordViewController: ViewWordViewController = segue.destination as! ViewWordViewController
            viewWordViewController.wordInfoPassed = wordInfoToPass
            viewWordViewController.set = setPassed
        }
    }
 
    
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

    func imageRotatedByDegrees(oldImage: UIImage, deg degrees: CGFloat) -> UIImage {
        //Calculate the size of the rotated view's containing box for our drawing space
        let rotatedViewBox: UIView = UIView(frame: CGRect(x: 0, y: 0, width: oldImage.size.width, height: oldImage.size.height))
        let t: CGAffineTransform = CGAffineTransform(rotationAngle: degrees * CGFloat.pi / 180)
        rotatedViewBox.transform = t
        let rotatedSize: CGSize = rotatedViewBox.frame.size
        //Create the bitmap context
        UIGraphicsBeginImageContext(rotatedSize)
        let bitmap: CGContext = UIGraphicsGetCurrentContext()!
        //Move the origin to the middle of the image so we will rotate and scale around the center.
        bitmap.translateBy(x: rotatedSize.width / 2, y: rotatedSize.height / 2)
        //Rotate the image context
        bitmap.rotate(by: (degrees * CGFloat.pi / 180))
        //Now, draw the rotated/scaled image into the context
        bitmap.scaleBy(x: 1.0, y: -1.0)
        bitmap.draw(oldImage.cgImage!, in: CGRect(x: -oldImage.size.width / 2, y: -oldImage.size.height / 2, width: oldImage.size.width, height: oldImage.size.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
}
