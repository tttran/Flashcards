//
//  ViewWordViewController.swift
//  Flashcards
//
//  Created by Timothy Tran on 12/3/17.
//  Copyright © 2017 Timothy Tran. All rights reserved.
//

import UIKit

class ViewWordViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    //data from the plist
    let applicationDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var imageSet: NSDictionary = NSDictionary()
    var listOfWords: NSDictionary = NSDictionary()
    var imageData: NSData? = NSData()
    
    var set = ""    
    var imagePicker: UIImagePickerController!

    //outlets from the interface builder
    @IBOutlet var termLabel: UILabel!
    @IBOutlet var partOfSpeechLabel: UILabel!
    @IBOutlet var definitionTextView: UITextView!
    @IBOutlet var wordImageView: UIImageView!
    @IBOutlet var takePictureButton: UIButton!
    //info needed to populate data
    var wordInfoPassed = [Any]()
    var editInfoToPass = [String]()
    
    override func viewDidLoad() {
        imageSet = applicationDelegate.dict_Images as NSDictionary
        listOfWords = imageSet[set] as! NSDictionary
        
        let editButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(ViewWordViewController.editWord(_:)))
        self.navigationItem.rightBarButtonItem = editButton

        //set up the text and the images
        super.viewDidLoad()
        termLabel.text = String(describing: wordInfoPassed[0])
        definitionTextView.text = String(describing: wordInfoPassed[1])
        definitionTextView.layer.borderWidth = 1
        definitionTextView.layer.borderColor = UIColor.white.cgColor
        definitionTextView.layer.cornerRadius = 0.03 * (definitionTextView.bounds.size.width)

        partOfSpeechLabel.text = String(describing: wordInfoPassed[2])
        if (listOfWords[wordInfoPassed[0]] as? NSData == nil) {
            wordImageView.image = #imageLiteral(resourceName: "AppIcon60")
        } else {
            let imageData = listOfWords[wordInfoPassed[0]] as! NSData
            let imm = imageData as Data
            print(imm)
            if imm.count > 0 {
                let im: UIImage = UIImage(data:imm, scale: 1.0)!
                let newImage = imageRotatedByDegrees(oldImage: im, deg: 90)
                wordImageView.image = newImage
                print(im.imageOrientation)
            }
        }
        self.navigationItem.title = wordInfoPassed[0] as? String
        takePictureButton.layer.cornerRadius = 0.1 * (takePictureButton.bounds.size.width)
        takePictureButton.layer.borderWidth = 1
        takePictureButton.layer.borderColor = UIColor.white.cgColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //present the camera to take a picture
    @IBAction func takePicture(_ sender: Any) {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    //set the imageview to the picture taken and save the iamge to the plist
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info:[String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.wordImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
            let saveImage = UIImagePNGRepresentation(image) as NSData?
            imageData = saveImage!
            listOfWords.setValue(imageData, forKey: termLabel.text!)
            self.applicationDelegate.dict_Images.setValue(listOfWords, forKey: self.set)
            imageSet = applicationDelegate.dict_Images as NSDictionary
            listOfWords = imageSet[set] as! NSDictionary
  
        } else {
            print("error")
        }
        imagePicker.dismiss(animated: true, completion: nil)

    }
    
    //edit word segue
    @objc func editWord(_ sender: AnyObject) {
        performSegue(withIdentifier: "EditWord", sender: self)
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "EditWord" {
            let editWordViewController: EditWordViewController = segue.destination as! EditWordViewController
            editInfoToPass = [wordInfoPassed[0] as! String, wordInfoPassed[1] as! String, wordInfoPassed[2] as! String]
            editWordViewController.editInfoPassed = editInfoToPass
            
        }
    }
 
    //rotating image function
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
