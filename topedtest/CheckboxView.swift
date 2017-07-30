//
//  CheckboxView.swift
//  topedtest
//
//  Created by Ivan Reinaldo on 7/28/17.
//  Copyright © 2017 rei. All rights reserved.
//

import UIKit

@IBDesignable
class CheckboxView: UIControl {

    
    @IBInspectable var isChecked = false
    
    override func draw(_ rect: CGRect) {
        
        let rect = CGRect(x: 5, y: 5, width: bounds.width-10, height: bounds.height-10)
        let kotak = UIBezierPath(roundedRect: rect, cornerRadius: 3.0)
        
        
        UIColor.green.setStroke()
        kotak.stroke()
        if(isChecked){
            let garis1 = UIBezierPath()
            let start = CGPoint(x: bounds.width/2, y: bounds.height/2)
            
            let end = CGPoint(x: start.x - (1*start.x/2-2), y: start.y - (1*start.y/2-2))
            garis1.move(to: start)
            garis1.addLine(to: end)
           // garis1.stroke()
            
            let end2 =  CGPoint(x: bounds.width, y: 0)
            
            
            let garis2 = UIBezierPath()
            garis2.move(to:start)
            garis2.addLine(to: end2)
            garis1.stroke()
            garis2.stroke()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
            isChecked = !isChecked
            setNeedsDisplay()
        }
    }
    
    
    

}
