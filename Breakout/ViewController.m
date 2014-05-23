//
//  ViewController.m
//  Breakout
//
//  Created by Richard Fellure on 5/22/14.
//  Copyright (c) 2014 Rich. All rights reserved.
//

#import "ViewController.h"
#import "PaddleView.h"
#import "BallView.h"
#import "BlockView.h"

@interface ViewController ()<UICollisionBehaviorDelegate>
@property (weak, nonatomic) IBOutlet PaddleView *paddleView;
@property (weak, nonatomic) IBOutlet UIView *ballView;
@property (weak, nonatomic) IBOutlet BlockView *blockView;
@property UIDynamicAnimator *dynamicAnimator;
@property UIPushBehavior *pushBehavior;
@property UICollisionBehavior *collisionBehavior;
@property UIDynamicItemBehavior *paddleBehavior;
@property UIDynamicItemBehavior *ballBehavior;
@property UIGravityBehavior *gravityBehavior;



@property CGPoint point;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.dynamicAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];

    self.pushBehavior = [[UIPushBehavior alloc] initWithItems:@[self.ballView] mode:UIPushBehaviorModeInstantaneous];
    self.pushBehavior.pushDirection = CGVectorMake(1, 0.4);
    self.pushBehavior.magnitude = 0.2;
    self.pushBehavior.active = YES;
    [self.dynamicAnimator addBehavior:self.pushBehavior];

    self.collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[self.paddleView, self.ballView, self.blockView]];
    self.collisionBehavior.collisionMode = UICollisionBehaviorModeEverything;
    self.collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    self.collisionBehavior.collisionDelegate = self;
    [self.dynamicAnimator addBehavior:self.collisionBehavior];

    self.paddleBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.paddleView]];
    self.paddleBehavior.allowsRotation = NO;
    self.paddleBehavior.density = 5000;
    [self.dynamicAnimator addBehavior:self.paddleBehavior];

    self.ballBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.ballView]];
    self.ballBehavior.allowsRotation = NO;
    self.ballBehavior.elasticity = 1.0;
    self.ballBehavior.friction = 0.0;
    self.ballBehavior.resistance = 0.0;
    [self.dynamicAnimator addBehavior:self.ballBehavior];

}

-(IBAction)dragPaddle:(UIPanGestureRecognizer *)gestureRecognizer
{
    self.paddleView.center = CGPointMake([gestureRecognizer locationInView:self.view].x, self.paddleView.center.y);
    [self.dynamicAnimator updateItemUsingCurrentState:self.paddleView];
}

-(void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item withBoundaryIdentifier:(id<NSCopying>)identifier atPoint:(CGPoint)p
{
    if (self.ballView.center.y > 475)
    {

        self.ballView.center = self.point;
        self.pushBehavior.pushDirection = CGVectorMake(0, 1);
        self.pushBehavior.magnitude = 0.1;


        [self.dynamicAnimator updateItemUsingCurrentState:self.ballView];


//        self.pushBehavior.active = YES;


    }
    

}

-(void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(BallView *)item1 withItem:(BlockView *)item2 atPoint:(CGPoint)p
{
    [self.blockView removeFromSuperview];
    [self.blockView setHidden:YES];
    NSLog(@"hit the block");
}



@end
