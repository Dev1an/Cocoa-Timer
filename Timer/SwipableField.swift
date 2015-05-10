//
//  SwipableField.swift
//  Timer
//
//  Created by Damiaan Dufaux on 30/04/15.
//  Copyright (c) 2015 Damiaan Dufaux. All rights reserved.
//

import Cocoa

class SwipableField: NSTextField {
	
	@IBOutlet var swipeDelegate: SwipeControlDelegate?
	
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        // Drawing code here.
    }
	
	override func wantsScrollEventsForSwipeTrackingOnAxis(axis: NSEventGestureAxis) -> Bool {
		return axis == NSEventGestureAxis.Vertical
	}
	
	override func scrollWheel(theEvent: NSEvent) {
		swipeDelegate?.change(theEvent.deltaY)
	}
}

@objc protocol SwipeControlDelegate {
	func change(value: CGFloat)
}