//
//  UIShopTypeViewCell.swift
//  topedtest
//
//  Created by Ivan Reinaldo on 7/29/17.
//  Copyright © 2017 rei. All rights reserved.
//

import UIKit
@IBDesignable
class UIShopTypeViewCell: UICollectionViewCell {
    
    @IBOutlet weak var shopLabel: UILabel!
    @IBOutlet weak var deleteButton: DeleteButton!
    override func draw(_ rect: CGRect) {
        let rectInset = rect.insetBy(dx: 1, dy: 1)
        let path = UIBezierPath(roundedRect: rectInset, cornerRadius: 50)
        path.stroke()
    }
    
    
    
    
}
