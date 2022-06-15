//
//  GameScene.swift
//  TiltGame
//
//  Created by Monica Villanoy on 6/14/22.
//

import SpriteKit
import CoreMotion

enum CollisionTypes: UInt32 {
    case ball = 1
    case wall = 2
    case triangle = 4
}


class GameScene: SKScene {
    
    
    var ball: SKShapeNode!
    var triangle:SKShapeNode!
    
    var bestTimeLabel:SKLabelNode!
    var currentTimeLabel:SKLabelNode!
    
    
    var motionManager: CMMotionManager!
    
    var timer = Timer()
    var trajectoryTimer = Timer()
    var currentCount = 0
    var bestCount = 0
    
    var triangleSpeed:Double = 10
    var angle = 45
    
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.white
        
        motionManager = CMMotionManager()
        
        let borderBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        borderBody.friction = 0
        self.physicsBody = borderBody
        self.name = "wall"
        physicsWorld.contactDelegate = self
        
        
        createTriangle()
        createBall()
        createBestTimeLabel()
        createCurrentTimeLabel()
        
        self.trajectoryTimer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true, block: { [self] _ in
            angle = Int.random(in: 0...360)
            changeSpeedOrDirection()
        })
        
        
        if motionManager.isAccelerometerAvailable {
            motionManager.accelerometerUpdateInterval = 0.01
            motionManager.startAccelerometerUpdates(to: .main) { [self]
                (data, error) in
                guard let data = data, error == nil else {
                    return
                }
                
                physicsWorld.gravity = CGVector(dx: data.acceleration.x * 1, dy: data.acceleration.y * 1)
            }
        }
    }
    
    
    
    func createBestTimeLabel(){
        bestTimeLabel = SKLabelNode(text: "Best Time: 00:00")
        bestTimeLabel.horizontalAlignmentMode = .right
        bestTimeLabel.fontColor = UIColor.black
        bestTimeLabel.position = CGPoint(x: self.frame.width/2+bestTimeLabel.frame.width/2, y: self.frame.height - bestTimeLabel.frame.height - 50)
        addChild(bestTimeLabel)
    }
    
    
    func createCurrentTimeLabel(){
        currentTimeLabel = SKLabelNode(text: "Current Time: 00:00")
        currentTimeLabel.horizontalAlignmentMode = .right
        currentTimeLabel.fontColor = UIColor.black
        currentTimeLabel.position = CGPoint(x: self.frame.width/2+currentTimeLabel.frame.width/2, y: self.frame.height - currentTimeLabel.frame.height - 100)
        addChild(currentTimeLabel)
    }
    
    
    func createBall() {
        ball = SKShapeNode(circleOfRadius: 20 )
        ball.position = CGPoint(x: 100, y: 100)
        ball.fillColor = UIColor.black
        ball.name = "ball"
        
        ball.physicsBody = SKPhysicsBody(circleOfRadius: 20)
        ball.physicsBody?.categoryBitMask = CollisionTypes.ball.rawValue
        ball.physicsBody?.contactTestBitMask = CollisionTypes.triangle.rawValue
        ball.physicsBody?.collisionBitMask = CollisionTypes.wall.rawValue
        ball.physicsBody?.affectedByGravity = true
        ball.physicsBody?.restitution = 0.0;
        ball.physicsBody?.friction = 0.0;
        ball.physicsBody?.linearDamping = 0.0;
        ball.physicsBody?.angularDamping = 0.0;
        
        addChild(ball)
    }
    
    func createTriangle(){
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0.0, y: 100.0))
        path.addLine(to: CGPoint(x: 100.0, y: -36.6))
        path.addLine(to: CGPoint(x: -100.0, y: -36.6))
        path.addLine(to: CGPoint(x: 0.0, y: 100.0))
        
        triangle = SKShapeNode(path: path.cgPath)
        triangle.name = "triangle"
        triangle.position = CGPoint(x: 200, y: 200)
        triangle.fillColor = UIColor.gray
        
        
        triangle.physicsBody = SKPhysicsBody(polygonFrom: path.cgPath)
        triangle.physicsBody?.isDynamic = true
        triangle.physicsBody?.allowsRotation = false
        triangle.physicsBody?.categoryBitMask = CollisionTypes.triangle.rawValue
        triangle.physicsBody?.contactTestBitMask = CollisionTypes.ball.rawValue
        triangle.physicsBody?.collisionBitMask = CollisionTypes.wall.rawValue
        triangle.physicsBody?.affectedByGravity = false
        triangle.physicsBody?.restitution = 1.0;
        triangle.physicsBody?.friction = 0.0;
        triangle.physicsBody?.linearDamping = 0.0;
        triangle.physicsBody?.angularDamping = 0.0;
        
        addChild(triangle)
        
        changeSpeedOrDirection()
        
    }
    
    func changeSpeedOrDirection(){
        triangle.physicsBody?.applyImpulse(CGVector(dx: triangleSpeed * cos(Double(angle) * Double.pi / 180), dy: triangleSpeed * sin(Double(angle) * Double.pi / 180)))
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
    
    
}

extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyB.node?.name == "ball" {
            if contact.bodyA.node?.name == "triangle" {
                startTimer()
                triangle.fillColor = UIColor.yellow
            }
            
            if contact.bodyA.node?.name == "wall" {
                triangleSpeed += 2
                changeSpeedOrDirection()
                
            }
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        if contact.bodyA.node?.name == "triangle" &&
            contact.bodyB.node?.name == "ball" {
            resetTimer()
            triangle.fillColor = UIColor.gray
        }
    }
}

