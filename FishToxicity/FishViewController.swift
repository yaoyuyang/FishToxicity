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
    var bannerView: GADBannerView!

    /*
    This value is passed by `FishTableViewController` in `prepareForSegue(_:sender:)`
    */
    
    var fish: Fish?
    let singleAttribute1 = [ NSAttributedString.Key.foregroundColor: UIColor.green ]
    let singleAttribute2 = [ NSAttributedString.Key.backgroundColor: UIColor.yellow ]
    let singleAttribute3 = [ NSAttributedString.Key.underlineStyle: NSUnderlineStyle.double.rawValue ]
    
    let fishToxicGuide: [NSAttributedString] = [
        NSAttributedString(string: "LEAST MERCURY".localized(), attributes: [ NSAttributedString.Key.foregroundColor: UIColor(red: 88/255, green: 152/255, blue: 42/255, alpha: 1) ]),
        NSAttributedString(string: "MODERATE MERCURY".localized(), attributes: [ NSAttributedString.Key.foregroundColor: UIColor(red: 234/255, green: 203/255, blue: 0/255, alpha: 1) ]),
        NSAttributedString(string: "HIGH MERCURY".localized(), attributes: [ NSAttributedString.Key.foregroundColor: UIColor(red: 255/255, green: 171/255, blue: 28/255, alpha: 1) ]),
        NSAttributedString(string: "HIGHEST MERCURY".localized(), attributes: [ NSAttributedString.Key.foregroundColor: UIColor(red: 254/255, green: 72/255, blue: 25/255, alpha: 1) ])
    ]
    let eatingGuideText: [String] = ["Enjoy this fish.*".localized(), "Eat six servings or less per month.*".localized(), "Eat three servings or less per month!*".localized(), "Avoid eating!*".localized()]
    let ratingImageNames: [String] = ["least", "moderate", "high", "highest"]

    override func viewDidLoad() {
        super.viewDidLoad()
        let bannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        addBannerViewToView(bannerView)
        // Set up views if editing an existing Meal.
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(FishViewController.handleSwipes(_:)))
        rightSwipe.direction = .right
        view.addGestureRecognizer(rightSwipe)
        if let fish = fish {
            navigationItem.title = fish.name
            photoImageView.image = fish.photo
            fishLabel.attributedText = fishToxicGuide[fish.level]
            eatingGuide.text = eatingGuideText[fish.level]
            ratingImage.image = UIImage(named: ratingImageNames[fish.level])!
            concData.text = "Mercury concentration mean: ".localized() + fish.conc!.description + " PPM, according to FDA: Mercury Levels in Commercial Fish and Shellfish (1990-2010). ".localized()
        }
        bannerView.adUnitID = "ca-app-pub-1494190819778945/8661449578"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Navigation
    @IBAction func back(_ sender: UIBarButtonItem) {
        navigationController!.popViewController(animated: true)

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    @objc func handleSwipes(_ sender:UISwipeGestureRecognizer) {
        if (sender.direction == .right) {
            navigationController!.popViewController(animated: true)
        }
    }
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        if #available(iOS 11.0, *) {
            // In iOS 11, we need to constrain the view to the safe area.
            positionBannerViewFullWidthAtBottomOfSafeArea(bannerView)
        }
        else {
            // In lower iOS versions, safe area is not available so we use
            // bottom layout guide and view edges.
            positionBannerViewFullWidthAtBottomOfView(bannerView)
        }
    }
    
    // MARK: - view positioning
    @available (iOS 11, *)
    func positionBannerViewFullWidthAtBottomOfSafeArea(_ bannerView: UIView) {
        // Position the banner. Stick it to the bottom of the Safe Area.
        // Make it constrained to the edges of the safe area.
        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            guide.leftAnchor.constraint(equalTo: bannerView.leftAnchor),
            guide.rightAnchor.constraint(equalTo: bannerView.rightAnchor),
            guide.bottomAnchor.constraint(equalTo: bannerView.bottomAnchor)
            ])
    }
    
    func positionBannerViewFullWidthAtBottomOfView(_ bannerView: UIView) {
        view.addConstraint(NSLayoutConstraint(item: bannerView,
                                              attribute: .leading,
                                              relatedBy: .equal,
                                              toItem: view,
                                              attribute: .leading,
                                              multiplier: 1,
                                              constant: 0))
        view.addConstraint(NSLayoutConstraint(item: bannerView,
                                              attribute: .trailing,
                                              relatedBy: .equal,
                                              toItem: view,
                                              attribute: .trailing,
                                              multiplier: 1,
                                              constant: 0))
        view.addConstraint(NSLayoutConstraint(item: bannerView,
                                              attribute: .bottom,
                                              relatedBy: .equal,
                                              toItem: bottomLayoutGuide,
                                              attribute: .top,
                                              multiplier: 1,
                                              constant: 0))
    }
}

