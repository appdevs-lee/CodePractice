//
//  SupportingMethods.swift
//  Universal
//
//  Created by Yongseok Choi on 2023/04/04.
//

import UIKit
import PhotosUI
import Alamofire

enum PickerType {
    case image
    case video
}

enum CoverViewState {
    case on
    case off
}

enum ReceivedContentType {
    case feed
    case place
    case path
    case live
}

class SupportingMethods {
    private(set) var receivedContent: (contentType: ReceivedContentType, contentNumber: Int)?
    
    private var notiAnimator: UIViewPropertyAnimator?
    private var notiViewBottomAnchor: NSLayoutConstraint!
    private var notiTitleLabelTrailingAnchor: NSLayoutConstraint!
    private var notiButtonAction: (() -> ())?
    private(set) var versionCheckRequest: DataRequest?
    
    private lazy var notiBaseView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var notiView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.layer.useSketchShadow(color: .black, alpha: 0.15, x: 0, y: 4, blur: 8, spread: 0)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var notiImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "notiImage"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private lazy var notiTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .useFont(ofSize: 16, weight: .Bold)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.text = "Noti Title"
        label.textColor = .useRGB(red: 66, green: 66, blue: 66)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var notiButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.useRGB(red: 131, green: 164, blue: 245), for: .normal)
        button.titleLabel?.font = .useFont(ofSize: 16, weight: .Bold)
        button.addTarget(self, action: #selector(notiButton(_:)), for: .touchUpInside)
        button.setTitle("Button Title", for: .normal)
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        button.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private lazy var coverView: UIView = {
        // Cover View
        let coverView = UIView()
        coverView.backgroundColor = UIColor.useRGB(red: 0, green: 0, blue: 0, alpha: 0.1)
        coverView.isHidden = true
        coverView.translatesAutoresizingMaskIntoConstraints = false
        
        // Activity Indicator View
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .white
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        coverView.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            // Activity Indicator
            activityIndicator.centerYAnchor.constraint(equalTo: coverView.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: coverView.centerXAnchor)
        ])
        
        activityIndicator.startAnimating()
        
        return coverView
    }()
    
    static let shared = SupportingMethods()
    
    private init() {
        self.initializeAlertNoti()
        self.initializeCoverView()
    }
}

// MARK: - Extension for methods added
extension SupportingMethods {
    // MARK: Initial views
    // alert noti view
    func initializeAlertNoti() {
        let window: UIWindow! = ReferenceValues.keyWindow
        
        self.addSubviews([
            self.notiBaseView
        ], to: window)
        
        self.addSubviews([
            self.notiView
        ], to: self.notiBaseView)
        
        self.addSubviews([
            self.notiImageView,
            self.notiTitleLabel,
            self.notiButton
        ], to: self.notiView)
        
        // notiBaseView
        NSLayoutConstraint.activate([
            self.notiBaseView.topAnchor.constraint(equalTo: window.topAnchor),
            self.notiBaseView.heightAnchor.constraint(equalToConstant: 150),
            self.notiBaseView.leadingAnchor.constraint(equalTo: window.leadingAnchor),
            self.notiBaseView.trailingAnchor.constraint(equalTo: window.trailingAnchor)
        ])
        
        // notiView
        self.notiViewBottomAnchor = self.notiView.bottomAnchor.constraint(equalTo: self.notiBaseView.topAnchor)
        NSLayoutConstraint.activate([
            self.notiViewBottomAnchor,
            self.notiView.heightAnchor.constraint(greaterThanOrEqualToConstant: 56),
            self.notiView.leadingAnchor.constraint(equalTo: self.notiBaseView.leadingAnchor, constant: 16),
            self.notiView.trailingAnchor.constraint(equalTo: self.notiBaseView.trailingAnchor, constant: -16)
        ])
        
        // notiImageView
        NSLayoutConstraint.activate([
            self.notiImageView.centerYAnchor.constraint(equalTo: self.notiView.centerYAnchor),
            self.notiImageView.heightAnchor.constraint(equalToConstant: 24),
            self.notiImageView.leadingAnchor.constraint(equalTo: self.notiView.leadingAnchor, constant: 16),
            self.notiImageView.widthAnchor.constraint(equalToConstant: 24)
        ])
        
        // notiTitleLabel
        self.notiTitleLabelTrailingAnchor = self.notiTitleLabel.trailingAnchor.constraint(equalTo: self.notiView.trailingAnchor, constant: -16)
        NSLayoutConstraint.activate([
            self.notiTitleLabel.topAnchor.constraint(equalTo: self.notiView.topAnchor, constant: 18.5),
            self.notiTitleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 19),
            self.notiTitleLabel.bottomAnchor.constraint(equalTo: self.notiView.bottomAnchor, constant: -18.5),
            self.notiTitleLabel.leadingAnchor.constraint(equalTo: self.notiImageView.trailingAnchor, constant: 8),
            self.notiTitleLabelTrailingAnchor
        ])
        
        // notiButton
        NSLayoutConstraint.activate([
            self.notiButton.centerYAnchor.constraint(equalTo: self.notiView.centerYAnchor),
            self.notiButton.trailingAnchor.constraint(equalTo: self.notiView.trailingAnchor, constant: -16),
        ])
    }
    
    // cover view
    func initializeCoverView() {
        let window: UIWindow! = ReferenceValues.keyWindow
        
        self.addSubviews([
            self.coverView
        ], to: window)
        
        // coverView
        NSLayoutConstraint.activate([
            self.coverView.topAnchor.constraint(equalTo: window.topAnchor),
            self.coverView.bottomAnchor.constraint(equalTo: window.bottomAnchor),
            self.coverView.leadingAnchor.constraint(equalTo: window.leadingAnchor),
            self.coverView.trailingAnchor.constraint(equalTo: window.trailingAnchor)
        ])
    }
    
    // MARK: Show alert noti
    func showAlertNoti(title: String, button: (title: String, notiButtonAction:(() -> ())?)? = nil) {
        ReferenceValues.keyWindow.bringSubviewToFront(self.notiBaseView)
        
        // Set noti label and button
        self.notiTitleLabel.text = title
        self.notiButton.setTitle(button?.title, for: .normal)
        if let notiButtonAction = button?.notiButtonAction {
            self.notiButtonAction = notiButtonAction
            self.notiButton.isHidden = false
            
            NSLayoutConstraint.deactivate([
                self.notiTitleLabelTrailingAnchor
            ])
            self.notiTitleLabelTrailingAnchor = self.notiTitleLabel.trailingAnchor.constraint(equalTo: self.notiButton.leadingAnchor, constant: -4)
            NSLayoutConstraint.activate([
                self.notiTitleLabelTrailingAnchor
            ])
            
        } else {
            self.notiButtonAction = nil
            self.notiButton.isHidden = true
            
            NSLayoutConstraint.deactivate([
                self.notiTitleLabelTrailingAnchor
            ])
            self.notiTitleLabelTrailingAnchor = self.notiTitleLabel.trailingAnchor.constraint(equalTo: self.notiView.trailingAnchor, constant: -16)
            NSLayoutConstraint.activate([
                self.notiTitleLabelTrailingAnchor
            ])
        }
        self.notiBaseView.layoutIfNeeded()
        
        // Animating
        self.notiAnimator?.stopAnimation(false)
        self.notiAnimator?.finishAnimation(at: .end)
        
        if self.notiAnimator == nil || self.notiAnimator?.state == .inactive {
            self.notiBaseView.isHidden = false
            
            self.notiAnimator = UIViewPropertyAnimator(duration: 0.25, dampingRatio: 0.6, animations: {
                self.notiViewBottomAnchor.constant = ReferenceValues.Size.SafeAreaInsets.top + 8 + self.notiView.frame.height
                self.notiBaseView.layoutIfNeeded()
            })
            
            self.notiAnimator?.addCompletion({ position in
                switch position {
                case .end:
                    //print("position end")
                    self.hideNotiAlert()
                    
                default:
                    break
                }
            })
            
            self.notiAnimator?.startAnimation()
        }
    }
    
    private func hideNotiAlert() {
        //print("close")
        self.notiAnimator = UIViewPropertyAnimator(duration: 0.15, curve: .easeIn, animations: {
            self.notiViewBottomAnchor.constant = 0
            self.notiBaseView.layoutIfNeeded()
        })
        self.notiAnimator?.addCompletion({ position in
            switch position {
            case .end:
                //print("second position end")
                self.notiBaseView.isHidden = true
                
            default:
                break
            }
        })
        self.notiAnimator?.startAnimation(afterDelay: 3.0)
    }
    
    @objc private func notiButton(_ sender: UIButton) {
        if let action = self.notiButtonAction {
            action()
            
            self.notiButtonAction = nil
        }
    }
    
    // MARK: Compare to App Store version
    func compareAppVersionToAppStore(completion: ((_ needToUpdate: Bool) -> ())?) {
        guard let bundleId = Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String else {
            print("App Version Check >> impossible to get bundle id")
            
            completion?(false)
            
            return
        }
        
        let url = "https://itunes.apple.com/kr/lookup"
        
        let parameters: Parameters = [
            "bundleId":bundleId
        ]
        
        self.versionCheckRequest = AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil)
        self.versionCheckRequest?.responseData { response in
            switch response.result {
            case .success(let data):
                guard let jsonObject = try? JSONSerialization.jsonObject(with: data), let json = jsonObject as? [String: Any], let results = json["results"] as? [[String: Any]], let firstResult = results.first, let appStoreVersion = firstResult["version"] as? String else {
                    print("App Version Check >> impossible to get store version")
                    
                    completion?(false)
                    
                    return
                }
                
                guard let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
                    print("App Version Check >> impossible to get app version")
                    
                    completion?(false)
                    
                    return
                }
                
                let appStoreVersionArray = appStoreVersion.components(separatedBy: ".")
                let appVersionArray = appVersion.components(separatedBy: ".")
                
                guard appStoreVersionArray.count == 3 && appVersionArray.count == 3 else {
                    print("App Version Check >> improper version type")
                    
                    completion?(false)
                    
                    return
                }
                
                if let firstStoreVersionNumber = Int(appStoreVersionArray[0]),
                   let secondStoreVersionNumber = Int(appStoreVersionArray[1]),
                   let thirdStoreVersionNumber = Int(appStoreVersionArray[2]),
                   let firstAppVersionNumber = Int(appVersionArray[0]),
                   let secondAppVersionNumber = Int(appVersionArray[1]),
                   let thirdAppVersionNumber = Int(appVersionArray[2]) {
                    
                    let storeVersionValue = firstStoreVersionNumber * 100_000_000 + secondStoreVersionNumber * 100_000 + thirdStoreVersionNumber * 100
                    let appVersionValue = firstAppVersionNumber * 100_000_000 + secondAppVersionNumber * 100_000 + thirdAppVersionNumber * 100
                    
                    print("Store Version Int Value::::::::::: \(storeVersionValue)")
                    print("App Version Int Value::::::::::: \(appVersionValue)")
                    
                    if storeVersionValue > appVersionValue {
                        print("App Version Check >> store version is higher")
                        completion?(true) // Need to be updated
                        
                    } else {
                        print("App Version Check >> app version is same as store version (or higher which must not happen)")
                        completion?(false) // No need to be updated
                    }
                    
                } else {
                    print("App Version Check >> impossible to cast to Integer type with version")
                    completion?(false)
                }
                
            case .failure(let error):
                print("App Version Check >> error: \(error.localizedDescription)")
                completion?(false)
            }
        }
    }
    
    // MARK: Received content
    func saveReceivedContent(contentType: ReceivedContentType, contentNumber: Int) {
        self.receivedContent = (contentType: contentType, contentNumber: contentNumber)
    }
    
    func removeReceivedContent() {
        self.receivedContent = nil
    }
    
    func showReceivedContent() {
        var vc: UIViewController!
        if let receivedContent = SupportingMethods.shared.receivedContent {
            switch receivedContent.contentType {
            case .feed:
                vc = FeedDetailedViewController(feedNumber: receivedContent.contentNumber)
                
            case .place:
                vc = TravelPlaceDetailedViewController(placeNumber: receivedContent.contentNumber)
                
            case .path:
                vc = TravelPathDetailedViewController(pathNumber: receivedContent.contentNumber)
                
            case .live:
                 if let liveVC = SupportingMethods.shared.makeViewControllerFromStoryBoard("LiveDetailViewController") as? LiveDetailViewController {
                     let liveCourse = LiveData.shared.getLiveCourseDetailData(courseNo: receivedContent.contentNumber)
                    liveVC.liveCourse = liveCourse
                     
                     vc = liveVC
                }
            }
            
            if let topVC = self.getTopVC(ReferenceValues.keyWindow.rootViewController) {
                topVC.navigationController?.pushViewController(vc, animated: false)
            }
            
            SupportingMethods.shared.removeReceivedContent()
        }
    }
    
    // MARK: Text
    func makeAttributedString(_ strings: [NSAttributedString]) -> NSAttributedString {
        let attributedString = NSMutableAttributedString()
        for string in strings {
            attributedString.append(string)
        }
        
        return attributedString
    }
    
    func makeAttributedString(_ string: String, color: UIColor, font: UIFont, urlString: String? = nil, ofTextAlign alignment: NSTextAlignment) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = alignment
        
        if let urlString = urlString, let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
            let attributedString = NSAttributedString(string: string, attributes: [
                .font:font,
                .foregroundColor:color,
                .paragraphStyle:paragraphStyle,
                .link:url
            ])
            
            return attributedString
            
        } else {
            let attributedString = NSAttributedString(string: string, attributes: [
                .font:font,
                .foregroundColor:color,
                .paragraphStyle:paragraphStyle
            ])
            
            return attributedString
        }
    }
    
    // MARK: Add Subviews
    func addSubviews(_ views: [UIView], to: UIView) {
        for view in views {
            to.addSubview(view)
        }
    }
    
    // MARK: About time
    func makeDateFormatter(_ format: String) -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR") //Locale.current
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")!
        dateFormatter.dateFormat = format
        
        return dateFormatter
    }
    
    func calculatePassedTime(_ targetDate: Date?) -> String? {
        guard let targetDate = targetDate else {
            return nil
        }
        
        let now: Int = Int(Date().timeIntervalSince1970)
        let target = Int(targetDate.timeIntervalSince1970)
        let seconds = now - target // time interval between now and target time
        
        if seconds < 3600 { // 1시간 미만
            let minutes = seconds / 60
            if minutes <= 0 {
                return "방금전"
                
            } else {
                return "\(minutes)분 전"
            }
            
        } else if seconds >= 3600 && seconds < 3600 * 24 { // 1시간 이상 1일(24시간) 미만
            let hours = seconds / 3600
            return "\(hours)시간 전"
            
        } else if seconds >= 3600 * 24 && seconds < 3600 * 24 * 7 { // 1일 이상 1주일(7일) 미만
            let days = seconds / (3600 * 24)
            return "\(days)일 전"
            
        } else { // 1주일(7일) 이상
            let dateFormatter = self.makeDateFormatter("yy.MM.dd")
            return dateFormatter.string(from: targetDate)
        }
        
        /*
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: "ko_KR")
        calendar.timeZone = TimeZone(abbreviation: "KST")!

        let now = Date()
        let nowComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: now)
        //let nowDaysOfMonth = calendar.range(of: .day, in: .month, for: now)

        let targetComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: targetDate)
        let targetDaysOfMonthRange = calendar.range(of: .day, in: .month, for: now)

        guard let nowYear = nowComponents.year, let nowMonth = nowComponents.month, let nowDay = nowComponents.day, let nowHour = nowComponents.hour, let nowMinute = nowComponents.minute,
              let targetYear = targetComponents.year, let targetMonth = targetComponents.month, let targetDay = targetComponents.day, let targetDaysOfMonth = targetDaysOfMonthRange?.count, let targetHour = targetComponents.hour, let targetMinute = targetComponents.minute else {
            return nil
        }

        if nowYear == targetYear {
            if nowMonth == targetMonth {
                if nowDay == targetDay {
                    if nowHour == targetHour {
                        if nowMinute == targetMinute {
                            return "방금전"

                        } else if nowMinute > targetMinute {
                            return "\(nowMinute - targetMinute)분 전"

                        } else { // MARK: Must not happen for minute
                            let dateFormatter = self.makeDateFormatter("yy.MM.dd")
                            return dateFormatter.string(from: targetDate)
                        }

                    } else if nowHour > targetHour {
                        return "\(nowHour - targetHour)시간 전"

                    } else { // MARK: Must not happen for hour
                        let dateFormatter = self.makeDateFormatter("yy.MM.dd")
                        return dateFormatter.string(from: targetDate)
                    }

                } else if nowDay - targetDay < 7 {
                    return "\(nowDay - targetDay)일 전"

                } else {
                    let dateFormatter = self.makeDateFormatter("yy.MM.dd")
                    return dateFormatter.string(from: targetDate)
                }

            } else if nowMonth - targetMonth == 1 && (nowDay + targetDaysOfMonth - targetDay) < 7 {
                return "\(nowDay + targetDaysOfMonth - targetDay)일 전"

            } else {
                let dateFormatter = self.makeDateFormatter("yy.MM.dd")
                return dateFormatter.string(from: targetDate)
            }

        } else if nowYear - targetYear == 1 && nowMonth == 1 && targetMonth == 12 && (nowDay + targetDaysOfMonth - targetDay) < 7 {
            return "\(nowDay + targetDaysOfMonth - targetDay)일 전"

        } else {
            let dateFormatter = self.makeDateFormatter("yy.MM.dd")
            return dateFormatter.string(from: targetDate)
        }
        */
    }
    
    func testForMakingTempDate(string: String) -> Date? {
        return self.makeDateFormatter("yyyy.MM.dd HH:mm:ss").date(from: string)
    }
    
    // MARK: About map or location
    func calculateMetersToKiloMeters(_ meters: Int) -> String {
        let kiloMeters = meters / 1000
        let restMeters = meters % 1000
        
        if kiloMeters > 0 {
            if restMeters == 0 {
                return "\(kiloMeters)km"
                
            } else if restMeters > 0 && restMeters < 100 {
                return "\(kiloMeters).0km"
                
            } else { // restMeters >= 100
                let pointKiloMeters = restMeters / 100
                return "\(kiloMeters).\(pointKiloMeters)km"
            }
            
        } else {
            return "\(meters)m"
        }
    }
    
    func makeAddress(_ place: TravelPlaceItem) -> (address: String, latitude: String, longitude: String)? {
        let address = ""
        + (place.tripPlaceAdd1 != "" ? " \(place.tripPlaceAdd1)" : "")
        + (place.tripPlaceAdd2 != "" ? " \(place.tripPlaceAdd2)" : "")
        + (place.tripPlaceAdd3 != "" ? " \(place.tripPlaceAdd3)" : "")
        
        if address == "" || place.tripPlaceLatitude == "" || place.tripPlaceLongitude == "" {
            return nil
            
        } else {
            return (address, place.tripPlaceLatitude, place.tripPlaceLongitude)
        }
    }
    
    // MARK: About constraint
    func makeConstraintsOf(_ firstView: UIView, sameAs secondView: UIView) {
        NSLayoutConstraint.activate([
            firstView.topAnchor.constraint(equalTo: secondView.topAnchor),
            firstView.bottomAnchor.constraint(equalTo: secondView.bottomAnchor),
            firstView.leadingAnchor.constraint(equalTo: secondView.leadingAnchor),
            firstView.trailingAnchor.constraint(equalTo: secondView.trailingAnchor)
        ])
    }
    
    func makeConstraintsOf(_ firstView: UIView, sameAs secondViewLayout: UILayoutGuide) {
        NSLayoutConstraint.activate([
            firstView.topAnchor.constraint(equalTo: secondViewLayout.topAnchor),
            firstView.bottomAnchor.constraint(equalTo: secondViewLayout.bottomAnchor),
            firstView.leadingAnchor.constraint(equalTo: secondViewLayout.leadingAnchor),
            firstView.trailingAnchor.constraint(equalTo: secondViewLayout.trailingAnchor)
        ])
    }
    
    // MARK: Cover view
    func turnCoverView(_ state: CoverViewState) {
        ReferenceValues.keyWindow.bringSubviewToFront(self.coverView)
        
        switch state {
        case .on:
            self.coverView.isHidden = false
            
        case .off:
            self.coverView.isHidden = true
        }
    }
    
    // MARK: Get Top ViewController
    func getTopVC(_ windowRootVC: UIViewController?) -> UIViewController? {
        var topVC = windowRootVC
        while true {
            if let top = topVC?.presentedViewController {
                topVC = top
                
            } else if let base = topVC as? UINavigationController, let top = base.visibleViewController {
                topVC = top
                
            } else if let base = topVC as? UITabBarController, let top = base.selectedViewController {
                topVC = top
                
            } else {
                break
            }
        }
        
        return topVC
    }
    
    func makeRandomPorcentage() -> AreaType {
        let randomNumberValue = Int.random(in: 1...100)
        
        let percentArray = [40, 60]
        let area: [AreaType] = [.daegu, .jeju]
        
        var percent = 0
        for index in 0..<2 {
            percent += percentArray[index]
            
            if randomNumberValue <= percent {
                return area[index]
            }
        }
        
        return .jeju
    }
    
    // MARK: Determine app state
    enum AppState {
        case terminate
        case logout
        case networkError
        case serverError
        case expired
    }
    
    func determineAppState(_ state: AppState) {
        ReferenceValues.isAppAvailable = true
        
        switch state {
        case .terminate:
            exit(0)
            
        case .logout:
//            postFCMInit()
            ReferenceValues.firstVC?.isLoggingOut = true
            UserDefaults.standard.removeObject(forKey: "refreshToken")
            if let providerNm = UserDefaults.standard.string(forKey: "provider") {
                if providerNm == "GOOGLE" {
                    GIDSignIn.sharedInstance().signOut()
                    UserDefaults.standard.removeObject(forKey: "provider")
                }
                UserDefaults.standard.removeObject(forKey: "provider")
            }
            
            guard let _ = ReferenceValues.firstVC?.presentedViewController as? TabBarController else {
                ReferenceValues.firstVC?.navigationController?.popToRootViewController(animated: false)
                
                return
            }
            
            ReferenceValues.firstVC?.dismiss(animated: true)
            ReferenceValues.firstVC?.navigationController?.popToRootViewController(animated: false)
            
        case .networkError:
            ReferenceValues.firstVC?.isLoggingOut = false
            ReferenceValues.firstVC?.backGroundView.isHidden = true
            guard let _ = ReferenceValues.firstVC?.presentedViewController as? TabBarController else {
                ReferenceValues.firstVC?.navigationController?.popToRootViewController(animated: false)
                
                ReferenceValues.firstVC?.setUpProgressView()
                
                return
            }
            
            ReferenceValues.firstVC?.dismiss(animated: false)
            ReferenceValues.firstVC?.navigationController?.popToRootViewController(animated: false)
            
        case .serverError:
            ReferenceValues.firstVC?.isLoggingOut = false
            ReferenceValues.firstVC?.backGroundView.isHidden = true
            guard let _ = ReferenceValues.firstVC?.presentedViewController as? TabBarController else {
                ReferenceValues.firstVC?.navigationController?.popToRootViewController(animated: false)
                
                ReferenceValues.firstVC?.setUpProgressView()
                
                return
            }
            
            ReferenceValues.firstVC?.dismiss(animated: false)
            ReferenceValues.firstVC?.navigationController?.popToRootViewController(animated: false)
            
        case .expired:
            ReferenceValues.firstVC?.isLoggingOut = false
            UserDefaults.standard.removeObject(forKey: "refreshToken")
            if let providerNm = UserDefaults.standard.string(forKey: "provider") {
                if providerNm == "GOOGLE" {
                    GIDSignIn.sharedInstance().signOut()
                    UserDefaults.standard.removeObject(forKey: "provider")
                }
                UserDefaults.standard.removeObject(forKey: "provider")
            }
            
            ReferenceValues.firstVC?.backGroundView.isHidden = true
            guard let _ = ReferenceValues.firstVC?.presentedViewController as? TabBarController else {
                ReferenceValues.firstVC?.navigationController?.popToRootViewController(animated: false)
                
                ReferenceValues.firstVC?.setUpProgressView()
                
                return
            }
            
            ReferenceValues.firstVC?.dismiss(animated: false)
            ReferenceValues.firstVC?.navigationController?.popToRootViewController(animated: false)
        }
    }
    
    func checkExpiration(errorMessage: String, completion: (() -> ())?) {
        ReferenceValues.isAppAvailable = false
        
        if errorMessage == ReferenceValues.expiredConditionMessage {
            let vc = AlertPopViewController(.normalOneButton(messageTitle: "로그아웃 되었습니다", messageContent: "다른 기기에서 중복 로그인되어\n현재 기기에서 자동 로그아웃 되었습니다.", buttonTitle: "확인", action: {
                self.determineAppState(.expired)
            }))
            
            if let topVC = SupportingMethods.shared.getTopVC(ReferenceValues.keyWindow.rootViewController) {
                if let presentingVC = topVC.presentingViewController, let _ = topVC as? AlertPopViewController {
                    presentingVC.dismiss(animated: false) {
                        presentingVC.present(vc, animated: true)
                    }
                    
                } else {
                    topVC.present(vc, animated: true)
                }
            }
            
            self.turnCoverView(.off)
            
        } else {
            completion?()
            
            let vc = AlertPopViewController(.normalTwoButton(messageTitle: "서비스 접속이 원활하지 않습니다", messageContent: "잠시 후 다시 시도해 주세요.", leftButtonTitle: "앱 종료", leftAction: {
                exit(0)
                
            }, rightButtonTitle: "재접속", rightAction: {
                self.determineAppState(.serverError)
            }))
            
            if let topVC = SupportingMethods.shared.getTopVC(ReferenceValues.keyWindow.rootViewController) {
                if let presentingVC = topVC.presentingViewController, let _ = topVC as? AlertPopViewController {
                    presentingVC.dismiss(animated: false) {
                        presentingVC.present(vc, animated: true)
                    }
                    
                } else {
                    topVC.present(vc, animated: true)
                }
            }
            
            self.turnCoverView(.off)
        }
    }
    
    // MARK: Map
    // Google
    func showGoogleMap(lat: Double, lng: Double) {
        guard let url = URL(string: "comgooglemaps://?saddr=&daddr=\(lat),\(lng)&directionsmode=transit") else { return }
        
        // googlemap 앱스토어 url
        //guard let appStoreUrl = URL(string: "https://apps.apple.com/kr/app/google-maps/id585027354") else { return }
        let urlString = "comgooglemaps://"
        
        // googlemap 앱이 있다면,
        if let appUrl = URL(string: urlString) {
            // googlemap 앱이 존재한다면,
            if UIApplication.shared.canOpenURL(appUrl) {
                // 길찾기 open
                UIApplication.shared.open(url)
            } else { // googlemap 앱이 없다면,
                // googlemap 앱 설치 앱스토어로 이동
                UIApplication.shared.open(URL(string: "https://www.google.com/maps?saddr=&daddr=\(lat),\(lng)&directionsmode=transit")!)
            }
        }
    }
    
    // Kakao
    func showKakaoMap(lat: Double, lng: Double) {
        // 도착지 좌표 + 자동차 길찾기
        guard let url = URL(string: "kakaomap://route?ep=\(lat),\(lng)&by=CAR") else { return }
        // 카카오맵 앱스토어 url
        guard let appStoreUrl = URL(string: "itms-apps://itunes.apple.com/app/id304608425") else { return }
        let urlString = "kakaomap://open"

        if let appUrl = URL(string: urlString) {
            // 카카오맵 앱이 존재한다면,
            if UIApplication.shared.canOpenURL(appUrl) {
                // 길찾기 open
                UIApplication.shared.open(url)
            } else { // 카카오맵 앱이 없다면,
                // 카카오맵 앱 설치 앱스토어로 이동
                UIApplication.shared.open(appStoreUrl)
            }
        }
    }
    
    // Tmap
    func showTMap(locationName: String, lat: Double, lng: Double) {
        // 도착지 이름 + 도착지 좌표
        let urlStr = "tmap://route?rGoName=\(locationName)&rGoX=\(lng)&rGoY=\(lat)"
        
        // url에 한글이 들어가있기 때문에 인코딩을 따로 해줘야함
        guard let encodedStr = urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        guard let url = URL(string: encodedStr) else { return }
        
        // tmap 앱스토어 url
        guard let appStoreURL = URL(string: "http://itunes.apple.com/app/id431589174") else { return }

        // tmap 앱이 있다면,
        if UIApplication.shared.canOpenURL(url) {
            // 길찾기 open
            UIApplication.shared.open(url)
        } else { // tmap 앱이 없다면,
            // tmap 설치 앱스토어로 이동
            UIApplication.shared.open(appStoreURL)
        }
    }
    
    // Apple
    func showAppleMap(latitude: Double, longitude: Double) {
        // 주소 + 자동차 길찾기
        //let urlStr = "maps://?daddr=\(endPoint)&dirfgl=d"
        let urlStr = "maps://?daddr=\(latitude),\(longitude)"
        
        // 한글 인코딩
        guard let encodedStr = urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        guard let url = URL(string: encodedStr) else { return }
        
        // 애플지도 앱스토어 url
        guard let appStoreUrl = URL(string: "itms-apps://itunes.apple.com/app/id915056765") else { return }

        // 애플지도 앱이 있다면,
        if UIApplication.shared.canOpenURL(url) {
            // 애플 길찾기 open
            UIApplication.shared.open(url)
        } else { // 애플 지도 앱이 없다면,
            // 애플지도 설치 앱스토어로 이동
            UIApplication.shared.open(appStoreUrl)
        }
    }
    
    // MARK: Storyboard
    func makeViewControllerFromStoryBoard(_ storyboardId: String) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: storyboardId)
    }
    
    // MARK: Manage contents (photo / movie)
    func gatherDataFromPickedContents(index: Int, pickerType: PickerType, pickedResults: [String:PHPickerResult], selectedIdentifiers: [String], contentsMetaData: [String:PHAsset], contentsData: [String:Data], success: ((_ pickedResults: [String:PHPickerResult], _ selectedIdentifiers: [String], _ contentsData: [String:Data]) -> ())?, failure: (() -> ())?) {
        var index = index
        let count = selectedIdentifiers.count
        var contentsData = contentsData
        
        guard index < count else {
            success?(pickedResults, selectedIdentifiers, contentsData)
            
            return
        }
        
        if pickerType == .image {
            if let itemProvider = (pickedResults[selectedIdentifiers[index]])?.itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                    if let self = self, let image = image as? UIImage, let imageData = image.fixedOrientaion.jpegData(compressionQuality: 0.1) {
                        DispatchQueue.main.async {
                            contentsData.updateValue(imageData, forKey: selectedIdentifiers[index])
                            
                            index += 1
                            self.gatherDataFromPickedContents(index: index, pickerType: pickerType, pickedResults: pickedResults, selectedIdentifiers: selectedIdentifiers, contentsMetaData: contentsMetaData, contentsData: contentsData, success: success, failure: failure)
                        }
                        
                    } else {
                        failure?()
                    }
                }
                
            } else if let itemProvider = (pickedResults[selectedIdentifiers[index]])?.itemProvider, itemProvider.hasItemConformingToTypeIdentifier(UTType.webP.identifier) {
                itemProvider.loadDataRepresentation(forTypeIdentifier: UTType.webP.identifier) { data, error in
                    if let data = data, let _ = UIImage(data: data) {
                        DispatchQueue.main.async {
                            contentsData.updateValue(data, forKey: selectedIdentifiers[index])
                            
                            index += 1
                            self.gatherDataFromPickedContents(index: index, pickerType: pickerType, pickedResults: pickedResults, selectedIdentifiers: selectedIdentifiers, contentsMetaData: contentsMetaData, contentsData: contentsData, success: success, failure: failure)
                        }
                        
                    } else {
                        failure?()
                    }
                }
                
            } else {
                failure?()
            }
            
        } else { // video
            if let itemProvider = (pickedResults[selectedIdentifiers[index]])?.itemProvider, let videoAsset = contentsMetaData[selectedIdentifiers[index]], itemProvider.hasItemConformingToTypeIdentifier(UTType.movie.identifier) {
                itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.movie.identifier) { [weak self] url, err in
                    if let self = self, let url = url {
                        var preset = AVAssetExportPresetPassthrough//AVAssetExportPresetHEVC1920x1080
                        
                        if videoAsset.pixelHeight > 1920 || videoAsset.pixelWidth > 1080 {
                            preset = AVAssetExportPresetHEVC1920x1080
                        }
                        
                        self.convertVideo(sourceUrl: url, preset: preset) { videoData in
                            DispatchQueue.main.async {
                                contentsData.updateValue(videoData, forKey: selectedIdentifiers[index])
                                if let thumbnailData = videoAsset.thumbnailImage.fixedOrientaion.jpegData(compressionQuality: 1.0) {
                                    contentsData.updateValue(thumbnailData, forKey: "thumbnailData")
                                }
                                
                                index += 1
                                self.gatherDataFromPickedContents(index: index, pickerType: pickerType, pickedResults: pickedResults, selectedIdentifiers: selectedIdentifiers, contentsMetaData: contentsMetaData, contentsData: contentsData, success: success, failure: failure)
                            }
                            
                        } failure: {
                            failure?()
                        }
                        
                    } else {
                        failure?()
                    }
                }
                
            } else {
                failure?()
            }
        }
    }
    
    // MARK: Convert Video
    // AVAssetExportPresetHEVC1920x1080,
    func convertVideo(sourceUrl: URL, preset: String = AVAssetExportPresetPassthrough, success: ((_ videoData: Data) -> ())?, failure: (() -> ())?) {
        guard let videoData = try? Data(contentsOf: sourceUrl, options: Data.ReadingOptions.alwaysMapped) else {
            print("Video data of source url is nil")
            failure?()
            
            return
        }
        print("Original Video: \(videoData)")
        
        let originalVideoDataUrl = NSURL.fileURL(withPath: NSTemporaryDirectory() + UUID().uuidString + ".mp4")
        guard (try? videoData.write(to: originalVideoDataUrl, options: [])) != nil else {
            print("Writing video data of source url on disc is failed")
            failure?()
            
            return
        }
        
        let convertedURL = NSURL.fileURL(withPath: NSTemporaryDirectory() + UUID().uuidString + ".mp4")
        self.convertVideo(inputURL: originalVideoDataUrl, outputURL: convertedURL, preset: preset) { exportSession in
            guard let session = exportSession else {
                print("exportSession.status: nil")
                failure?()
                
                return
            }
            
            switch session.status {
            case .unknown:
                print("exportSession.status: unknown")
                failure?()
                
            case .waiting:
                print("exportSession.status: waiting")
                failure?()
                
            case .exporting:
                print("exportSession.status: exporting")
                failure?()
                
            case .completed:
                guard let convertedData = try? Data(contentsOf: convertedURL) else {
                    print("Video data of converted url is nil")
                    failure?()
                    
                    return
                }
                
                print("exportSession.status: completed")
                print("Converted Video: \(convertedData)")
                
                success?(convertedData)
                
            case .failed:
                print("exportSession.status: failed")
                failure?()
                
            case .cancelled:
                print("exportSession.status: cancelled")
                failure?()
                
            default:
                print("exportSession.status: default")
                failure?()
            }
        }
    }
    
    private func convertVideo(inputURL: URL,
                       outputURL: URL,
                       preset: String,
                      handler:@escaping (_ exportSession: AVAssetExportSession?) -> Void) {
        let urlAsset = AVURLAsset(url: inputURL, options: nil)
        guard let exportSession = AVAssetExportSession(asset: urlAsset,
                                                       presetName: preset) else {
            handler(nil)

            return
        }

        exportSession.outputURL = outputURL
        exportSession.outputFileType = .mp4
        exportSession.exportAsynchronously {
            handler(exportSession)
        }
    }
}

// MARK: - Other Extensions
// MARK: Array
extension Array {
    subscript(indice indice: Int) -> Element? {
        return indices ~= indice ? self[indice] : nil
    }
}

// MARK: UIImage
extension UIImage {
    var fixedOrientaion: UIImage {
        if self.imageOrientation == .up {
                return self
            }
        
            var transform: CGAffineTransform = CGAffineTransform.identity
            switch self.imageOrientation {
            case .down, .downMirrored:
                transform = transform.translatedBy(x: self.size.width, y: self.size.height)
                transform = transform.rotated(by: CGFloat(Double.pi))
                
            case .left, .leftMirrored:
                transform = transform.translatedBy(x: self.size.width, y: 0)
                transform = transform.rotated(by: CGFloat(Double.pi / 2))
                
            case .right, .rightMirrored:
                transform = transform.translatedBy(x: 0, y: self.size.height)
                transform = transform.rotated(by: CGFloat(-(Double.pi / 2)))
            default: // .up, .upMirrored
                break
            }

            switch self.imageOrientation {
            case .upMirrored, .downMirrored:
                //transform.translatedBy(x: self.size.width, y: 0)
                //transform.scaledBy(x: -1, y: 1)
                CGAffineTransformTranslate(transform, size.width, 0)
                CGAffineTransformScale(transform, -1, 1)
                
            case .leftMirrored, .rightMirrored:
                //transform.translatedBy(x: self.size.height, y: 0)
                //transform.scaledBy(x: -1, y: 1)
                CGAffineTransformTranslate(transform, size.height, 0)
                CGAffineTransformScale(transform, -1, 1)
                
            default: // .up, .down, .left, .right
                break
            }

            let ctx:CGContext = CGContext(data: nil, width: Int(self.size.width), height: Int(self.size.height), bitsPerComponent: (self.cgImage)!.bitsPerComponent, bytesPerRow: 0, space: (self.cgImage)!.colorSpace!, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!

            ctx.concatenate(transform)

            switch self.imageOrientation {
            case .left, .leftMirrored, .right, .rightMirrored:
                ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: self.size.height, height: self.size.width))
                
            default:
                ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
            }

            let cgimg:CGImage = ctx.makeImage()!
            let img:UIImage = UIImage(cgImage: cgimg)

            return img
    }
}

// MARK: UIDevice haptics
extension UIDevice {
    // MARK: Make Haptic Effect
    static func softHaptic() {
        let haptic = UIImpactFeedbackGenerator(style: .soft)
        haptic.impactOccurred()
    }
    
    static func lightHaptic() {
        let haptic = UIImpactFeedbackGenerator(style: .light)
        haptic.impactOccurred()
    }
    
    static func heavyHaptic() {
        let haptic = UIImpactFeedbackGenerator(style: .heavy)
        haptic.impactOccurred()
    }
}

// MARK: UIColor to be possible to get color using 0 ~ 255 integer
extension UIColor {
    class func useRGB(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1) -> UIColor {
        return UIColor(red: red / CGFloat(255), green: green / CGFloat(255), blue: blue / CGFloat(255), alpha: alpha)
    }
}

// MARK: String
extension String {
    func substring(from: Int, length: Int) -> String? {
        guard from < self.count && length > 0 && from + length <= self.count else {
            return nil
        }
        
        // Index 값 획득
        let startIndex = self.index(self.startIndex, offsetBy: from)
        let endIndex = self.index(startIndex, offsetBy: length - 1)
        
        // 파싱
        return String(self[startIndex...endIndex])
    }
    
//    func validatePathName() -> Bool {
////        // 정규식 pattern. 한글, 영어, 숫자, 공백만 있어야함
////        let pattern = "^[ㄱ-ㅎㅏ-ㅣ가-힣a-zA-Z0-9\\s]$"
//
//        // 정규식 pattern. 한글, 영어, 숫자, 공백만 있어야함 (초성 금지)
//        let pattern = "^[[가-힣a-zA-Z][0-9][\\s]]$"
//        let predicate = NSPredicate(format: "SELF MATCHES %@", pattern)
//
//        return predicate.evaluate(with: self)
//    }
    
    func validatePathName() -> Bool {
//        // 정규식 pattern. 한글, 영어, 숫자, 공백만 있어야함
//        let pattern = "^[ㄱ-ㅎㅏ-ㅣ가-힣a-zA-Z0-9\\s]$"
        
        // 정규식 pattern. 한글, 영어, 숫자, 공백만 있어야함 (초성 금지)
        let pattern = "^[가-힣a-zA-Z0-9\\s]$"
        let stringArray = Array(self)
        
        if let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) {
            for index in 0..<stringArray.count {
                let results = regex.matches(in: String(stringArray[index]), options: [], range: NSRange(location: 0, length: 1))
                if results.isEmpty {
                    return false
                }
            }
        }
        
        return true
    }
}

// MARK: Shadow
extension CALayer {
    func useSketchShadow(color: UIColor, alpha: Float, x: CGFloat, y: CGFloat, blur: CGFloat, spread: CGFloat) {
        self.masksToBounds = false
        self.shadowColor = color.cgColor
        self.shadowOpacity = alpha
        self.shadowOffset = CGSize(width: x, height: y)
        self.shadowRadius = blur / 2.0
        
        if spread == 0 {
            self.shadowPath = nil
            
        } else {
            let dx = -spread
            let rect = self.bounds.insetBy(dx: dx, dy: dx)
            self.shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
    
    func useSketchShadow(color: UIColor, alpha: Float, shadowSize: CGFloat, viewSize: CGSize) {
        let shadowPath = UIBezierPath(rect: CGRect(x: -shadowSize / 2,
                                                   y: -shadowSize / 2,
                                                   width: viewSize.width + shadowSize,
                                                   height: viewSize.height + shadowSize))
        self.masksToBounds = false
        self.shadowColor = color.cgColor
        self.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.shadowOpacity = alpha
        self.shadowPath = shadowPath.cgPath
    }
}

// MARK: UIFont
extension UIFont {
    enum PretendardFontType: String {
        case Black
        case Bold
        case ExtraBold
        case ExtraLight
        case Light
        case Medium
        case Regular
        case SemiBold
        case Thin
    }
    class func useFont(ofSize size: CGFloat, weight: PretendardFontType) -> UIFont {
        return UIFont(name: "PretendardVariable-\(weight.rawValue)", size: size)!
    }
}

// MARK: - PHAsset
extension PHAsset {
    var thumbnailImage : UIImage {
        get {
            let manager = PHImageManager.default()
            let option = PHImageRequestOptions()
            var thumbnail: UIImage?
            option.isSynchronous = true
            manager.requestImage(for: self, targetSize: CGSize(width: 300, height: 300), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
                thumbnail = result
            })
            return thumbnail ?? UIImage()
        }
    }
}

// MARK: - View Protocol
protocol EssentialViewMethods {
    func setViewFoundation()
    func initializeObjects()
    func setDelegates()
    func setGestures()
    func setNotificationCenters()
    func setSubviews()
    func setLayouts()
    func setViewAfterTransition()
}

// MARK: - Cell & Header Protocol
protocol EssentialCellHeaderMethods {
    func setViewFoundation()
    func initializeObjects()
    func setSubviews()
    func setLayouts()
}
