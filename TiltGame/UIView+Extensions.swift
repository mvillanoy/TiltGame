//
//  UIView+Extensions.swift
//  TiltGame
//
//  Created by Bayanihanets on 6/11/22.
//

import Foundation
import UIKit

extension UIView {

    func setRightTriangle(targetView:UIView?){
        let heightWidth = targetView!.frame.size.width //you can use triangleView.frame.size.height
        let path = CGMutablePath()

        path.move(to: CGPoint(x: heightWidth/2, y: 0))
        path.addLine(to: CGPoint(x:heightWidth, y: heightWidth/2))
        path.addLine(to: CGPoint(x:heightWidth/2, y:heightWidth))
        path.addLine(to: CGPoint(x:heightWidth/2, y:0))

        let shape = CAShapeLayer()
        shape.path = path
        shape.fillColor = UIColor.blue.cgColor

        targetView!.layer.insertSublayer(shape, at: 0)
    }

    func setLeftTriangle(targetView:UIView?){
        let heightWidth = targetView!.frame.size.width
        let path = CGMutablePath()

        path.move(to: CGPoint(x: heightWidth/2, y: 0))
        path.addLine(to: CGPoint(x:0, y: heightWidth/2))
        path.addLine(to: CGPoint(x:heightWidth/2, y:heightWidth))
        path.addLine(to: CGPoint(x:heightWidth/2, y:0))

        let shape = CAShapeLayer()
        shape.path = path
        shape.fillColor = UIColor.blue.cgColor

        targetView!.layer.insertSublayer(shape, at: 0)
    }

    func setUpTriangle(targetView:UIView?){
     let heightWidth = targetView!.frame.size.width
        let path = CGMutablePath()

        path.move(to: CGPoint(x: 0, y: heightWidth))
        path.addLine(to: CGPoint(x:heightWidth/2, y: heightWidth/2))
        path.addLine(to: CGPoint(x:heightWidth, y:heightWidth))
        path.addLine(to: CGPoint(x:0, y:heightWidth))

        let shape = CAShapeLayer()
        shape.path = path
        shape.fillColor = UIColor.blue.cgColor

        targetView!.layer.insertSublayer(shape, at: 0)
    }

    func setDownTriangle(targetView:UIView?){
        let heightWidth = targetView!.frame.size.width
        let path = CGMutablePath()

        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x:heightWidth/2, y: heightWidth/2))
        path.addLine(to: CGPoint(x:heightWidth, y:0))
        path.addLine(to: CGPoint(x:0, y:0))

        let shape = CAShapeLayer()
        shape.path = path
        shape.fillColor = UIColor.blue.cgColor

        targetView!.layer.insertSublayer(shape, at: 0)
    }
    
    func intersects(_ her: UIView) -> Bool {
           let herInMyGeometry = convert(her.bounds, from: her)
           return bounds.intersects(herInMyGeometry)
       }
}
