//
//  FrameNavigationController.swift
//  RNZendesk
//
//  Created by Catalin Voss on 12/1/19.
//  Copyright © 2019 Catalin Voss. All rights reserved.
//

//
// A navigation controller superclass used to "hack out" the Zendesk exit button
//

import Foundation

class FrameNavigationController: UINavigationController {
    public var exitCallback:RCTResponseSenderBlock? = nil
    
    @objc func exit(sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Sign Out", message: "Do you want to sign out?", preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        alertController.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: { action in
            if self.exitCallback != nil {
                self.dismiss(animated: true, completion: nil)
                self.exitCallback?([NSNull(), NSNull()])
            }
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
    public func performClear() {
        if (self.viewControllers.count == 1) {
            let exitButton = UIBarButtonItem(image: UIImage(named: "logout"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(exit(sender:)))
            self.navigationBar.topItem?.leftBarButtonItem = exitButton
            self.visibleViewController?.navigationItem.leftBarButtonItem = exitButton
        }
    }

    func clearLeftButton() {
        // Now and again in 0.5 and 1 seconds to be fucking safe
        self.performClear()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.performClear()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.performClear()
        }
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.clearLeftButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.clearLeftButton()
    }
}
