//
//  DeleteButton.swift
//  topedtest
//
//  Created by Ivan Reinaldo on 7/29/17.
//  Copyright © 2017 rei. All rights reserved.
//

import UIKit

@IBDesignable
class DeleteButton: UIView {

    
    override func draw(_ rect: CGRect) {
        let rectInset = rect.insetBy(dx: 1, dy: 1)
        let path = UIBezierPath(ovalIn: rectInset)
        
        UIColor.gray.setFill()
        UIColor.black.setStroke()
        path.fill()        
        path.stroke()
        UIColor.white.setStroke()
        let garis1 = UIBezierPath()
        
        let x0 = rectInset.midX - (0.7 * rectInset.width / 2)
        let y0 = rectInset.midY - (0.7 * rectInset.width / 2)
        let x1 = rectInset.midX + (0.7 * rectInset.width / 2)
        let y1 = rectInset.midY + (0.7 * rectInset.width / 2)
        
        garis1.move(to: CGPoint(x: x0, y: y0))
        garis1.addLine(to: CGPoint(x: x1, y: y1))
        
        let garis2 = UIBezierPath()
        garis2.move(to: CGPoint(x: x1, y: x0))
        garis2.addLine(to: CGPoint(x: x0, y: y1))
        
        garis1.stroke()
        garis2.stroke()
    }
 
    
}
