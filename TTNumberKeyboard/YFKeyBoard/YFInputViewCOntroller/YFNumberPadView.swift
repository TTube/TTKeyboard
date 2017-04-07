//
//  YFNumberPadView.swift
//  TTNumberKeyboard
//
//  Created by 陈嘉维 on 2017/4/6.
//  Copyright © 2017年 TTube. All rights reserved.
//

import UIKit
extension YFInputType: YFInputKeyType {}

struct YFNumKeyViewModel: YFInputKeyViewModel {

    var inputType: YFInputKeyType
    var expectSize: CGSize
    var margin: UIEdgeInsets
    
    var viewClass: AnyClass {
        return YFNumKeyboardKey.classForCoder()
    }
    
    var clickAction: YFInputAction?
    
    func getView() -> UIView {
        return YFNumKeyboardKey()
    }
    
    init(_ type: YFInputKeyType, _ size: CGSize, _ margin: UIEdgeInsets = .zero, _ clickAction: YFInputAction? = nil) {
        inputType = type
        expectSize = size
        self.margin = margin
        self.clickAction = clickAction
    }
}

struct YFNumLineViewModel: YFKeyboardLineViewModel {
    var horizontalAlign: YFKeyboardLineHorizontalAlign = .center
    
    var keys: [YFInputKeyViewModel]
    
    var padding: UIEdgeInsets = .zero
    
    var viewClass: AnyClass = YFBaseKeyboardLine.classForCoder()
    
    func getView() -> UIView {
        return YFBaseKeyboardLine()
    }
    
    init(keys: [YFInputKeyViewModel]) {
        self.keys = keys
    }
}

struct YFNumKeyboardViewModel: YFKeyboardViewModel {
    
    var lines: [YFKeyboardLineViewModel]
    
    var viewClass: AnyClass = YFBaseKeyboard.classForCoder()
    
    func getView() -> UIView {
        return YFBaseKeyboard(self)
    }
    
    init(_ lines: [YFKeyboardLineViewModel]) {
        self.lines = lines
    }
}

class YFNumKeyboardKey: YFBaseKeyboardKey {
    
    override func setupView() {
        super.setupView()
        addSubview(numBtn)
        numBtn.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func btnDidClick() {
        guard let vm = viewModel as? YFNumKeyViewModel else { return }
        vm.clickAction?()
    }
    
    override func refresh(_ vm: YFKeyboardBaseViewModel, clear: Bool) {
        guard let numKeyVM = vm as? YFNumKeyViewModel else { return }
        viewModel = numKeyVM
        if let inputType = numKeyVM.inputType as? YFInputType {
            switch inputType {
            case .appned(let number):
                numBtn.setTitle(number, for: .normal)
                break
            case .delete:
                numBtn.setTitle("删除", for: .normal)
                break
            default:
                //unsupport
                numBtn.setTitle("", for: .normal)
                break
            }
        }
    }
    
    //MARK: property
    lazy var numBtn: UIButton = {
        let btn = UIButton()
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.addTarget(self, action: #selector(btnDidClick), for: .touchUpInside)
        return btn
    }()
    
}


class YFNumberPadView: UIView, YFKeyboard {
    typealias LineDesc = ([YFInputType], YFKeyboardLineHorizontalAlign)
    convenience init() {
        self.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
    func setupView() {
        if let oldNumKeyboard = numKeyboard {
            oldNumKeyboard.removeFromSuperview()
        }
        
        let new = keyboardViewModel.getView()
        addSubview(new)
        new.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        if let unwarpKeyboardSubView = new as? YFBaseKeyboard {
            numKeyboard = unwarpKeyboardSubView
        }
        backgroundColor = UIColor.black
    }

    
    func reload() {
        numKeyboard?.refresh(keyboardViewModel, clear: false)
    }
    
    func expectSize() -> CGSize {
        return self.keyboardViewModel.totalSize
    }
    
    //MARK: private
    private func getKeyViewModel(with type: YFInputType) -> YFNumKeyViewModel {
        //屏幕宽度 三等分
        let keywidth = UIScreen.main.bounds.width / 3.0
        let clickAction: YFInputAction = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.delegate?.keyboard(keyboard: strongSelf, didInput: type)
        }
        let vm = YFNumKeyViewModel(type, CGSize(width: keywidth, height: 60), .zero, clickAction)
        return vm
    }
    
    private func getLineViewModel(with desc: LineDesc) -> YFNumLineViewModel {
        var line = YFNumLineViewModel(keys: desc.0.map{ return getKeyViewModel(with: $0) })
        line.horizontalAlign = desc.1
        return line
    }
    
    
    //MARK: property
    weak var delegate: YFKeyboardDelegate?
    
    lazy var keyboardViewModel: YFNumKeyboardViewModel = {
        let lines = self.keyPosition.map{ return self.getLineViewModel(with: $0) }
        return YFNumKeyboardViewModel(lines)
    }()
    
    let keyPosition: [LineDesc] = [
        LineDesc([.appned("1"), .appned("2"), .appned("3")], .center),
        LineDesc([.appned("4"), .appned("5"), .appned("6")], .center),
        LineDesc([.appned("7"), .appned("8"), .appned("9")], .center),
        LineDesc([.appned("0"), .delete], .right),
    ]
    
    var numKeyboard: YFBaseKeyboard?
    
}
