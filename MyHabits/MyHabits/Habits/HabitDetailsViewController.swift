//
//  HabitDetailsViewController.swift
//  MyHabits
//
//  Created by TIS Developer on 13.08.2021.
//

import UIKit

class HabitDetailsViewController: UIViewController {
    
    var detailsHabit: Habit?
    
    private let cellID = "cellID"
    
    lazy var habitTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = detailsHabit?.name
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Править", style: .plain, target: self, action: #selector(editTap))
        navigationController?.navigationBar.tintColor = .customPurple
        
        setupView()
        
        navigationItem.largeTitleDisplayMode = .never

        habitTableView.dataSource = self
        habitTableView.delegate = self
        habitTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
    }
    

    @objc func editTap(){
        let habitVC = HabitViewController()
        habitVC.editingHabit = detailsHabit
        habitVC.isOnEditMode = true
        habitVC.setupEditingMode()
        habitVC.dismissingVCDelegate = self
        habitVC.reloadingTitleDelegate = self
        
        navigationController?.present(habitVC, animated: true, completion: nil)
    }
}

extension HabitDetailsViewController{
    func setupView() {
    
        view.addSubview(habitTableView)
        let constraints = [
            habitTableView.topAnchor.constraint(equalTo: view.topAnchor),
            habitTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            habitTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            habitTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}


extension HabitDetailsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return HabitsStore.shared.dates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        cell.textLabel?.text = HabitsStore.shared.trackDateString(forIndex: indexPath.row)
        
        if let habit = detailsHabit {
            if HabitsStore.shared.habit(habit, isTrackedIn: HabitsStore.shared.dates[indexPath.row]) {
                cell.accessoryType = .checkmark
                cell.tintColor = .customPurple
            } else {
                cell.accessoryType = .none
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "АКТИВНОСТЬ"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        habitTableView.deselectRow(at: indexPath, animated: true)
    }
}

extension HabitDetailsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .zero
    }

}

extension HabitDetailsViewController: ReloadingTitleDelegate {
    func reloadTitle() {
        if let habit = detailsHabit, let index = HabitsStore.shared.habits.firstIndex(of: habit) {
            title = HabitsStore.shared.habits[index].name
        }
    }
}

extension HabitDetailsViewController: DissmissingViewControllerDelegate {
    func dismissViewController() {
        self.navigationController?.popViewController(animated: false)
    }
}
