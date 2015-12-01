//
//  Meal.swift
//  FoodTracker
//
//  Created by Yaoyu Yang on 11/17/15.
//  Copyright © 2015 Yaoyu Yang. All rights reserved.
//

import UIKit

class Fish: NSObject, NSCoding {
    // MARK: Properties

    var name: String
    var photo: UIImage?
    var level: Int

    // MARK: Archiving Paths

    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("meals")

    // MARK: Types

    struct PropertyKey {
        static let nameKey = "name"
        static let photoKey = "photo"
        static let levelKey = "level"
    }

    // MARK: Initialization

    init?(name: String, photo: UIImage?, level: Int) {
        // Initialize stored properties.
        self.name = name
        self.photo = photo
        self.level = level

        super.init()

        // Initialization should fail if there is no name or if the level is negative.
        if name.isEmpty || level < 0 {
            return nil
        }
    }

    // MARK: NSCoding
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: PropertyKey.nameKey)
        aCoder.encodeObject(photo, forKey: PropertyKey.photoKey)
        aCoder.encodeInteger(level, forKey: PropertyKey.levelKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObjectForKey(PropertyKey.nameKey) as! String
        let photo = aDecoder.decodeObjectForKey(PropertyKey.photoKey) as? UIImage
        let level = aDecoder.decodeIntegerForKey(PropertyKey.levelKey)
        // Must call designated initilizer.
        self.init(name: name, photo: photo, level: level)
    }

}
