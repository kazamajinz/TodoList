//
//  SettingViewController.swift
//  Todolist
//
//  Created by 이정환 on 2020/12/26.
//

import UIKit
import GoogleMobileAds

class SettingViewController: UITableViewController, GADRewardedAdDelegate{
    
    /// Is an ad being loaded.
    var adRequestInProgress = false

    /// The rewarded video ad.
    var rewardedAd: GADRewardedAd?
    
    
    @IBOutlet weak var ManualLb: UILabel!
    @IBOutlet weak var ThanksLb: UILabel!
    @IBOutlet weak var VersionLb: UILabel!
    @IBOutlet weak var TimeAletLb: UILabel!
    @IBOutlet weak var TimeSelectLb: UILabel!
    @IBOutlet weak var DarkModeLb: UILabel!
    @IBOutlet weak var LanguageLb: UILabel!
    
    
    
    @IBOutlet weak var Version: UILabel!
    
    @IBOutlet weak var TimeAlert: UISwitch!
    
    @IBOutlet weak var timeText: UITextField!
    
    @IBOutlet weak var segMode: UISegmentedControl!
    
    @IBOutlet weak var Language: UISwitch!
    
    let datePicker = UIDatePicker()
    
    let defaults = UserDefaults.standard
    let alertOn = "alertOn"
    // let dateAlertKey = "dateAlertKey"
    let hourAlert = "hourAlert"
    let minuteAlert = "minuteAlert"
    let timeAlert = "timeAlert"
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        rewardedAd = GADRewardedAd(adUnitID: "ca-app-pub-8496395555121734/4339892030")
        rewardedAd?.load(GADRequest())
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rewardedAd = GADRewardedAd(adUnitID: "ca-app-pub-8496395555121734/4339892030")
        rewardedAd?.load(GADRequest())
        
        self.tableView.rowHeight = 44
        
        //   setupView()
        
        let plist = UserDefaults.standard
        
        let attributes = [NSAttributedString.Key.foregroundColor:UIColor.label, NSAttributedString.Key.font:UIFont(name: "Verdana-bold", size: 25)]
                self.navigationController?.navigationBar.titleTextAttributes = attributes as [NSAttributedString.Key : Any]
        
        timeText.text = plist.string(forKey: "timeAlert")
        
        createDatePicker()
        
        TimeAlert.isOn = plist.bool(forKey: "alertOn")
        
        Language.isOn = plist.bool(forKey: "KorOn")
        
        updateKor()
        
        
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
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        
        Version.text = appVersion
        
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
    
    
    
    @IBAction func LanguageOnOff(_ sender: UISwitch) {
        let value = sender.isOn
        let plist = UserDefaults.standard
        plist.set(value, forKey: "KorOn")
        plist.synchronize() // 동기화 처리
        
        updateKor()
        
    }
    
    func updateKor() {
        let plist = UserDefaults.standard
        if plist.bool(forKey: "KorOn") == true {
            ManualLb.text = "설명서"
            ThanksLb.text = "감사인사"
            VersionLb.text = "앱 버전"
            TimeAletLb.text = "시간알림"
            TimeSelectLb.text = "시간설정"
            DarkModeLb.text = "다크모드"
            LanguageLb.text = "영어 -> 한국어"
        }else {
            ManualLb.text = "Manuals"
            ThanksLb.text = "Thanks to"
            VersionLb.text = "App Version"
            TimeAletLb.text = "TimeAlert"
            TimeSelectLb.text = "TimeSelect"
            DarkModeLb.text = "DarkMode"
            LanguageLb.text = "Eng -> Kor"
        }
    }
    

    
    @IBAction func adClick(_ sender: Any) {
       
        rewardedAd?.present(fromRootViewController: self, delegate: self)
          rewardedAd = GADRewardedAd(adUnitID: "ca-app-pub-8496395555121734/4339892030")
          rewardedAd?.load(GADRequest())
    }
    
    
    @IBAction func review(_ sender: Any) {
        let appleID = "1546963564"
        let url = "https://itunes.apple.com/app/id\(appleID)?action=write-review"
        if let path = URL(string: url) {
                UIApplication.shared.open(path, options: [:], completionHandler: nil)
        }
    }
    
    // MARK: GADRewardedAdDelegate
    func rewardedAd(_ rewardedAd: GADRewardedAd, userDidEarn reward: GADAdReward) {
    }

    func rewardedAdDidPresent(_ rewardedAd: GADRewardedAd) {
    }

    func rewardedAdDidDismiss(_ rewardedAd: GADRewardedAd) {
    }

}

