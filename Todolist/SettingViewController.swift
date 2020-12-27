//
//  SettingViewController.swift
//  Todolist
//
//  Created by 이정환 on 2020/12/26.
//

import UIKit

class SettingViewController: UITableViewController {

    
    var isOn = false
    
    @IBOutlet weak var TimeAlert: UISwitch!
    
    @IBOutlet weak var timeText: UITextField!
    
     @IBOutlet weak var darkModeToggle: UISegmentedControl!
    
    
    let datePicker = UIDatePicker()
    
    let defaults = UserDefaults.standard
    let alertOn = "alertOn"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()

        // Do any additional setup after loading the view.
        createDatePicker()
      
        if let isOn = defaults.value(forKey: alertOn) {
           TimeAlert.isOn = isOn as! Bool
            self.setNotification()
        }
 
        self.setNotification()
    }
    
    func createDatePicker() {
        // toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        // bar button
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneBtn], animated: true)
        
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
        /*
        let dateAlert = formatter.dateFormat
        defaults.set(dateAlert, forKey: alertOn)
        */
        
        /*
        let hourFormatter = DateFormatter()
        hourFormatter.dateFormat = "HH"
        let minuteFormatter = DateFormatter()
        minuteFormatter.dateFormat = "mm"
        let hourAlert = hourFormatter.string(from: datePicker.date)
        let minuteAlert = minuteFormatter.string(from: datePicker.date)
        print(hourAlert)
        print(minuteAlert)
        */
        
        timeText.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @IBAction func AlertOnOff(_ sender: UISwitch) {
        defaults.set(sender.isOn, forKey: alertOn)
        if sender.isOn {
            isOn = true
            self.setNotification()
            
        } else {
           
            //초기화값 넣기
            isOn = false
        }
    }
    func setNotification(){
       
        let todoListViewModel = TodoViewModel()
        let todayCount = todoListViewModel.todayTodos.count
        let manager = LocalNotificationManager()
       
        if todayCount == 0 {
            manager.addNotification(title: "오늘의 할일을 등록해주세요.")
        } else {
            manager.addNotification(title: "오늘의 할일 진행상황 😎")
        }
        
        manager.schedule()
    }
    
    
    func setupView() {
        setupDarkModeToggle()
    }
    
    func setupDarkModeToggle() {
        darkModeToggle.addTarget(self, action: #selector(darkModeAction), for: .touchUpInside)
    }
    
    @objc func darkModeAction() {
        switch darkModeToggle.selectedSegmentIndex {
            
        case 0: view.backgroundColor = .black
                    
            case 1: view.backgroundColor = .red
                    
            case 2: view.backgroundColor = .blue
                
            default: return
        }
    }
    
    /*
    func saveAllData() {
        UserDefaults.standard.set("hohyeon", forKey: "userID")
    }
    
    func loadAllData() {
      
    }
    */
}

