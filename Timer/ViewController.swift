//
//  ViewController.swift
//  Timer
//
//  Created by Damiaan Dufaux on 29/04/15.
//  Copyright (c) 2015 Damiaan Dufaux. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

	var timer = Timer(duration: NSTimeInterval(73))
	@IBOutlet var timeLabel: NSTextField!
	@IBOutlet var timeLabelFormatter: NSDateFormatter!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		updateTimeLabel()
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

	@IBAction func start(sender: AnyObject) {
		timer.startTiming()
	}
}

