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
    var imageSet: NSDictionary = NSDictionary()
    var listOfWords: NSDictionary = NSDictionary()
    var imageData: NSData? = NSData()
    
    var set = ""    
    var imagePicker: UIImagePickerController!

    @IBOutlet var termLabel: UILabel!
    @IBOutlet var partOfSpeechLabel: UILabel!
    @IBOutlet var definitionTextView: UITextView!
    
    @IBOutlet var wordImageView: UIImageView!
    
    var wordInfoPassed = [Any]()
    
    
    override func viewDidLoad() {
        imageSet = applicationDelegate.dict_Images as NSDictionary
        listOfWords = imageSet[set] as! NSDictionary
        
       
        //let imageData2: NSData = UIImagePNGRepresentation(#imageLiteral(resourceName: "AppIcon60"))! as NSData


        
        super.viewDidLoad()
        termLabel.text = String(describing: wordInfoPassed[0])
        definitionTextView.text = String(describing: wordInfoPassed[1])
        partOfSpeechLabel.text = String(describing: wordInfoPassed[2])
        
        if (listOfWords[wordInfoPassed[0]] as? NSData == nil) {
            wordImageView.image = #imageLiteral(resourceName: "AppIcon60")
        } else {
            let imageData = listOfWords[wordInfoPassed[0]] as! NSData
            let imm = imageData as Data
            print(imm)
            if imm.count > 0 {
                let im: UIImage = UIImage(data:imm, scale: 1.0)!
                //let imageToDisplay = UIImage.init(cgImage: im as! CGImage, scale: im.scale, orientation: UIImageOrientation.down)
                let newImage = imageRotatedByDegrees(oldImage: im, deg: 90)
                wordImageView.image = newImage//ageToDisplay
                print(im.imageOrientation)
            }
        }
        
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
            
            self.wordImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage

            let saveImage = UIImagePNGRepresentation(image) as NSData?
            imageData = saveImage!
            listOfWords.setValue(imageData, forKey: termLabel.text!)
            
           // let modifiedWordArray = [termLabel.text, definitionTextView.text, partOfSpeechLabel.text, saveImage] as [Any]
            
            
            //self.words.setValue(modifiedWordArray, forKey: termLabel.text!)
            self.applicationDelegate.dict_Images.setValue(listOfWords, forKey: self.set)
            imageSet = applicationDelegate.dict_Images as NSDictionary
            listOfWords = imageSet[set] as! NSDictionary
            
            
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
