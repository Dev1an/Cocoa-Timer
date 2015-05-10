//
//  TodayViewController.swift
//  TimerWidget
//
//  Created by Damiaan Dufaux on 9/05/15.
//  Copyright (c) 2015 Damiaan Dufaux. All rights reserved.
//

import Cocoa
import NotificationCenter
import CoreTimer

class TodayViewController: NSViewController, NCWidgetProviding {

    override var nibName: String? {
        return "TodayViewController"
    }

    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        // Update your data and prepare for a snapshot. Call completion handler when you are done
        // with NoData if nothing has changed or NewData if there is new data since the last
        // time we called you
        completionHandler(.NoData)
    }

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

extension TodayViewController: SwipeControlDelegate {
	func change(value: CGFloat) {
		timer.duration = timer.duration.advancedBy(Double(value))
		updateTimeLabel()
	}
}