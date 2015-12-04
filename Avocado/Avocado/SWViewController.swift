import UIKit

class SWViewController: UIViewController {
    
    @IBOutlet var displayTimeLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var slidervalue: UILabel!
    
    var startTime = NSTimeInterval()
    var elapsedTime = NSTimeInterval()
    var suspendedTime = NSTimeInterval()
    var sliderChangedTime = NSTimeInterval()
    
    var strMinutes = String()
    var strSeconds = String()
    var strFraction = String()
    
    var suspendFlag = Int()
    var sliderChangedFlag = Int()
    
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
    
    @IBAction func reset(sender: AnyObject) {
        timer.invalidate()
        displayTimeLabel.text = "25:00:00"
    }
    
    @IBAction func sliderValueChanged(sender: UISlider) {
        let selectedValue = Float(slider.value)
        slidervalue.text = String(stringInterpolationSegment: selectedValue)

        sliderChangedFlag = 1;
        sliderChangedTime = Double(slider.value)
        
        /*
        let sliderminutes = UInt8(sliderChangedTime / 60.0)
        let sliderseconds = UInt8(sliderChangedTime)
*/
        
        strMinutes = String(format: "%02d", UInt8(sliderChangedTime / 60.0))
        strSeconds = String(format: "%02d", UInt8(sliderChangedTime % 60.0))
        strFraction = String(format: "%02.0F", Float(sliderChangedTime % 1.0) * 100.0)

        displayTimeLabel.text = "\(strMinutes):\(strSeconds):\(strFraction)"
        
        //print(String(stringInterpolationSegment: selectedValue))
        print(sliderChangedTime)
    }
    
    
    func updateTime() {
        
        let currentTime = NSDate.timeIntervalSinceReferenceDate()
        var countDown =  NSTimeInterval();
        
        //if suspend button has pressed
        if(suspendFlag == 1) {
            startTime = startTime - elapsedTime;
            print("=== SUSPENDED ===");
        }

        if(sliderChangedFlag == 1) {
            startTime = currentTime - (1500.0 - sliderChangedTime);
            print("=== SLIDER CHANGED ===");
        }
        
        elapsedTime = currentTime - startTime;
        countDown = 1500.0 - elapsedTime;
        
        print("startTime", startTime)
        print("elapsedTime", elapsedTime);
        print("countDown", countDown);
        
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
        
        print(suspendFlag);
        print(sliderChangedFlag);
        suspendFlag = 0;
        sliderChangedFlag = 0;

        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}