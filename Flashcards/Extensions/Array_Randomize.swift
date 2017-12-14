//
//  Array_Randomize.swift
//  Flashcards
//
//  Created by Julian Nguyen on 12/14/17.
//  Copyright © 2017 Timothy Tran. All rights reserved.
//

import Foundation

extension Array {
    mutating func shuffle() {
        for i in 0 ..< (count - 1) {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            swapAt(i, j)
        }
    }
}
