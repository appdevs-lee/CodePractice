//
//  AlertViewController.swift
//  CodePractice
//
//  Created by Awesomepia on 2023/07/12.
//

import UIKit
import Alamofire

final class AlertViewController: UIViewController {
    
    lazy var topView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var alarmCountLabel: UILabel = {
        let label = UILabel()
        label.text = "새 소식 0"
        label.font = UIFont(name: "PretendardVariable-Bold", size: 16)
        label.textColor = UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1)
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
        tableView.sectionHeaderTopPadding = 0
        tableView.register(AlertTableViewCell.self, forCellReuseIdentifier: "AlertTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
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
    
    var alarmModel = AlarmModel()
    var alarmList: [AlarmDetailItem] = []
    var isChangeStatus: Bool = false
    var alarmCount: Int = 0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setViewAfterTransition()
        
        self.loadAlarmListRequestAtBeginning() { alarmCount in
            self.alarmCount = alarmCount
            self.alarmCountLabel.text = "새 소식 \(alarmCount)"
        }
    }
    
    deinit {
            print("----------------------------------- AlertViewController is disposed -----------------------------------")
    }
}

// MARK: Extension for essential methods
extension AlertViewController: EssentialViewMethods {
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
        self.view.addSubview(self.deleteStackView)
        self.view.addSubview(self.tableView)
        
        self.topView.addSubview(self.alarmCountLabel)
        self.topView.addSubview(self.deleteButton)
    }
    
    func setLayouts() {
        let safeArea = self.view.safeAreaLayoutGuide
        
        // topView
        NSLayoutConstraint.activate([
            self.topView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            self.topView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            self.topView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            self.topView.bottomAnchor.constraint(equalTo: self.tableView.topAnchor),
            self.topView.heightAnchor.constraint(equalToConstant: 55)
        ])
        
        // alarmCountLabel
        NSLayoutConstraint.activate([
            self.alarmCountLabel.leadingAnchor.constraint(equalTo: self.topView.leadingAnchor, constant: 16),
            self.alarmCountLabel.centerYAnchor.constraint(equalTo: self.topView.centerYAnchor)
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
extension AlertViewController {
    func loadAlarmListRequest(lastNo: Int, success: ((AlarmItem) -> ())?, failure: ((String) -> ())) {
        self.alarmModel.loadAlarmListRequest(lastNo: lastNo) { alarmData in
            success?(alarmData)
            
        } failure: { errorMessage in
//            SupportingMethods.shared.checkExpiaration(errorMessage) {
//                failure?(errorMessage)
//            }
            
        }

    }
    
    func loadAlarmListRequestAtBeginning(completion: ((Int) -> ())?) {
//        SupportingMethods.shared.turnCoverView(.on)
        self.loadAlarmListRequest(lastNo: 0) { alarmData in
            self.alarmList = alarmData.alarmList
            
            self.tableView.reloadData()
            
//            if self.alarmList.isEmpty {
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
            print("loadAlarmlistRequestAtBeginning API Error: \(errorMessage)")
            
        }

    }
    
    func loadAlarmListRequest(lastNumber: Int) {
//        SupportingMethods.shared.turnCoverView(.on)
        self.loadAlarmListRequest(lastNo: lastNumber) { alarmData in
            self.alarmList.append(contentsOf: alarmData.alarmList)
            
            if !alarmData.alarmList.isEmpty {
                self.tableView.reloadData()
            }
            
//            if self.alarmList.isEmpty {
//                self.noDataStackView.isHidden = false
//            } else {
//                self.noDataStackView.isHidden = true
//            }
            
        } failure: { errorMessage in
//            SupportingMethods.shared.turnCoverView(.off)
            print("loadAlarmListRequest(lastNumber: ~) API Error: \(errorMessage)")
            
        }
    }
    
    func deleteAlarmRequest(alarmHistoryNo: Int, success: (() -> ())?, failure: ((String) -> ())?) {
        self.alarmModel.deleteAlarmRequest(alarmHistoryNo: alarmHistoryNo) {
            success?()
            
        } failure: { errorMessage in
//            SupportingMethods.shared.checkExpiaration(errorMessage) {
//                failure?(errorMessage)
//            }
        }

    }
    
    func deleteAllAlarmRequest(success: (() -> ())?, failure: ((String) -> ())?) {
        self.alarmModel.deleteAllAlarmRequest {
            success?()
            
        } failure: { errorMassage in
//            SupportingMethods.shared.checkExpiaration(errorMessage) {
//                failure?(errorMessage)
//            }
            
        }

    }
}

// MARK: - Extension for selector methods
extension AlertViewController {
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
        self.deleteAllAlarmRequest {
            self.loadAlarmListRequestAtBeginning { alarmCount in
                self.alarmCount = alarmCount
                self.alarmCountLabel.text = "새 소식 \(alarmCount)"
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
//                    SupportingMethods.shared.turnCoverView(.off)
                }
            }
        } failure: { error in
//            SupportingMethods.shared.turnCoverView(.off)
            print("allDeleteButton deleteAllAlarmRequest API Error: \(error)")
        }

        
        self.alarmList.removeAll()
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

// MARK: - Extension for UITableViewDelegate, UITableViewDataSource
extension AlertViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.alarmList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlertTableViewCell", for: indexPath) as! AlertTableViewCell
        cell.setCell(alarm: self.alarmList[indexPath.row])
        
        if self.isChangeStatus {
            cell.deleteButton.isHidden = false
            cell.timeLabel.isHidden = true
        } else {
            cell.deleteButton.isHidden = true
            cell.timeLabel.isHidden = false
        }
        
        cell.delegate = self
        cell.index = indexPath.row
        
        if indexPath.row == self.alarmList.count - 1 {
            self.loadAlarmListRequest(lastNumber: self.alarmList[indexPath.row].no)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alarm = self.alarmList[indexPath.row]
        
        let alarmKindsNo: Int = alarm.alarmKindsNo
        var contents: Int? = 0
        
        let data = alarm.alarmContents?.data(using: .utf8)
        if let data = data, let json = try? JSONDecoder().decode(AlarmContentsDetail.self, from: data) {
            contents = json.contentsNo
        }
        
        let contentsNo = contents ?? 0
        
//        switch alarmKindsNo {
//        case 1:
//            // 새 쪽지
//            print("쪽지 클릭됨")
//            let vc = ChatRoomListViewController()
//
//            self.navigationController?.pushViewController(vc, animated: true)
//        case 2:
//            // 새 피드
//            let vc = FeedDetailedViewController(feedNumber: contentsNo)
//
//            self.navigationController?.pushViewController(vc, animated: true)
//
////        case 3:
////            // 새 메이트
////
//        case 4:
//            // 여행지 댓글
//            let vc = TravelPlaceDetailedViewController(placeNumber: contentsNo)
//
//            self.navigationController?.pushViewController(vc, animated: true)
//        case 5:
//            // 여행지 대댓글
//            let vc = TravelPlaceDetailedViewController(placeNumber: contentsNo)
//
//            self.navigationController?.pushViewController(vc, animated: true)
//        case 6:
//            // 경로 댓글
//            let vc = TravelPathDetailedViewController(pathNumber: contentsNo)
//
//            self.navigationController?.pushViewController(vc, animated: true)
//        case 7:
//            // 경로 대댓글
//            let vc = TravelPathDetailedViewController(pathNumber: contentsNo)
//
//            self.navigationController?.pushViewController(vc, animated: true)
//        case 8:
//            // 피드 좋아요
//            let vc = FeedDetailedViewController(feedNumber: contentsNo)
//
//            self.navigationController?.pushViewController(vc, animated: true)
//        case 9:
//            // 피드 댓글
//            let vc = FeedDetailedViewController(feedNumber: contentsNo)
//
//            self.navigationController?.pushViewController(vc, animated: true)
//        case 10:
//            // 피드 대댓글
//            let vc = FeedDetailedViewController(feedNumber: contentsNo)
//
//            self.navigationController?.pushViewController(vc, animated: true)
//        case 11:
//            // 공지사항
//            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "") as? NoticeDetailViewController else { return }
//
//            vc.noteNo = contentsNo
//            self.navigationController?.pushViewController(vc, animated: true)
////        case 12:
////            // 점검
////
////        case 13:
////            // 이벤트
////
////        case 14:
////            // 인게임 초대
////
//        case 15:
//            // 가입 완료
//            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "MissionViewPagerViewController") else { return }
//
//            self.navigationController?.pushViewController(vc, animated: true)
////        case 16:
////            // 신고
////
////        case 17:
////            // 인게임 퀘스트 완료
////
//        case 18:
//            // 칭호
//            guard let vc = self.storyboard?.instantiateViewController(identifier: "EntitleViewController") as? EntitleViewController else { return }
//
//            self.navigationController?.pushViewController(vc, animated: true)
//        default:
//            // 이외
//            break
//        }
    }
}

extension AlertViewController: AlertDeleteDelegate {
    func alertDelete(index: Int) {
//        SupportingMethods.shared.turnCoverView(.on)
        self.deleteAlarmRequest(alarmHistoryNo: self.alarmList[index].alarmHistoryNo) {
            self.alarmList.remove(at: index)
            self.alarmCount -= 1
            self.alarmCountLabel.text = "새 소식 \(self.alarmCount)"
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
//                SupportingMethods.shared.turnCoverView(.off)
            }
        } failure: { error in
//            SupportingMethods.shared.turnCoverView(.off)
            print("alertDelete deleteAlarmRequest API Error: \(error)")
        }
    }
}
