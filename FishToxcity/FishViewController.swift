//
//  FishViewController.swift
//  FishToxcity
//
//  Created by Yaoyu Yang on 11/23/15.
//  Copyright © 2015 Yaoyu Yang. All rights reserved.
//

import UIKit

class FishViewController: UIViewController {
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var fishLabel: UILabel!
    @IBOutlet weak var eatingGuide: UILabel!
    @IBOutlet weak var ratingImage: UIImageView!
    
    /*
    This value is passed by `FishTableViewController` in `prepareForSegue(_:sender:)`
    */
    var fish: Fish?
    let fishToxicGuide: [String] = ["LEAST MERCURY", "MODERATE MERCURY", "HIGH MERCURY", "HIGHEST MERCURY"]
    let eatingGuideText: [String] = ["Enjoy this fish", "Eat six servings or less per month", "Eat three servings or less per month", "Avoid eating"]
    let ratingImageNames: [String] = ["least", "moderate", "high", "highest"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Set up views if editing an existing Meal.
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        rightSwipe.direction = .Right
        view.addGestureRecognizer(rightSwipe)
        if let fish = fish {
            navigationItem.title = fish.name
            photoImageView.image = fish.photo
            fishLabel.text = fishToxicGuide[fish.level]
            eatingGuide.text = eatingGuideText[fish.level]
            ratingImage.image = UIImage(named: ratingImageNames[fish.level])!
        }
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

