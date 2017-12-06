//
//  TestModeViewController.swift
//  Flashcards
//
//  Created by Julian Nguyen on 12/6/17.
//  Copyright © 2017 Timothy Tran. All rights reserved.
//

import UIKit

class TestModeViewController: UIViewController, PickerViewDataSource, PickerViewDelegate {
    
    /*
     -----------------------------------
     MARK: - UI Elements
     -----------------------------------
     */
    
    @IBOutlet var setPicker: PickerView!
    @IBOutlet var navigationTitle: UINavigationItem!
    @IBOutlet var startTestButton: UIButton!
    
    /*
     -----------------------------------
     MARK: - Variables
     -----------------------------------
     */
    
    let applicationDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var flashcards = [String]()
    var setToPass:String = ""
    var selectedRow:Int = 0
    
    
    /*
     -----------------------------------
     MARK: - viewDidLoad, didReceiveMemory Warning
     -----------------------------------
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        setPicker.dataSource = self
        setPicker.delegate = self
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.semibold)]
        
        startTestButton.backgroundColor = UIColor(red: 98/255, green: 123/255, blue: 180/255, alpha: 1.0)
        
        flashcards = applicationDelegate.dict_Flashcards.allKeys as! [String]
        flashcards.sort{ $0 < $1 }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        setPicker.reloadPickerView()
    }
    
    /*
     -----------------------------------
     MARK: - PickerViewDataSource Implementation
     -----------------------------------
     */
    
    func pickerViewNumberOfRows(_ pickerView: PickerView) -> Int {
        
        return flashcards.count
    }
    
    func pickerView(_ pickerView: PickerView, titleForRow row: Int, index: Int) -> String {
        let flashCardSet = flashcards[index]
        return flashCardSet
    }
    
    /*
     -----------------------------------
     MARK: - PickerViewDelegate Implementation
     -----------------------------------
     */
    
    func pickerViewHeightForRows(_ pickerView: PickerView) -> CGFloat {
        return 40.0
    }
    
    func pickerView(_ pickerView: PickerView, didSelectRow row: Int) {
        let selectedSet = flashcards[row]
        setToPass = selectedSet
    }
    
    func pickerView(_ pickerView: PickerView, didTapRow row: Int, index: Int) {
        selectedRow = row
    }
    
    func pickerView(_ pickerView: PickerView, styleForLabel label: UILabel, highlighted: Bool) {
        label.textAlignment = .center
        
        if highlighted {
            label.font = UIFont.systemFont(ofSize: 25.0, weight: UIFont.Weight.semibold)
            label.textColor = view.tintColor
        } else {
            label.font = UIFont.systemFont(ofSize: 15.0, weight: UIFont.Weight.light)
            label.textColor = UIColor.lightGray
        }
    }
    
}
