//
//  HighlightCell.swift
//  GifGuess
//
//  Created by Alex Greene on 1/4/17.
//  Copyright © 2017 AlexGreene. All rights reserved.
//

import UIKit

class HighlightCell: UITableViewCell {
    
    @IBOutlet weak var phraseLabel: UILabel!
    
    func configure(phrase: String) {
        self.phraseLabel.text = phrase
    }
}
