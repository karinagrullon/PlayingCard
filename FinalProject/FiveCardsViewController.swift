//
//  FiveCardsViewController.swift
//  FinalProject
//
//  Created by Melida Grullon on 12/17/19.
//  Copyright © 2019 Melida Grullon. All rights reserved.
//

import UIKit

class FiveCardsViewController: UIViewController {

    private var deck = PlayingCardDeck()
    lazy var game = CardGame()
    var counter = 0
    var groupCards: [Int] = []
    var playerCards: [PlayingCardView] = []
    var computerCards: [PlayingCardView] = []
    
    @IBOutlet weak var playerScoreLabel: UILabel!
    
    @IBOutlet weak var gameBalanceLabel: UILabel!
    
    @IBOutlet weak var gameBetLabel: UILabel!
    
    
    @IBOutlet weak var computerScoreLabel: UILabel!
    
    @IBOutlet weak var dealButton: UIButton!
    
    @IBOutlet weak var betButton: UIButton!
    
    
    @IBAction func gameBetButton(_ sender: UIButton) {
        
        if balanceAmount <= 0 {
            print("Game is Over!!! No more money left to bet")
        }
        
        betAmount = game.increaseBet()
        balanceAmount = game.decreaseBalance(amount: 1)
        
        game.turn = "computer"
    }
    
    @IBAction func gameDealButton(_ sender: UIButton) {
        // game = CardGame()  // creating new instance of the game
        
        if game.turn == "player" {
            playerScore = 0 // set new players turn player score to 0
        }
        
        // enable bet button
        betButton.isEnabled = true
        betButton.backgroundColor = UIColor(red: 0/255, green: 143/255, blue: 0/255, alpha: 1)

        viewDidLoad()
    }
    
    @IBAction func gameResetButton(_ sender: UIButton) {
        deck = PlayingCardDeck()
        game.balance = 100
        playerScore = 0
        computerScore = 0
        balanceAmount = 100
        betAmount = 0
        
        // face down computer cards
        if computerCards.count != 0 {
            for i in 0...((computerCards.count) - 1) {
                flipCardDownAnimation(viewName: playerCards[i])
            }
        }
        
        // face down computer cards
        if computerCards.count != 0 {
            for i in 0...((computerCards.count) - 1) {
                flipCardDownAnimation(viewName: computerCards[i])
            }
        }
        
        // disable bet button
        betButton.isEnabled = false
        betButton.backgroundColor = UIColor.gray
        
        // enable deal button
        dealButton.isEnabled = true
        dealButton.backgroundColor = UIColor(red: 83/255, green: 27/255, blue: 147/255, alpha: 1)
        
    }
    
    var playerScore: Int = 0 {
        didSet {
            playerScoreLabel.text = "Score:  \(playerScore)"
        }
    }
    
    var computerScore: Int = 0 {
        didSet {
            computerScoreLabel.text = "Score:  \(computerScore)"
        }
    }
    
    var balanceAmount: Int = 0 {
        didSet {
            gameBalanceLabel.text = "Balance:  \(balanceAmount)"
        }
    }
    
    var betAmount: Int = 0 {
        didSet {
            gameBetLabel.text = "Bet: \(betAmount)"
            
            if (betAmount != 0) {
                dealButton.isEnabled = true
                dealButton.backgroundColor = UIColor(red: 83/255, green: 27/255, blue: 147/255, alpha: 1)
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var cards = [PlayingCard]()
        
        if (game.turn == "player") {

            computerScore = 0 // set new players turn computer score to 0
            
            // face down computer cards when is players turn
            if computerCards.count != 0 {
                for i in 0...((computerCards.count) - 1) {
                    flipCardDownAnimation(viewName: computerCards[i])
                }
            }

            if deck.amountCards() <= 6 {
                print("Game is Over!!! No more cards left")
                
                // disable bet button
                betButton.isEnabled = false
                betButton.backgroundColor = UIColor.gray
                
                // disable deal button
                dealButton.isEnabled = false
                dealButton.backgroundColor = UIColor.gray
                
            } else {
                
                for _ in 1...((cardViews.count+1/2)) {
                    let card = deck.draw()!
                    cards += [card, card]
                }
                
                if counter != 0 { // if it is not first turn
                    for cardView in cardViews {
                        
                        // add animations
                        flipCardUpAnimation(viewName: cardView)
                        
                        playerCards.append(cardView)
                        
                        let card = cards.remove(at: cards.count.arc4random)
                        cardView.rank = card.rank.order
                        cardView.suit = card.suit.rawValue
                        
                        playerScore += card.gameScore(suit: card.suit.order, rank: cardView.rank)
                        
                        groupCards.append(card.gameScore(suit: card.suit.order, rank: cardView.rank))
                    }
                    
                    
                } else {
                    // First turn
                    for cardView in cardViews {
                        cardView.isFaceUp = false
                    }
                    
                    for computerCardView in computerCardViews {
                        computerCardView.isFaceUp = false
                    }
                    
                    balanceAmount = game.balance
                    
                    // disable bet button
                    betButton.isEnabled = false
                    betButton.backgroundColor = UIColor.gray
                }
                
                if (counter != 0) {
                    // disable deal button
                    dealButton.isEnabled = false
                    dealButton.backgroundColor = UIColor.gray
                }
                counter = 1
            }
            
        } else if (game.turn == "computer") {
            
            if cardViews != nil {
                
                for _ in 1...((computerCardViews.count+1/2)) {
                    let card = deck.draw()!
                    cards += [card, card]
                }
                
                for computerCardView in computerCardViews {
                    
                    // add animations
                    flipCardUpAnimation(viewName: computerCardView)
                    
                    let card = cards.remove(at: cards.count.arc4random)
                    computerCardView.rank = card.rank.order
                    computerCardView.suit = card.suit.rawValue
                    
                    computerCards.append(computerCardView)
                    
                    computerScore += card.gameScore(suit: card.suit.order, rank: computerCardView.rank)
                }

                balanceAmount = balanceAmount + game.compareBothScores(playerScore: playerScore, computerScore: computerScore, betAmount: betAmount)
                
                // reseting bet to 0
                game.bet = 0
                betAmount = 0
                
                // disable bet button
                betButton.isEnabled = false
                betButton.backgroundColor = UIColor.gray
                
                game.turn = "player"
                
                
            } else {
                
                // disable bet button
                betButton.isEnabled = false
                betButton.backgroundColor = UIColor.gray
            }
        }
        
    }
    
    
    func flipCardUpAnimation(viewName: PlayingCardView) {
        UIView.transition(with: viewName,
                          duration: 0.6,
                          options: .transitionFlipFromLeft,
                          animations: {
                            viewName.isFaceUp = true
        },
                          completion: nil)
    }
    
    func flipCardDownAnimation(viewName: PlayingCardView) {
        UIView.transition(with: viewName,
                          duration: 0.6,
                          options: .transitionFlipFromRight,
                          animations: {
                            viewName.isFaceUp = false
        },
                          completion: nil)
    }
    
    
    @IBOutlet var cardViews: [PlayingCardView]!
    
   
    @IBOutlet var computerCardViews: [PlayingCardView]!
    
    
    @IBOutlet weak var playingCardView: PlayingCardView! {
        didSet {
            
            let swipe = UISwipeGestureRecognizer(target: self,
                                                 action: #selector(nextCard))
            swipe.direction = [.right]
            playingCardView.addGestureRecognizer(swipe)
        }
    }
    
    
    @objc private func nextCard() {
        if let card = deck.draw() {
            playingCardView.rank = card.rank.order
            playingCardView.suit = card.suit.rawValue
            playerScore += (card.gameScore(suit: card.suit.order, rank: card.rank.order) - groupCards[0])
            
        }
    }
    
    
    
    @IBOutlet weak var playingCardViewTwo: PlayingCardView! {
        didSet {
            let swipe = UISwipeGestureRecognizer(target: self,
                                                 action: #selector(nextCardTwo))
            swipe.direction = [.right]
            playingCardViewTwo.addGestureRecognizer(swipe)
        }
    }
    
    @objc private func nextCardTwo() {
        if let card = deck.draw() {
            playingCardViewTwo.rank = card.rank.order
            playingCardViewTwo.suit = card.suit.rawValue
            playerScore += (card.gameScore(suit: card.suit.order, rank: card.rank.order) - groupCards[1])
        }
    }
    
    
    @IBOutlet weak var playingCardViewThree: PlayingCardView! {
        didSet {
            let swipe = UISwipeGestureRecognizer(target: self,
                                                 action: #selector(nextCardThree))
            swipe.direction = [.right]
            playingCardViewThree.addGestureRecognizer(swipe)
        }
    }
    
    @objc private func nextCardThree() {
        if let card = deck.draw() {
            playingCardViewThree.rank = card.rank.order
            playingCardViewThree.suit = card.suit.rawValue
            playerScore += (card.gameScore(suit: card.suit.order, rank: card.rank.order) - groupCards[2])
        }
    }
    
    
    @IBOutlet weak var playingCardViewFour: PlayingCardView! {
        didSet {
            let swipe = UISwipeGestureRecognizer(target: self,
                                                 action: #selector(nextCardFour))
            swipe.direction = [.right]
            playingCardViewFour.addGestureRecognizer(swipe)
        }
    }
    
    @objc private func nextCardFour() {
        if let card = deck.draw() {
            playingCardViewFour.rank = card.rank.order
            playingCardViewFour.suit = card.suit.rawValue
            playerScore += (card.gameScore(suit: card.suit.order, rank: card.rank.order) - groupCards[2])
        }
    }
    
    
    @IBOutlet weak var playingCardViewFive: PlayingCardView! {
        didSet {
            let swipe = UISwipeGestureRecognizer(target: self,
                                                 action: #selector(nextCardFive))
            swipe.direction = [.right]
            playingCardViewFive.addGestureRecognizer(swipe)
        }
    }
    
    @objc private func nextCardFive() {
        if let card = deck.draw() {
            playingCardViewFive.rank = card.rank.order
            playingCardViewFive.suit = card.suit.rawValue
            playerScore += (card.gameScore(suit: card.suit.order, rank: card.rank.order) - groupCards[2])
        }
    }
    
    
}
