//
//  PlatformNode.swift
//  UberJump
//
//  Created by Catherine Jung on 10/07/2014.
//  Copyright (c) 2014 InPlayTime Ltd. All rights reserved.
//

import SpriteKit



class PlatformNode: GameObjectNode{
    
    let platformType:PlatformType!
    
    init(type: PlatformType) {
        super.init()
        platformType = type
    }
    
    override func collisionWithPlayer(player: SKNode) -> Bool {
        // only bounce player if she's falling
        if (player.physicsBody.velocity.dy < 0){
            // disappear if you're  a breaking platform
            player.physicsBody.velocity = CGVectorMake(player.physicsBody.velocity.dx,250.0)
            if (platformType == PlatformType.PLATFORM_BREAK){
                self.removeFromParent()
            }
        }
        // no stars for platforms (boolean is if to refresh the HUD)
        return false
    }
}
enum PlatformType{
    case PLATFORM_NORMAL, PLATFORM_BREAK
}
