//
//  ViewWordViewController.swift
//  Flashcards
//
//  Created by Timothy Tran on 12/3/17.
//  Copyright © 2017 Timothy Tran. All rights reserved.
//

import UIKit

class ViewWordViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    let applicationDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    //var imageSet: NSDictionary = NSDictionary()
    
    var set = ""
    var listOfWords = [String]()
    var words: NSDictionary = NSDictionary()
    var flashcards: NSDictionary = NSDictionary()

    
    var imagePicker: UIImagePickerController!

    @IBOutlet var termLabel: UILabel!
    @IBOutlet var partOfSpeechLabel: UILabel!
    @IBOutlet var definitionTextView: UITextView!
    
    @IBOutlet var wordImageView: UIImageView!
    
    var wordInfoPassed = [Any]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        termLabel.text = String(describing: wordInfoPassed[0])
        definitionTextView.text = String(describing: wordInfoPassed[1])
        partOfSpeechLabel.text = String(describing: wordInfoPassed[2])
        //wordImageView.image = wordInfoPassed[3] as! UIImage
        
        
        flashcards = applicationDelegate.dict_Flashcards as NSDictionary
        words = (flashcards[set] as! NSDictionary)
        print(words)
        //listOfWords = words.allKeys as! [String]
        //listOfWords.sort{ $0 < $1 }
        
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func takePicture(_ sender: Any) {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        
        present(imagePicker, animated: true, completion: nil)
    }
    

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info:[String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            DispatchQueue.main.async {
                self.wordImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
                
            
                
            
            
            
            }
            
            let saveImage = UIImagePNGRepresentation(image) as NSData?
            
           // let modifiedWordArray = [termLabel.text, definitionTextView.text, partOfSpeechLabel.text, saveImage] as [Any]
            
            
            //self.words.setValue(modifiedWordArray, forKey: termLabel.text!)
            //self.applicationDelegate.dict_Flashcards.setValue(self.words, forKey: self.set)

            
            
        } else {
            print("error")
        }
        
        imagePicker.dismiss(animated: true, completion: nil)


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
