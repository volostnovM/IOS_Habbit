//
//  HabitViewController.swift
//  MyHabits
//
//  Created by TIS Developer on 11.08.2021.
//

import UIKit

protocol ReloadingCollectionDataDelegate: class {
    func updCollection()
}

protocol ReloadingTitleDelegate: class {
    func reloadTitle()
}

protocol DissmissingViewControllerDelegate: class {
    func dismissViewController()
}

class HabitViewController: UIViewController {
    
    weak var reloadingDataDelegate: ReloadingCollectionDataDelegate?
    weak var reloadingTitleDelegate: ReloadingTitleDelegate?
    weak var dismissingVCDelegate: DissmissingViewControllerDelegate?
    
    var isOnEditMode: Bool = false
    var editingHabit: Habit?
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var feedStack: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        return stackView
    }()
    
    lazy var nameHabitLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "НАЗВАНИЕ"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        label.numberOfLines = 1
        return label
    }()
    
    lazy var nameHabitTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Бегать по утрам, спать 8 часов и т.п."
        textField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textField.backgroundColor = .white
        return textField
    }()

    lazy var colorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "ЦВЕТ"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        return label
    }()
    
    lazy var colorPickerButton: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.roundCornerWithRadius(15, top: true, bottom: true, shadowEnabled: false)
        imageView.backgroundColor = .customPurple
        
        return imageView
    }()
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "ВРЕМЯ"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        return label
    }()
    
    
    lazy var habitTimeTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.text = "Каждый день в "
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        return label
    }()
    
    lazy var datepickerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .customPurple
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)

        return label
    }()
    
    lazy var datepicker: UIDatePicker = {
        let datepicker = UIDatePicker()
        datepicker.translatesAutoresizingMaskIntoConstraints = false
        datepicker.datePickerMode = .time
        datepicker.preferredDatePickerStyle = .wheels
        datepicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        return datepicker
    }()
    
    private lazy var deleteHabitButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Удалить привычку", for: .normal)
        button.setTitleColor(UIColor.systemRed, for: .normal)
        button.addTarget(self, action: #selector(deleteButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var colorPickerViewController: UIColorPickerViewController = {
        let picker = UIColorPickerViewController()
        picker.delegate = self
        return picker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapColorPicker))
        colorPickerButton.isUserInteractionEnabled = true
        colorPickerButton.addGestureRecognizer(tapGestureRecognizer)
        
        navigationController?.navigationBar.tintColor = .customPurple
        
        setupView()
        dateChanged()
        setupHideKeyboardOnTap()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func tapColorPicker() {
        present(colorPickerViewController, animated: true, completion: nil)
    }
    
    @objc func dateChanged() {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        datepickerLabel.text = formatter.string(from: datepicker.date)
    }
    
    @objc func actionCancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func actionSaveButton(_ sender: Any) {
        
        if isOnEditMode {
            if let habit = editingHabit, let index = HabitsStore.shared.habits.firstIndex(of: habit) {
                HabitsStore.shared.habits[index].name = nameHabitTextField.text ?? ""
                HabitsStore.shared.habits[index].date = datepicker.date
                HabitsStore.shared.habits[index].color = colorPickerButton.backgroundColor ?? .customPurple
                HabitsStore.shared.save()
                reloadingDataDelegate?.updCollection()
                reloadingTitleDelegate?.reloadTitle()
                self.dismiss(animated: true, completion: nil)
            }
        } else {
            guard let text = nameHabitTextField.text, !text.isEmpty else {
                let alertController = UIAlertController(title: "Внимание", message: "Вы не ввели название привычки!", preferredStyle: .alert)
                
                let actionOk = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alertController.addAction(actionOk)
                self.present(alertController, animated: true, completion: nil)
                return
            }
            
            let newHabit = Habit(name: nameHabitTextField.text ?? "",
                                 date: datepicker.date,
                                 color: colorPickerButton.backgroundColor ?? .customPurple)
            let store = HabitsStore.shared
            store.habits.append(newHabit)
            reloadingDataDelegate?.updCollection()
            dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func deleteButtonPressed() {
         
        let alertController = UIAlertController(title: "Удалить привычку?", message: "Вы хотите удалить привычку \(nameHabitLabel.text ?? "")", preferredStyle: .alert)
         
        let cancelAction = UIAlertAction(title: "Отмена", style: .default) {_ in
            alertController.dismiss(animated: true, completion: nil)
        }
         
        let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) { _ in
          if let habit = self.editingHabit, let index = HabitsStore.shared.habits.firstIndex(of: habit) {
            HabitsStore.shared.habits.remove(at: index)
             
            self.dismiss(animated: true, completion: nil)
            self.dismissingVCDelegate?.dismissViewController()
          }
        }
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        self.present(alertController, animated: true, completion: nil)
      }
    
    func setupEditingMode() {
        if isOnEditMode {
            if let habit = editingHabit {
                nameHabitTextField.text = habit.name
                nameHabitTextField.textColor = habit.color
                colorPickerButton.backgroundColor = habit.color
                datepickerLabel.textColor = habit.color
            }
        }
    }
}

extension HabitViewController {
    func setupView() {
        
        let navigBar = UINavigationBar()
        navigBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navigBar)

        let const = [
            navigBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigBar.heightAnchor.constraint(equalToConstant: 44),
            navigBar.widthAnchor.constraint(equalTo: view.widthAnchor)
        ]

        NSLayoutConstraint.activate(const)

        let navigItem = UINavigationItem()

        let leftBarButtonItem = UIBarButtonItem(title: "Отменить", style: UIBarButtonItem.Style.plain, target: self, action: #selector(actionCancelButton))
        let rightBarButtonItem = UIBarButtonItem(title: "Сохранить", style: UIBarButtonItem.Style.done, target: self, action: #selector(actionSaveButton))

        leftBarButtonItem.tintColor = .customPurple
        rightBarButtonItem.tintColor = .customPurple
        navigItem.rightBarButtonItem = rightBarButtonItem
        navigItem.leftBarButtonItem = leftBarButtonItem

        navigBar.setItems([navigItem], animated: true)
        navigBar.backgroundColor = .systemGray
        
        if isOnEditMode == false {
            navigItem.title = "Создать"
        } else {
            navigItem.title = "Править"
        }
        
        feedStack.addArrangedSubview(nameHabitLabel)
        feedStack.addArrangedSubview(nameHabitTextField)
        feedStack.addArrangedSubview(colorLabel)
        
        view.addSubview(feedStack)
        feedStack.setCustomSpacing(7.0, after: nameHabitLabel)
        feedStack.setCustomSpacing(15.0, after: nameHabitTextField)
 
        view.addSubview(colorPickerButton)
        view.addSubview(timeLabel)
        view.addSubview(habitTimeTextLabel)
        view.addSubview(datepicker)
        view.addSubview(datepickerLabel)
        
        
        let constraints = [
            feedStack.topAnchor.constraint(equalTo: navigBar.bottomAnchor, constant: 40),
            feedStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            feedStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 16),

            colorPickerButton.topAnchor.constraint(equalTo: feedStack.bottomAnchor, constant: 7),
            colorPickerButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            colorPickerButton.heightAnchor.constraint(equalToConstant: 30),
            colorPickerButton.widthAnchor.constraint(equalToConstant: 30),
            

            timeLabel.topAnchor.constraint(equalTo: colorPickerButton.bottomAnchor, constant: 15),
            timeLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            habitTimeTextLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 7),
            habitTimeTextLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            datepickerLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 7),
            datepickerLabel.leadingAnchor.constraint(equalTo: habitTimeTextLabel.trailingAnchor),
            
            datepicker.topAnchor.constraint(equalTo: habitTimeTextLabel.bottomAnchor, constant: 15),
            datepicker.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            datepicker.heightAnchor.constraint(equalToConstant: 216),
            datepicker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
            
        ]
        NSLayoutConstraint.activate(constraints)
        

        if isOnEditMode {
            view.addSubview(deleteHabitButton)
            
            let constrForButton = [
                deleteHabitButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -52),
                deleteHabitButton.heightAnchor.constraint(equalToConstant: 22),
                deleteHabitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ]
            NSLayoutConstraint.activate(constrForButton)
            }
    }
}


extension HabitViewController: UIColorPickerViewControllerDelegate {
    
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        let selectedColor = viewController.selectedColor
        colorPickerButton.backgroundColor = selectedColor
    }
}

extension HabitViewController {
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            scrollView.contentInset.bottom = keyboardSize.height
            scrollView.verticalScrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset.bottom = .zero
        scrollView.verticalScrollIndicatorInsets = .zero
    }
}

extension HabitViewController: UITextFieldDelegate {
    //Скрытие keyboard при нажатии за пределами TextField
    func setupHideKeyboardOnTap() {
        view.addGestureRecognizer(self.endEditingRecognizer())
        navigationController?.navigationBar.addGestureRecognizer(self.endEditingRecognizer())
    }
    
    private func endEditingRecognizer() -> UIGestureRecognizer {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(self.view.endEditing(_:)))
        tap.cancelsTouchesInView = false
        return tap
    }
    
    //Скрытие keyboard при нажатии клавиши Return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameHabitTextField.resignFirstResponder()
        return true
    }
}
