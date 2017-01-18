//
//  GateCloseOutsideSegue.swift
//  GifGuess
//
//  Created by Alex Greene on 12/29/16.
//  Copyright © 2016 AlexGreene. All rights reserved.
//

import UIKit

class ZoomSegue: UIStoryboardSegue {

    override func perform() {
        let firstVC = self.source.view
        let secondVC = self.destination.view
        
        // Add view to window
        let window = UIApplication.shared.keyWindow
        window?.insertSubview(secondVC!, belowSubview: firstVC!)
        
        // Scale down the destination view
        secondVC?.transform = (secondVC?.transform)!.scaledBy(x: 0.001, y: 0.001)
        
        // Animate the transition
        UIView.animate(withDuration: 0.5, animations: {
            // animate the source view to scale down
            secondVC?.transform = (secondVC?.transform)!.scaledBy(x: 0.001, y: 0.001)
            
        }) { (finished) in
            // We animate again to scale the destination view up
            UIView.animate(withDuration: 0.5, animations: {
                // Scale up the destination view
                secondVC?.transform = CGAffineTransform.identity
            }, completion: { (finished) in
                firstVC?.transform = CGAffineTransform.identity
                self.source.present(self.destination, animated: false, completion: nil)
            })
        }
        
        
    }
}
