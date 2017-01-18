//
//  ZoomUnwindSegue.swift
//  GifGuess
//
//  Created by Alex Greene on 12/29/16.
//  Copyright © 2016 AlexGreene. All rights reserved.
//

import UIKit

class ZoomUnwindSegue: UIStoryboardSegue {

    override func perform() {
        let firstVC = self.source.view
        let secondVC = self.destination.view
        
        // Add view to window
        let window = UIApplication.shared.keyWindow
        window?.insertSubview(secondVC!, at: 0)
        
        UIView.animate(withDuration: 0.5, animations: {
            firstVC?.transform = CGAffineTransform(scaleX: 25.0, y: 25.0)
            firstVC?.alpha = 0.0
        }) { (Finished) in
            secondVC?.removeFromSuperview()
            self.source.dismiss(animated: false, completion: nil)

        }
    }

}
