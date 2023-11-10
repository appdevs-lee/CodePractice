//
//  PipViewController.swift
//  CodePractice
//
//  Created by Awesomepia on 10/20/23.
//

import UIKit
import PIPKit

final class PipViewController: UIViewController {
    
    lazy var pipButton: UIButton = {
        let button = UIButton()
        button.setTitle("운행 시작", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(tappedPipButton(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    lazy var dismissButton: UIButton = {
        let button = UIButton()
        button.setTitle("운행 종료", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(tappedDismissButton(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    lazy var captureView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var screenImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setViewAfterTransition()
    }
    
    deinit {
            print("----------------------------------- TemplateViewController is disposed -----------------------------------")
    }
}

// MARK: Extension for essential methods
extension PipViewController: EssentialViewMethods {
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
        self.view.addSubview(self.pipButton)
        self.view.addSubview(self.dismissButton)
        self.view.addSubview(self.screenImage)
        self.view.addSubview(self.captureView)
    }
    
    func setLayouts() {
        let safeArea = self.view.safeAreaLayoutGuide
        
        // pipButton
        NSLayoutConstraint.activate([
            self.pipButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            self.pipButton.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor)
        ])
        
        // dismissButton
        NSLayoutConstraint.activate([
            self.dismissButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            self.dismissButton.topAnchor.constraint(equalTo: self.pipButton.bottomAnchor, constant: 4)
        ])
        
        // screenImage
        NSLayoutConstraint.activate([
            self.screenImage.topAnchor.constraint(equalTo: safeArea.topAnchor),
            self.screenImage.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            self.screenImage.widthAnchor.constraint(equalToConstant: 80),
            self.screenImage.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        // captureView
        NSLayoutConstraint.activate([
            self.captureView.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
            self.captureView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            self.captureView.widthAnchor.constraint(equalToConstant: 80),
            self.captureView.heightAnchor.constraint(equalToConstant: 240)
        ])
    }
    
    func setViewAfterTransition() {
        //self.navigationController?.setNavigationBarHidden(false, animated: true)
        //self.tabBarController?.tabBar.isHidden = false
    }
}

// MARK: - Extension for methods added
extension PipViewController {
    func screenShot() {
        self.captureView.isHidden = false
        self.screenImage.image = self.captureView.asImage()
    }
}

extension UIView {
    func asImage() -> UIImage? {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        
        return renderer.image {
            rendererContext in layer.render(in: rendererContext.cgContext)
            
        }
        
    }
}

// MARK: - Extension for selector methods
extension PipViewController {
    @objc func tappedPipButton(_ sender: UIButton) {
        self.screenShot()
        
    }
    
    @objc func tappedDismissButton(_ sender: UIButton) {
        PIPKit.dismiss(animated: true)
        
    }
}


