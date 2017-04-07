//
//  TTTextFIeld.swift
//  TTNumberKeyboard
//
//  Created by 陈嘉维 on 2017/4/6.
//  Copyright © 2017年 TTube. All rights reserved.
//

import UIKit

class TTTextFIeld: UITextField {

    override var inputViewController: UIInputViewController? {
        get {
            return KeyboardType.numberPad.inputController()
        }
    }
}
