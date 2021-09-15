//
//  InfoViewController.swift
//  MyHabits
//
//  Created by TIS Developer on 11.08.2021.
//

import UIKit

class InfoViewController: UIViewController {
        
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    var textForInfo: String? = "Прохождение этапов, за которые за 21 день вырабатывается привычка, подчиняется следующему алгоритму:\n \n1. Провести 1 день без обращения к старым привычкам, стараться вести себя так, как будто цель, загаданная в перспективу, находится на расстоянии шага.\n \n2. Выдержать 2 дня в прежнем состоянии самоконтроля.\n \n3. Отметить в дневнике первую неделю изменений и подвести первые итоги — что оказалось тяжело, что — легче, с чем еще предстоит серьезно бороться.\n \n4. Поздравить себя с прохождением первого серьезного порога в 21 день. За это время отказ от дурных наклонностей уже примет форму осознанного преодоления и человек сможет больше работать в сторону принятия положительных качеств.\n \n5. Держать планку 40 дней. Практикующий методику уже чувствует себя освободившимся от прошлого негатива и двигается в нужном направлении с хорошей динамикой.\n \n6. На 90-й день соблюдения техники все лишнее из «прошлой жизни» перестает напоминать о себе, и человек, оглянувшись назад, осознает себя полностью обновившимся.\n \nИсточник: psychbook.ru"
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.text = "Привычка за 21 день"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var textLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "Информация"
        textLabel.text = textForInfo
        
        setupViews()
    }
    
}

private extension InfoViewController{

    func setupViews() {
        self.view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(textLabel)
                
        let constraints = [
            scrollView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            
            
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 22),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            textLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            textLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            textLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            textLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -22)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
