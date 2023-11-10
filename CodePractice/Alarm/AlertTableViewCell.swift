//
//  AlertTableViewCell.swift
//  CodePractice
//
//  Created by Awesomepia on 2023/07/17.
//

import UIKit

protocol AlertDeleteDelegate: NSObjectProtocol {
    func alertDelete(index: Int)
}

class AlertTableViewCell: UITableViewCell {
    
    lazy var imageBackgroundView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1).cgColor
        view.layer.borderWidth = 1.0
        view.layer.cornerRadius = 16.0
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Event")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.titleLabel, self.contentsLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.distribution = .fill
        stackView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "공지사항"
        label.font = UIFont(name: "PretendardVariable-Bold", size: 16)
        label.textColor = UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var contentsLabel: UILabel = {
        let label = UILabel()
        label.text = "[공지사항] 바르고 고운말을 사용해주세요."
        label.font = UIFont(name: "PretendardVariable-Medium", size: 14)
        label.textColor = UIColor(red: 97/255, green: 97/255, blue: 97/255, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.text = "36주 전"
        label.font = UIFont(name: "PretendardVariable-Medium", size: 12)
        label.textColor = UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1)
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont(name: "PretendardVariable-Medium", size: 16)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.setTitleColor(UIColor(red: 131/255, green: 164/255, blue: 245/255, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(deleteData(_:)), for: .touchUpInside)
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    weak var delegate: AlertDeleteDelegate?
    var index: Int?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setCellFoundation()
        self.initializeViews()
        self.setGestures()
        self.setNotificationCenters()
        self.setSubviews()
        self.setLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

// MARK: Extension for essential methods
extension AlertTableViewCell {
    // Set view foundation
    func setCellFoundation() {
        self.selectionStyle = .none
        self.contentView.isUserInteractionEnabled = true
    }
    
    // Initialize views
    func initializeViews() {
        
    }
    
    // Set gestures
    func setGestures() {
        
    }
    
    // Set notificationCenters
    func setNotificationCenters() {
        
    }
    
    // Set subviews
    func setSubviews() {
        self.addSubview(self.imageBackgroundView)
        self.addSubview(self.stackView)
        self.addSubview(self.thumbnailImageView)
        self.addSubview(self.timeLabel)
        self.addSubview(self.deleteButton)
    }
    
    // Set layouts
    func setLayouts() {
//        let safeArea = self.safeAreaLayoutGuide
        
        // imageBackgroundView
        NSLayoutConstraint.activate([
            self.imageBackgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            self.imageBackgroundView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.imageBackgroundView.heightAnchor.constraint(equalToConstant: 40),
            self.imageBackgroundView.widthAnchor.constraint(equalToConstant: 40)
        ])
        
        // thumbnailImageView
        NSLayoutConstraint.activate([
            self.thumbnailImageView.centerYAnchor.constraint(equalTo: self.imageBackgroundView.centerYAnchor),
            self.thumbnailImageView.centerXAnchor.constraint(equalTo: self.imageBackgroundView.centerXAnchor)
        ])
        
        // stackView
        NSLayoutConstraint.activate([
            self.stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.stackView.leadingAnchor.constraint(equalTo: self.imageBackgroundView.trailingAnchor, constant: 8),
            self.stackView.trailingAnchor.constraint(equalTo: self.timeLabel.leadingAnchor, constant: -12),
            self.stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 12),
            self.stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12)
        ])
        
        // timeLabel
        NSLayoutConstraint.activate([
            self.timeLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            self.timeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 12)
        ])
        
        // deleteButton
        NSLayoutConstraint.activate([
            self.deleteButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            self.deleteButton.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}

// MARK: - Extension for methods added
extension AlertTableViewCell {
    func setCell(alarm: AlarmDetailItem) {
        let alarmKindsNo: Int = alarm.alarmKindsNo
        
        self.titleLabel.text = alarm.alarmKindsTitleKr
        self.contentsLabel.text = alarm.alarmHistoryBody
        
        switch(alarmKindsNo) {
        case 1:
            // 새 쪽지
            self.thumbnailImageView.image = UIImage(named: "Chating")
        case 2:
            // 새 피드
            self.thumbnailImageView.image = UIImage(named: "Feed")
        case 3:
            // 새 메이트
            self.thumbnailImageView.image = UIImage(named: "Mate")
        case 4:
            // 여행지 댓글
            self.thumbnailImageView.image = UIImage(named: "Comment")
        case 5:
            // 여행지 대댓글
            self.thumbnailImageView.image = UIImage(named: "Comment")
        case 6:
            // 경로 댓글
            self.thumbnailImageView.image = UIImage(named: "Comment")
        case 7:
            // 경로 대댓글
            self.thumbnailImageView.image = UIImage(named: "Comment")
        case 8:
            // 피드 좋아요
            self.thumbnailImageView.image = UIImage(named: "Like")
        case 9:
            // 피드 댓글
            self.thumbnailImageView.image = UIImage(named: "Comment")
        case 10:
            // 피드 대댓글
            self.thumbnailImageView.image = UIImage(named: "Comment")
        case 11:
            // 공지사항
            self.thumbnailImageView.image = UIImage(named: "Notice")
        case 12:
            // 점검
            self.thumbnailImageView.image = UIImage(named: "Repair")
        case 13:
            // 이벤트
            self.thumbnailImageView.image = UIImage(named: "Event")
        case 14:
            // 인게임 초대
            self.thumbnailImageView.image = UIImage(named: "")
        case 15:
            // 가입 완료
            self.thumbnailImageView.image = UIImage(named: "Notice")
        case 16:
            // 신고
            self.thumbnailImageView.image = UIImage(named: "Repair")
        case 17:
            // 인게임 퀘스트 완료
            self.thumbnailImageView.image = UIImage(named: "")
        case 18:
            // 칭호
            self.thumbnailImageView.image = UIImage(named: "AlertEntitleImage")
        default:
            // 이외
            self.thumbnailImageView.image = UIImage(named: "")
        }
        
        self.selectionStyle = .none
    }
}

// MARK: - Extension for selectors added
extension AlertTableViewCell {
    @objc func deleteData(_ sender: UIButton) {
        self.delegate?.alertDelete(index: self.index!)
    }
}
