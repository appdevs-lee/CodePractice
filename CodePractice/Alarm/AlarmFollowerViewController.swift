//
//  AlarmFollowerViewController.swift
//  CodePractice
//
//  Created by Awesomepia on 2023/07/19.
//

import UIKit

final class AlarmFollowerViewController: UIViewController {
    
    lazy var topView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var followerCountLabel: UILabel = {
        let label = UILabel()
        label.text = "새 팔로워 0"
        label.textColor = UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1)
        label.font = UIFont(name: "PretendardVariable-Bold", size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont(name: "PretendardVariable-Medium", size: 16)
        button.setTitle("삭제", for: .normal)
        button.setTitleColor(UIColor(red: 131/255, green: 164/255, blue: 245/255, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(changeStatusButton(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    lazy var deleteStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [allDeleteButton, centerView, cancleButton])
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.distribution = .fill
        stackView.isHidden = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    lazy var allDeleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("전체삭제", for: .normal)
        button.setTitleColor(UIColor(red: 158/255, green: 158/255, blue: 158/255, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont(name: "PretendardVariable-Medium", size: 16)
        button.addTarget(self, action: #selector(allDeleteButton(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    lazy var centerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 158/255, green: 158/255, blue: 158/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var cancleButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont(name: "PretendardVariable-Medium", size: 16)
        button.setTitle("취소", for: .normal)
        button.setTitleColor(UIColor(red: 131/255, green: 164/255, blue: 245/255, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(cancleButton(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.bounces = false
        tableView.showsVerticalScrollIndicator = false
        tableView.register(AlarmFollowerTableViewCell.self, forCellReuseIdentifier: "AlarmFollowerTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.sectionHeaderTopPadding = 0
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    var alarmModel = AlarmModel()
    var followerList: [AlarmDetailItem] = []
    var followerCount: Int = 0
    var isChangeStatus: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setViewFoundation()
        self.initializeObjects()
        self.setDelegates()
        self.setGestures()
        self.setNotificationCenters()
        self.setSubviews()
        self.setLayouts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setViewAfterTransition()
        
        self.loadAlarmFollowerListRequestAtBeginning { followerCnt in
            self.followerCount = followerCnt
            self.followerCountLabel.text = "새 팔로워 \(followerCnt)"
        }
    }
    
    deinit {
            print("----------------------------------- TemplateViewController is disposed -----------------------------------")
    }
}

// MARK: Extension for essential methods
extension AlarmFollowerViewController: EssentialViewMethods {
    func setViewFoundation() {
        
    }
    
    func initializeObjects() {
        
    }
    
    func setDelegates() {
        
    }
    
    func setGestures() {
        
    }
    
    func setNotificationCenters() {
        
    }
    
    func setSubviews() {
        self.view.addSubview(self.topView)
        self.view.addSubview(self.tableView)
        
        self.topView.addSubview(self.followerCountLabel)
        self.topView.addSubview(self.deleteButton)
        self.topView.addSubview(self.deleteStackView)
    }
    
    func setLayouts() {
        let safeArea = self.view.safeAreaLayoutGuide
        
        // topView
        NSLayoutConstraint.activate([
            self.topView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            self.topView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            self.topView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            self.topView.bottomAnchor.constraint(equalTo: self.tableView.topAnchor),
            self.topView.heightAnchor.constraint(equalToConstant: 55)
        ])
        
        // followerCountLabel
        NSLayoutConstraint.activate([
            self.followerCountLabel.leadingAnchor.constraint(equalTo: self.topView.leadingAnchor, constant: 16),
            self.followerCountLabel.centerYAnchor.constraint(equalTo: self.topView.centerYAnchor)
        ])
        
        // deleteButton
        NSLayoutConstraint.activate([
            self.deleteButton.trailingAnchor.constraint(equalTo: self.topView.trailingAnchor, constant: -16),
            self.deleteButton.centerYAnchor.constraint(equalTo: self.topView.centerYAnchor)
        ])
        
        // deleteStackView
        NSLayoutConstraint.activate([
            self.deleteStackView.trailingAnchor.constraint(equalTo: self.topView.trailingAnchor, constant: -16),
            self.deleteStackView.centerYAnchor.constraint(equalTo: self.topView.centerYAnchor)
        ])
        
        // centerView
        NSLayoutConstraint.activate([
            self.centerView.widthAnchor.constraint(equalToConstant: 1),
            self.centerView.heightAnchor.constraint(equalToConstant: 19)
        ])
        
        // tableView
        NSLayoutConstraint.activate([
            self.tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    func setViewAfterTransition() {
        //self.navigationController?.setNavigationBarHidden(false, animated: true)
        //self.tabBarController?.tabBar.isHidden = false
    }
}

// MARK: - Extension for methods added
extension AlarmFollowerViewController {
    func loadAlarmFollowerListRequest(lastNo: Int, success: ((AlarmItem) -> ())?, failure: ((String) -> ())) {
        self.alarmModel.loadAlarmFollowerListRequest(lastNo: lastNo) { alarmData in
            success?(alarmData)
            
        } failure: { errorMessage in
//            SupportingMethods.shared.checkExpiaration(errorMessage) {
//                failure?(errorMessage)
//            }
            
        }

    }
    
    func loadAlarmFollowerListRequestAtBeginning(completion: ((Int) -> ())?) {
//        SupportingMethods.shared.turnCoverView(.on)
        self.loadAlarmFollowerListRequest(lastNo: 0) { alarmData in
            self.followerList = alarmData.alarmList
            
            self.tableView.reloadData()
            
//            if self.followerList.isEmpty {
//                self.noDataStackView.isHidden = false
//            } else {
//                self.noDataStackView.isHidden = true
//            }
            
            DispatchQueue.main.async {
//                SupportingMethods.shared.turnCoverView(.off)
                completion?(alarmData.alarmCnt)
            }
            
        } failure: { errorMessage in
//            SupportingMethods.shared.turnCoverView(.off)
            print("loadAlarmFollowerListRequestAtBeginning API Error: \(errorMessage)")
            
        }

    }
    
    func loadAlarmFollowerListRequest(lastNumber: Int) {
//        SupportingMethods.shared.turnCoverView(.on)
        self.loadAlarmFollowerListRequest(lastNo: lastNumber) { alarmData in
            self.followerList.append(contentsOf: alarmData.alarmList)
            
            if !alarmData.alarmList.isEmpty {
                self.tableView.reloadData()
            }
            
//            if self.followerList.isEmpty {
//                self.noDataStackView.isHidden = false
//            } else {
//                self.noDataStackView.isHidden = true
//            }
            
        } failure: { errorMessage in
//            SupportingMethods.shared.turnCoverView(.off)
            print("loadAlarmFollowerListRequest(lastNumber: ~) API Error: \(errorMessage)")
            
        }
    }
    
    func deleteFollowerRequest(alarmHistoryNo: Int, success: (() -> ())?, failure: ((String) -> ())?) {
        self.alarmModel.deleteFollowerRequest(alarmHistoryNo: alarmHistoryNo) {
            success?()
            
        } failure: { errorMessage in
//            SupportingMethods.shared.checkExpiaration(errorMessage) {
//                failure?(errorMessage)
//            }
        }

    }
    
    func deleteAllFollowerRequest(success: (() -> ())?, failure: ((String) -> ())?) {
        self.alarmModel.deleteAllFollowerRequest {
            success?()
            
        } failure: { errorMassage in
//            SupportingMethods.shared.checkExpiaration(errorMessage) {
//                failure?(errorMessage)
//            }
            
        }

    }
}

// MARK: - Extension for selector methods
extension AlarmFollowerViewController {
    @objc func changeStatusButton(_ sender: UIButton) {
        self.deleteStackView.isHidden = false
        self.deleteButton.isHidden = true
        
        self.isChangeStatus = true
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @objc func cancleButton(_ sender: UIButton) {
        self.deleteStackView.isHidden = true
        self.deleteButton.isHidden = false
        
        self.isChangeStatus = false
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @objc func allDeleteButton(_ sender: UIButton) {
//        SupportingMethods.shared.turnCoverView(.on)
        self.deleteAllFollowerRequest {
            self.loadAlarmFollowerListRequestAtBeginning { followerCnt in
                self.followerCount = followerCnt
                self.followerCountLabel.text = "새 팔로워 \(followerCnt)"
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
//                    SupportingMethods.shared.turnCoverView(.off)
                }
            }
        } failure: { error in
//            SupportingMethods.shared.turnCoverView(.off)
            print("allDeleteButton deleteAllAlarmRequest API Error: \(error)")
        }
        
        self.followerList.removeAll()
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

// MARK: - Extension for UITableViewDelegate, UITableViewDataSource
extension AlarmFollowerViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.followerList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlarmFollowerTableViewCell", for: indexPath) as! AlarmFollowerTableViewCell
        cell.setCell(follower: self.followerList[indexPath.row])
        
        if self.isChangeStatus {
            cell.deleteButton.isHidden = false
            cell.followButton.isHidden = true
        } else {
            cell.deleteButton.isHidden = true
            cell.followButton.isHidden = false
        }
        
        cell.delegate = self
        cell.index = indexPath.row
        
        if indexPath.row == self.followerList.count - 1 {
            self.loadAlarmFollowerListRequest(lastNumber: self.followerList[indexPath.row].no)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension AlarmFollowerViewController: AlertFollowerDeleteDelegate {
    func alertFollowerDelete(index: Int) {
        let detail = self.followerList[index]
        
//        SupportingMethods.shared.turnCoverView(.on)
        self.deleteFollowerRequest(alarmHistoryNo: detail.alarmHistoryNo) {
            self.followerList.remove(at: index)
            
            if detail.followingYn == "N" {
                self.followerCountLabel.text = "새 팔로워 \(self.followerCount - 1)"
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
//                SupportingMethods.shared.turnCoverView(.off)
            }
        } failure: { errorMessage in
//            SupportingMethods.shared.checkExpiration(errorMessage: errorMessage) {
//                SupportingMethods.shared.turnCoverView(.off)
//            }
        }
    }
}
