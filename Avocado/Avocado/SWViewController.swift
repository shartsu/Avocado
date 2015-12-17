import UIKit

class SWViewController: UIViewController {

    
    var timer:NSTimer = NSTimer()

    @IBOutlet var displayTimeLabel: UILabel!
    @IBOutlet weak var avokado: UIImageView!

    //NSTimeInterval == Double
    var startTime = NSTimeInterval()
    var suspendFlag = Int()
    var elapsedTime = NSTimeInterval()
    
    //Frame
    var viewFrame = CGRect ()
    var frameChangedTime = NSTimeInterval()
    var frameChangedFlag = Int()

    override func viewDidLoad() {
        super.viewDidLoad()

        displayTimeLabel.textColor = UIColor.whiteColor();
        
        //Move frame start point
        avokado.frame.origin.x = screenSize().width - CGRectGetWidth(avokado.frame)


        // Do any additional setup after loading the view.
        self.view.addSubview(avokado)
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
        timer.invalidate();
        suspendFlag = 1;
    }

    @IBAction func reset(sender: AnyObject) {
        timer.invalidate();
        displayTimeLabel.textColor = UIColor.whiteColor();
        
        //Replace to first position
        avokado.frame.origin.x = screenSize().width - CGRectGetWidth(avokado.frame);
        
        //Reset Timer
        elapsedTime = 0;
        
        showTimer ("25",strSeconds: "00",strFraction: "00");
    }

    func updateTime() {

        let currentTime = NSDate.timeIntervalSinceReferenceDate();
        var countDown =  NSTimeInterval();

        /* --- There are three cases considered below implementation --- */
        //1, ONLY suspend button pressed
        //2, suspend button pressed THEN frame changed
        //3, ONLY frame changed

        if(suspendFlag == 1) {
            startTime = startTime - elapsedTime;
        }

        if(frameChangedFlag == 1) {
            startTime = currentTime - (1500.0 - frameChangedTime);
        }

        //Calcurate elapsedTime then subtract it from 1500 (for 25 minutes countdown)
        elapsedTime = currentTime - startTime;
        countDown = 1500.0 - elapsedTime;

        if(countDown < 0.0) {
        //if counter over 00:00:00, then COUNTUP start
            displayTimeLabel.textColor = UIColor.redColor();
            countDown = elapsedTime - 1500.0;
            avokado.frame.origin.x = 0;
        } else {
        //Otherwise (Normal function)
            displayTimeLabel.textColor = UIColor.whiteColor();
            avokado.frame.origin.x = CGFloat(countDown * (Double(screenSize().width - CGRectGetWidth(avokado.frame)) / 1500.0));
        }

        //For debug (comment outed so far)
        //print("startTime", startTime)
        //print("elapsedTime", elapsedTime);
        //print("countDown", countDown);
        
        //Alter timer values
        let cdminutes = UInt8(countDown / 60.0)
        countDown -= (NSTimeInterval(cdminutes) * 60)

        let cdseconds = UInt8(countDown)
        countDown -= NSTimeInterval(cdseconds)

        let cdfraction = UInt8(countDown * 100)

        //Show timer values when frame changed
        showTimer (String(format: "%02d", cdminutes),
            strSeconds: String(format: "%02d", cdseconds),
            strFraction: String(format: "%02d", cdfraction))

        //Reset flags
        suspendFlag = 0;
        frameChangedFlag = 0;
        print("elapsedTime:finally", elapsedTime);
    }
    
    func screenSize() -> CGSize {
        let screenSize = UIScreen.mainScreen().bounds.size;
        if NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_7_1
            && UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication().statusBarOrientation) {
                return CGSizeMake(screenSize.height, screenSize.width)
        }
        return screenSize
    }

    func showTimer (strMinutes : String = "25", strSeconds : String = "00", strFraction : String = "00" ) {
        displayTimeLabel.text = "\(strMinutes):\(strSeconds):\(strFraction)"
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /*
        UIView.animateWithDuration(0.06,
            animations: { () -> Void in
                self.avokado.transform = CGAffineTransformMakeScale(0.9, 0.9)
            })
            { (Bool) -> Void in
        }
*/
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        // Get touchevent
        let touchEvent = touches.first!
        
        // Get valuables how long distance moved
        let preDx = touchEvent.previousLocationInView(self.view).x
        let newDx = touchEvent.locationInView(self.view).x
        let dx = newDx - preDx
    
        //Apply it to the frame
        avokado.frame.origin.x += dx
        
        // Stop move over their frame
        if(avokado.frame.origin.x < (screenSize().width - CGRectGetWidth(avokado.frame))) {
            avokado.frame.origin.x = screenSize().width - CGRectGetWidth(avokado.frame)
        } else if(avokado.frame.origin.x > 0) {
            avokado.frame.origin.x = 0
        }
  
        //FLAG and show changed time value
        timer.invalidate();
        frameChangedFlag = 1;
        frameChangedTime = Double(avokado.frame.origin.x) * (1500.0 / Double(screenSize().width - CGRectGetWidth(avokado.frame)))
        
        //Replace timer to nearby exact minutes
        if ((frameChangedTime % 60.0) > 30.0) {
            frameChangedTime =  frameChangedTime + 60.0 - (frameChangedTime % 60.0)
        } else {
            frameChangedTime =  frameChangedTime - (frameChangedTime % 60.0)
        }
        
        showTimer (String(format: "%02d", UInt8(frameChangedTime / 60.0)),
            strSeconds: "00",
            strFraction: "00")
        
        //Replace also value
        elapsedTime = 1500.0 - frameChangedTime;
        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        

        //Replace frame to nearby exact positions
        avokado.frame.origin.x = CGFloat((frameChangedTime / 60.0) * (-36.0));
        
        /*
        UIView.animateWithDuration(0.1,
            animations: { () -> Void in
                self.avokado.transform = CGAffineTransformMakeScale(0.4, 0.4)
                self.avokado.transform = CGAffineTransformMakeScale(1.0, 1.0)
            })
            { (Bool) -> Void in
                
        }
*/

    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}