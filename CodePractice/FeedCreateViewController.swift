//
//  FeedCreateViewController.swift
//  CodePractice
//
//  Created by Awesomepia on 2023/08/01.
//

import UIKit
import PIPKit

final class FeedCreateViewController: UIViewController {
    
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
extension FeedCreateViewController: EssentialViewMethods {
    func setViewFoundation() {
        self.view.backgroundColor = .red
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
        
    }
    
    func setLayouts() {
        //let safeArea = self.view.safeAreaLayoutGuide
        
        //
        NSLayoutConstraint.activate([
            
        ])
    }
    
    func setViewAfterTransition() {
        //self.navigationController?.setNavigationBarHidden(false, animated: true)
        //self.tabBarController?.tabBar.isHidden = false
    }
}

// MARK: - Extension for methods added
extension FeedCreateViewController {
    
}

// MARK: - Extension for selector methods
extension FeedCreateViewController {
    
}

// MARK: - Extension for PIPUsable
extension FeedCreateViewController: PIPUsable {
    func updatePIPSize() {
//        setNeedsUpdatePIPFrame()
    }
    
    func fullScreenAndPIPMode() {
        if PIPKit.isPIP {
            stopPIPMode()
        } else {
            startPIPMode()
        }
    }

    func didChangedState(_ state: PIPState) {}
}
