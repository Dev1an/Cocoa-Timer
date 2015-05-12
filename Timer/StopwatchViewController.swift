//
//  StopwatchViewController.swift
//  Timer
//
//  Created by Damiaan Dufaux on 9/05/15.
//  Copyright (c) 2015 Damiaan Dufaux. All rights reserved.
//

import Cocoa
import CoreTimer

class StopwatchViewController: NSViewController {
	
	@IBOutlet var timeLabel: NSTextField!
	@IBOutlet var startButton: NSButton!
	var formatter = TimedIntervalFormatter()
	dynamic var stopwatch: LappedStopwatch
	var timer: UnsyncedTimer!
	
	required init?(coder: NSCoder) {
		if let savedStopwatch = NSUserDefaults(suiteName: "group.devian.timer")!.objectForKey("Saved stopwatch") as? NSData {
			stopwatch = NSKeyedUnarchiver.unarchiveObjectWithData(savedStopwatch) as! LappedStopwatch
		} else {
			stopwatch = LappedStopwatch()
		}
		super.init(coder: coder)
		
		timer = SyncedTimer(interval: 0.1, syncedObject: stopwatch, callback: timerCallback)
	}
	
	func loadStopWatch() -> LappedStopwatch? {
		if let savedStopwatch = NSUserDefaults(suiteName: "group.devian.timer")!.objectForKey("Saved stopwatch") as? NSData {
			return NSKeyedUnarchiver.unarchiveObjectWithData(savedStopwatch) as! LappedStopwatch
		} else { return nil }
	}
	
	// MARK: Button actions
	@IBAction func stop(sender: AnyObject) {
		stopwatch.reset()
		timer.pause()
		startButton.title = "Start"
		timerCallback()
		saveTimer()
	}
	@IBAction func startPause(sender: NSButton) {
		stopwatch.toggleState()
		
		update()
		
		saveTimer()
	}
	@IBAction func newLap(sender: AnyObject) {
		stopwatch.newLap()
	}
	
	func update() {
		if stopwatch.isTicking {
			timer.start()
			startButton.title = "Pause"
		} else {
			timer.pause()
			startButton.title = "Start"
		}
		
		timerCallback()
	}
	
	func timerCallback() {
		timeLabel.stringValue = formatter.stringFromTimeInterval(stopwatch.duration)!
	}
	
	func saveTimer() {
		let defaults = NSUserDefaults(suiteName: "group.devian.timer")!;
		let encodedStopwatch = NSKeyedArchiver.archivedDataWithRootObject(stopwatch)
		defaults.setObject(encodedStopwatch, forKey: "Saved stopwatch")
		defaults.synchronize()
		NSDistributedNotificationCenter.defaultCenter().postNotificationName("Stopwatch changed", object: "Desktop app")
	}

	// MARK: View lifecycle
	var occlusionObserver: NSObjectProtocol?
	
	override func viewWillAppear() {
		timerCallback()
	}
	
	override func viewDidAppear() {
		update()
		occlusionObserver = NSNotificationCenter.defaultCenter().addObserverForName(NSWindowDidChangeOcclusionStateNotification, object: view.window!, queue: NSOperationQueue.mainQueue()) {
			notification in
			if self.view.window!.occlusionState.rawValue & NSWindowOcclusionState.Visible.rawValue == NSWindowOcclusionState.Visible.rawValue && self.stopwatch.isTicking {
				self.timer.start()
			} else {
				self.timer.pause()
			}
		}
		NSDistributedNotificationCenter.defaultCenter().addObserver(self, selector: "userDefaultsChanged", name: "Stopwatch changed", object: nil)
	}
	
	func userDefaultsChanged() {
		if let newStopwatch = loadStopWatch() {
			stopwatch = newStopwatch
			update()
		}
	}
	
	override func viewWillDisappear() {
		timer.pause()
		NSNotificationCenter.defaultCenter().removeObserver(occlusionObserver!)
		NSDistributedNotificationCenter.defaultCenter().removeObserver(self, name: "Stopwatch changed", object: nil)
	}

}

@objc(TimeTransformer) class TimeTransformer: NSValueTransformer {
	
	var formatter = TimedIntervalFormatter()
	
	override class func transformedValueClass() -> AnyClass {
		return NSString.self
	}
	
	override class func allowsReverseTransformation() -> Bool {
		return false
	}
	
	override func transformedValue(value: AnyObject?) -> AnyObject? {
		if let ti = value as? NSTimeInterval {
			return formatter.stringFromTimeInterval(ti)
		} else {
			return nil
		}
	}
}
