//
//  CircleView.swift
//  TiltGame
//
//  Created by Monica Villanoy on 6/14/22.
//

import Foundation
import UIKit

class CircleView: UIView {
  // setting collision’s bounds type to an ellipse.
  override var collisionBoundsType:
           UIDynamicItemCollisionBoundsType { return .ellipse }
  override func layoutSubviews() {
    super.layoutSubviews()
    //  Creating a custom CAShapeLayer object which makes the view's shape round
    let shapeLayer = CAShapeLayer()
    shapeLayer.fillColor = UIColor.clear.cgColor
    let center = CGPoint(x: bounds.midX, y: bounds.midY)
    shapeLayer.path = circularPath(center: center).cgPath
    layer.addSublayer(shapeLayer)
  }
  private func circularPath(center: CGPoint = .zero) -> UIBezierPath
  {
    // this UIBezierPath corresponds to a shape of a circle
    let radius = min(bounds.width, bounds.height) / 2
    return UIBezierPath(arcCenter: center,
                        radius: radius,
                        startAngle: 0,
                        endAngle: .pi * 2, clockwise: true)
  }
}
