//
//  YFNumberPadView.swift
//  TTNumberKeyboard
//
//  Created by 陈嘉维 on 2017/4/6.
//  Copyright © 2017年 TTube. All rights reserved.
//

import UIKit

class YFNumberPadView: UIInputView {

    init(frame: CGRect) {
        super.init(frame: frame, inputViewStyle: .default)
        setupView()
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
    func setupView() {
        let btn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 100, height: 100))
        btn.setTitle("1", for: .normal)
        btn.addTarget(self, action: #selector(keyDidTouch), for: .touchUpInside)
        addSubview(btn)
    }
    
    @objc func keyDidTouch() {
        inputHandler?("1")
    }
    
    //MARK: property
    var inputHandler: ((String) -> ())?
    
    
    
}
