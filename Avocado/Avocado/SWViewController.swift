import UIKit

class SWViewController: UIViewController {
    
    @IBOutlet var displayTimeLabel: UILabel!
    
    var startTime = NSTimeInterval()
    var elapsedTime = NSTimeInterval()
    var strMinutes = String()
    var strSeconds = String()
    var strFraction = String()
    
    var suspendFlag = Int()
    
    var timer:NSTimer = NSTimer()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func start(sender: AnyObject) {
        if (!timer.valid) {
            let aSelector : Selector = "updateTime"
            timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: aSelector, userInfo: nil, repeats: true)
            startTime = NSDate.timeIntervalSinceReferenceDate()
        }
        //print(timer)
        //print(startTime)
    }
    
    //suspend function
    @IBAction func suspend(sender: AnyObject) {
        timer.invalidate()
        suspendFlag = 1;
        displayTimeLabel.text = "\(strMinutes):\(strSeconds):\(strFraction)"
    }
    
    @IBAction func stop(sender: AnyObject) {
        timer.invalidate()
    }
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var slidervalue: UILabel!
    
    @IBAction func sliderValueChanged(sender: UISlider) {
        let selectedValue = Float(slider.value)
        slidervalue.text = String(stringInterpolationSegment: selectedValue)
        
        print(String(stringInterpolationSegment: selectedValue))
        //print(slider.value)
    }
    
    
    func updateTime() {
        
        let currentTime = NSDate.timeIntervalSinceReferenceDate()
        
        //if suspend button has pressed
        if(suspendFlag == 1) {
            startTime = startTime - elapsedTime
        }
    
        elapsedTime = currentTime - startTime
        var countDown: NSTimeInterval = 1500.0 - elapsedTime
        print(countDown)
        
        //=== slider (should be placed here)===
        slider.value = Float(countDown);
        slidervalue.text = String(Float(slider.value));
        //==============
        
        let cdminutes = UInt8(countDown / 60.0)
        countDown -= (NSTimeInterval(cdminutes) * 60)
        
        let cdseconds = UInt8(countDown)
        countDown -= NSTimeInterval(cdseconds)
    
        let cdfraction = UInt8(countDown * 100)
        
        strMinutes = String(format: "%02d", cdminutes)
        strSeconds = String(format: "%02d", cdseconds)
        strFraction = String(format: "%02d", cdfraction)
        
        displayTimeLabel.text = "\(strMinutes):\(strSeconds):\(strFraction)"
        
        suspendFlag = 0
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}