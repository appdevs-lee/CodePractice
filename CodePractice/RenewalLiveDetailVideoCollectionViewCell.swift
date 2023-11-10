//
//  RenewalLiveDetailVideoCollectionViewCell.swift
//  CodePractice
//
//  Created by Awesomepia on 11/10/23.
//

import UIKit

final class RenewalLiveDetailVideoCollectionViewCell: UICollectionViewCell {
    
    lazy var videoView: VideoView = {
        let view = VideoView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setViewFoundation()
        self.initializeObjects()
        self.setSubviews()
        self.setLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Extension for essential methods
extension RenewalLiveDetailVideoCollectionViewCell: EssentialCellHeaderMethods {
    func setViewFoundation() {
        self.backgroundColor = .white
        
    }
    
    func initializeObjects() {
        
    }
    
    func setSubviews() {
        self.addSubview(self.videoView)
        
    }
    
    func setLayouts() {
        
        // videoView
        NSLayoutConstraint.activate([
            self.videoView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.videoView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.videoView.topAnchor.constraint(equalTo: self.topAnchor),
            self.videoView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
}

// MARK: - Extension for methods added
extension RenewalLiveDetailVideoCollectionViewCell {
    func setCell(url: String) {
        self.videoView.reloadData(url: url)
        
    }
}

