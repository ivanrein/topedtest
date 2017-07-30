//
//  CustomSlider.swift
//  VideoFromPhoto
//
//  Created by Ivan Reinaldo on 7/1/17.
//  Copyright © 2017 rei. All rights reserved.
//

import UIKit
protocol CustomSliderDelegate {
    func customSliderOnValueChanged(lower: Float, upper: Float)
}

@IBDesignable
class UICustomSlider: UIControl {
    
    @IBInspectable var minValueBound: CGFloat = 0
    @IBInspectable var maxValueBound: CGFloat = 150
    
    
    var delegate: CustomSliderDelegate?
    
    private var minValRect:CGRect{
        get{
            return CGRect(x: (bounds.width-20)*(lowerValue), y: bounds.height/2-10, width: 20, height: 20)
        }
    }
    
    private var maxValRect:CGRect{
        get{
            return CGRect(x: (bounds.width-20)*(upperValue), y: bounds.height/2-10, width: 20, height: 20)
        }
    }
    
    
    
    private var sliderBarRect:CGRect{
        get{
            return CGRect(x: 10, y: bounds.height/2-4/2, width: bounds.width-10, height: 4)
        }
    }
    
    private var innerSliderBarRect:CGRect{
        get{
            return CGRect(x: minValRect.midX, y: bounds.height/2-4/2, width: maxValRect.midX - minValRect.midX, height: 4)
        }
    }
    
    var realLowerValue:Float{
        get{
            return Float(minValueBound + (maxValueBound - minValueBound) * lowerValue)
        }
    }
    var realUpperValue:Float{
        get{
            return Float(minValueBound + (maxValueBound - minValueBound) * upperValue)
        }
    }
    
    var lowerValue:CGFloat = 0{
        didSet{
            
            if(lowerValue >= upperValue){
                lowerValue -= 0.1
            }else if(lowerValue < 0){
                lowerValue = 0
            }
            
            setNeedsDisplay()
        }
    }
    var upperValue:CGFloat = 1{
        didSet{
            
            if(upperValue <= lowerValue){
                upperValue += 0.1
            }else if(upperValue > 1){
                upperValue = 1
            }
            
            setNeedsDisplay()
        }
    }
    
    
    private var lowerValueIsChanging = false
    private var upperValueIsChanging = false
    
    override func draw(_ rect: CGRect) {
        
        let minValBez = UIBezierPath(ovalIn: minValRect)
        let maxValBez = UIBezierPath(ovalIn: maxValRect)
        let sliderBez = UIBezierPath(roundedRect: sliderBarRect, cornerRadius: 5.0)
        let innerSliderBez = UIBezierPath(rect: innerSliderBarRect)
        
        UIColor.gray.setFill()
        sliderBez.lineWidth = 1.0
        sliderBez.fill()
        
        UIColor.blue.setFill()
        innerSliderBez.lineWidth = 1.0
        innerSliderBez.fill()
        
        UIColor.white.setFill()
        UIColor.blue.setStroke()
        minValBez.lineWidth = 1.0
        maxValBez.lineWidth = 1.0
        minValBez.fill()
        minValBez.stroke()
        maxValBez.fill()
        maxValBez.stroke()
        
    }
    
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let loc = touch.location(in: self)
        
        if(minValRect.contains(loc)){
            lowerValueIsChanging = true
            print("no pls")
        }else if(maxValRect.contains(loc)){
            upperValueIsChanging = true
        }
        
        return lowerValueIsChanging || upperValueIsChanging
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let pos = touch.location(in: self)
        
        
        if(lowerValueIsChanging){
            lowerValue = pos.x/bounds.width
            if(lowerValue + 0.1 > upperValue) {
                lowerValue = upperValue - 0.1
            }
        }else{
            upperValue = pos.x/bounds.width
            if(upperValue - 0.1 < lowerValue){
                upperValue = lowerValue + 0.1
            }
        }
        
        
        delegate?.customSliderOnValueChanged(lower: realLowerValue, upper: realUpperValue)
        return true
    }
    
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        lowerValueIsChanging = false
        upperValueIsChanging = false
    }
    
    
}
