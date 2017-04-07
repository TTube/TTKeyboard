//
//  YFInputViewController.swift
//  TTNumberKeyboard
//
//  Created by 陈嘉维 on 2017/4/6.
//  Copyright © 2017年 TTube. All rights reserved.
//

import UIKit

enum KeyboardType {
    case numberPad
}

extension KeyboardType {
    func inputController() -> YFInputViewController {
        let numKeyboard = YFNumberPadView()
        let inputVC = YFInputViewController()
        inputVC.keyboard = numKeyboard
        return inputVC
    }
}

class YFInputViewController: UIInputViewController, YFKeyboardDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func keyboard(keyboard: YFKeyboard, didInput: YFInputType) {
        switch didInput {
        case .appned(let inputString):
            textDocumentProxy.insertText(inputString)
            break
        case .delete:
            textDocumentProxy.deleteBackward()
            break
        case .action(let action):
            action?()
            break
        }
    }
    
    //MARK: property
    var keyboard: YFKeyboard? {
        didSet {
            oldValue?.delegate = nil
            guard let unwarpedKeyboard = keyboard else { return }
            let inputView = YFInputView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: unwarpedKeyboard.expectSize()))
            inputView.keyboardView = unwarpedKeyboard
            inputView.delegate = self
            self.inputView = inputView
        }
    }
    
    
}
