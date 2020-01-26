//
//  CardGame.swift
//  FinalProject
//
//  Created by Melida Grullon on 12/14/19.
//  Copyright © 2019 Melida Grullon. All rights reserved.
//

import Foundation

class CardGame
{
    var score = 0
    var balance = 0
    var bet = 0
    var turn = ""
    var winAmount = 0
    
    func increaseBet() -> Int {
        bet += 1
        return bet
    }
    
    func decreaseBalance(amount: Int) -> Int {
        balance -= amount
        return balance
    }
    
    func compareBothScores(playerScore: Int, computerScore: Int, betAmount: Int) -> Int {
        
        if playerScore >= computerScore {
            print("Player won this turn")
            winAmount = bet
        } else if (playerScore) > (computerScore * 2) {
            print("Player won this turn")
            winAmount = bet * 2
        } else if playerScore < computerScore {
            print("Player lost this turn")
            winAmount = (bet) * -1
        }
        return winAmount
    }
    
    init() {
        balance = 100
        turn = "player"
    }
    
    
}
