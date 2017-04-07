//
//  YFBaseKeyboard.swift
//  TTNumberKeyboard
//
//  Created by 陈嘉维 on 2017/4/6.
//  Copyright © 2017年 TTube. All rights reserved.
//

import UIKit
import SnapKit

class YFBaseKeyboardKey: UIView, YFKeyboardSubview {
    
    func setupView() {}
    
    func expectSize() -> CGSize {
        guard let vm = viewModel as? YFInputKeyViewModel else { return .zero }
        return vm.expectSize
    }
    
    func refresh(_ vm: YFKeyboardBaseViewModel, clear: Bool) {}
    
    //MARK: property
    var viewModel: YFKeyboardBaseViewModel?
    
}


class YFBaseKeyboardLine: UIView, YFKeyboardSubview {

    
    private func setupKeys() {
        keyViews.forEach { (view) in
            view.removeFromSuperview()
            
        }
        keyViews.removeAll()
        guard let lineVM = viewModel as? YFKeyboardLineViewModel else { return }
        
        var startX = lineVM.padding.left
        let startY = lineVM.padding.top
        for keyVM in lineVM.keys {
            guard let view = keyVM.getView() as? YFBaseKeyboardKey else { continue }
            addSubview(view)
            view.setupView()
            view.frame = CGRect(x: startX + keyVM.margin.left, y: startY + keyVM.margin.top, width: keyVM.expectSize.width, height: keyVM.expectSize.height)
            startX += keyVM.totalSize.width
            //view must has confirmed YFInputKeyViewProtocol when run to this line
            keyViews.append(view)
        }
    }
    
    func refresh(_ vm: YFKeyboardBaseViewModel, clear: Bool) {
        guard let lineVM = vm as? YFKeyboardLineViewModel else { return }
        viewModel = lineVM
        if clear || keyViews.isEmpty || keyViews.count != lineVM.keys.count {
            setupKeys()
        }
        for (index, view) in keyViews.enumerated() {
            guard index < lineVM.keys.count else { break }
            view.refresh(lineVM.keys[index], clear: clear)
        }
    }

    func expectSize() -> CGSize {
        guard let vm = viewModel as? YFKeyboardLineViewModel else { return .zero }
        return vm.lineSize
    }
    
    //MARK: proprety
    var viewModel: YFKeyboardBaseViewModel?
    var keyViews = [YFBaseKeyboardKey]()
}

class YFBaseKeyboard: UIView, YFKeyboardSubview {
    
    init(_ vm: YFKeyboardViewModel) {
        super.init(frame: CGRect.init(x: 0, y: 0, width: vm.totalSize.width, height: vm.totalSize.height))
        viewModel = vm
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLines() {
        lineViews.forEach { (line) in
            line.removeFromSuperview()
        }
        lineViews.removeAll()
        guard let vm = viewModel as? YFKeyboardViewModel else { return }
        var lastView: UIView?
        for lineVM in vm.lines {
            guard let lineView = lineVM.getView() as? YFBaseKeyboardLine else { continue }
            addSubview(lineView)
            lineView.snp.makeConstraints({ (make) in
                
                make.size.equalTo(lineVM.lineSize)
                
                if let last = lastView {
                    make.top.equalTo(last.snp.bottom)
                }else {
                    make.top.equalToSuperview()
                }
                
                switch lineVM.horizontalAlign {
                case .left:
                    make.left.equalToSuperview()
                    break
                case .center:
                    make.centerX.equalToSuperview()
                    break
                case .right:
                    make.right.equalToSuperview()
                    break
                }
                
            })
            lineViews.append(lineView)
            lastView = lineView
        }
        if let last = lastView {
            last.snp.makeConstraints({ (make) in
                 make.bottom.equalToSuperview()
            })
        }
        
    }
    
    func refresh(_ vm: YFKeyboardBaseViewModel, clear: Bool = false) {
        guard let keyboardVM = vm as? YFKeyboardViewModel else { return }
        viewModel = keyboardVM
        if clear || lineViews.isEmpty || lineViews.count != keyboardVM.lines.count {
            setupLines()
        }
        
        for (index, view) in lineViews.enumerated() {
            guard index < keyboardVM.lines.count else { break }
            view.refresh(keyboardVM.lines[index], clear: clear)
        }
        
    }
    
    func expectSize() -> CGSize {
        return (viewModel as? YFKeyboardViewModel)?.totalSize ?? .zero
    }
    
    //MARK: property
    var viewModel: YFKeyboardBaseViewModel?
    var lineViews = [YFBaseKeyboardLine]()
    
}
