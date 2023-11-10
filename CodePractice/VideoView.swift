//
//  VideoView.swift
//  CodePractice
//
//  Created by Awesomepia on 11/10/23.
//

import UIKit
import AVFoundation

final class VideoView: UIView {
    
    lazy var videoBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var playButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "PlayButton"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.addTarget(self, action: #selector(tappedPlayButton(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    init() {
        super.init(frame: .zero)
        
        self.setSubViews()
        self.setLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        self.playerLayer.frame = self.videoBackgroundView.bounds
    }
    
    var url: String = ""
    var player = AVPlayer()
    private var playerLayer = AVPlayerLayer()
    private var slider = UISlider()
    
}

extension VideoView {
    func setSubViews() {
        self.addSubview(self.videoBackgroundView)
        self.addSubview(self.playButton)
    }
    
    func setLayouts() {
        
        // videoBackgroundView
        NSLayoutConstraint.activate([
            self.videoBackgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.videoBackgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.videoBackgroundView.topAnchor.constraint(equalTo: self.topAnchor),
            self.videoBackgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
        
        // playButton
        NSLayoutConstraint.activate([
            self.playButton.centerYAnchor.constraint(equalTo: self.videoBackgroundView.centerYAnchor),
            self.playButton.centerXAnchor.constraint(equalTo: self.videoBackgroundView.centerXAnchor),
            self.playButton.widthAnchor.constraint(equalToConstant: 64),
            self.playButton.heightAnchor.constraint(equalToConstant: 64)
        ])
    }
    
    func setVideo(url: String) {
        guard let url = URL(string: url) else { return }
        let item = AVPlayerItem(url: url)
        self.player.replaceCurrentItem(with: item)
        
        let playerLayer = AVPlayerLayer(player: self.player)
        playerLayer.frame = self.videoBackgroundView.bounds
        playerLayer.videoGravity = .resizeAspectFill
        
        self.playerLayer = playerLayer
        self.videoBackgroundView.layer.addSublayer(playerLayer)
        
        if self.player.currentItem?.status == .readyToPlay {
            self.slider.minimumValue = 0
            self.slider.maximumValue = Float(CMTimeGetSeconds(item.duration))
        }
        self.slider.addTarget(self, action: #selector(changeValue), for: .valueChanged)
        
        let interval = CMTimeMakeWithSeconds(1, preferredTimescale: Int32(NSEC_PER_SEC))
        self.player.addPeriodicTimeObserver(forInterval: interval, queue: .main, using: { [weak self] elapsedSeconds in
            let elapsedTimeSecondsFloat = CMTimeGetSeconds(elapsedSeconds)
            let totalTimeSecondsFloat = CMTimeGetSeconds(self?.player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
            
            if !totalTimeSecondsFloat.isNaN {
                if Int(elapsedTimeSecondsFloat) == Int(totalTimeSecondsFloat) {
                    self?.player.seek(to: .zero)
                    self?.player.pause()
                    self?.playButton.setImage(UIImage(named: "PlayButton"), for: .normal)
                    
                }
                
            }
            
        })
    }
}

// MARK: - Extension for methods added
extension VideoView {
    func reloadData(url: String) {
        self.url = url
        
        self.setVideo(url: self.url)
    }
    
    func pause() {
        self.player.pause()
        self.playButton.setImage(UIImage(named: "PlayButton"), for: .normal)
        
    }
}

// MARK: - Extension for selector added
extension VideoView {
    @objc func changeValue() {
        self.player.seek(to: CMTime(seconds: Double(self.slider.value), preferredTimescale: Int32(NSEC_PER_SEC)), completionHandler: { _ in })
        
    }
    
    @objc func tappedPlayButton(_ sender: UIButton) {
        switch self.player.timeControlStatus {
        case .paused:
            self.player.play()
            self.playButton.setImage(UIImage(named: "PauseButton"), for: .normal)
            
        case .playing:
            self.player.pause()
            self.playButton.setImage(UIImage(named: "PlayButton"), for: .normal)
            
        default:
          break
        }
    }
}
