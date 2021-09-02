//
//  ProgressCollectionViewCell.swift
//  MyHabits
//
//  Created by TIS Developer on 12.08.2021.
//

import UIKit

class ProgressCollectionViewCell: UICollectionViewCell {
    
    lazy var textlabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Все получится!"
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        label.textColor = .systemGray
        return label
    }()
    
    lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        label.textColor = .systemGray
        label.text = String(Int(HabitsStore.shared.todayProgress * 100)) + "%"
        return label
    }()
    
    
    let progressLine: UIProgressView = {
        let progressLine = UIProgressView()
        progressLine.setProgress(HabitsStore.shared.todayProgress, animated: true)
        progressLine.progressTintColor = .CustomPurple
        progressLine.trackTintColor = .systemGray2
        progressLine.translatesAutoresizingMaskIntoConstraints = false
        progressLine.layer.cornerRadius = 4
        return progressLine
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.roundCornerWithRadius(8, top: true, bottom: true, shadowEnabled: false)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
}

extension ProgressCollectionViewCell {
    func setupView() {
        contentView.backgroundColor = .white
        contentView.addSubview(textlabel)
        contentView.addSubview(statusLabel)
        contentView.addSubview(progressLine)
        
        let constraints = [
            textlabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            textlabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            
            progressLine.topAnchor.constraint(equalTo: textlabel.bottomAnchor, constant: 10),
            progressLine.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            progressLine.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            progressLine.heightAnchor.constraint(equalToConstant: 7),
            progressLine.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
            
            statusLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            statusLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
