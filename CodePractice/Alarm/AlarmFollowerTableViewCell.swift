//
//  AlarmFollowerTableViewCell.swift
//  CodePractice
//
//  Created by Awesomepia on 2023/07/19.
//

import UIKit
import Kingfisher

protocol AlertFollowerDeleteDelegate: NSObjectProtocol {
    func alertFollowerDelete(index: Int)
}

final class AlarmFollowerTableViewCell: UITableViewCell {
    
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "emptyProfile")
        imageView.layer.cornerRadius = 16.0
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.titleLabel, self.contentLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.distribution = .fill
        stackView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1)
        label.font = UIFont(name: "PretendardVariable-Bold", size: 16.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 97/255, green: 97/255, blue: 97/255, alpha: 1)
        label.font = UIFont(name: "PretendardVariable-Medium", size: 14.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var timeLabael: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1)
        label.font = UIFont(name: "PretendardVariable-Medium", size: 12.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var followButton: UIButton = {
        let button = UIButton()
        button.setTitle("팔로우", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 131/255, green: 164/255, blue: 245/255, alpha: 1)
        button.layer.cornerRadius = 16.0
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    lazy var cancleButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.setTitleColor(UIColor(red: 131/255, green: 164/255, blue: 245/255, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(deleteData(_:)), for: .touchUpInside)
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
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
    
    var delegate: AlertFollowerDeleteDelegate?
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
extension AlarmFollowerTableViewCell {
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
        self.addSubview(self.profileImageView)
        self.addSubview(self.stackView)
        self.addSubview(self.timeLabael)
        self.addSubview(self.followButton)
        self.addSubview(self.cancleButton)
        self.addSubview(self.deleteButton)
    }
    
    // Set layouts
    func setLayouts() {
//        let safeArea = self.safeAreaLayoutGuide
        
        // profileImageView
        NSLayoutConstraint.activate([
            self.profileImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            self.profileImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 12),
            self.profileImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12),
            self.profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.profileImageView.heightAnchor.constraint(equalToConstant: 40),
            self.profileImageView.widthAnchor.constraint(equalToConstant: 40)
        ])
        
        // stackView
        NSLayoutConstraint.activate([
            self.stackView.leadingAnchor.constraint(equalTo: self.profileImageView.trailingAnchor, constant: 8),
            self.stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        // timeLabel
        NSLayoutConstraint.activate([
            self.timeLabael.trailingAnchor.constraint(equalTo: self.followButton.leadingAnchor, constant: -8),
            self.timeLabael.topAnchor.constraint(equalTo: self.topAnchor, constant: 12)
        ])
        
        // followButton
        NSLayoutConstraint.activate([
            self.followButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            self.followButton.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        // cancleButton
        NSLayoutConstraint.activate([
            self.cancleButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            self.cancleButton.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.deleteButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            self.deleteButton.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}

// MARK: - Extension for methods added
extension AlarmFollowerTableViewCell {
    func setCell(follower: AlarmDetailItem) {
        self.profileImageView.kf.setImage(with: URL(string: follower.profileImgPath!), placeholder: UIImage(named: "emptyProfile"))
        
        self.titleLabel.text = "\(follower.nickname ?? "")"
        self.contentLabel.text = "@\(follower.userId ?? "")님이 팔로우하기 시작했습니다."
        
        if follower.followingYn == "Y" {
            self.followButton.isHidden = false
            
            self.followButton.setTitle("팔로잉", for: .normal)
            self.followButton.setTitleColor(UIColor(red: 131/255, green: 164/255, blue: 245/255, alpha: 1), for: .normal)
            self.followButton.backgroundColor = .white
            self.followButton.layer.borderColor = UIColor(red: 131/255, green: 164/255, blue: 245/255, alpha: 1).cgColor
            self.followButton.layer.borderWidth = 1.0
            
        } else if follower.followingYn == "N" {
            self.followButton.isHidden = false
            
            self.followButton.setTitle("팔로우", for: .normal)
            self.followButton.setTitleColor(.white, for: .normal)
            self.followButton.backgroundColor = UIColor(red: 131/255, green: 164/255, blue: 245/255, alpha: 1)
        } else {
            self.followButton.isHidden = true
        }
    }
}

// MARK: - Extension for selectors added
extension AlarmFollowerTableViewCell {
    @objc func deleteData(_ sender: UIButton) {
        self.delegate?.alertFollowerDelete(index: self.index!)
    }
}
