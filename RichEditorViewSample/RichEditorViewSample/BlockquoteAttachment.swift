//
//  BlockquoteAttachment.swift
//  RichEditorViewSample
//
//  Created by zhuzhanping on 2017/11/15.
//  Copyright © 2017年 Caesar Wirth. All rights reserved.
//

import UIKit
import DTCoreText

class BlockquoteAttachment: DTTextAttachment,DTTextAttachmentDrawing,DTTextAttachmentHTMLPersistence {
    
    func draw(in rect: CGRect, context: CGContext!) {
        context.setFillColor(UIColor.red.cgColor)
        context.addEllipse(in: rect)
        context.closePath()
    }
    
    func stringByEncodingAsHTML() -> String! {
        return "<blockquote>aabsfsf</blockquote>"
    }
    
    override init!(element: DTHTMLElement!, options: [AnyHashable : Any]! = [:]) {
        super.init(element: element, options: options)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
