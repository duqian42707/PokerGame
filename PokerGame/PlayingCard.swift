//
//  PlayingCard.swift
//  PokerGame
//
//  Created by admin on 2018/10/24.
//  Copyright © 2018 dqv5. All rights reserved.
//

import Foundation
struct PlayingCard: CustomStringConvertible{
    var description:String{
        get{
            return "\(suit)\(rank)"
        }
    }
    
    var suit:Suit
    var rank:Rank
}

enum Suit:String,CustomStringConvertible {
    case heitao = "♠️"
    case hongtao = "♥️"
    case meihua = "♣️"
    case fangpian = "♦️"
    var description: String { return self.rawValue }
    static var all:[Suit]{
        return [.heitao,.hongtao,.meihua,.fangpian]
    }
    
}

enum Rank:CustomStringConvertible{
    case ace
    case numeric(Int)
    case face(String)
    
    var description: String{
        switch self{
        case .ace:
            return "A"
        case .numeric(let kind):
            return "\(kind)"
        case .face(let kind):
            return "\(kind)"
        }
    }
    
    static var all:[Rank]{
        var result = [Rank]()
        result.append(.ace)
        for i in 2...10{
            result.append(.numeric(i))
        }
        result+=[.face("J"),.face("Q"),.face("K")]
        return result
    }
    
    
}
