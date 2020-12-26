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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        TimeAlert.isOn = isOn
        
    }
    
    @IBAction func AlertOnOff(_ sender: UISwitch) {
        if sender.isOn {
            self.setNotification()
        } else {
           
            //초기화값 넣기
            isOn = false
        }
    }
    
    func setNotification(){
           let manager = LocalNotificationManager()
           manager.requestPermission()
           manager.addNotification(title: "This is a test reminder")
           manager.scheduleNotifications()
       }
    
}

