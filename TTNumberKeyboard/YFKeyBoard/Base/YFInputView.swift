//
//  YFInputView.swift
//  TTNumberKeyboard
//
//  Created by 陈嘉维 on 2017/4/7.
//  Copyright © 2017年 TTube. All rights reserved.
//

import UIKit

protocol YFKeyboardDelegate: class {
    func keyboard(keyboard: YFKeyboard, didInput: YFInputType)
}

protocol YFKeyboard: class, SizeExpectable {
    var delegate: YFKeyboardDelegate? { get set }
    func reload()
}

typealias YFInputAction = () -> ()

enum YFInputType {
    case appned(String)
    case delete
    case action(YFInputAction?)
}

class YFInputView: UIInputView {

    init(frame: CGRect) {
        super.init(frame: frame, inputViewStyle: .default)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: private
    private func setupView() {
        guard let keyboard = keyboardView as? UIView else { return }
        addSubview(keyboard)
        keyboard.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        keyboardView?.reload()
        
    }
    
    //MARK: property
    weak var delegate: YFKeyboardDelegate? {
        set {
            keyboardView?.delegate = newValue
        }
        get {
            return keyboardView?.delegate
        }
    }
    
    var keyboardView: YFKeyboard? {
        didSet {
            if let old = oldValue as? UIView {
                old.removeFromSuperview()
            }
            setupView()
        }
    }
    var oldSize: CGSize = .zero

    
}
