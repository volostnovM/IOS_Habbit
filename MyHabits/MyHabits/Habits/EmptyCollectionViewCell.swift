//
//  EmptyCollectionViewCell.swift
//  MyHabits
//
//  Created by TIS Developer on 12.08.2021.
//

import UIKit

class EmptyCollectionViewCell: UICollectionViewCell {
    
    var emptyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.numberOfLines = 2
        label.text = "Привычки не найдены. Добавьте новые!"
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .white
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
}


extension EmptyCollectionViewCell{
    private func setupViews() {
        contentView.addSubview(emptyLabel)

        let constraints = [
            emptyLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            emptyLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            emptyLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}
