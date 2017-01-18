//
//  Wordset.swift
//  GifGuess
//
//  Created by Alex Greene on 12/10/16.
//  Copyright © 2016 AlexGreene. All rights reserved.
//

class PuzzleSet {
    
    var id:Int = 0
    
    var name:String = ""
    
    var description:String = ""
    
    var locked:Bool = false
    
    var cost:Int = 0
        
    init(id:Int, name:String, description:String, locked:Bool, cost:Int) {
        self.id = id
        self.name = name
        self.description = description
        self.locked = locked
        self.cost = cost
    }
    
    func getProgress() -> Float {
        
        if let solved = PuzzleBank.db.query(sql: "SELECT SUM(solved) FROM Puzzles WHERE set_id=" + String(id))[0]["SUM(solved)"] as! Int?{
            if let total = PuzzleBank.db.query(sql: "SELECT COUNT(solved) FROM Puzzles WHERE set_id=" + String(id))[0]["COUNT(solved)"] as! Int?{
                return Float(solved)/Float(total)
            }
        }
        return 0.0
    }
    
    
}
