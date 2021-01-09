//
//  TodoListViewController.swift
//  Todolist
//
//  Created by 이정환 on 2020/12/26.
//

import UIKit
//import EventKitUI

class TodoListViewController: UIViewController {
    
    @IBOutlet weak var InputTextFieldLb: UITextField!
    @IBOutlet weak var TodayLb: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var inputViewBottom: NSLayoutConstraint!
    @IBOutlet var collectionViewBottom: NSLayoutConstraint!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var isTodayButton: UIButton!
    @IBOutlet weak var addButton: UIButton!

    var deleteButtonTapHandler: (() -> Void)?
    let todoListViewModel = TodoViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillHideNotification, object: nil)
        todoListViewModel.loadTasks()
        
        let attributes = [NSAttributedString.Key.foregroundColor:UIColor.label, NSAttributedString.Key.font:UIFont(name: "Verdana-bold", size: 25)]
        self.navigationController?.navigationBar.titleTextAttributes = attributes as [NSAttributedString.Key : Any]
        
        //다크모드
        let plist = UserDefaults.standard
        let segMode = plist.integer(forKey: "segMode")
        if segMode == 0 {
            UIApplication.shared.windows.forEach { window in
                window.overrideUserInterfaceStyle = .unspecified
            }
        } else if segMode == 1 {
            UIApplication.shared.windows.forEach { window in
                window.overrideUserInterfaceStyle = .light
            }
        } else {
            UIApplication.shared.windows.forEach { window in
                window.overrideUserInterfaceStyle = .dark
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView.reloadData()
        
        let plist = UserDefaults.standard
        if plist.bool(forKey: "KorOn") == true {
            InputTextFieldLb.placeholder = "오늘의 할일은?"
            TodayLb.setTitle("오늘", for: TodayLb.state)
        }else {
            InputTextFieldLb.placeholder = "I want to..."
            //TodayLb.titleLabel?.text = "today"
            TodayLb.setTitle("today", for: TodayLb.state)
        }
    }
    
    @IBAction func isTodayButtonTapped(_ sender: Any) {
        isTodayButton.isSelected = !isTodayButton.isSelected
    }
    
    @IBAction func addTaskButtonTapped(_ sender: Any) {
        guard let detail = inputTextField.text, detail.isEmpty == false else { return }
        let todo = TodoManager.shared.createTodo(detail: detail, isToday: isTodayButton.isSelected)
        todoListViewModel.addTodo(todo)
        collectionView.reloadData()
        inputTextField.text = ""

        if isTodayButton.isSelected { //숫자 적용이 맞는지....
            let item = self.collectionView(self.collectionView, numberOfItemsInSection: 0) - 1
            let lastItemIndex = IndexPath(item: item, section: 0)
            self.collectionView.scrollToItem(at: lastItemIndex, at: .top, animated: true)
        } else {
            let item = self.collectionView(self.collectionView, numberOfItemsInSection: 1) - 1
            let lastItemIndex = IndexPath(item: item, section: 1)
            self.collectionView.scrollToItem(at: lastItemIndex, at: .top, animated: true)
        }
    }

    @IBAction func tapBG(_ sender: Any) {
        inputTextField.resignFirstResponder()
    }
}

extension TodoListViewController {
    @objc private func adjustInputView(noti: Notification) {
        guard let userInfo = noti.userInfo else { return }
        guard let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }

        if noti.name == UIResponder.keyboardWillShowNotification {
            let adjustmentHeight = keyboardFrame.height - view.safeAreaInsets.bottom
            inputViewBottom.constant = adjustmentHeight
            collectionViewBottom.constant = 60 + adjustmentHeight
           
            if isTodayButton.isSelected {
                let item = self.collectionView(self.collectionView, numberOfItemsInSection: 0) - 1
                let lastItemIndex = IndexPath(item: item, section: 0)
                self.collectionView.scrollToItem(at: lastItemIndex, at: .top, animated: true)
            } else {
                let item = self.collectionView(self.collectionView, numberOfItemsInSection: 1) - 1
                let lastItemIndex = IndexPath(item: item, section: 1)
                self.collectionView.scrollToItem(at: lastItemIndex, at: .top, animated: true)
            }
        } else {
            inputViewBottom.constant = 0
            collectionViewBottom.constant = 60
        }
    }
}

extension TodoListViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return todoListViewModel.numOfSection
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return todoListViewModel.todayTodos.count
        } else {
            return todoListViewModel.upcompingTodos.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
           return UIEdgeInsets(top: 5, left: 0, bottom: 20, right: 0)
        }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TodoListCell", for: indexPath) as? TodoListCell else {
            return UICollectionViewCell()
        }
        var todo: Todo
        if indexPath.section == 0 {
            todo = todoListViewModel.todayTodos[indexPath.item]
        } else {
            todo = todoListViewModel.upcompingTodos[indexPath.item]
        }
        cell.updateUI(todo: todo)
        cell.doneButtonTapHandler = { isDone in
            todo.isDone = isDone
            self.todoListViewModel.updateTodo(todo)
            self.collectionView.reloadData()
        }
        cell.deleteButtonTapHandler = {
            let alert = UIAlertController(title: "알람", message: "지우시겠습니까?", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "삭제", style: .destructive) { (_) in
                self.todoListViewModel.deleteTodo(todo)
                self.collectionView.reloadData()
            }
            let cancelAction = UIAlertAction(title: "취소", style: .default, handler: nil)
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
        cell.tradeButtonTapHandler = {
            self.todoListViewModel.editTodo(todo)
            self.collectionView.reloadData()
        }
        cell.designMyCell()
        
        guard self.traitCollection.userInterfaceStyle != .dark else { return cell }
        cell.contentView.layer.cornerRadius = 4.0
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = false
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width:0, height: 1.0)
        cell.layer.shadowRadius = 4.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "TodoListHeaderView", for: indexPath) as? TodoListHeaderView else {
                return UICollectionReusableView()
            }
            guard let section = TodoViewModel.Section(rawValue: indexPath.section) else {
                return UICollectionReusableView()
            }
            header.sectionTitleLabel.text = section.title
            return header
        default:
            return UICollectionReusableView()
        }
    }
}

extension TodoListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = collectionView.bounds.width * 0.9
        let height: CGFloat = 45
        return CGSize(width: width, height: height)
    }
}

class TodoListCell: UICollectionViewCell {
    
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var strikeThroughView: UIView!
    @IBOutlet weak var strikeThroughWidth: NSLayoutConstraint!
    @IBOutlet var tradeButton: UIButton!
    
    var tradeButtonTapHandler: (() -> Void)?
    var doneButtonTapHandler: ((Bool) -> Void)?
    var deleteButtonTapHandler: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        reset()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        reset()
    }
    
    func updateUI(todo: Todo) {
        checkButton.isSelected = todo.isDone
        descriptionLabel.text = todo.detail
        descriptionLabel.alpha = todo.isDone ? 0.2 : 1
        deleteButton.isHidden = todo.isDone == false
        tradeButton.isSelected = todo.isToday
        tradeButton.isHidden = todo.isDone == true
        showStrikeThrough(todo.isDone)
    }
    
    private func showStrikeThrough(_ show: Bool) {
        if show {
            strikeThroughWidth.constant = descriptionLabel.bounds.width
        } else {
            strikeThroughWidth.constant = 0
        }
    }
    
    func reset() {
        descriptionLabel.alpha = 1
        deleteButton.isHidden = true
        tradeButton.isHidden = false
        showStrikeThrough(false)
    }
    
    @IBAction func checkButtonTapped(_ sender: Any) {
        checkButton.isSelected = !checkButton.isSelected
        let isDone = checkButton.isSelected
        showStrikeThrough(isDone)
        descriptionLabel.alpha = isDone ? 0.2 : 1
        deleteButton.isHidden = !isDone
        tradeButton.isHidden = !isDone
        doneButtonTapHandler?(isDone)
    }
    
    @IBAction func tradeButtonTapped(_ sender: Any) {
        tradeButtonTapHandler?()
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        deleteButtonTapHandler?()
    }
}

class TodoListHeaderView: UICollectionReusableView {
    
    @IBOutlet weak var sectionTitleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
 
extension UIView {
    func designMyCell(){
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.masksToBounds = true
    }
}

 


