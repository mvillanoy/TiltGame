//
//  ViewController.swift
//  TiltGame
//
//  Created by Monica Villanoy on 6/11/22.
//

import UIKit

import CoreMotion


class ViewController: UIViewController, UICollisionBehaviorDelegate {
    
    lazy public var currentTimeLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: self.view.frame.midX-100, y: 100, width: 200, height: 21))
        label.textColor = UIColor.black
        label.textAlignment = .center
        self.view.addSubview(label)
        return label
    }()
    
    lazy public var bestTimeLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: self.view.frame.midX-100, y: 70, width: 200, height: 21))
        label.textColor = UIColor.black
        label.textAlignment = .center
        self.view.addSubview(label)
        return label
    }()
    
    lazy var circleView: CircleView = {
        let view = CircleView(frame: CGRect(x: 0.0, y: 0.0, width: 50.0, height: 50.0))
        view.backgroundColor = UIColor.black
        view.layer.cornerRadius = 25.0
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(view)
        return view
    }()
    
    lazy var triangleView: UIView = {
        let view = UIView(frame: CGRect(x: 0.0, y: 400.0, width: 200.0, height: 200.0))
        view.backgroundColor = UIColor.gray
        self.view.addSubview(view)
        return view
    }()
    
    
    let motionManager = CMMotionManager()
    
    var animator: UIDynamicAnimator!
    
    var collision: UICollisionBehavior!
    var gravity: UIGravityBehavior!
    
    
    var intersectionTimer = Timer()
    
    var timer = Timer()
    var trajectoryTimer = Timer()
    var currentCount = 0
    var bestCount = 0
    
    var counterStarted = false
    
    var triangleSpeed:Double = 0.5
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
        motionManager.accelerometerUpdateInterval = 0.01
        
        motionManager.startAccelerometerUpdates(to: .main) { [self]
            (data, error) in
            guard let data = data, error == nil else {
                return
            }
            
            self.gravity.gravityDirection = CGVector(dx: data.acceleration.x * 1, dy: data.acceleration.y *    (-1))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        self.intersectionTimer = Timer.scheduledTimer(withTimeInterval: 0.03, repeats: true, block: { [self] _ in
            
            if(circleView.intersects(triangleView)){
                if !counterStarted {
                    counterStarted = true
                    startTimer()
                    triangleView.backgroundColor = UIColor.yellow
                }
                
            }else {
               
                
                if counterStarted {
                    resetTimer()
                    counterStarted = false
                    triangleView.backgroundColor = UIColor.gray

                }
            }
        })
        
        
        animator = UIDynamicAnimator(referenceView: view)
        collision = UICollisionBehavior(items: [triangleView, circleView])
        collision.collisionMode = .boundaries
        
        collision.translatesReferenceBoundsIntoBoundary = true
        animator.addBehavior(collision)
        
        gravity = UIGravityBehavior(items: [circleView])
        animator.addBehavior(gravity)
        
        let circleCollision = UICollisionBehavior(items: [triangleView, circleView])
        circleCollision.collisionMode = .boundaries
        circleCollision.collisionDelegate = self
        circleCollision.translatesReferenceBoundsIntoBoundary = true
        animator.addBehavior(circleCollision)
        
        
        let push = UIPushBehavior(items: [triangleView], mode: .instantaneous)
        push.pushDirection = CGVector(dx: triangleSpeed, dy: triangleSpeed)
        animator.addBehavior(push)
        
        let behavior = UIDynamicItemBehavior.init(items: [triangleView])
        behavior.friction = 0
        behavior.resistance = 0
        behavior.allowsRotation = false
        behavior.angularResistance = 0
        behavior.elasticity = 1.0
        behavior.density = 0.0
        animator.addBehavior(behavior)
        
        let circleBehaviors = UIDynamicItemBehavior.init(items: [circleView])
        
        circleBehaviors.friction = 0
        circleBehaviors.resistance = 0
        circleBehaviors.allowsRotation = false
        circleBehaviors.angularResistance = 0
        circleBehaviors.elasticity = 0
        animator.addBehavior(circleBehaviors)
        
        currentTimeLabel.text = "Current Time: 00:00"
        bestTimeLabel.text = "Best Time: 00:00"
        
        
        self.trajectoryTimer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true, block: { [self] _ in
            
            let push = UIPushBehavior(items: [triangleView], mode: .instantaneous)
            push.pushDirection = CGVector(dx: triangleSpeed, dy: triangleSpeed)
            animator.addBehavior(push)
        })
        
    }
    
    func resetTimer(){
        timer.invalidate()
        if(bestCount < currentCount){
            bestTimeLabel.text = "Best Time: \(timeString(time: TimeInterval(currentCount)))"
            bestCount = currentCount
            currentTimeLabel.text = "Current Time: \(timeString(time: TimeInterval(0)))"
        }
        currentCount = 0
    }
    
    
    func startTimer(){
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerUpdate), userInfo: nil, repeats: true)
    }
    
    @objc func timerUpdate(){
        currentCount = currentCount + 1
        currentTimeLabel.text = "Current Time: \(timeString(time: TimeInterval(currentCount)))"
        
    }
    
    func timeString(time:TimeInterval) -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        
        return String(format:"%02i:%02i", minutes, seconds)
    }
    
    func collisionBehavior(_ behavior: UICollisionBehavior,
                           beganContactFor item: UIDynamicItem,
                           withBoundaryIdentifier identifier: NSCopying?,
                           at p: CGPoint) {
        triangleSpeed += 0.1
        let push = UIPushBehavior(items: [triangleView], mode: .instantaneous)
        push.pushDirection = CGVector(dx: triangleSpeed, dy: triangleSpeed)
        animator.addBehavior(push)
        

        
    }
    
    
}

