//
//  ViewController.swift
//  Timer
//
//  Created by Damiaan Dufaux on 29/04/15.
//  Copyright (c) 2015 Damiaan Dufaux. All rights reserved.
//

import Cocoa
import CoreTimer

class ViewController: NSViewController {

	var timer = Timer(duration: NSTimeInterval(73))
	var isTiming = false
	
	@IBOutlet var timeLabel: SwipableField!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		updateTimeLabel()
		timeLabel.swipeDelegate = self
		// Do any additional setup after loading the view.
	}
	
	override func viewWillAppear() {
		timer.signalFunction = self.updateTimeLabel
	}
	
	override func viewWillDisappear() {
		timer.signalFunction = nil
	}
	
	func updateTimeLabel() {
		var interval = timer.getTime()
		let time = (
			NSString(format: "%02d", Int(round(interval % 60))),
			NSString(format: "%02d", Int(interval/60) % 60),
			NSString(format: "%02d", Int(interval / 3600))
		)
		timeLabel.stringValue = "\(time.2):\(time.1):\(time.0)"
	}

	override var representedObject: AnyObject? {
		didSet {
		// Update the view, if already loaded.
		}
	}

	@IBAction func start(sender: NSButton) {
		if isTiming {
			timer.pauseTiming()
			sender.title = "start"
			isTiming = false
		} else {
			timer.startTiming()
			sender.title = "pause"
			isTiming = true
		}
	}
}

extension ViewController: SwipeControlDelegate {
	func change(value: CGFloat) {
		timer.duration = timer.duration.advancedBy(Double(value))
		updateTimeLabel()
	}
}

