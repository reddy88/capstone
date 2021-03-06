//
//  WorkoutNameTableViewCell.swift
//  Capstone
//
//  Created by Mithun Reddy on 8/28/17.
//  Copyright © 2017 Mithun Reddy. All rights reserved.
//

import UIKit

class WorkoutNameTableViewCell: UITableViewCell {

    // MARK: - IBOutlets
    
    @IBOutlet weak var workoutNameTextField: UITextField!
    
}

// MARK: - UITextFieldDelegate

extension WorkoutNameTableViewCell: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
