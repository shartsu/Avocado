import UIKit

class SWViewController: UIViewController {
    
    var timer:NSTimer = NSTimer()
    
    @IBOutlet var displayTimeLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    //would be deleted (Just show double value of slider)
    @IBOutlet weak var slidervalue: UILabel!
    
    //NSTimeInterval == Double
    var startTime = NSTimeInterval()
    var sliderChangedTime = NSTimeInterval()
    
    var suspendFlag = Int()
    var sliderChangedFlag = Int()

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
    }
    
    //suspend function
    @IBAction func suspend(sender: AnyObject) {
        timer.invalidate()
        suspendFlag = 1;
    }
    
    @IBAction func reset(sender: AnyObject) {
        timer.invalidate()
        displayTimeLabel.textColor = UIColor.whiteColor();
        showTimer ("25",strSeconds: "00",strFraction: "00");
    }
    
    @IBAction func sliderValueChanged(sender: UISlider) {
        //let selectedValue = Float(slider.value)
        //slidervalue.text = String(stringInterpolationSegment: selectedValue)
        displayTimeLabel.textColor = UIColor.whiteColor();
        
        slider.value = slider.value - (slider.value % 60.0)
        
        //FLAG and show changed time value
        sliderChangedFlag = 1;
        sliderChangedTime = Double(slider.value)

        showTimer (String(format: "%02d", UInt8(sliderChangedTime / 60.0)),
            strSeconds: String(format: "%02d", UInt8(sliderChangedTime % 60.0)),
            strFraction: String(format: "%02.0F", Float(sliderChangedTime % 1.0) * 100.0))
        
        //print(String(stringInterpolationSegment: selectedValue))
        //print(sliderChangedTime)
        print(slider.value - (slider.value % 60.0))
    }
    
    
    func updateTime() {
        
        let currentTime = NSDate.timeIntervalSinceReferenceDate()
        var countDown =  NSTimeInterval();
        var elapsedTime = NSTimeInterval()
        
        /* --- There are three cases considered below implementation --- */
        //1, ONLY suspend button pressed
        //2, suspend button pressed THEN slider changed
        //3, ONLY slider changed
        
        if(suspendFlag == 1) {
            startTime = startTime - elapsedTime;
            print("=== SUSPENDED ===");
        }
        
        if(sliderChangedFlag == 1) {
            startTime = currentTime - (1500.0 - sliderChangedTime);
            print("=== SLIDER CHANGED ===");
        }
        
        //Calcurate elapsedTime then subtract it from 1500 (for 25minutes countdown)
        elapsedTime = currentTime - startTime;
        countDown = 1500.0 - elapsedTime;
        
        //For debug (comment outed so far)
        //print("startTime", startTime)
        //print("elapsedTime", elapsedTime);
        //print("countDown", countDown);
        
        //Change slider
        slider.value = Float(countDown);
        //slidervalue.text = String(Float(slider.value));
        
        //Alter timer values
        let cdminutes = UInt8(countDown / 60.0)
        countDown -= (NSTimeInterval(cdminutes) * 60)
        
        let cdseconds = UInt8(countDown)
        countDown -= NSTimeInterval(cdseconds)
    
        let cdfraction = UInt8(countDown * 100)
        
        //Show timer values when slider changed
        showTimer (String(format: "%02d", cdminutes),
            strSeconds: String(format: "%02d", cdseconds),
            strFraction: String(format: "%02d", cdfraction))
        
        //Finally,
        if(countDown < 0.0) {
            displayTimeLabel.textColor = UIColor.redColor();
            timer.invalidate();
            showTimer ("00",strSeconds: "00",strFraction: "00");
        }
        
        //For debug (comment outed so far)
        //print(suspendFlag);
        //print(sliderChangedFlag);
        
        //Reset flags
        suspendFlag = 0;
        sliderChangedFlag = 0;
    }
    
    func showTimer (strMinutes : String = "25", strSeconds : String = "00", strFraction : String = "00" ) {
        displayTimeLabel.text = "\(strMinutes):\(strSeconds):\(strFraction)"
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}