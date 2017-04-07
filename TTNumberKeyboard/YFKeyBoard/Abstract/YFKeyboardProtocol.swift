//
//  YFKeyboardProtocol.swift
//  TTNumberKeyboard
//
//  Created by 陈嘉维 on 2017/4/6.
//  Copyright © 2017年 TTube. All rights reserved.
//

import Foundation
import UIKit

typealias InputAction = () -> ()

protocol YFInputKeyType {}

/// description of keyboard's every key
protocol YFInputKey {
    var inputType: YFInputKeyType { get set }
}


protocol YFInputKeyViewModel: YFInputKey {
    var expectSize: CGSize { get set }
    var margin: UIEdgeInsets { get set }
}

extension YFInputKeyViewModel {
    var margin: UIEdgeInsets {
        return .zero
    }
    
    var totalSize: CGSize {
        return CGSize(width: expectSize.width + margin.left + margin.right, height: expectSize.height + margin.top + margin.bottom)
    }
}


protocol YFInputKeyViewProtocol {
    var viewModel: YFInputKeyViewModel? { get set }
    func refresh(_  vm: YFInputKeyViewModel)
}

extension YFInputKeyViewProtocol {
    func refresh(_  vm: YFInputKeyViewModel) {}
}


enum YFKeyboardLineHorizontalAlign {
    case left, center, right
}


protocol YFKeyboardLineViewModel {
    var horizontalAlign: YFKeyboardLineHorizontalAlign { get set }
    var keys: [YFInputKeyViewModel] { get set }
    var padding: UIEdgeInsets { get set }
}

extension YFKeyboardLineViewModel {
    var padding: UIEdgeInsets {
        return .zero
    }
    
    var lineSize: CGSize {
        get {
            var expectWidth: CGFloat = padding.left + padding.right
            var expectHeight: CGFloat = padding.top + padding.bottom
            for keyVM in keys {
                let keySize = keyVM.totalSize
                expectWidth += keySize.width
                expectHeight = max(keySize.height + padding.top + padding.bottom, expectHeight)
            }
            return CGSize(width: expectWidth, height: expectHeight)
        }
    }
}


protocol YFKeyboardLineViewProtocol {
    var viewModel: YFKeyboardLineViewModel? { get set }
    func refresh(_ vm: YFKeyboardLineViewModel, clear: Bool)
}

extension YFKeyboardLineViewProtocol {
    var lineSize: CGSize {
        return viewModel?.lineSize ?? .zero
    }
    
    func refresh(_ vm: YFKeyboardLineViewModel, clear: Bool = false) {}
}

protocol YFKeyboardViewModel {
    var lines: [YFKeyboardLineViewModel] { get set }
}

protocol YFKeyboardViewProtocol {
    var viewModel: YFKeyboardViewModel? { get set }
    func refresh(_ vm: YFKeyboardViewModel, clear: Bool)
}

extension YFKeyboardViewModel {
    var totalSize: CGSize {
        get {
           return lines.reduce(CGSize.zero, { (last, element) -> CGSize in
            return CGSize(width: max(last.width, element.lineSize.width), height: element.lineSize.height)
           })
        }
        
    }
}


extension YFKeyboardViewProtocol {
    var keyboardSize: CGSize {
        return viewModel?.totalSize ?? .zero
    }
    
    func refresh(_ vm: YFKeyboardViewModel, clear: Bool = false) {}
}


