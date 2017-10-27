//
//  LockView.swift
//  Kisi
//
//  Created by Jorge Orjuela on 10/27/17.
//  Copyright © 2017 Jorge Orjuela. All rights reserved.
//

import UIKit

/// NAIVE IMPLEMENTATION
@IBDesignable
class LockView: UIView {

    @IBInspectable var color: UIColor = UIColor.white

    private lazy var ovalLayer: CAShapeLayer = {
        let ovalLayer = CAShapeLayer()
        ovalLayer.lineWidth = 2
        ovalLayer.strokeColor = color.cgColor
        ovalLayer.fillColor = backgroundColor?.cgColor
        return ovalLayer
    }()

    private lazy var rectangleLayer: CAShapeLayer = {
        let rectangleLayer = CAShapeLayer()
        rectangleLayer.fillColor = backgroundColor?.cgColor
        rectangleLayer.lineWidth = 1.8
        rectangleLayer.strokeColor = color.cgColor
        return rectangleLayer
    }()

    private lazy var semiCircleLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.anchorPoint = CGPoint.zero
        layer.zPosition = CGFloat(Int.min)
        layer.fillColor = UIColor.clear.cgColor
        layer.lineCap = kCALineCapRound
        layer.strokeColor = color.cgColor
        layer.lineWidth = 5
        return layer
    }()

    private lazy var squareLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = backgroundColor?.cgColor
        layer.lineCap = kCALineCapRound
        layer.strokeColor = color.cgColor
        layer.lineWidth = 3
        layer.zPosition = CGFloat(Int.max)
        return layer
    }()

    // MARK: Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    // MARK: Intance methods

    final func animate(_ completionHandler: @escaping (() -> Void)) {
        CATransaction.begin()
        let positionAnimation = CABasicAnimation(keyPath: "transform.translation.x")
        positionAnimation.toValue = rectangleLayer.frame.width - 10
        positionAnimation.fillMode = kCAFillModeForwards
        positionAnimation.duration = 0.25
        positionAnimation.isRemovedOnCompletion = false

        let fillColorAnimation = CABasicAnimation(keyPath: "fillColor")
        fillColorAnimation.fromValue = UIColor.clear.cgColor
        fillColorAnimation.toValue = color.cgColor
        fillColorAnimation.fillMode = kCAFillModeForwards
        fillColorAnimation.duration = 0.25
        fillColorAnimation.isRemovedOnCompletion = false

        let ovalAnimationGroup = CAAnimationGroup()
        ovalAnimationGroup.duration = 0.25
        ovalAnimationGroup.fillMode = kCAFillModeForwards
        ovalAnimationGroup.isRemovedOnCompletion = false
        ovalAnimationGroup.animations = [fillColorAnimation, positionAnimation]

        ovalLayer.removeAllAnimations()
        ovalLayer.add(ovalAnimationGroup, forKey: nil)

        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(Float.pi / 4)
        rotateAnimation.duration = 0.25
        rotateAnimation.fillMode = kCAFillModeForwards
        rotateAnimation.isRemovedOnCompletion = false

        CATransaction.setCompletionBlock(completionHandler)

        semiCircleLayer.removeAllAnimations()
        semiCircleLayer.add(rotateAnimation, forKey: nil)
        CATransaction.commit()
    }

    // MARK: Overrided methods

    override func layoutSubviews() {
        super.layoutSubviews()
        squareLayer.frame = CGRect(x: 0, y: self.frame.height - self.frame.width, width: self.frame.width, height: self.frame.width)
        var roundedRect = CGRect(x: 0, y: 0, width: squareLayer.frame.width, height: squareLayer.frame.height)
        squareLayer.path = UIBezierPath(roundedRect: roundedRect, cornerRadius: 8).cgPath

        var radiusPercentage: CGFloat = 0.25
        var size = CGSize(width: squareLayer.frame.width, height: squareLayer.frame.height)
        let arcCenter = CGPoint(x: -8.5, y: -3)
        let bezierPath = UIBezierPath(arcCenter: arcCenter,
                                      radius: size.width * radiusPercentage,
                                      startAngle: CGFloat(Float.pi),
                                      endAngle: 0,
                                      clockwise: true)

        var origin =  CGPoint(x: self.frame.minX - size.width / 2, y: squareLayer.frame.minY)
        semiCircleLayer.frame = CGRect(x: origin.x, y: origin.y, width: size.width, height: size.height)
        semiCircleLayer.path = bezierPath.cgPath

        radiusPercentage = 0.233
        let heightPercentage: CGFloat = 0.17
        var widthPercentage: CGFloat = 0.34
        size = CGSize(width: squareLayer.frame.width * widthPercentage, height: squareLayer.frame.height * heightPercentage)
        origin = CGPoint(x: squareLayer.frame.midX - size.width / 2, y: squareLayer.frame.height / 2 - size.height / 2 + squareLayer.lineWidth)
        let frame = CGRect(x: origin.x, y: origin.y, width: size.width, height: size.height)
        rectangleLayer.frame = frame
        roundedRect = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        rectangleLayer.path = UIBezierPath(roundedRect: roundedRect, cornerRadius: frame.width * radiusPercentage).cgPath

        widthPercentage = 0.737
        let width = rectangleLayer.frame.width * widthPercentage
        let xOriginPadding: CGFloat = 10
        let yOriginPadding: CGFloat = 5
        size = CGSize(width: width, height: width)
        origin = CGPoint(x: rectangleLayer.frame.origin.x - xOriginPadding, y: rectangleLayer.frame.origin.y - yOriginPadding)
        ovalLayer.frame = CGRect(x: origin.x, y: origin.y, width: size.width, height: size.height)
        roundedRect = CGRect(x: 0, y: 0, width: ovalLayer.frame.width, height: ovalLayer.frame.height)
        ovalLayer.path = UIBezierPath(ovalIn: roundedRect).cgPath
    }

    // MARK: Private methods

    private final func commonInit() {
        layer.addSublayer(semiCircleLayer)
        layer.addSublayer(squareLayer)
        squareLayer.addSublayer(rectangleLayer)
        squareLayer.addSublayer(ovalLayer)
    }
}
