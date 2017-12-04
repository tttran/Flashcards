//
//  ViewWordViewController.swift
//  Flashcards
//
//  Created by Timothy Tran on 12/3/17.
//  Copyright © 2017 Timothy Tran. All rights reserved.
//

import UIKit

class ViewWordViewController: UIViewController {

    @IBOutlet var termLabel: UILabel!
    @IBOutlet var partOfSpeechLabel: UILabel!
    @IBOutlet var definitionTextView: UITextView!
    
    var wordInfoPassed = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        termLabel.text = wordInfoPassed[0]
        definitionTextView.text = wordInfoPassed[1]
        partOfSpeechLabel.text = wordInfoPassed[2]

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
