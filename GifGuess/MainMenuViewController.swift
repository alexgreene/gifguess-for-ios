//
//  MainMenuViewController.swift
//  GifGuess
//
//  Created by Alex Greene on 12/10/16.
//  Copyright © 2016 AlexGreene. All rights reserved.
//

import UIKit
import GoogleMobileAds

class MainMenuViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bannerView: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let title:NSString = "GifGuess"
        var mutableTitle = NSMutableAttributedString()
        mutableTitle = NSMutableAttributedString(string: title as
            String, attributes: [NSFontAttributeName:UIFont(name: "Avenir-Black", size: 40.0)!])
        
        mutableTitle.addAttribute(NSForegroundColorAttributeName, value: UIColor(
            red: 179/255.0,
            green: 254/255.0,
            blue: 239/255.0,
            alpha: 1.0), range: NSRange(location:0,length:3))
        
        titleLabel.attributedText = mutableTitle
        
        bannerView.adUnitID = "ca-app-pub-0461995597454379/6278562707"
        bannerView.rootViewController = self
        let request = GADRequest()
        request.testDevices = [ kGADSimulatorID ]
        bannerView.load(request)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    @IBAction func unwindToMainMenu(segue: UIStoryboardSegue) {
    }


}

