//
//  Workout.swift
//  Capstone
//
//  Created by Mithun Reddy on 8/27/17.
//  Copyright © 2017 Mithun Reddy. All rights reserved.
//

import UIKit
import CoreData

extension Workout {
    
    // MARK: - Initializers
    
    convenience init(name: String?, context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        
        self.name = name
    }
    
}
