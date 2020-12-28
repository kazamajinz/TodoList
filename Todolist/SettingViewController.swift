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
    let dateAlertKey = "dateAlertKey"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        let attributes = [NSAttributedString.Key.foregroundColor:UIColor.label, NSAttributedString.Key.font:UIFont(name: "Verdana-bold", size: 25)]
                self.navigationController?.navigationBar.titleTextAttributes = attributes as [NSAttributedString.Key : Any]
        
        /*
        overrideUserInterfaceStyle = .light     //라이트모드
        overrideUserInterfaceStyle = .dark    //다크모드
         */
        // Do any additional setup after loading the view.
        createDatePicker()
      
        if let isOn = defaults.value(forKey: alertOn) {
           TimeAlert.isOn = isOn as! Bool
            self.setNotification()
        }
 /*
        if let dateAlert = defaults.array(forKey: dateAlertKey) {
            timeText.text = dateAlert as! array
        }
   */
        
        
    }
    
    func createDatePicker() {
        // toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        // bar button
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneBtn], animated: true)
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
        print(hourAlert)
        print(minuteAlert)
        
        
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
            
            case 0: overrideUserInterfaceStyle = .unspecified
                    
            case 1:   overrideUserInterfaceStyle = .light
                    
            case 2:   overrideUserInterfaceStyle = .dark
                
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

