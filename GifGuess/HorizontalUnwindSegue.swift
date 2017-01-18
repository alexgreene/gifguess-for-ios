//
//  HorizontalUnwindSegue.swift
//  GifGuess
//
//  Created by Alex Greene on 12/27/16.
//  Copyright © 2016 AlexGreene. All rights reserved.
//

import UIKit

class HorizontalUnwindSegue: UIStoryboardSegue {
    
    override func perform() {
        // Assign the source and destination views to local variables.
        let firstVCView = self.destination.view as UIView!
        let secondVCView = self.source.view as UIView!
        
        // Get the screen width and height.
        let screenWidth = UIScreen.main.bounds.size.width
        //let screenHeight = UIScreen.main.bounds.size.height
        
        // Specify the initial position of the destination view.
        //secondVCView?.frame = CGRect(x: -screenWidth, y: 0.0, width: screenWidth, height: screenHeight)
        
        // Access the app's key window and insert the destination view above the current (source) one.
        let window = UIApplication.shared.keyWindow
        window?.insertSubview(firstVCView!, aboveSubview: secondVCView!)
        
        // Animate the transition.
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            firstVCView?.frame = (firstVCView?.frame.offsetBy(dx: screenWidth, dy: 0.0))!
            secondVCView?.frame = (secondVCView?.frame)!.offsetBy(dx: screenWidth, dy: 0.0)
            
        }) { (Finished) -> Void in
            self.source.dismiss(animated: false, completion: nil)
        }
        
    }

}
