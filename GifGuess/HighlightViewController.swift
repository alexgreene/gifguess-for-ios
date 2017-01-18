//
//  HighlightViewController.swift
//  GifGuess
//
//  Created by Alex Greene on 1/4/17.
//  Copyright © 2017 AlexGreene. All rights reserved.
//

import Foundation
import UIKit

class HighlightViewController: UIViewController {
    
    var puzzle:Puzzle!
    
    @IBOutlet weak var phraseLabel: UILabel!
    
    override func viewDidLoad() {
        puzzle = PuzzleBank.currentPuzzleForHighlight
        phraseLabel.text = puzzle.phrase
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    @IBAction func shareButtonPressed(_ sender: Any) {
        
    }
}
