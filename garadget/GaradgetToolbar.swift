//
//  GaradgetToolbar.swift
//  garadget
//
//  Created by Stephen Madsen on 5/1/16.
//  Copyright © 2016 Stephen Madsen. All rights reserved.
//

class GaradgetToolbar: UIToolbar {
    override func layoutSubviews() {
        super.layoutSubviews()
        frame.size.height = 64
    }
    
    override func sizeThatFits(size: CGSize) -> CGSize {
        var size = super.sizeThatFits(size)
        size.height = 64
        return size
    }

}
