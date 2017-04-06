//
//  YFBaseKeyboard.swift
//  TTNumberKeyboard
//
//  Created by 陈嘉维 on 2017/4/6.
//  Copyright © 2017年 TTube. All rights reserved.
//

import UIKit

class YFBaseKeyboardKey: UIView, YFInputKeyViewProtocol {
    func setupView() {}
    
    func refresh(_ vm: YFInputKeyViewModel) {
        viewModel = vm
    }
    
    //MARK: property
    var viewModel: YFInputKeyViewModel?
    
}

protocol YFExpectViewType {
    var viewClass: AnyClass { get }
    func getView() -> UIView
}

class YFBaseKeyboardLine: UIView, YFKeyboardLineViewProtocol {
    private func setupKeys() {
        keyViews.forEach { (view) in
            if let keyView = view as? UIView {
                keyView.removeFromSuperview()
            }
            
        }
        keyViews.removeAll()
        guard let lineVM = viewModel else { return }
        
        var startX = lineVM.padding.left
        let startY = lineVM.padding.top
        for keyVM in lineVM.keys {
            guard let type = expectKeyView(with: keyVM) else { continue }
            let view = type.getView()
            guard view is YFInputKeyViewProtocol else { continue }
            addSubview(view)
            view.frame = CGRect(x: startX + keyVM.margin.left, y: startY + keyVM.margin.top, width: keyVM.expectSize.width, height: keyVM.expectSize.height)
            startX += keyVM.totalSize.width
            //view must has confirmed YFInputKeyViewProtocol when run to this line
            keyViews.append(view as! YFInputKeyViewProtocol)
        }
    }
    
    func refresh(_ vm: YFKeyboardLineViewModel, clear: Bool = false) {
        viewModel = vm
        if clear || keyViews.isEmpty || keyViews.count != vm.keys.count {
            setupKeys()
        }
        for (index, view) in keyViews.enumerated() {
            guard index < vm.keys.count else { break }
            view.refresh(vm.keys[index])
        }
    }
    
    func expectKeyView(with viewModel: YFInputKeyViewModel) -> YFExpectViewType? {
        return nil
    }
    
    //MARK: proprety
    var viewModel: YFKeyboardLineViewModel?
    var keyViews = [YFInputKeyViewProtocol]()
}

class YFBaseKeyboard: UIInputView, YFKeyboardViewProtocol {

    init(_ vm: YFKeyboardViewModel) {
        super.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: vm.totalHeight), inputViewStyle: .default)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupupLines() {
        
    }
    
    func refresh(_ vm: YFKeyboardViewModel, clear: Bool = false) {
        viewModel = vm
    }
    
    var viewModel: YFKeyboardViewModel?
    var lineViews = [YFKeyboardLineViewProtocol]()
    
}
