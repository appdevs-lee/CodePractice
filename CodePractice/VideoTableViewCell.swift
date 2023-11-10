//
//  VideoTableViewCell.swift
//  CodePractice
//
//  Created by Awesomepia on 11/10/23.
//

import UIKit

final class VideoTableViewCell: UITableViewCell {
    
    lazy var videoTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1)
        label.font = .boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var numberBackgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var numberLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 343, height: 194)
        flowLayout.minimumLineSpacing = 1
        flowLayout.minimumInteritemSpacing = 1
        flowLayout.headerReferenceSize = .zero
        flowLayout.footerReferenceSize = .zero
        flowLayout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = .white
        collectionView.register(RenewalLiveDetailVideoCollectionViewCell.self, forCellWithReuseIdentifier: "RenewalLiveDetailVideoCollectionViewCell")
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.bounces = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    lazy var videoContentLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1)
        label.font = .boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var url: [String]  = [
        "https://aspiamediasvc-koct1.streaming.media.azure.net/a225d2c2-0f0e-4da7-becb-c590107a6554/25_cheonasupdullegil.ism/manifest(format=m3u8-cmaf)",
        "http://59.8.86.15:1935/live/44.stream/playlist.m3u8",
        "http://119.65.216.155:1935/live/cctv03.stream_360p/playlist.m3u8"
    ]
    
    var beforeIndex: Int = 0
    
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
extension VideoTableViewCell {
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
        self.addSubview(self.collectionView)
        
    }
    
    // Set layouts
    func setLayouts() {
        //let safeArea = self.safeAreaLayoutGuide
        
        // collectionView
        NSLayoutConstraint.activate([
            self.collectionView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.collectionView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            self.collectionView.widthAnchor.constraint(equalToConstant: 343),
            self.collectionView.heightAnchor.constraint(equalToConstant: 194),
            
            self.collectionView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            self.collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16)
        ])
    }
}

// MARK: - Extension for methods added
extension VideoTableViewCell {
    func setCell() {
        
    }
}

// MARK: - Extension for UICollectionViewDelegateFlowLayout, UICollectionViewDataSource
extension VideoTableViewCell: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RenewalLiveDetailVideoCollectionViewCell", for: indexPath) as! RenewalLiveDetailVideoCollectionViewCell
        let url = self.url[indexPath.row]
        
        cell.setCell(url: url)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.url.count
        
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x / self.collectionView.frame.width)
        self.beforeIndex = index
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x / self.collectionView.frame.width)
        
        if self.beforeIndex == index {
            print("index: \(index)")
            
        } else {
            guard let cell = self.collectionView.cellForItem(at: IndexPath(row: self.beforeIndex, section: 0)) as? RenewalLiveDetailVideoCollectionViewCell else { return }
            
            cell.videoView.pause()
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        print("index: \(indexPath.row)")
//        let cell = self.collectionView.cellForItem(at: indexPath) as! RenewalLiveDetailVideoCollectionViewCell
//        
//        cell.videoView.pause()
    }
    
}
