//
//  Puzzle.swift
//  GifGuess
//
//  Created by Alex Greene on 12/11/16.
//  Copyright © 2016 AlexGreene. All rights reserved.
//

class Puzzle {
    
    var id:Int = 0
    var phrase:String = ""
    var slices = [String]()
    var highlight:Int = 0
    
    
    init(id:Int, phrase:String, slices:String, highlight:Int) {
        self.id = id
        self.phrase = phrase
        self.slices = [slices]
        self.highlight = highlight
    }
}
