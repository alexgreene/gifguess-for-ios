//
//  WordsetCell.swift
//  GifGuess
//
//  Created by Alex Greene on 12/10/16.
//  Copyright © 2016 AlexGreene. All rights reserved.
//

import UIKit

class PuzzleSetCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var short: UILabel!
    @IBOutlet weak var locked: UILabel!
    @IBOutlet weak var progressBar: UIView!
    @IBOutlet weak var progressBarBackground: UIView!
    
    func configure(title: String, short: String, cost: Int, progress: Float, isLocked: Bool) {
        self.title.text = title
        self.short.text = short

        if (!isLocked) {
            self.locked.text = ""
            progressBar.isHidden = false
            progressBarBackground.isHidden = false
        }
        else {
            let cost_formatted = cost == 0 ? "" : "⭐️ " + String(cost) + " to unlock"
            self.locked.text = cost_formatted
            progressBar.isHidden = true
            progressBarBackground.isHidden = true
        }
        
        let width:Float = Float(progressBarBackground.frame.width)
        var newWidth:Float = 0.0
        if width != 0.0 {
             newWidth = progress * width
        }
        
        progressBar.removeConstraints(progressBar.constraints)
        
        let widthConstraint = NSLayoutConstraint(item: progressBar, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1.0, constant: CGFloat(newWidth))
        progressBar.addConstraints([widthConstraint])
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.white
        self.selectedBackgroundView = bgColorView
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        let color = progressBar.backgroundColor
        let colorBG = progressBarBackground.backgroundColor
        super.setSelected(selected, animated: animated)
        
        if(selected) {
            progressBar.backgroundColor = color
            progressBarBackground.backgroundColor = colorBG
        }
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        let color = progressBar.backgroundColor
        let colorBG = progressBarBackground.backgroundColor
        super.setHighlighted(highlighted, animated: animated)
        
        if(highlighted) {
            progressBar.backgroundColor = color
            progressBarBackground.backgroundColor = colorBG
            
        }
    }
}
