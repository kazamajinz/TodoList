//
//  SettingViewController.swift
//  Todolist
//
//  Created by 이정환 on 2020/12/26.
//

import UIKit

class SettingViewController: UITableViewController {
    
    @IBOutlet weak var TimeAlert: UISwitch!
    
    @IBOutlet weak var timeText: UITextField!
    
    @IBOutlet weak var segMode: UISegmentedControl!
    
    
    let datePicker = UIDatePicker()
    
    let defaults = UserDefaults.standard
    let alertOn = "alertOn"
    // let dateAlertKey = "dateAlertKey"
    let hourAlert = "hourAlert"
    let minuteAlert = "minuteAlert"
    let timeAlert = "timeAlert"
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        
        self.tableView.rowHeight = 44
        
        //   setupView()
        
        let plist = UserDefaults.standard
        
        let attributes = [NSAttributedString.Key.foregroundColor:UIColor.label, NSAttributedString.Key.font:UIFont(name: "Verdana-bold", size: 25)]
                self.navigationController?.navigationBar.titleTextAttributes = attributes as [NSAttributedString.Key : Any]
        
        timeText.text = plist.string(forKey: "timeAlert")
        
        createDatePicker()
        
        TimeAlert.isOn = plist.bool(forKey: "alertOn")
        
        segMode.selectedSegmentIndex = plist.integer(forKey: "segMode")
        
        if segMode.selectedSegmentIndex == 0 {
            UIApplication.shared.windows.forEach { window in
                window.overrideUserInterfaceStyle = .unspecified
            }
        }else if segMode.selectedSegmentIndex == 1 {
            UIApplication.shared.windows.forEach { window in
                window.overrideUserInterfaceStyle = .light
            }
        }else{
            UIApplication.shared.windows.forEach { window in
                window.overrideUserInterfaceStyle = .dark
            }
        }
}
    
    func createDatePicker() {
        // toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        
        
        // bar button
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneBtn], animated: true)
        
        doneBtn.tintColor = UIColor.label
        
        
      //  defaults.set([doneBtn], forKey: dateAlertKey)
        
       // UserDefaults.standard.set([doneBtn], forKey: "dateAlertKey")
        
        // assign toolbar
        timeText.inputAccessoryView = toolbar
        
        // assign date picker to the text field
        timeText.inputView = datePicker
        
        //date picker mode
        datePicker.datePickerMode = .time
        datePicker.preferredDatePickerStyle = .wheels
    }
    
    @objc func donePressed() {
        // formatter
        
        let formatter = DateFormatter()
        formatter.dateFormat = "hh : mm a"
        
        let hourFormatter = DateFormatter()
        hourFormatter.dateFormat = "HH"
        
        let minuteFormatter = DateFormatter()
        minuteFormatter.dateFormat = "mm"
        
        let hourAlert = hourFormatter.string(from: datePicker.date)
        let minuteAlert = minuteFormatter.string(from: datePicker.date)
        let timeAlert = formatter.string(from: datePicker.date)
        
        
        let plist = UserDefaults.standard
        plist.set(hourAlert, forKey: "hourAlert")
        plist.set(minuteAlert, forKey: "minuteAlert")
        plist.set(timeAlert, forKey: "timeAlert")
        plist.synchronize()
        
        timeText.text = timeAlert
        self.view.endEditing(true)
        
        updateNoti()
        
    }
    
    @IBAction func tapBG(_ sender: Any) {
        timeText.resignFirstResponder()
    }
    
    
    @IBAction func AlertOnOff(_ sender: UISwitch) {
       
        let value = sender.isOn // true면 기혼, false면 미혼
        
        let plist = UserDefaults.standard // 기본 저장소 객체를 가져온다.
        plist.set(value, forKey: "alertOn") // "married"라는 키로 값을 저장한다.
        plist.synchronize() // 동기화 처리
        
        updateNoti()
    }
    
    func updateNoti() {
        let plist = UserDefaults.standard
        let manager = LocalNotificationManager()
        if plist.bool(forKey: "alertOn") == true {
            manager.deleteNotifications()
            setNotification()
        }else {
            manager.deleteNotifications()
        }
    }
    
    func setNotification(){
       
        let todoListViewModel = TodoViewModel()
        let todayCount = todoListViewModel.todayTodos.count
        let manager = LocalNotificationManager()
       
        if todayCount == 0 {
            manager.deleteNotifications()
            manager.addNotification(title: "오늘의 할일을 등록해주세요.")
        } else {
            manager.deleteNotifications()
            manager.addNotification(title: "오늘의 할일 진행상황 😎")
        }
        
        manager.schedule()
        
        let todayDetail = todoListViewModel.todayTodos
        //print(todayDetail)
        for id in todayDetail {
            print("id는 \(id) 입니다")
        }
        
    }


    @IBAction func segue(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            UIApplication.shared.windows.forEach { window in
                window.overrideUserInterfaceStyle = .unspecified
            }
        }else if sender.selectedSegmentIndex == 1 {
            UIApplication.shared.windows.forEach { window in
                window.overrideUserInterfaceStyle = .light
            }
        }else{
            UIApplication.shared.windows.forEach { window in
                window.overrideUserInterfaceStyle = .dark
            }
        }
        
        let plist = UserDefaults.standard
        let value = sender.selectedSegmentIndex
        plist.set(value, forKey: "segMode")
        plist.synchronize()
        
    }
    
}

