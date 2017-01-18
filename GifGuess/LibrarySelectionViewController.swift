//
//  LibrarySelectionViewController.swift
//  GifGuess
//
//  Created by Alex Greene on 12/10/16.
//  Copyright © 2016 AlexGreene. All rights reserved.
//

import UIKit
import GoogleMobileAds

class LibrarySelectionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var selectedSet:PuzzleSet!
    
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var setTableView: UITableView!
    
    @IBOutlet weak var totalStarsLabel: UILabel!
    
    override func viewDidLoad() {
        updateStarsLabel()
        PuzzleBank.currentSetId = -1
        
        bannerView.adUnitID = "ca-app-pub-0461995597454379/3185495501"
        bannerView.rootViewController = self
        let request = GADRequest()
        request.testDevices = [ kGADSimulatorID ]
        bannerView.load(request)
    }
    
    func updateStarsLabel() {
        totalStarsLabel.text = "⭐️ " + String(PuzzleBank.totalStars) + " to spend"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PuzzleBank.sets.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let setForRow:PuzzleSet = PuzzleBank.sets[indexPath.row]
        return setForRow.locked == true ? 90 : 110
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PuzzleSetCell") as! PuzzleSetCell
        
        let setForRow:PuzzleSet = PuzzleBank.sets[indexPath.row]
        cell.configure(title: setForRow.name, short: setForRow.description, cost: setForRow.cost, progress: setForRow.getProgress(), isLocked: setForRow.locked)
        
        cell.layer.backgroundColor = indexPath.row % 2 == 0 ?
            UIColor(red: 214/255, green: 214/255, blue: 214/255, alpha: 1.0).cgColor :
            UIColor(red: 205/255, green: 205/255, blue: 205/255, alpha: 1.0).cgColor
        
        return cell
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.layer.transform = CATransform3DMakeScale(0.3,0.3,1)
        UIView.animate(withDuration: 0.25, animations: {
            cell.layer.transform = CATransform3DMakeScale(1,1,1)
        })
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow!
        
        selectedSet = PuzzleBank.sets[indexPath.row]
        
        if (selectedSet.locked == true) {
            if (selectedSet.cost > PuzzleBank.totalStars) {
                let insufficientFundsAlert = UIAlertController(title: "Sorry", message: "You're lacking the funds, my friend", preferredStyle: UIAlertControllerStyle.alert)
                insufficientFundsAlert.addAction(UIAlertAction(title: "Alright", style: .default, handler: { (action: UIAlertAction!) in
                    let indexPath = self.setTableView.indexPathForSelectedRow!
                    self.setTableView.deselectRow(at: indexPath, animated: true)
                }))
                
                present(insufficientFundsAlert, animated: true, completion: nil)
            }
            else {
                let confirmPurchaseAlert = UIAlertController(title: "Purchase this puzzle set?", message: "It will cost you ⭐️ " + String(selectedSet.cost), preferredStyle: UIAlertControllerStyle.alert)
            
                confirmPurchaseAlert.addAction(UIAlertAction(title: "Purchase", style: .cancel, handler: { (action: UIAlertAction!) in
                    let query = "UPDATE PuzzleSets SET locked=0 WHERE id='" + String(self.selectedSet.id) + "'"
                    PuzzleBank.db.execute(sql: query)
                    PuzzleBank.fetchSetsFromDB()
                    
                    PuzzleBank.totalStars -= self.selectedSet.cost
                    tableView.reloadData()
                    self.updateStarsLabel()
                }))
                confirmPurchaseAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action: UIAlertAction!) in
                    let indexPath = self.setTableView.indexPathForSelectedRow!
                    self.setTableView.deselectRow(at: indexPath, animated: true)

                }))
            
                present(confirmPurchaseAlert, animated: true, completion: nil)
            }
        }
        else {
            PuzzleBank.currentSetId = selectedSet.id
            performSegue(withIdentifier: "setWasSelectedSegue", sender: self)
        }
    }
    
    @IBAction func unwindToPuzzleSets(segue: UIStoryboardSegue) {
        let indexPath = setTableView.indexPathForSelectedRow!
        setTableView.deselectRow(at: indexPath, animated: true)
        self.updateStarsLabel()
    }
    
}
