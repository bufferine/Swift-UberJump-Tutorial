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
        midgroundNode = createMidgroundNode()
        self.addChild(midgroundNode)
        
        foregroundNode = SKNode()
        self.addChild(foregroundNode)
        
        hudNode = SKNode()
        self.addChild(hudNode)
        
        let levelPlist = NSBundle.mainBundle().pathForResource("Level01", ofType:"plist")
        let levelData = NSDictionary(contentsOfFile:levelPlist)
        endLevelY = levelData.objectForKey("EndY") as Int
        
        
        // there's gonna be a swifter way to do this.
        let platforms = levelData.objectForKey("Platforms") as NSDictionary
        
        let platformPatterns = platforms.objectForKey("Patterns") as NSDictionary
        
        let platformPositions = platforms.objectForKey("Positions") as NSArray
        
        for platformPosition in platformPositions{
            let position = platformPosition as NSDictionary
            let patternX = position.objectForKey("x") as Float
            let patternY = position.objectForKey("y") as Float
            let pattern = platformPosition.objectForKey("pattern") as String
            let platformPattern = platformPatterns.objectForKey(pattern) as NSArray
            for platformPointer in platformPattern {
                let platformPoint = platformPointer as NSDictionary
                let x = platformPoint.objectForKey("x") as Float
                let y = platformPoint.objectForKey("y") as Float
                let type = PlatformType.fromRaw(platformPoint.objectForKey("type") as Int)
                let platformNode = self.createPlatformAtPosition(CGPointMake(x + patternX, y + patternY), type: type!)
                foregroundNode.addChild(platformNode)
            }
        }
        
        let stars = levelData.objectForKey("Stars") as NSDictionary
        
        let starPatterns = stars.objectForKey("Patterns") as NSDictionary
        
        let starPositions = stars.objectForKey("Positions") as NSArray
        
        for starPosition in starPositions{
            let position = starPosition as NSDictionary
            let patternX = position.objectForKey("x") as Float
            let patternY = position.objectForKey("y") as Float
            let pattern = starPosition.objectForKey("pattern") as String
            println("pattern \(pattern)")
            let starPattern = starPatterns.objectForKey(pattern) as NSArray
            
            for starPointer in starPattern {
                let starPoint = starPointer as NSDictionary
                let x = starPoint.objectForKey("x") as Float
                let y = starPoint.objectForKey("y") as Float
                let type = StarType.fromRaw(starPoint.objectForKey("type") as Int)
                let starNode = self.createStarAtPosition(CGPointMake(x + patternX, y + patternY), type: type!)
                foregroundNode.addChild(starNode)
            }
        }
        
        player = createPlayer()
        foregroundNode.addChild(player)
        
        tapToStartNode = SKSpriteNode(imageNamed: "TapToStart")
        tapToStartNode.position = CGPointMake(160, 180.0)
        hudNode.addChild(tapToStartNode)
        
        self.physicsWorld.gravity = CGVectorMake(0.0, -2.0)
        self.physicsWorld.contactDelegate = self
        
        

        
    }
    
    func createBackgroundNode() -> SKNode{
        let backgroundNode = SKNode()
        for var nodeCount = 0; nodeCount < 20; ++nodeCount {
            let backgroundImageName = "Background\(nodeCount+1)"

            let node = SKSpriteNode(imageNamed:backgroundImageName)
            node.anchorPoint = CGPointMake(0.5, 0.0)
            node.position = CGPointMake(160.0, Float(nodeCount) * 64.0)
            backgroundNode.addChild(node)
        }
        return backgroundNode
    }
    let backgroundNode:SKNode!
    let midgroundNode:SKNode!
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
    
    let endLevelY:Int!
    
    func createMidgroundNode() -> SKNode {
        let midgroundNode = SKNode()
        for index in 0 .. 10 {
            var spriteName:String!
            let r = arc4random() % 2
            if r > 0 {
                spriteName = "BranchRight"
            }else{
                spriteName = "BranchLeft"
            }
            let branchNode = SKSpriteNode(imageNamed:spriteName)
            branchNode.position = CGPointMake(160.0, 500.0 * Float(index))
            midgroundNode.addChild(branchNode)
        }
        return midgroundNode
    }
    

    
    override func update(currentTime:CFTimeInterval) {
        if (player.position.y > 200.0){
            backgroundNode.position = CGPointMake(0.0, -((player.position.y - 200.0)/10))
            midgroundNode.position = CGPointMake(0.0, -((player.position.y - 200.0)/4))
            foregroundNode.position = CGPointMake(0.0, -((player.position.y - 200.0)))
        }
    }
    
    func rwAdd(a:CGPoint, b:CGPoint) -> CGPoint {
        return CGPointMake(a.x + b.x, a.y + b.y)
    }
    func rwSubtract(a:CGPoint, b:CGPoint) -> CGPoint {
        return CGPointMake(a.x - b.x, a.y - b.y)
    }
    func rwMultiply(a:CGPoint, f:Float) -> CGPoint {
        return CGPointMake(a.x * f, a.y * f)
    }
    func rwLength(a:CGPoint) -> Float{
        return sqrtf(a.x * a.x + a.y * a.y)
    }
    func rwNormalize(a:CGPoint) -> CGPoint{
        let length = rwLength(a)
        return CGPointMake(a.x / length, a.y / length)
    }
    
    override func touchesEnded(touches: NSSet!, withEvent event: UIEvent!) {
        let touch = touches.anyObject() as UITouch
        let location = touch.locationInNode(self)
        
        println("touch at \(location)")
        println("player at \(player.position)")
        
        let boost = rwSubtract(location, b:player.position)
        
        println("difference is  \(boost)" )
        
        let nBoost = rwNormalize(boost)
        
        println("normalized is \(nBoost)")
        
        // boost the player sideways by that much

        player.physicsBody.applyForce(CGVectorMake(boost.x, 0))
//        player.physicsBody.velocity = CGVectorMake(location.x - (self.size.width/2), player.physicsBody.velocity.dy)

/*
        let projectile = SKSpriteNode(imageNamed: "projectile")
        projectile.position = self.player.position
        let offset = rwSubtract(location, b:projectile.position)
        if (offset.x <= 0) {return}
        self.addChild(projectile)
        let amount:Float = 1000
        let direction = rwNormalize(offset)
        let shootAmount = rwMultiply(direction, f:amount)
        let realDest = rwAdd(shootAmount, b:projectile.position)
        let velocity:Float = 480
        let realMoveDuration:NSTimeInterval = NSTimeInterval(self.size.width / velocity)
        let actionMove:SKAction = SKAction.moveTo(realDest, duration:realMoveDuration)
        let actionMoveDone = SKAction.removeFromParent()
        projectile.runAction(SKAction.sequence([actionMove, actionMoveDone]))
*/
    }

    
    override func didSimulatePhysics() {
        if (player.position.x < -20.0){
            player.position = CGPointMake(340.0, player.position.y)
        }else if (player.position.x > 340.0){
            player.position = CGPointMake(-20, player.position.y)
        }
    }
    /*
- (void) didSimulatePhysics
{
// 1
// Set velocity based on x-axis acceleration
_player.physicsBody.velocity = CGVectorMake(_xAcceleration * 400.0f, _player.physicsBody.velocity.dy);

// 2
// Check x bounds
if (_player.position.x < -20.0f) {
_player.position = CGPointMake(340.0f, _player.position.y);
} else if (_player.position.x > 340.0f) {
_player.position = CGPointMake(-20.0f, _player.position.y);
}
return;
}*/

}

