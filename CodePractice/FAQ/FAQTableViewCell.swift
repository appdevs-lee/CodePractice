//
//  FAQTableViewCell.swift
//  CodePractice
//
//  Created by Awesomepia on 2023/08/14.
//
import UIKit

final class FAQTableViewCell: UITableViewCell {
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.titleStackView, self.contentLabel])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    lazy var titleStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.titleLabel, self.upAndDownButton])
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "여러 기기에 중복으로 로그인 할 수 있나요?"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var upAndDownButton: UIButton = {
        let button = UIButton()
        button.imageView?.image = UIImage(systemName: "chevron.down")
        button.addTarget(self, action: #selector(tappedUpAndDownButton(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false

        
        return button
    }()
    
    lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.text = "중복로그인은 불가능합니다."
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var isVisible = false
    
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
extension FAQTableViewCell {
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
        self.addSubview(self.stackView)
    }
    
    // Set layouts
    func setLayouts() {
        //let safeArea = self.safeAreaLayoutGuide
        
        // stackView
        NSLayoutConstraint.activate([
            self.stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            self.stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            self.stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            self.stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
        ])
    }
}

// MARK: - Extension for methods added
extension FAQTableViewCell {
    func setCell() {
        if self.isVisible {
            self.upAndDownButton.imageView?.image = UIImage(systemName: "chevron.up")
            self.contentLabel.isHidden = false
        } else {
            self.upAndDownButton.imageView?.image = UIImage(systemName: "chevron.down")
            self.contentLabel.isHidden = true
        }
    }
}

// MARK: - Extension for seletors added
extension FAQTableViewCell {
    @objc func tappedUpAndDownButton(_ sender: UIButton) {
        if self.isVisible {
            self.upAndDownButton.imageView?.image = UIImage(systemName: "chevron.down")
            self.contentLabel.isHidden = true
            self.isVisible = false
            
        } else {
            self.upAndDownButton.imageView?.image = UIImage(systemName: "chevron.up")
            self.contentLabel.isHidden = false
            self.isVisible = true
            
        }
    }
}
