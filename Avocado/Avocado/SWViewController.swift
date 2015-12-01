import UIKit

class SWViewController: UIViewController {
    
    @IBOutlet var displayTimeLabel: UILabel!
    
    var startTime = NSTimeInterval()
    
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
    
    @IBAction func stop(sender: AnyObject) {
        timer.invalidate()
    }
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var slidervalue: UILabel!
    
    @IBAction func sliderValueChanged(sender: UISlider) {
        let selectedValue = Float(slider.value)
        slidervalue.text = String(stringInterpolationSegment: selectedValue)
        
        //label.text = "Value = \(slider.value)"
        //var currentValue = Int(sender.value)
        print(String(stringInterpolationSegment: selectedValue))
    }
    
    
    func updateTime() {
        
        let currentTime = NSDate.timeIntervalSinceReferenceDate()
        
        let elapsedTime: NSTimeInterval = currentTime - startTime
        var countDown: NSTimeInterval = 1500.0 - elapsedTime
        print(countDown)

        let cdminutes = UInt8(countDown / 60.0)
        countDown -= (NSTimeInterval(cdminutes) * 60)
        
        let cdseconds = UInt8(countDown)
        countDown -= NSTimeInterval(cdseconds)
    
        let cdfraction = UInt8(countDown * 100)
        
        let strMinutes = String(format: "%02d", cdminutes)
        let strSeconds = String(format: "%02d", cdseconds)
        let strFraction = String(format: "%02d", cdfraction)
        
        displayTimeLabel.text = "\(strMinutes):\(strSeconds):\(strFraction)"
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}