
//
//  StarNode.swift
//  UberJump
//
//  Created by Catherine Jung on 10/07/2014.
//  Copyright (c) 2014 InPlayTime Ltd. All rights reserved.
//

import SpriteKit

class StarNode: GameObjectNode {
    override func collisionWithPlayer(player:SKNode) -> Bool{
        player.physicsBody.velocity = CGVectorMake(player.physicsBody.velocity.dx, 400.0)
        self.removeFromParent()
        return true
    }
}
enum StarType : Int{
    case STAR_NORMAL = 0, STAR_SPECIAL
}