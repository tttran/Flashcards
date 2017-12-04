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
    

    let applicationDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        //self.navigationItem.leftBarButtonItem = self.editButtonItem

        flashcards = applicationDelegate.dict_Flashcards as NSDictionary
        words = (flashcards[setPassed] as! NSDictionary)
        listOfWords = words.allKeys as! [String]
        listOfWords.sort{ $0 < $1 }
        self.title = setPassed
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
 

    @IBAction func unwindToWordsTableViewController (segue : UIStoryboardSegue) {
        if segue.identifier == "AddWord-Save" {
            
        }
    }
    
    // Informs the table view delegate that the specified row is selected.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let rowNumber = (indexPath as NSIndexPath).row
        //print(words)
        let word = listOfWords[rowNumber]
        wordInfoToPass = words[word] as! [String]
        //let moviesOfGivenGenre = movies! as! NSDictionary
        //let movieInfo = moviesOfGivenGenre["\(rowNumber+1)"] as? NSArray
        
        
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

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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
        }
    }
 

}
