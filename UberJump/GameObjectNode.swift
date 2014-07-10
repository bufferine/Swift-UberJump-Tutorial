//
//  GameObjectNode.swift
//  UberJump
//
//  Created by Catherine Jung on 10/07/2014.
//  Copyright (c) 2014 InPlayTime Ltd. All rights reserved.
//
import SpriteKit

class GameObjectNode: SKNode {
    func collisionWithPlayer(player:SKNode) -> Bool {
        return false
    }
    func checkNodeRemoval(playerY:CGFloat) {
        if (playerY > self.position.y + 300.0) {
            self.removeFromParent()
        }
    }
    
}