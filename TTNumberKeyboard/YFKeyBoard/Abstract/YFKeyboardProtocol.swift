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

//MARK: ViewModel

protocol YFInputKeyType {}

protocol YFExpectViewType {
    var viewClass: AnyClass { get }
    func getView() -> UIView
}

protocol YFKeyboardBaseViewModel {}

/// description of keyboard's every key
protocol YFInputKey {
    var inputType: YFInputKeyType { get set }
}


/// description of keyboard's every key‘s layout
protocol YFInputKeyViewModel: YFInputKey, YFKeyboardBaseViewModel, YFExpectViewType {
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

//for each keyboard line, this enum describe its horizontal position in superView
enum YFKeyboardLineHorizontalAlign {
    case left, center, right
}


/// keyboard line ViewModel
protocol YFKeyboardLineViewModel: YFExpectViewType, YFKeyboardBaseViewModel {
    var horizontalAlign: YFKeyboardLineHorizontalAlign { get set }
    
    /// every key will show on current keyboard line
    var keys: [YFInputKeyViewModel] { get set }
    
    //line padding
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


protocol YFKeyboardViewModel: YFExpectViewType, YFKeyboardBaseViewModel {
    /// every line will show on keyboard
    var lines: [YFKeyboardLineViewModel] { get set }
}

extension YFKeyboardViewModel {
    var totalSize: CGSize {
        get {
           return lines.reduce(CGSize.zero, { (last, element) -> CGSize in
            return CGSize(width: max(last.width, element.lineSize.width), height: last.height + element.lineSize.height)
           })
        }
        
    }
}


//MARK: Keyboard view
protocol SizeExpectable {
    func expectSize() -> CGSize
}


protocol YFKeyboardSubview: SizeExpectable {
    var viewModel: YFKeyboardBaseViewModel? { get set }
    func refresh(_ vm: YFKeyboardBaseViewModel, clear: Bool)
    
}


