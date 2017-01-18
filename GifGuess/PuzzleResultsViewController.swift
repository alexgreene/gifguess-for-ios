//
//  PuzzleResultsViewController.swift
//  GifGuess
//
//  Created by Alex Greene on 12/29/16.
//  Copyright © 2016 AlexGreene. All rights reserved.
//

import UIKit

class PuzzleResultsViewController: UIViewController {
    
    @IBOutlet weak var continueButton: UIButton!
    
    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var puzzleRewardLabel: UILabel!
    @IBOutlet weak var bonusLabel: UILabel!
    @IBOutlet weak var bonusExplanationLabel: UILabel!
    @IBOutlet weak var netRewardLabel: UILabel!
    @IBOutlet weak var totalStarsLabel: UILabel!
    
    
    var badGuesses:Int = 0
    var puzzleReward:Int = 3
    var bonus:Int = 0
    
    override func viewDidLoad() {
        
        badGuesses = PuzzleBank.badGuesses
        
        greetingLabel.text = "Good Job!"
        puzzleRewardLabel.text = "⭐️ " + String(puzzleReward) + " Reward"
        bonus = badGuesses > 2 ? -1: (badGuesses == 0 ? 1 : 0)
        bonusLabel.text = badGuesses > 2 ? "- ⭐️ 1 Penalty": (badGuesses == 0 ? "+ 🌟 1 Perfection Bonus" : " + No Bonus")
        bonusExplanationLabel.text = "You made " + String(badGuesses) + " incorrect guesses"
        netRewardLabel.text = "⭐️ " + String(bonus + puzzleReward)
        
        PuzzleBank.totalStars += (bonus + puzzleReward)
        totalStarsLabel.text = "⭐️ " + String(PuzzleBank.totalStars) + " Total"
        
        PuzzleBank.badGuesses = 0
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
}
