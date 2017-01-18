//
//  HighlightsListViewController.swift
//  GifGuess
//
//  Created by Alex Greene on 1/4/17.
//  Copyright © 2017 AlexGreene. All rights reserved.
//

import Foundation
import UIKit

class HighlightsListViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var highlights = [Puzzle]()
    @IBOutlet weak var highlightsTableView: UITableView!
    var selectedHighlight: Puzzle!
    
    override func viewDidLoad() {
        highlights = PuzzleBank.getHighlights()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return highlights.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.layer.transform = CATransform3DMakeScale(1.5,1.5,1)
        UIView.animate(withDuration: 0.25, animations: {
            cell.layer.transform = CATransform3DMakeScale(1,1,1)
        })
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HighlightCell") as! HighlightCell
        
        cell.configure(phrase: highlights[indexPath.row].phrase)
        
        cell.layer.backgroundColor = indexPath.row % 2 == 0 ?
            UIColor(red: 214/255, green: 214/255, blue: 214/255, alpha: 1.0).cgColor :
            UIColor(red: 205/255, green: 205/255, blue: 205/255, alpha: 1.0).cgColor
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow!
        
        PuzzleBank.currentPuzzleForHighlight = highlights[indexPath.row]
        performSegue(withIdentifier: "highlightWasSelectedSegue", sender: self)
    }
    
    @IBAction func unwindToHighlightsList(segue: UIStoryboardSegue) {
        highlights = PuzzleBank.getHighlights()
        highlightsTableView.reloadData()
        
        // let indexPath = highlightsTableView.indexPathForSelectedRow!
        // highlightsTableView.deselectRow(at: indexPath, animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
}
