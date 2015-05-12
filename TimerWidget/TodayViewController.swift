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

	@IBOutlet var timeLabel: NSTextField!
	@IBOutlet var startButton: NSButton!
	let formatter = TimedIntervalFormatter()
	
    override var nibName: String? {
        return "TodayViewController"
    }
	
	var stopwatch = LappedStopwatch()
	var timer: UnsyncedTimer!

	override init?(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
		timer = SyncedTimer(interval: 0.02 , syncedObject: stopwatch, callback: updateLabel)
		loadUserDefaultStopwatch()
	}
	
	func loadUserDefaultStopwatch() {
		if let savedStopwatch = NSUserDefaults(suiteName: "group.devian.timer")!.objectForKey("Saved stopwatch") as? NSData {
			stopwatch = NSKeyedUnarchiver.unarchiveObjectWithData(savedStopwatch) as! LappedStopwatch
		}
	}

	required init?(coder: NSCoder) {
	    super.init(coder: coder)
	}

	func updateLabel() {
		timeLabel.stringValue = formatter.stringFromTimeInterval(stopwatch.duration)!
	}
	
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        // Update your data and prepare for a snapshot. Call completion handler when you are done
        // with NoData if nothing has changed or NewData if there is new data since the last
        // time we called you
		updateLabel()
        completionHandler(.NewData)
    }
	
	func saveUserDefaults() {
		let defaults = NSUserDefaults(suiteName: "group.devian.timer")!;
		let encodedStopwatch = NSKeyedArchiver.archivedDataWithRootObject(stopwatch)
		defaults.setObject(encodedStopwatch, forKey: "Saved stopwatch")
		defaults.synchronize()
		
		NSDistributedNotificationCenter.defaultCenter().postNotificationName("Stopwatch changed", object: "Desktop app")
	}
	
	@IBAction func start(sender: NSButton) {
		stopwatch.toggleState()
		update(sender)
		saveUserDefaults()
	}
	@IBAction func reset(sender: AnyObject) {
		stopwatch.reset()
		startButton.title = "Start"
		saveUserDefaults()
	}

	@IBAction func update(sender: AnyObject) {
		if stopwatch.isTicking {
			timer.start()
			startButton.title = "Pause"
		} else {
			timer.pause()
			startButton.title = "Start"
		}
	}
	
	override func viewDidLoad() {
		update(self)
		NSDistributedNotificationCenter.defaultCenter().addObserver(self, selector: "userDefaultsChanged", name: "Stopwatch changed", object: nil)
	}
	
	func userDefaultsChanged() {
		loadUserDefaultStopwatch()
		update(self)
		updateLabel()
	}
	
	override func viewWillAppear() {
		update(self)
	}
	
	override func viewDidDisappear() {
		timer.pause()
	}
}