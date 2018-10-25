//
//  PlayingCardDeck.swift
//  PokerGame
//
//  Created by admin on 2018/10/24.
//  Copyright © 2018 dqv5. All rights reserved.
//

import Foundation
struct PlayingCardDeck{
    private(set) var cards = [PlayingCard]()
    
    mutating func draw()->PlayingCard?{
        if(cards.isEmpty){
            return nil
        }
        return cards.remove(at: cards.count.random)
    }
    init(){
        for suit in Suit.all{
            for rank in Rank.all{
                cards.append(PlayingCard(suit:suit,rank:rank))
            }
        }
    }
}


extension Int{
    var random:Int{
        return Int(arc4random_uniform(UInt32(self)))
    }
}
