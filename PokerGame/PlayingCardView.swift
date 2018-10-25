//
//  PlayingCardView.swift
//  PokerGame
//
//  Created by admin on 2018/10/24.
//  Copyright © 2018 dqv5. All rights reserved.
//

import UIKit

@IBDesignable
class PlayingCardView: UIView {

    @IBInspectable
    var rank:Int = 9 {didSet{ setNeedsDisplay();setNeedsDisplay()}}
    @IBInspectable
    var suit:String = "♠️" {didSet{ setNeedsDisplay();setNeedsDisplay()}}
    @IBInspectable
    var isFaceUp:Bool = true {didSet{ setNeedsDisplay();setNeedsDisplay()}}
    
    private var cornerString:NSAttributedString{
        get{
            return centerAttrString("\(rankString)\n\(suit)", fontSize: cornerFontSize)
        }
    }
    
    lazy var leftTopCornerLabel:UILabel = createCornerLabel()
    lazy var rightBottomCornerLabel:UILabel = createCornerLabel()
    
    
    
    
    
    override func draw(_ rect: CGRect) {
        //画出带圆角的矩形框--牌
        let roundPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        roundPath.addClip()
        UIColor.white.setFill()
        roundPath.fill()
        
        //画带人脸的扑克牌 ：J  Q  K
        if(isFaceUp){
            if(rank>10){
                if let facedImage = UIImage(named: rankString + suit, in: Bundle(for: self.classForCoder), compatibleWith: traitCollection) {
                    facedImage.draw(in:bounds.zoom(by: SizeRatio.faceCardImageSizeToBoundsSize))
                }
            }else{
                drawPips()
            }
        }else{
            if let backImage = UIImage(named: "cardback", in: Bundle(for: self.classForCoder), compatibleWith: traitCollection) {
                backImage.draw(in:bounds.zoom(by: SizeRatio.faceCardImageSizeToBoundsSize))
            }
        }
     
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //画左上角的点数、花色
        configurCornerLabel(leftTopCornerLabel)
        leftTopCornerLabel.frame.origin = bounds.origin.offsetBy(dx:cornerOffset,dy:cornerOffset)
        
        //画右下角的点数、花色
        configurCornerLabel(rightBottomCornerLabel)
        rightBottomCornerLabel.transform = CGAffineTransform.identity
            //.translatedBy(x: rightBottomCornerLabel.frame.size.width, y: rightBottomCornerLabel.frame.size.height)
            .rotated(by: CGFloat.pi)
        rightBottomCornerLabel.frame.origin = CGPoint(x: bounds.maxX, y: bounds.maxY)
            .offsetBy(dx: -cornerOffset, dy: -cornerOffset)
            .offsetBy(dx: -rightBottomCornerLabel.frame.size.width, dy: -rightBottomCornerLabel.frame.size.height)
        
    }
    //调整字体大小设置时，重新画
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
    
    private func drawPips() {
        let pipsPerRowForRank = [[0], [1], [1,1], [1,1,1], [2,2], [2,1,2], [2,2,2], [2,1,2,2], [2,2,2,2], [2,2,1,2,2], [2,2,2,2,2]]
        
        func createPipString(thatFits pipRect: CGRect) -> NSAttributedString {
            let maxVerticalPipCount = CGFloat(pipsPerRowForRank.reduce(0) { max($1.count, $0)})
            let maxHorizontalPipCount = CGFloat(pipsPerRowForRank.reduce(0) { max($1.max() ?? 0, $0)})
            let verticalPipRowSpacing = pipRect.size.height / maxVerticalPipCount
            let attemptedPipString = centerAttrString(suit, fontSize: verticalPipRowSpacing)
            let probablyOkayPipStringFontSize = verticalPipRowSpacing / (attemptedPipString.size().height / verticalPipRowSpacing)
            let probablyOkayPipString = centerAttrString(suit, fontSize: probablyOkayPipStringFontSize)
            if probablyOkayPipString.size().width > pipRect.size.width / maxHorizontalPipCount {
                return centerAttrString(suit, fontSize: probablyOkayPipStringFontSize /
                    (probablyOkayPipString.size().width / (pipRect.size.width / maxHorizontalPipCount)))
            } else {
                return probablyOkayPipString
            }
        }
        
        if pipsPerRowForRank.indices.contains(rank) {
            let pipsPerRow = pipsPerRowForRank[rank]
            var pipRect = bounds.insetBy(dx: cornerOffset, dy: cornerOffset).insetBy(dx: cornerString.size().width, dy: cornerString.size().height / 2)
            let pipString = createPipString(thatFits: pipRect)
            let pipRowSpacing = pipRect.size.height / CGFloat(pipsPerRow.count)
            pipRect.size.height = pipString.size().height
            pipRect.origin.y += (pipRowSpacing - pipRect.size.height) / 2
            for pipCount in pipsPerRow {
                switch pipCount {
                case 1:
                    pipString.draw(in: pipRect)
                case 2:
                    pipString.draw(in: pipRect.leftHalf)
                    pipString.draw(in: pipRect.rightHalf)
                default:
                    break
                }
                pipRect.origin.y += pipRowSpacing
            }
        }
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

extension CGRect{
    func zoom(by zoomFactor: CGFloat) -> CGRect {
        let zoomedWidth = size.width * zoomFactor
        let zoomedHeight = size.height * zoomFactor
        let originX = origin.x + (size.width - zoomedWidth) / 2
        let originY = origin.y + (size.height - zoomedHeight) / 2
        return CGRect(origin: CGPoint(x: originX,y: originY) , size: CGSize(width: zoomedWidth, height: zoomedHeight))
    }
    var leftHalf: CGRect {
        let width = size.width / 2
        return CGRect(origin: origin, size: CGSize(width: width, height: size.height))
    }
    
    var rightHalf: CGRect {
        let width = size.width / 2
        return CGRect(origin: CGPoint(x: origin.x + width, y: origin.y), size: CGSize(width: width, height: size.height))
    }
}
