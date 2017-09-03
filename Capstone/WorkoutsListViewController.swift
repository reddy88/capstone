//
//  WorkoutsListViewController.swift
//  Capstone
//
//  Created by Mithun Reddy on 8/31/17.
//  Copyright © 2017 Mithun Reddy. All rights reserved.
//

import UIKit

class WorkoutsListViewController: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editWorkout" {
            guard let index = tableView.indexPathForSelectedRow?.row else { return }
            let workout = WorkoutController.shared.workouts[index]
            WorkoutController.shared.selectedWorkout = workout
        } else if segue.identifier == "newWorkout" {
            let newWorkoutPageViewController = segue.destination as? NewWorkoutPageViewController
            newWorkoutPageViewController?.isNewWorkout = true
            WorkoutController.shared.createWorkout(name: nil, tagColor: .noTag, workoutDays: [], exercises: [])
            let workout = WorkoutController.shared.workouts.last
            WorkoutController.shared.selectedWorkout = workout
        }
    }

}

// MARK: UITableViewDataSource, UITableViewDelegate

extension WorkoutsListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WorkoutController.shared.workouts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "workoutCell", for: indexPath)
        let workout = WorkoutController.shared.workouts[indexPath.row]
        cell.textLabel?.text = workout.name
        return cell
    }
    
}