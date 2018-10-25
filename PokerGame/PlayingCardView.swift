//
//  PlayingCardView.swift
//  PokerGame
//
//  Created by admin on 2018/10/24.
//  Copyright © 2018 dqv5. All rights reserved.
//

import UIKit

class PlayingCardView: UIView {

    var rank = 5 {didSet{ setNeedsDisplay();setNeedsDisplay()}}
    var suit = "♥️" {didSet{ setNeedsDisplay();setNeedsDisplay()}}
    var isFaceUp = true {didSet{ setNeedsDisplay();setNeedsDisplay()}}
    
    private var cornerString:NSAttributedString{
        get{
            return centerAttrString("\(rankString)\n\(suit)", fontSize: cornerFontSize)
        }
    }
    
    lazy var leftTopCornerLabel:UILabel = createCornerLabel()
    lazy var rightBottomCornerLabel:UILabel = createCornerLabel()
    
    
    
    
    
    override func draw(_ rect: CGRect) {
        let roundPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        roundPath.addClip()
        UIColor.white.setFill()
        roundPath.fill()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configurCornerLabel(leftTopCornerLabel)
        leftTopCornerLabel.frame.origin = bounds.origin.offsetBy(dx:cornerOffset,dy:cornerOffset)
        
        configurCornerLabel(rightBottomCornerLabel)
        rightBottomCornerLabel.transform = CGAffineTransform.identity
            //.translatedBy(x: rightBottomCornerLabel.frame.size.width, y: rightBottomCornerLabel.frame.size.height)
            .rotated(by: CGFloat.pi)
        rightBottomCornerLabel.frame.origin = CGPoint(x: bounds.maxX, y: bounds.maxY)
            .offsetBy(dx: -cornerOffset, dy: -cornerOffset)
            .offsetBy(dx: -rightBottomCornerLabel.frame.size.width, dy: -rightBottomCornerLabel.frame.size.height)
        
    }
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setNeedsDisplay()
        setNeedsLayout()
    }
    
    private func centerAttrString(_ str:String,fontSize:CGFloat) -> NSAttributedString{
        var font = UIFont.preferredFont(forTextStyle: .body).withSize(fontSize)
        font = UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.center
        let attr = [NSAttributedString.Key.paragraphStyle:paragraphStyle,NSAttributedString.Key.font:font]
        return NSAttributedString(string: str,attributes:attr)
    }
    
    private func createCornerLabel() -> UILabel{
        let label = UILabel()
        label.numberOfLines=0
        addSubview(label)
        return label
    }
    
    private func configurCornerLabel(_ label:UILabel){
        label.attributedText = cornerString
        label.frame.size = CGSize.zero
        label.sizeToFit()
        label.isHidden = !isFaceUp
        
    }

}


// MARK: extensions
extension PlayingCardView {
    private struct SizeRatio {
        static let cornerFontSizeToBoundsHeight: CGFloat = 0.085
        static let cornerRadiusToBoundsHeight: CGFloat = 0.06
        static let cornerOffsetToCornerRadius: CGFloat = 0.33
        static let faceCardImageSizeToBoundsSize: CGFloat = 0.75
    }
    
    private var cornerRadius: CGFloat {
        return bounds.size.height * SizeRatio.cornerRadiusToBoundsHeight
    }
    
    private var cornerOffset: CGFloat {
        return cornerRadius * SizeRatio.cornerOffsetToCornerRadius
    }
    
    private var cornerFontSize: CGFloat {
        return bounds.size.height * SizeRatio.cornerFontSizeToBoundsHeight
    }
    
    private var rankString: String {
        switch rank {
        case 1: return "A"
        case 2...10: return String(rank)
        case 11: return "J"
        case 12: return "Q"
        case 13: return "K"
        default: return "?"
        }
    }
}

extension CGPoint {
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint(x: x + dx, y: y + dy)
    }
}
