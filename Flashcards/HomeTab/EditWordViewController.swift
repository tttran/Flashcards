//
//  EditWordViewController.swift
//  Flashcards
//
//  Created by Timothy Tran on 12/10/17.
//  Copyright © 2017 Timothy Tran. All rights reserved.
//

import UIKit

class EditWordViewController: UIViewController, UITextViewDelegate {
    //interface builder outlets
    @IBOutlet var defintionTextView: UITextView!
    @IBOutlet var partOfSpeechTextfield: UITextField!
    @IBOutlet var termTextField: UITextField!
    var editInfoPassed = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //populate the data
        termTextField.text = editInfoPassed[0]
        partOfSpeechTextfield.text = editInfoPassed[2]
        defintionTextView.text = editInfoPassed[1]
        self.navigationItem.title = "Edit \(editInfoPassed[0])"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // This method is invoked when the user taps the Done key on the keyboard
    @IBAction func keyboardDone(_ sender: UITextField) {
        // Once the text field is no longer the first responder, the keyboard is removed
        sender.resignFirstResponder()
    }
    
    @IBAction func userTappedBackground(sender: AnyObject) {
        /*
         "This method looks at the current view and its subview hierarchy for the text field that is
         currently the first responder. If it finds one, it asks that text field to resign as first responder.
         If the force parameter is set to true, the text field is never even asked; it is forced to resign." [Apple]
         */
        view.endEditing(true)
    }
    
    //dismiss keyboard when textview is done editing
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }

}
