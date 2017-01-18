//
//  GameplayViewController.swift
//  GifGuess
//
//  Created by Alex Greene on 12/10/16.
//  Copyright © 2016 AlexGreene. All rights reserved.
//

import UIKit
import GoogleMobileAds

class GameplayViewController: UIViewController {
    
    @IBOutlet weak var lettersAndBlanks: UILabel!
    
    var guessed = [String]()
    
    var badGuesses = 0
    
    var wordCompleted = false
    
    var puzzle:Puzzle!

    @IBOutlet weak var totalStars: UILabel!
    
    @IBOutlet var keys: [UIButton]!
    
    @IBOutlet weak var bannerView: GADBannerView!
    
    struct Constants
    {
        static let adColonyAppID = "appddde8836c8224b4289"
        static let adColonyZoneID = "vzddb62d18a23348a196"
    }
    var ad: AdColonyInterstitial?

    
    override func viewDidLoad() {
        puzzle = PuzzleBank.getPuzzle(setId: PuzzleBank.currentSetId)
        
        lettersAndBlanks.text = formatLettersAndBlanks()
        totalStars.text = "⭐️ " + String(PuzzleBank.totalStars)
        
        bannerView.adUnitID = "ca-app-pub-0461995597454379/7196892701"
        bannerView.rootViewController = self
        let request = GADRequest()
        request.testDevices = [ kGADSimulatorID ]
        bannerView.load(request)

        //Configure AdColony once
        AdColony.configure(withAppID: Constants.adColonyAppID, zoneIDs: [Constants.adColonyZoneID], options: nil,
                           completion:{(zones) in
                            
            self.requestInterstitial()
                            
            //If the application has been inactive for a while, our ad might have expired so let's add a check for a nil ad object
            NotificationCenter.default.addObserver(self, selector:#selector(GameplayViewController.onBecameActive), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if PuzzleBank.totalStars <= 0 {
            getSomeMoreStars()
        }
    }
    
    @IBAction func keyPress(_ sender: UIButton) {
        
        if (wordCompleted) { return }
        
        let letter = (sender.titleLabel?.text)!.lowercased()
        
        guessed.append(letter)
        lettersAndBlanks.text = formatLettersAndBlanks()
        
        if !puzzle.phrase.contains(letter) {
            sender.setTitleColor(UIColor.red, for: UIControlState.normal)
            badGuesses += 1
            PuzzleBank.totalStars -= 1
            totalStars.text = "⭐️ " + String(PuzzleBank.totalStars)
            if PuzzleBank.totalStars == 0 {
                getSomeMoreStars()
            }
        }
        else {
            sender.setTitleColor(sender.backgroundColor, for: UIControlState.normal)
        }
        
        sender.alpha = 0.6
        sender.isEnabled = false
        sender.backgroundColor = UIColor.clear

        if wordCompleted {
            PuzzleBank.badGuesses = badGuesses
            
            let query = "UPDATE Puzzles SET solved=1 WHERE id='" + String(puzzle.id) + "'"
            PuzzleBank.db.execute(sql: query)
            
            PuzzleBank.highlightUpdate(puzzleId: puzzle.id, isHighlight: 1)
            
            performSegue(withIdentifier: "PuzzleResultsSegue", sender: self)
        }
    }
    
    func formatLettersAndBlanks() -> String {
        var str: String = ""
        wordCompleted = true

        for char in puzzle.phrase.characters {
            if char == " " {
                str += "   "
            }
            else if guessed.contains(String(char)) {
                str.append(" " + String(char) + " ")
            }
            else {
                str.append(" _ ")
                wordCompleted = false
            }
        }
        
        return str
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        if (wordCompleted) { return }

        let confirmExitAlert = UIAlertController(title: "Play a different puzzle set?", message: "Your progress on this specific puzzle will be erased.", preferredStyle: UIAlertControllerStyle.alert)
        
        confirmExitAlert.addAction(UIAlertAction(title: "No, stay", style: .cancel, handler: { (action: UIAlertAction!) in
        }))
        confirmExitAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            self.performSegue(withIdentifier: "unwindToPuzzleSets", sender: self)
        }))
        
        present(confirmExitAlert, animated: true, completion: nil)
    }
    
    
    @IBAction func unwindToGameplay(segue: UIStoryboardSegue) {
        resetGameplay()
    }
    
    func resetGameplay() {
        badGuesses = 0
        guessed = [String]()
        wordCompleted = false
        
        puzzle = PuzzleBank.getPuzzle(setId: PuzzleBank.currentSetId)
        
        for key in keys {
            key.alpha = 1.0
            key.backgroundColor = UIColor(colorLiteralRed: 179/255, green: 254/255, blue: 239/255, alpha: 1.0)
            key.setTitleColor(self.view.backgroundColor, for: UIControlState.normal)
            key.isEnabled = true
        }
        lettersAndBlanks.text = formatLettersAndBlanks()
        totalStars.text = "⭐️ " + String(PuzzleBank.totalStars)

    }
    
    func getSomeMoreStars() {
        let moreStarsAlert = UIAlertController(title: "You've run out of ⭐️", message: "You can't play without stars, but if you watch a short ad we'll resupply you with ⭐️ 5.", preferredStyle: UIAlertControllerStyle.alert)
        
        moreStarsAlert.addAction(UIAlertAction(title: "Watch Ad", style: .cancel, handler: { (action: UIAlertAction!) in
            self.launchInterstitial()
            PuzzleBank.totalStars = 5
            self.totalStars.text = "⭐️ " + String(PuzzleBank.totalStars)
        }))
        moreStarsAlert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action: UIAlertAction!) in
            self.performSegue(withIdentifier: "unwindToPuzzleSets", sender: self)
        }))
        
        present(moreStarsAlert, animated: true, completion: nil)
    }
    
    
    @IBAction func skipPressed(_ sender: Any) {
        let skipConfirmAlert = UIAlertController(title: "Skip this puzzle?", message: "You'll see it again sometime.", preferredStyle: UIAlertControllerStyle.alert)
        
        skipConfirmAlert.addAction(UIAlertAction(title: "Skip", style: .cancel, handler: { (action: UIAlertAction!) in
            self.launchInterstitial()
            self.resetGameplay()
        }))
        skipConfirmAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action: UIAlertAction!) in
        }))
        
        present(skipConfirmAlert, animated: true, completion: nil)
    }

    // // // // // // //
    // AD COLONY
    // // // // // // //
    
    func requestInterstitial() {
        //Request an interstitial ad from AdColony
        AdColony.requestInterstitial(inZone: Constants.adColonyZoneID, options:nil,
                                     
                                     //Handler for successful ad requests
            success:{(newAd) in
                
                //Once the ad has finished, set the loading state and request a new interstitial
                newAd.setClose({
                    self.ad = nil
                    self.requestInterstitial()
                })
                
                //Interstitials can expire, so we need to handle that event also
                newAd.setExpire({
                    self.ad = nil
                    self.requestInterstitial()
                })
                
                //Store a reference to the returned interstitial object
                self.ad = newAd
              },
            
            //Handler for failed ad requests
            failure:{(error) in
                NSLog("SAMPLE_APP: Request failed with error: " + error.localizedDescription + " and suggestion: " + error.localizedRecoverySuggestion!)
        }
        )
    }
    
    func launchInterstitial() {
        //Display our ad to the user
        if let ad = self.ad {
            if (!ad.expired) {
                ad.show(withPresenting: self)
            }
        }
    }
    
    func onBecameActive() {
        //If our ad has expired, request a new interstitial
        if (self.ad == nil) {
            self.requestInterstitial()
        }
    }
    
}
