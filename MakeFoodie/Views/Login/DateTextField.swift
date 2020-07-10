//
//  DateTextField.swift
//  MakeFoodie
//
//  Created by 180527E  on 7/9/20.
//  Copyright © 2020 ITP312. All rights reserved.
//

import UIKit

class DateTextField: UITextField {
    
    //Remove Cursor so cannot copy paste
    override func caretRect(for position: UITextPosition) -> CGRect {
        return CGRect.zero
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        //only paste is gone
        if action == #selector(paste(_:)) || action == #selector(cut(_:)){
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
