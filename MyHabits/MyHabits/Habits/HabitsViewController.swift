//
//  HabitsViewController.swift
//  MyHabits
//
//  Created by TIS Developer on 11.08.2021.
//

import UIKit

class HabitsViewController: UIViewController {
    
    private lazy var store = HabitsStore.shared
    
    lazy var habitsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .almostWhite
        collectionView.register(HabbitCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: HabbitCollectionViewCell.self))
        collectionView.register(EmptyCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: EmptyCollectionViewCell.self))
        collectionView.register(ProgressCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: ProgressCollectionViewCell.self))
        
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(habitsCollectionView)
        setupView()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.tintColor = .customPurple
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addHabit))
        navigationItem.rightBarButtonItem?.tintColor = .customPurple
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        habitsCollectionView.reloadData()
    }
    
    
    @objc func addHabit(sender: UIButton!) {
        let addHabitVC = HabitViewController()
        addHabitVC.reloadingDataDelegate = self
        self.present(addHabitVC, animated: true, completion: nil)
    }
}


extension HabitsViewController {
    func setupView() {
        
        let constraints = [
            habitsCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            habitsCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            habitsCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            habitsCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}

extension HabitsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsets(top: 22, left: 16, bottom: 18, right: 16)
        }
        else {
            return UIEdgeInsets(top: .zero, left: 16, bottom: 18, right: 16)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        guard section == 0 else { return 12 }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.section == 0 {
            return CGSize(width: (view.frame.size.width - 32), height: 60)
        } else
        {
            return CGSize(width: (view.frame.size.width - 32), height: 130)
        }
    }
}

extension HabitsViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return store.habits.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if store.habits.count != 0 {
            if indexPath.section == 0{
                let cellProgress = habitsCollectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ProgressCollectionViewCell.self), for: indexPath) as! ProgressCollectionViewCell
                
                cellProgress.progressLine.setProgress(HabitsStore.shared.todayProgress, animated: true)
                cellProgress.statusLabel.text = "\(Int(HabitsStore.shared.todayProgress * 100))%"
                
                 return cellProgress
            } else {
                let cellHabit = habitsCollectionView.dequeueReusableCell(withReuseIdentifier: String(describing: HabbitCollectionViewCell.self), for: indexPath) as! HabbitCollectionViewCell

                cellHabit.habit = store.habits[indexPath.item]
                cellHabit.onTapTrackImageViewDelegate = self

                 return cellHabit
            }
        } else
        {
            let cellHabit = habitsCollectionView.dequeueReusableCell(withReuseIdentifier: String(describing: EmptyCollectionViewCell.self), for: indexPath) as! EmptyCollectionViewCell
            
            return cellHabit
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        habitsCollectionView.deselectItem(at: indexPath, animated: true)
        
        if indexPath.section == 1 {
            let habitDetailVC = HabitDetailsViewController()
            habitDetailVC.detailsHabit = store.habits[indexPath.item]
            
            navigationController?.pushViewController(habitDetailVC, animated: true)
        }
    }
}
extension HabitsViewController: ReloadingCollectionDataDelegate {
    func updCollection() {
        habitsCollectionView.reloadData()
    }
}

extension HabitsViewController: ReloadingProgressBarDelegate {
    func reloadProgressBar() {
        habitsCollectionView.reloadData()
    }
}
