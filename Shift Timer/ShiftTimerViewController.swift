//
//  ShiftTimerViewController.swift
//  Shift Timer
//
//  Created by Kyle Johnson on 6/30/16.
//  Copyright © 2016 Kyle Johnson. All rights reserved.
//

import UIKit
import QuartzCore
import AVFoundation

class ShiftTimerViewController: UIViewController {
    
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var timeRemainingLabel: UILabel!
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    
    var currentTime: Date!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentTime = Date()
        
        profileImage.layer.cornerRadius = profileImage.frame.size.height / 2
        
        startTimeLabel.text = startTimeText
        endTimeLabel.text = endTimeText
        percentageLabel.textColor = UIColor.white
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(ShiftTimerViewController.swipedDown(_:)))
        swipeDown.direction = UISwipeGestureRecognizerDirection.down
        self.view.addGestureRecognizer(swipeDown)
        
        _ = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ShiftTimerViewController.update), userInfo: nil, repeats: true)
    }
    
    override func viewDidLayoutSubviews() {
        update()
    }
    
    @IBAction func closeBtnTapped(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func swipedDown(_ gesture: UIGestureRecognizer) {
        closeBtnTapped(self)
    }
    
    func update() {
        currentTime = Date().addingTimeInterval(1)
        
        let calendar = Calendar.current
        startTimeLabel.text = startTimeText
        endTimeLabel.text = endTimeText
        
        if startTimeDate != nil && endTimeDate != nil {
            let progressTimeInSeconds = (calendar as NSCalendar).components(.second, from: startTimeDate, to: currentTime, options: []).second!
            let totalTimeInSeconds = (calendar as NSCalendar).components(.second, from: startTimeDate, to: endTimeDate, options: []).second!
            
            if totalTimeInSeconds != 0 {
                let progressPercent = CGFloat(progressTimeInSeconds) / CGFloat(totalTimeInSeconds)
                let intPercentage = Int(floor((progressPercent) * 100))
                
                if progressTimeInSeconds <= 0 {
                    percentageLabel.text = "0%"
                    timeRemainingLabel.textAlignment = NSTextAlignment.center
                    timeRemainingLabel.text = "Shift has not started yet!"
                } else if progressTimeInSeconds >= totalTimeInSeconds {
                    percentageLabel.text = "100%"
                    timeRemainingLabel.textAlignment = NSTextAlignment.center
                    timeRemainingLabel.text = "Shift complete. Enjoy your day!"
                } else {
                    percentageLabel.text = String(intPercentage) + "%"
                    timeRemainingLabel.textAlignment = NSTextAlignment.left
                    timeRemaining()
                }
                
                let dateFormatter = DateFormatter()
                dateFormatter.timeStyle = .short
                dateFormatter.dateFormat = "h:mm:ss aa"
                currentTimeLabel.text = dateFormatter.string(from: currentTime)
                
                drawCircularProgressBar(progressPercent)
            }
        }
    }
    
    func timeRemaining() {
        let timeinterval = endTimeDate.timeIntervalSince(currentTime) + 1
        let dateCompFormatter = DateComponentsFormatter()
        dateCompFormatter.unitsStyle = .full
        dateCompFormatter.includesTimeRemainingPhrase = true
        timeRemainingLabel.text = dateCompFormatter.string(from: timeinterval)!
    }
    
    func drawCircularProgressBar(_ percentage: CGFloat) {
        let circle = UIView()
        
        circle.bounds = CGRect(x: 0, y: 0, width: progressView.bounds.size.width, height: progressView.bounds.size.height)
        circle.frame = CGRect(x: 0, y: 0, width: progressView.bounds.size.width, height: progressView.bounds.size.height)
        circle.layoutIfNeeded()
        
        var progressCircle = CAShapeLayer()
        
        let centerPoint = CGPoint (x: circle.bounds.width / 2, y: circle.bounds.width / 2)
        let circleRadius : CGFloat = circle.bounds.width / 2 * 0.83
        let circlePath = UIBezierPath(arcCenter: centerPoint, radius: circleRadius, startAngle: CGFloat(-0.5 * M_PI), endAngle: CGFloat(1.5 * M_PI), clockwise: true)
        
        progressCircle = CAShapeLayer()
        progressCircle.path = circlePath.cgPath
        progressCircle.strokeColor = UIColor(red: 0 / 255.0, green: 150 / 255.0, blue: 255 / 255.0, alpha: 1.0).cgColor
        progressCircle.fillColor = UIColor(red: 255 / 255.0, green: 147 / 255.0, blue: 0 / 255.0, alpha: 1.0).cgColor
        progressCircle.lineWidth = 10
        progressCircle.strokeStart = 0
        progressCircle.strokeEnd = 1.0
        
        var bgProgressCircle = CAShapeLayer()
        
        bgProgressCircle = CAShapeLayer()
        bgProgressCircle.path = circlePath.cgPath
        bgProgressCircle.strokeColor = UIColor(red: 225 / 255.0, green: 242 / 255.0, blue: 255 / 255.0, alpha: 1.0).cgColor
        bgProgressCircle.fillColor = UIColor(red: 255 / 255.0, green: 147 / 255.0, blue: 0 / 255.0, alpha: 1.0).cgColor
        bgProgressCircle.lineWidth = 10
        bgProgressCircle.strokeStart = 0.0
        bgProgressCircle.strokeEnd = 1.0
        
        circle.layer.addSublayer(bgProgressCircle)
        circle.layer.addSublayer(progressCircle)
        circle.layer.zPosition = -1

        progressCircle.strokeEnd = percentage
        progressView.addSubview(circle)
    }
}

