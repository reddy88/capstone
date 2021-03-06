//
//  NewWorkoutViewController.swift
//  Capstone
//
//  Created by Mithun Reddy on 8/28/17.
//  Copyright © 2017 Mithun Reddy. All rights reserved.
//

import UIKit

class NewWorkoutViewController: UIViewController {
    
    // MARK: - IBOutlets

    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - IBActions
    
    @IBAction func addExerciseButtonTapped(_ sender: Any) {
        if let exerciseListViewController = storyboard?.instantiateViewController(withIdentifier: "ExerciseListViewController") as? ExerciseListViewController {
            view.window?.rootViewController?.present(exerciseListViewController, animated: true, completion: nil)
        }
    }
    
    // MARK: - Properties
    
    var editButton: UIButton!
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadSections([3], with: .automatic)
        tableView.isEditing = false
        
      
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.separatorColor = UIColor(red: 41.0/255.0, green: 35.0/255.0, blue: 66.0/255.0, alpha: 1.0)
    }
    
    // MARK: - Methods
    
    func editTableButtonTapped() {
        if(tableView.isEditing == true)
        {
            tableView.isEditing = false
            editButton.setTitle("Edit", for: .normal)
        }
        else
        {
            tableView.isEditing = true
            editButton.setTitle("Done", for: .normal)
        }
    }
    
}

// MARK: - UITableViewDataSource

extension NewWorkoutViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Workout Name"
        case 1:
            return "Color Tag"
        case 2:
            return "Days of Week"
        case 3:
            return "Exercises"
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 3 {
            return WorkoutController.shared.selectedWorkout?.exercises?.count ?? 0
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "workoutNameCell", for: indexPath) as? WorkoutNameTableViewCell else { return WorkoutNameTableViewCell() }
            cell.workoutNameTextField.delegate = cell
            cell.workoutNameTextField.text = WorkoutController.shared.selectedWorkout?.name
            
            let attributes = [
                NSForegroundColorAttributeName: UIColor.white,
                NSFontAttributeName : UIFont.systemFont(ofSize: 17, weight: UIFontWeightRegular)
            ]
            
            cell.workoutNameTextField.attributedPlaceholder = NSAttributedString(string: "Name", attributes:attributes)
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "workoutColorTagCell", for: indexPath) as? ColorTagTableViewCell,
                let tagColorRawValue = WorkoutController.shared.selectedWorkout?.tagColor, let tagColor = TagColor(rawValue: tagColorRawValue) else { return ColorTagTableViewCell() }
            cell.updateViews()
            
            cell.setColorTag(colorTag: tagColor)
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "workoutDaysOfWeekCell", for: indexPath) as? DaysOfWeekTableViewCell,
                let workout = WorkoutController.shared.selectedWorkout else { return DaysOfWeekTableViewCell() }
            cell.updateViews()
            cell.setDaysSelected(daysSelected: WorkoutController.shared.daysOfWeekConverterToArray(workout: workout))
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "workoutExercisesCell", for: indexPath)
            if let exercises = WorkoutController.shared.selectedWorkout?.exercises?.array as? [WorkoutExercise] {
                cell.textLabel?.text = exercises[indexPath.row].name
                cell.textLabel?.textColor = UIColor.white
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if (indexPath.section == 3) {
            return true
        }
        return false
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if var workoutExercises = WorkoutController.shared.selectedWorkout?.exercises?.array as? [WorkoutExercise] {
                let removedWorkoutExercise = workoutExercises.remove(at: indexPath.row)
                WorkoutController.shared.selectedWorkout?.exercises = NSOrderedSet(array: workoutExercises)
                WorkoutExerciseController.shared.removeWorkoutExercise(removedWorkoutExercise)
            }
            
            ExerciseController.shared.exercisesSelected[indexPath.row].isSelected = false
            ExerciseController.shared.exercisesSelected.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
}

// MARK: UITableViewDelegate

extension NewWorkoutViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if section != 3 {
            
            let header = view as! UITableViewHeaderFooterView
            
            if let textlabel = header.textLabel {
                textlabel.font = textlabel.font.withSize(15)
                textlabel.textColor = .white
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 3 {
            
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: tableView.sectionHeaderHeight))
            
            //15, 20
            let sectionTitle = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 10))
            sectionTitle.text = "EXERCISES"
            sectionTitle.font = UIFont.systemFont(ofSize: 15, weight: 0)
            sectionTitle.textColor = .white
            headerView.addSubview(sectionTitle)
            
            editButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: tableView.frame.height))
            editButton.setTitle("Edit", for: .normal)
            editButton.setTitleColor(UIColor(red: 0.0, green: 128.0/255.0, blue: 255.0/255.0, alpha: 1.0), for: .normal)
            editButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
            editButton.addTarget(nil, action: #selector(editTableButtonTapped), for: .touchUpInside)
            headerView.addSubview(editButton)
            
            
            let views: [String: Any] = ["sectionTitle": sectionTitle, "editButton": editButton, "headerView": headerView]
            let headerViewHorizontalConstraint = NSLayoutConstraint.constraints(withVisualFormat: "|-(15)-[sectionTitle]-[editButton(45)]-(15)-|", options: [], metrics: nil, views: views)
            let sectionTitleVerticalConstraint = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(10)-[sectionTitle]-|", options: [], metrics: nil, views: views)
            let editButtonVerticalConstraint = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(10)-[editButton(20)]", options: [], metrics: nil, views: views)
           
            
            sectionTitle.translatesAutoresizingMaskIntoConstraints = false
            editButton.translatesAutoresizingMaskIntoConstraints = false
            
            headerView.addConstraints(sectionTitleVerticalConstraint)
            headerView.addConstraints(editButtonVerticalConstraint)
            headerView.addConstraints(headerViewHorizontalConstraint)

            return headerView
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0, 1, 2:
            return 60
        default:
            return 44
        }
    }
    
}
