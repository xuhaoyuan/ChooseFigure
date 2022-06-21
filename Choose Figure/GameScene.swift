//
//  GameScene.swift
//  Choose Figure
//
//  Created by Ivan Sosnovik on 07.02.16.
//  Copyright (c) 2016 ivansosnovik. All rights reserved.
//

import SpriteKit
import SwiftEntryKit


class GameScene: SKScene {
    
    var level: Int = 1
    var logic: GameActions?
        
    var levelLabelNode: SKLabelNode?
    var rightFigureNode: SKSpriteNode?
    var deckNodes: [SKSpriteNode] = []
    var lifeNodes: [SKSpriteNode] = []
    var lives: Int = 3
    
    
    // preparations
    override func didMove(to view: SKView) {

        // connect nodes with scene
        self.levelLabelNode = childNode(withName: "level") as? SKLabelNode
        self.rightFigureNode = childNode(withName: "rightFigure") as? SKSpriteNode
        enumerateChildNodes(withName: "//*") {
            node, stop in
            if node.name == "figure" {
                self.deckNodes.append(node as! SKSpriteNode)
            }
            if node.name == "life" {
                self.lifeNodes.append(node as! SKSpriteNode)
            }
        }
        // configure the label
        self.levelLabelNode?.text = String(level)
        // configure logic
        self.logic = GameLogic(delegate: self, deckSize: deckNodes.count)
        // Draw sprites
        drawDeck()
        drawRightFigure()
        drawLives()
    }
    
}


// MARK: - Drawings
extension GameScene {
    
    func drawDeck() {
        for (index, node) in deckNodes.enumerated() {
            let name = logic?.deck[index]
            node.texture = SKTexture(imageNamed: name!)
        }
    }
    
    func drawRightFigure() {
        guard let name = logic?.rightFigureName else { return }
        self.rightFigureNode?.texture = SKTexture(imageNamed: name)
    }
    
    func drawLives() {
        if lives < 3 {
            for index in lives...2 {
                let node = lifeNodes[index]
                node.alpha = 0.2
            }
        }
    }
    
}

// MARK: - Event Delegation
extension GameScene: GameEvents {
    
    func userDidRightChoice(index: Int, animation: @escaping () -> Void) {
        let node = deckNodes[index]
        let action = SKAction.scale(by: 0.7, duration: 0.3)
        node.run(action) {
            animation()
        }
    }

    func userDidWrongChoice(index: Int, animation: @escaping () -> Void) {
        let livesIndex = lives - 1
        if livesIndex >= 0 {
            let lifeNode = lifeNodes[livesIndex]
            let action = SKAction.fadeAlpha(to: 0.2, duration: 0.1)
            lifeNode.run(action)
        }

        let node = deckNodes[index]
        let actions = [
            SKAction.move(by: CGVector(dx: -10, dy: 0), duration: 0.05),
            SKAction.move(by: CGVector(dx: 10, dy: 0), duration: 0.05)
        ]
        let square = SKAction.sequence(actions)
        let repeatAnimation = SKAction.repeat(square, count: 5)
        node.run(repeatAnimation) {
            animation()
        }
    }

    func gameOver() {
        let view = GameOverView(score: logic?.bestScore ?? 0)
        view.retryHandler = { [weak self] in
            SwiftEntryKit.dismiss() { [weak self] in
                self?.retry()
            }
        }
        SwiftEntryKit.display(entry: view, using: .gameCenterToast(duration: 0.3))
    }

    func moveToNextLevel() {
        guard let nextLevelScene = GameScene(fileNamed:"GameScene") else { return }
        nextLevelScene.size = UIScreen.main.bounds.size
        nextLevelScene.level = level + 1
        nextLevelScene.lives = lives
        let transition = SKTransition.crossFade(withDuration: 0.2)
        self.scene?.view?.presentScene(nextLevelScene, transition: transition)
    }
}

extension GameScene {

    func retry() {
        guard let nextLevelScene = GameScene(fileNamed:"GameScene") else { return }
        nextLevelScene.size = UIScreen.main.bounds.size
        nextLevelScene.level = 1
        nextLevelScene.lives = 3
        let transition = SKTransition.crossFade(withDuration: 0.2)
        self.scene?.view?.presentScene(nextLevelScene, transition: transition)
    }
}

// MARK: - Touches
extension GameScene {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let position = touch.location(in: self)
            let node = self.atPoint(position)
            guard node.name == "figure",
                  let figure = node as? SKSpriteNode,
                  let index = deckNodes.firstIndex(of: figure) else { continue }
            self.logic?.userChoose(index: index)
        }
    }
}













