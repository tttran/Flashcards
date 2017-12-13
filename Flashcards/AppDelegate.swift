//
//  AppDelegate.swift
//  Flashcards
//
//  Created by Timothy Tran on 11/24/17.
//  Copyright © 2017 Timothy Tran. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    //dictionaries used for the majority of the application
    var dict_Flashcards: NSMutableDictionary = NSMutableDictionary()
    var dict_Images: NSMutableDictionary = NSMutableDictionary()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let paths2 = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)

        let documentDirectoryPath = paths[0] as String
        let documentDirectoryPath2 = paths2[0] as String

        let plistFilePathInDocumentDirectory = documentDirectoryPath + "/FlashcardsData.plist"
        let plistFilePathInDocumentDirectory2 = documentDirectoryPath2 + "/WordImages.plist"

        let dictionaryFromFile: NSMutableDictionary? = NSMutableDictionary(contentsOfFile: plistFilePathInDocumentDirectory)
        let dictionaryFromFile2: NSMutableDictionary? = NSMutableDictionary(contentsOfFile: plistFilePathInDocumentDirectory2)
 
        if let dictionaryFromFileInDocumentDirectory = dictionaryFromFile {
            dict_Flashcards = dictionaryFromFileInDocumentDirectory
        } else {
            // FlashcardsData.plist does not exist in the Document directory; Read it from the main bundle.
            // Obtain the file path to the plist file in the mainBundle (project folder)
            let plistFilePathInMainBundle = Bundle.main.path(forResource: "FlashcardsData", ofType: "plist")
            // Instantiate an NSMutableDictionary object and initialize it with the contents of the FlashcardsData.plist file.
            let dictionaryFromFileInMainBundle: NSMutableDictionary? = NSMutableDictionary(contentsOfFile: plistFilePathInMainBundle!)
            // Store the object reference into the instance variable
            dict_Flashcards = dictionaryFromFileInMainBundle!
        }
        
        
        //Repeat process for 2nd plist
        if let dictionaryFromFileInDocumentary2 = dictionaryFromFile2 {
            dict_Images = dictionaryFromFileInDocumentary2
        } else {
            let plistFilePathInMainBundle = Bundle.main.path(forResource: "WordImages", ofType: "plist")
            let dictionaryFromFileInMainBundle: NSMutableDictionary? = NSMutableDictionary(contentsOfFile: plistFilePathInMainBundle!)
            dict_Images = dictionaryFromFileInMainBundle!
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentDirectoryPath = paths[0] as String
        let plistFilePathInDocumentDirectory = documentDirectoryPath + "/FlashcardsData.plist"
        
        dict_Flashcards.write(toFile: plistFilePathInDocumentDirectory, atomically: true)
        
        let paths2 = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentDirectoryPath2 = paths2[0] as String
        
        // Add the plist filename to the document directory path to obtain an absolute path to the plist filename
        let plistFilePathInDocumentDirectory2 = documentDirectoryPath2 + "/WordImages.plist"
        dict_Images.write(toFile: plistFilePathInDocumentDirectory2, atomically: true)
    }
    

}

