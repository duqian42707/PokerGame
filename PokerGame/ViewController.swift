//
//  ViewController.swift
//  PokerGame
//
//  Created by admin on 2018/10/24.
//  Copyright © 2018 dqv5. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var deck = PlayingCardDeck()
    
    
    @IBOutlet weak var playingCardView: PlayingCardView!{
        didSet{
            let swipe = UISwipeGestureRecognizer(target: self, action: #selector(nextCard))
            swipe.direction = [.left, .right]
            playingCardView.addGestureRecognizer(swipe)
            let pinchSelector = #selector(playingCardView.adjustFaceCardScale(byHandlingGestureRecognizerBy:))
            let pinch = UIPinchGestureRecognizer(target: playingCardView, action: pinchSelector)
            playingCardView.addGestureRecognizer(pinch)
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    @objc func nextCard() {
        if let card  = deck.draw() {
            playingCardView.rank = card.rank.order
            playingCardView.suit = card.suit.rawValue
        }
    }

    @IBAction func tabCard(_ sender: UITapGestureRecognizer) {
        switch sender.state{
        case .ended: playingCardView.isFaceUp = !playingCardView.isFaceUp
        default:break
        }
    }
    
}

