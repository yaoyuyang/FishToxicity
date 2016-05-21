//
//  Fish.swift
//  FishToxicity
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
    var conc: Float?

    // MARK: Archiving Paths

    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("fishes")

    // MARK: Types

    struct PropertyKey {
        static let nameKey = "name"
        static let photoKey = "photo"
        static let levelKey = "level"
        static let concKey = "conc"
    }

    // MARK: Initialization

    init?(name: String, photo: UIImage?, level: Int, conc: Float?) {
        // Initialize stored properties.
        self.name = name
        self.photo = photo
        self.level = level
        self.conc = conc

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
        aCoder.encodeFloat(conc!, forKey: PropertyKey.concKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObjectForKey(PropertyKey.nameKey) as! String
        let photo = aDecoder.decodeObjectForKey(PropertyKey.photoKey) as? UIImage
        let level = aDecoder.decodeIntegerForKey(PropertyKey.levelKey)
        let conc = aDecoder.decodeFloatForKey(PropertyKey.concKey)
        // Must call designated initilizer.
        self.init(name: name, photo: photo, level: level, conc: conc)
    }

}
