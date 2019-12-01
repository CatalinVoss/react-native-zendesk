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

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func clearLeftButton() {
        let emptyButton = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
        self.navigationBar.topItem?.leftBarButtonItem = emptyButton
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
