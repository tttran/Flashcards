//
//  EditSetViewController.swift
//  Flashcards
//
//  Created by Timothy Tran on 12/6/17.
//  Copyright © 2017 Timothy Tran. All rights reserved.
//

import UIKit

class EditSetViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet var setPickerView: UIPickerView!
    let applicationDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var nameOfSet = ""
    
    
    @IBAction func renameSet(_ sender: Any) {
        nameOfSet = setPickerData[setPickerView.selectedRow(inComponent: 0)]
        performSegue(withIdentifier: "RenameSet", sender: self)
    }
    
    var setPickerData = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setPickerData = applicationDelegate.dict_Flashcards.allKeys as! [String]
        setPickerData.sort { $0 < $1 }
        
        
        
        setPickerView.selectRow(Int(setPickerData.count / 2), inComponent: 0, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return setPickerData.count
    }
    
    // Specifies title for a row in the Picker View component
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return setPickerData[row]
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "RenameSet" {
            let renameSetViewController: RenameSetViewController = segue.destination as! RenameSetViewController
            renameSetViewController.setToRename = nameOfSet
        }
    }
 

}
