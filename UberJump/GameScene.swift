//
//  GameScene.swift
//  UberJump
//
//  Created by Catherine Jung on 10/07/2014.
//  Copyright (c) 2014 InPlayTime Ltd. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    /*
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "Hello, World!";
        myLabel.fontSize = 65;
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        
        self.addChild(myLabel)
    }
    */
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        if player.physicsBody.dynamic {return}
        tapToStartNode.removeFromParent()
        player.physicsBody.dynamic = true
        player.physicsBody.applyImpulse(CGVectorMake(0.0, 20.0))
    }
   /*
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
*/
    init(size: CGSize) {
        super.init(size:size)
        self.backgroundColor = SKColor.whiteColor()
        backgroundNode = createBackgroundNode()
        self.addChild(backgroundNode)
        foregroundNode = SKNode()
        self.addChild(foregroundNode)
        
        hudNode = SKNode()
        self.addChild(hudNode)
        
        let platform = createPlatformAtPosition(CGPointMake(160, 320), type: PlatformType.PLATFORM_NORMAL)
        foregroundNode.addChild(platform)
        
        let star = createStarAtPosition(CGPointMake(160, 220), type:StarType.STAR_SPECIAL)
        foregroundNode.addChild(star)
        
        player = createPlayer()
        foregroundNode.addChild(player)
        
        tapToStartNode = SKSpriteNode(imageNamed: "TapToStart")
        tapToStartNode.position = CGPointMake(160, 180.0)
        hudNode.addChild(tapToStartNode)
        
        self.physicsWorld.gravity = CGVectorMake(0.0, -2.0)
        self.physicsWorld.contactDelegate = self
        
        
    }
    
    func createBackgroundNode() -> SKNode{
        println("CreateBagcorunwer")
        let backgroundNode = SKNode()
        for var nodeCount = 0; nodeCount < 20; ++nodeCount {
            let backgroundImageName = "Background\(nodeCount+1)"
            println("Adding background " + backgroundImageName)

            let node = SKSpriteNode(imageNamed:backgroundImageName)
            node.anchorPoint = CGPointMake(0.5, 0.0)
            node.position = CGPointMake(160.0, Float(nodeCount) * 64.0)
            backgroundNode.addChild(node)
        }
        return backgroundNode
    }
    let backgroundNode:SKNode!
//    let midgroundNode
    let foregroundNode:SKNode!
    let hudNode:SKNode!
    let player:SKNode!
    
    func createPlayer() -> SKNode{
        let playerNode = SKNode()
        playerNode.position = CGPointMake(160, 80.0)
        let sprite = SKSpriteNode(imageNamed: "Player")
        playerNode.addChild(sprite)
        
        playerNode.physicsBody = SKPhysicsBody(circleOfRadius: sprite.size.width/2)
        playerNode.physicsBody.dynamic = false
        playerNode.physicsBody.allowsRotation = false
        playerNode.physicsBody.restitution = 1.0
        playerNode.physicsBody.friction = 0.0
        playerNode.physicsBody.angularDamping = 0.0
        playerNode.physicsBody.linearDamping = 0.0
        playerNode.physicsBody.usesPreciseCollisionDetection = true
        playerNode.physicsBody.categoryBitMask = collisionCategoryPlayer
        playerNode.physicsBody.collisionBitMask = 0
        playerNode.physicsBody.contactTestBitMask = collisionCategoryStar | collisionCategoryPlatform
        
        
        return playerNode
    }
    
    let tapToStartNode:SKSpriteNode!
    
    func createStarAtPosition(position:CGPoint, type:StarType) -> StarNode{
        let node = StarNode()
        node.position = position
        node.name = "NODE_STAR"
        var sprite: SKSpriteNode!
        if (type == StarType.STAR_SPECIAL) {
            sprite = SKSpriteNode(imageNamed:"StarSpecial")
        }else{
            sprite = SKSpriteNode(imageNamed:"Star")
        }
        node.addChild(sprite)
        node.physicsBody = SKPhysicsBody(circleOfRadius: sprite.size.width/2)
        node.physicsBody.dynamic = false;
        node.physicsBody.categoryBitMask = collisionCategoryStar
        node.physicsBody.collisionBitMask = 0
        return node
    }
    
    let collisionCategoryPlayer:UInt32 = 0x1 << 0
    let collisionCategoryStar:UInt32 = 0x1 << 1
    let collisionCategoryPlatform:UInt32 = 0x1 << 2
    
    func didBeginContact(contact:SKPhysicsContact) {
        var updateHUD = false
        let other = (contact.bodyA.node != player ? contact.bodyA.node : contact.bodyB.node) as GameObjectNode
        updateHUD = other.collisionWithPlayer(player)
        if (updateHUD){
            //TODO
        }
    }
    let starType:StarType!
    
    func createPlatformAtPosition(position:CGPoint, type:PlatformType) -> PlatformNode{
        let node = PlatformNode(type:type)
        node.position = position
        node.name = "NODE_PLATFORM"
        var sprite: SKSpriteNode!
        if (type == PlatformType.PLATFORM_BREAK){
            sprite = SKSpriteNode(imageNamed:"PlatformBreak")
        }else{
            sprite = SKSpriteNode(imageNamed: "Platform")
        }
        node.addChild(sprite)
        node.physicsBody = SKPhysicsBody(rectangleOfSize: sprite.size)
        node.physicsBody.dynamic = false
        node.physicsBody.categoryBitMask = collisionCategoryPlatform
        node.physicsBody.collisionBitMask = 0
        return node
    }
}

