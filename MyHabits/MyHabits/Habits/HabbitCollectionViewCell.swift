//
//  HabbitCollectionViewCell.swift
//  MyHabits
//
//  Created by TIS Developer on 11.08.2021.
//

import UIKit

protocol ReloadingProgressBarDelegate: AnyObject {
    func reloadProgressBar()
}

class HabbitCollectionViewCell: UICollectionViewCell {
    
    weak var onTapTrackImageViewDelegate: ReloadingProgressBarDelegate?
    weak var delegateHabitCell: ReloadingCollectionDataDelegate?
    
    var habit: Habit? {
        didSet{
            guard let habit = habit else { return }
            nameHabitLabel.text = habit.name
            dateLabel.text = habit.dateString
            changeButton.layer.borderColor = habit.color.cgColor
            changeButton.backgroundColor = habit.color
            nameHabitLabel.textColor = habit.color
            counterLabel.text = ("Подряд: \(habit.trackDates.count)")
            
            if habit.isAlreadyTakenToday == false {
                changeButton.backgroundColor = .white
                checkMarkLabel.removeFromSuperview()
            } else {
                setupCheckedImageView()
            }
        }
    }
    
    var nameHabitLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.numberOfLines = 2
        return label
    }()
    
    var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemGray
        return label
    }()
    
    var counterLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.text = "Подряд: "
        label.textColor = .systemGray
        return label
    }()
    
    var changeButton: UIImageView = {
        let imageView = UIImageView()
        imageView.roundCornerWithRadius(19, top: true, bottom: true, shadowEnabled: false)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .white
        imageView.layer.borderWidth = 3
       
        return imageView
    }()
    
    var checkMarkLabel: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "checkmark")
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
       
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.roundCornerWithRadius(6, top: true, bottom: true, shadowEnabled: false)
        contentView.backgroundColor = .white
        setupViews()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapButton))
        changeButton.isUserInteractionEnabled = true
        changeButton.addGestureRecognizer(tapGestureRecognizer)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    @objc func tapButton() {
        if let checkHabit = habit {
            if checkHabit.isAlreadyTakenToday == true {
                print("Привычка уже была сегодня нажата")
            } else {
                print("трекаем время привычки")
                setupCheckedImageView()
                HabitsStore.shared.track(checkHabit)
                onTapTrackImageViewDelegate?.reloadProgressBar()
            }
        }
        else {
            print("Упс, вместо привычки nil")
        }
    }
    
}

extension HabbitCollectionViewCell{
    private func setupViews() {
        contentView.addSubview(nameHabitLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(counterLabel)
        contentView.addSubview(changeButton)
        contentView.addSubview(checkMarkLabel)
        
        
        let constraints = [
            nameHabitLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            nameHabitLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            dateLabel.topAnchor.constraint(equalTo: nameHabitLabel.bottomAnchor, constant: 4),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            dateLabel.bottomAnchor.constraint(equalTo: counterLabel.topAnchor, constant: -30),
            
            counterLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            counterLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            changeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -26),
            changeButton.heightAnchor.constraint(equalToConstant: 36),
            changeButton.widthAnchor.constraint(equalToConstant: 36),
            changeButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -47)

        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func setupCheckedImageView() {
        changeButton.backgroundColor = nameHabitLabel.textColor
        changeButton.addSubview(checkMarkLabel)
        
        let checkedImageViewConstrains = [
            checkMarkLabel.centerXAnchor.constraint(equalTo: changeButton.centerXAnchor),
            checkMarkLabel.centerYAnchor.constraint(equalTo: changeButton.centerYAnchor),
            checkMarkLabel.widthAnchor.constraint(equalToConstant: 25),
            checkMarkLabel.heightAnchor.constraint(equalToConstant: 25)
        ]
        
        NSLayoutConstraint.activate(checkedImageViewConstrains)
    }
}
