//
//  YFInputViewController.swift
//  TTNumberKeyboard
//
//  Created by 陈嘉维 on 2017/4/6.
//  Copyright © 2017年 TTube. All rights reserved.
//

import UIKit

class YFInputViewController: UIInputViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.inputView = keyboard
        keyboard.inputHandler = { [weak self] inputString in
            self?.textDocumentProxy.insertText(inputString)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: property
    var keyboard = YFNumberPadView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: 300))
    
    
}
