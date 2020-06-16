//
//  CircleProgressView.swift
//  circles
//
//  Created by Sherzod Khashimov on 7/18/19.
//  Copyright © 2019 Sherzod Khashimov. All rights reserved.
//

import UIKit

@IBDesignable class CircleProgressView: UIView {

    @IBInspectable var lineColor: UIColor = .gray {
        didSet {
            setNeedsDisplay()
        }
    }

    @IBInspectable var lineBackgroundColor: UIColor = .black {
        didSet {
            setNeedsDisplay()
        }
    }

    @IBInspectable var lineWidth: CGFloat = 1 {
        didSet {
            setNeedsDisplay()
        }
    }

    @IBInspectable var percent: CGFloat = 1 {
        didSet {
            setNeedsDisplay()
        }
    }

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {

        // 1
        let center = CGPoint(x: self.bounds.width / 2, y: self.bounds.height / 2)

        // 2
        let radius: CGFloat = max(self.bounds.width - (lineWidth / 2), self.bounds.height - (lineWidth / 2))

        // 3
        let startAngle: CGFloat = -(.pi / 2)
        let backgroundEndAngle: CGFloat = startAngle + (2 * .pi)
        let endAngle: CGFloat = (startAngle + CGFloat((2 * .pi) * percent))
        //        let endAngle: CGFloat = startAngle + CGFloat((2 * .pi * currentPercent))

        let backgroundCirclePath = UIBezierPath(arcCenter: center, radius: (radius - lineWidth) / 2, startAngle: startAngle, endAngle: backgroundEndAngle, clockwise: true)

        lineBackgroundColor.setStroke()
        backgroundCirclePath.lineWidth = lineWidth
        backgroundCirclePath.lineCapStyle = .round
        backgroundCirclePath.stroke()

        let circlePath = UIBezierPath(arcCenter: center, radius: (radius - lineWidth) / 2, startAngle: startAngle, endAngle: endAngle, clockwise: true)

        lineColor.setStroke()
        circlePath.lineWidth = lineWidth
        circlePath.lineCapStyle = .round
        circlePath.stroke()
    }

}
