//
//  FlashcardsCollectionViewCell.swift
//  Flashcards
//
//  Created by Timothy Tran on 11/24/17.
//  Copyright © 2017 Timothy Tran. All rights reserved.
//

import UIKit

class FlashcardsCollectionViewCell: UICollectionViewCell {

    @IBOutlet var title: UILabel!
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
 
  
    
}
