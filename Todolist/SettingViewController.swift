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
       
        let attributes = [NSAttributedString.Key.foregroundColor:UIColor.label, NSAttributedString.Key.font:UIFont(name: "Verdana-bold", size: 25)]
        self.navigationController?.navigationBar.titleTextAttributes = attributes as [NSAttributedString.Key : Any]
       
        let plist = UserDefaults.standard
        timeText.text = plist.string(forKey: "timeAlert")
        TimeAlert.isOn = plist.bool(forKey: "alertOn")
        createDatePicker()
        Language.isOn = plist.bool(forKey: "KorOn")
        updateKor()
        
        
        segMode.selectedSegmentIndex = plist.integer(forKey: "segMode")
        if segMode.selectedSegmentIndex == 0 {
            UIApplication.shared.windows.first?.overrideUserInterfaceStyle = UIUserInterfaceStyle.unspecified
        } else if segMode.selectedSegmentIndex == 1 {
            UIApplication.shared.windows.first?.overrideUserInterfaceStyle = UIUserInterfaceStyle.light
        } else {
            UIApplication.shared.windows.first?.overrideUserInterfaceStyle = UIUserInterfaceStyle.dark
        }
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        Version.text = appVersion
        
    }
    
    func createDatePicker() {
       
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneBtn], animated: true)
        doneBtn.tintColor = UIColor.label
        timeText.inputAccessoryView = toolbar
        timeText.inputView = datePicker
        datePicker.datePickerMode = .time
        datePicker.preferredDatePickerStyle = .wheels
    }
    
    @objc func donePressed() {
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
       
        let value = sender.isOn
        let plist = UserDefaults.standard
        plist.set(value, forKey: "alertOn")
        plist.synchronize()
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
            UIApplication.shared.windows.first?.overrideUserInterfaceStyle = UIUserInterfaceStyle.unspecified
        } else if sender.selectedSegmentIndex == 1 {
            UIApplication.shared.windows.first?.overrideUserInterfaceStyle = UIUserInterfaceStyle.light
         } else {
            UIApplication.shared.windows.first?.overrideUserInterfaceStyle = UIUserInterfaceStyle.dark
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
        guard let path = URL(string: url) else { return }
        UIApplication.shared.open(path, options: [:], completionHandler: nil)
    }
    
    // MARK: GADRewardedAdDelegate
    func rewardedAd(_ rewardedAd: GADRewardedAd, userDidEarn reward: GADAdReward) {
        print("Reward received with currency: \(reward.type), amount \(reward.amount).")
    }
    func rewardedAdDidPresent(_ rewardedAd: GADRewardedAd) {
        print("Rewarded ad presented.")
    }
    func rewardedAdDidDismiss(_ rewardedAd: GADRewardedAd) {
        print("Rewarded ad dismissed.")
    }
    func rewardedAd(_ rewardedAd: GADRewardedAd, didFailToPresentWithError error: Error) {
      print("Rewarded ad failed to present.")
    }
}

