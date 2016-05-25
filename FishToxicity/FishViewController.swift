//
//  FishViewController.swift
//  FishToxcity
//
//  Created by Yaoyu Yang on 11/23/15.
//  Copyright © 2015 Yaoyu Yang. All rights reserved.
//

import UIKit
import GoogleMobileAds
import Localize_Swift

class FishViewController: UIViewController {
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var fishLabel: UILabel!
    @IBOutlet weak var eatingGuide: UILabel!
    @IBOutlet weak var ratingImage: UIImageView!
    @IBOutlet weak var concData: UILabel!

    
    /*
    This value is passed by `FishTableViewController` in `prepareForSegue(_:sender:)`
    */
    
    var fish: Fish?
    let singleAttribute1 = [ NSForegroundColorAttributeName: UIColor.greenColor() ]
    let singleAttribute2 = [ NSBackgroundColorAttributeName: UIColor.yellowColor() ]
    let singleAttribute3 = [ NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleDouble.rawValue ]
    
    let fishToxicGuide: [NSAttributedString] = [
        NSAttributedString(string: "LEAST MERCURY".localized(), attributes: [ NSForegroundColorAttributeName: UIColor(red: 88/255, green: 152/255, blue: 42/255, alpha: 1) ]),
        NSAttributedString(string: "MODERATE MERCURY".localized(), attributes: [ NSForegroundColorAttributeName: UIColor(red: 234/255, green: 203/255, blue: 0/255, alpha: 1) ]),
        NSAttributedString(string: "HIGH MERCURY".localized(), attributes: [ NSForegroundColorAttributeName: UIColor(red: 255/255, green: 171/255, blue: 28/255, alpha: 1) ]),
        NSAttributedString(string: "HIGHEST MERCURY".localized(), attributes: [ NSForegroundColorAttributeName: UIColor(red: 254/255, green: 72/255, blue: 25/255, alpha: 1) ])
    ]
    let eatingGuideText: [String] = ["Enjoy this fish.*".localized(), "Eat six servings or less per month.*".localized(), "Eat three servings or less per month!*".localized(), "Avoid eating!*".localized()]
    let ratingImageNames: [String] = ["least", "moderate", "high", "highest"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Set up views if editing an existing Meal.
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(FishViewController.handleSwipes(_:)))
        rightSwipe.direction = .Right
        view.addGestureRecognizer(rightSwipe)
        if let fish = fish {
            navigationItem.title = fish.name
            photoImageView.image = fish.photo
            fishLabel.attributedText = fishToxicGuide[fish.level]
            eatingGuide.text = eatingGuideText[fish.level]
            ratingImage.image = UIImage(named: ratingImageNames[fish.level])!
            concData.text = "Mercury concentration mean: ".localized() + fish.conc!.description + " PPM, according to FDA: Mercury Levels in Commercial Fish and Shellfish (1990-2010). ".localized()
        }
//        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
//        bannerView.rootViewController = self
//        bannerView.loadRequest(GADRequest())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Navigation
    @IBAction func back(sender: UIBarButtonItem) {
        navigationController!.popViewControllerAnimated(true)

    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
    
    func handleSwipes(sender:UISwipeGestureRecognizer) {
        if (sender.direction == .Right) {
            navigationController!.popViewControllerAnimated(true)
        }
    }


}

