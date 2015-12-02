//
//  FishTableViewController.swift
//  FishToxicity
//
//  Created by Yaoyu Yang on 11/23/15.
//  Copyright © 2015 Yaoyu Yang. All rights reserved.
//

import UIKit

class FishTableViewController: UITableViewController, UISearchResultsUpdating {

    // MARK: Properties

    var fishes = [Fish]()
    var filteredFishes = [Fish]()
    var resultSearchController = UISearchController()
    let ratingImageNames: [String] = ["least", "moderate", "high", "highest"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Load the fish data.
        loadFish()

        self.resultSearchController = UISearchController(searchResultsController: nil)
        self.resultSearchController.searchResultsUpdater = self
        self.resultSearchController.dimsBackgroundDuringPresentation = false
        self.resultSearchController.searchBar.sizeToFit()

        self.tableView.tableHeaderView = self.resultSearchController.searchBar

        self.tableView.reloadData()
    }

    func loadFish() {
        let anchovies = Fish(name: "Anchovies", photo: UIImage(named: "Anchovies")!, level: 0)!
        let butterfish = Fish(name: "Butterfish", photo: UIImage(named: "Butterfish")!, level: 0)!
        let catfish = Fish(name: "Catfish", photo: UIImage(named: "Catfish")!, level: 0)!
        let clam = Fish(name: "Clam", photo: UIImage(named: "Clam")!, level: 0)!
        let marlin = Fish(name: "Marlin", photo: UIImage(named: "Marlin")!, level: 3)!
        let bass = Fish(name: "Bass (Striped, Black)", photo: UIImage(named: "Bass")!, level: 1)!
        let blueFish = Fish(name: "Bluefish", photo: UIImage(named: "Bluefish")!, level: 2)!
        fishes += [anchovies, butterfish, catfish, clam, marlin, bass, blueFish]
        fishes.sortInPlace({ $0.name < $1.name })
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
    }

}
