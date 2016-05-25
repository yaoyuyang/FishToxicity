//
//  FishTableViewController.swift
//  FishToxicity
//
//  Created by Yaoyu Yang on 11/23/15.
//  Copyright © 2015 Yaoyu Yang. All rights reserved.
//

import UIKit
import GoogleMobileAds
import Localize_Swift
//import SwiftCSV

class FishTableViewController: UITableViewController, UISearchResultsUpdating, GADInterstitialDelegate {

    // MARK: Properties

    var fishes = [Fish]()
    var filteredFishes = [Fish]()
    var resultSearchController = UISearchController()
    let ratingImageNames: [String] = ["least", "moderate", "high", "highest"]
    var timer = 5
    
    // Google Ad
    var interstitial: GADInterstitial!

    override func viewDidLoad() {
        super.viewDidLoad()
        interstitial = createAndLoadInterstitial()

        // Load the fish data.
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setBool(false, forKey: "isPreloaded")
        let isPreloaded = defaults.boolForKey("isPreloaded")
        if !isPreloaded {
            preloadFish()
            defaults.setBool(true, forKey: "isPreloaded")
            print("PreloadFish")
        } else {
            if let saveFishes = loadFishes() {
                fishes += saveFishes
            }
            print("LoadSavedFish")
        }

        self.resultSearchController = UISearchController(searchResultsController: nil)
        self.resultSearchController.searchResultsUpdater = self
        self.resultSearchController.dimsBackgroundDuringPresentation = false
        self.resultSearchController.searchBar.sizeToFit()

        self.tableView.tableHeaderView = self.resultSearchController.searchBar

        self.tableView.reloadData()
    }
    
    func parseCSV (contentsOfURL: NSURL, encoding: NSStringEncoding, error: NSErrorPointer) -> [Dictionary<String, String>]? {
        // Load the CSV file and parse it
        let delimiter = ","
        var items = [[String:String]]?()
        if let data = NSData(contentsOfURL: contentsOfURL) {
            if let content = NSString(data: data, encoding: NSUTF8StringEncoding) {
                items = []
                let lines:[String] = content.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet()) as [String]
                let keys = lines[0].componentsSeparatedByString(delimiter)
                
                for line in lines[1..<lines.count] {
                    var values:[String] = []
                    if line != "" {
                        // For a line with double quotes
                        // we use NSScanner to perform the parsing
                        if line.rangeOfString("\"") != nil {
                            var textToScan:String = line
                            var value:NSString?
                            var textScanner:NSScanner = NSScanner(string: textToScan)
                            while textScanner.string != "" {
                            
                                if (textScanner.string as NSString).substringToIndex(1) == "\"" {
                                    textScanner.scanLocation += 1
                                    textScanner.scanUpToString("\"", intoString: &value)
                                    textScanner.scanLocation += 1
                                } else {
                                    textScanner.scanUpToString(delimiter, intoString: &value)
                                }
                                
                                // Store the value into the values array
                                values.append(value as! String)
                                
                                // Retrieve the unscanned remainder of the string
                                if textScanner.scanLocation < textScanner.string.characters.count {
                                    textToScan = (textScanner.string as NSString).substringFromIndex(textScanner.scanLocation + 1)
                                    
                                } else {
                                    textToScan = ""
                                }
                                textScanner = NSScanner(string: textToScan)
                            }
                            
                            // For a line without double quotes, we can simply separate the string
                            // by using the delimiter (e.g. comma)
                        } else  {
                            values = line.componentsSeparatedByString(delimiter)
                        }
//                        print(values)
                        if values.count < keys.count {
                            values.append("")
                        }
                        
                        // Put the values into the tuple and add it to the items array
                        var item = [String: String]()
                        for (index, key) in keys.enumerate() {
                            item[key] = values[index]
                        }
                        items?.append(item)
                    }
                }
            }
        }
        return items
    }
    
    func preloadFish() {
        // Retrieve data from the source file
        if let contentsOfURL = NSBundle.mainBundle().URLForResource("fishdata", withExtension: "csv") {
            
            print("preprocessing")
            // Remove all the menu items before preloading
            removeFishes()
            
            var error:NSError?
            
            if let processedItems = parseCSV(contentsOfURL, encoding: NSUTF8StringEncoding, error: &error) {
                for processedItem in processedItems {
//                    print(processedItem)
                    let newFish = Fish(name: processedItem["name"]!.localized(), photo: UIImage(named: processedItem["photo"]!), level: Int(processedItem["level"]!)!, conc: Float(processedItem["concentration"]!))!
                    fishes.append(newFish)
                }
            }
            
        
        }
        
        fishes.sortInPlace({ $0.name < $1.name })
        saveFishes()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if (self.resultSearchController.active) {
            return self.filteredFishes.count
        } else {
            return fishes.count
        }
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "FishTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! FishTableViewCell

        var aFish = fishes[indexPath.row]

        if (self.resultSearchController.active) {
            aFish = filteredFishes[indexPath.row]
        } else {
            aFish = fishes[indexPath.row]
        }

        // Fetches the appropriate meal for the data source layout.

        cell.nameLabel.text = aFish.name
        cell.photoImageView.image = aFish.photo
        cell.ratingImage.image = UIImage(named: ratingImageNames[aFish.level])!
        
        self.definesPresentationContext = true

        return cell
    }

    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filteredFishes.removeAll(keepCapacity: false)

        let searchPredicate = NSPredicate(format: "SELF.name CONTAINS[c] %@", searchController.searchBar.text!)
        let array = (fishes as NSArray).filteredArrayUsingPredicate(searchPredicate)
        filteredFishes = array as! [Fish]

        self.tableView.reloadData()
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let fishDetailViewController = segue.destinationViewController as! FishViewController
        // Get the cell that generated this segue.
        if let selectedFishCell = sender as? FishTableViewCell {
            var selectedFish: Fish?
            let indexPath = tableView.indexPathForCell(selectedFishCell)!
            if (self.resultSearchController.active) {
                selectedFish = filteredFishes[indexPath.row]
            } else {
                selectedFish = fishes[indexPath.row]
            }
            fishDetailViewController.fish = selectedFish
        }
        print(timer)
        if interstitial.isReady && timer == 5 {
            interstitial.presentFromRootViewController(self)
            timer = 0
        }
        timer = timer + 1
    }
    
    func createAndLoadInterstitial() -> GADInterstitial {
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
        interstitial.delegate = self
        interstitial.loadRequest(GADRequest())
        return interstitial
    }
    
    func interstitialDidDismissScreen(ad: GADInterstitial!) {
        interstitial = createAndLoadInterstitial()
    }
    
    func saveFishes() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(fishes, toFile: Fish.ArchiveURL.path!)
        if !isSuccessfulSave {
            print("Failed to save meals...")
        }
    }
    func loadFishes() -> [Fish]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Fish.ArchiveURL.path!) as? [Fish]
    }
    
    // clear the records in Archive
    func removeFishes() {
        fishes = [Fish]()
        saveFishes()
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "isPreloaded")
        print("Fishes removed")
    }

}
