//
//  WordBank.swift
//  GifGuess
//
//  Created by Alex Greene on 12/10/16.
//  Copyright © 2016 AlexGreene. All rights reserved.
//

import Foundation

class PuzzleBank {
    
    static let db = SQLiteDB.sharedInstance

    static let puzzleBank = PuzzleBank()

    static var sets = [PuzzleSet]()
    
    static var totalStars = 5
    
    static var badGuesses = 0
    
    static var currentSetId = -1
    
    static var currentPuzzleForHighlight:Puzzle!
    
    static func fetchSetsFromDB() {
        
        sets = [PuzzleSet]()
        
        let result = db.query(sql: "SELECT * FROM PuzzleSets;")
        
        var setId = 0
        var name = ""
        var description = ""
        var locked = true
        var cost = 0
        
        for puzzleSet in result {
            if (puzzleSet["id"] != nil) {
                setId = puzzleSet["id"] as! Int
            }
            if (puzzleSet["name"] != nil) {
                name = puzzleSet["name"] as! String
            }
            if (puzzleSet["description"] != nil) {
                description = puzzleSet["description"] as! String
            }
            if (puzzleSet["locked"] != nil) {
                locked = Bool(puzzleSet["locked"] as! NSNumber)
            }
            if (puzzleSet["cost"] != nil) {
                cost = puzzleSet["cost"] as! Int
            }
            
            sets.append(
                PuzzleSet(id: setId, name: name, description: description, locked: Bool(locked), cost: cost)
            )
            
        }
        
        sortPuzzleSets()
    }
    
    static func sortPuzzleSets() {
        PuzzleBank.sets = PuzzleBank.sets.sorted { t1, t2 in
            if t1.locked == t2.locked {
                return t1.cost < t2.cost
            }
            return !t1.locked && t2.locked
        }
    }
    
    static func getPuzzle(setId: Int) -> Puzzle {
    
        let puzzle = db.query(sql: "SELECT * FROM Puzzles WHERE set_id=" + String(setId) + " AND solved=0 ORDER BY RANDOM() LIMIT 1;")[0]
        
        var puzzleId = 0
        var phrase = ""
        var slices = ""
        var highlight = 0
        
        if (puzzle["id"] != nil) {
            puzzleId = puzzle["id"] as! Int
        }
        if (puzzle["phrase"] != nil) {
            phrase = puzzle["phrase"] as! String
        }
        if (puzzle["slices"] != nil) {
            slices = puzzle["slices"] as! String
        }
        if (puzzle["highlight"] != nil) {
            highlight = puzzle["highlight"] as! Int
        }
        
        return Puzzle(id: puzzleId, phrase: phrase, slices: slices, highlight: highlight)
    }
    
    static func getHighlights() -> [Puzzle] {
        let puzzles = db.query(sql: "SELECT * FROM Puzzles WHERE highlight=1;")
        var result = [Puzzle]()
        
        for puzzle in puzzles {
            
            var puzzleId = 0
            var phrase = ""
            var slices = ""
            var highlight = 0
            
            if (puzzle["id"] != nil) {
                puzzleId = puzzle["id"] as! Int
            }
            if (puzzle["phrase"] != nil) {
                phrase = puzzle["phrase"] as! String
            }
            if (puzzle["slices"] != nil) {
                slices = puzzle["slices"] as! String
            }
            if (puzzle["highlight"] != nil) {
                highlight = puzzle["highlight"] as! Int
            }
            
            result.append( Puzzle(id: puzzleId, phrase: phrase, slices: slices, highlight: highlight) )
        }
        return result
    }
    
    static func highlightUpdate(puzzleId: Int, isHighlight:Int) {
        let query = "UPDATE Puzzles SET solved=" + String(isHighlight) + " WHERE id='" + String(puzzleId) + "'"
        db.execute(sql: query)

    }
}

extension String {
    public func indexOfCharacter(char: Character) -> Int? {
        if let idx = characters.index(of: char) {
            return characters.distance(from: startIndex, to: idx)
        }
        return nil
    }
}
