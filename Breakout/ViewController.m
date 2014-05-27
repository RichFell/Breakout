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
@property (weak, nonatomic) IBOutlet BallView *ballView;
@property IBOutlet BlockView *blockView;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property IBOutletCollection(BlockView)NSMutableArray *allBlockArray;
@property UIDynamicAnimator *dynamicAnimator;
@property UIPushBehavior *pushBehavior;
@property UICollisionBehavior *collisionBehavior;
@property UIDynamicItemBehavior *paddleBehavior;
@property UIDynamicItemBehavior *ballBehavior;
@property UIDynamicItemBehavior *blockBehavior;
@property NSMutableArray *blockArray;
@property NSMutableArray *allViewsArray;
@property NSMutableArray *blockTrackingArray;
@property NSMutableArray *deletedBlockArray;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self createLevelOneBlocks];

    self.deletedBlockArray = [[NSMutableArray alloc]init];

    NSLog(@"count %d", self.blockTrackingArray.count);

}

-(IBAction)dragPaddle:(UIPanGestureRecognizer *)gestureRecognizer
{
    self.paddleView.center = CGPointMake([gestureRecognizer locationInView:self.view].x, self.paddleView.center.y);
    [self.dynamicAnimator updateItemUsingCurrentState:self.paddleView];
}

-(void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item withBoundaryIdentifier:(id<NSCopying>)identifier atPoint:(CGPoint)p
{
    if (self.ballView.center.y > 520)
    {

        self.ballView.center = self.view.center;
        self.ballBehavior.resistance = 100;
        [self resetAfterHittingBottom];
        [self.startButton setHidden:NO];
        [self.startButton setEnabled:YES];





        [self.dynamicAnimator updateItemUsingCurrentState:self.ballView];
    }
}

-(void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(BallView *)item1 withItem:(BlockView *)item2 atPoint:(CGPoint)p
{
    if ([item2 isKindOfClass:[BlockView class]] && [item1 isKindOfClass:[BallView class]]) {

//        [(BlockView *)item2 removeFromSuperview];
        if (item2.backgroundColor == [UIColor yellowColor]) {
            item2.backgroundColor = [UIColor blueColor];
        }
        else
        {
        [item2 setHidden:YES];
        [self.collisionBehavior removeItem:item2];
        [self.dynamicAnimator updateItemUsingCurrentState:self.blockView];
        [self.deletedBlockArray addObject:item2];
        }
    }
    [self shouldStartAgain];
}

-(void)createLevelOneBlocks
{

    self.allViewsArray = [[NSMutableArray alloc] init];
    [self.allViewsArray addObject:self.paddleView];
    [self.allViewsArray addObject:self.ballView];

    self.blockArray = [[NSMutableArray alloc] init];
    self.allBlockArray = [[NSMutableArray alloc]init];

    self.blockTrackingArray = [[NSMutableArray alloc]init];

    for (int y = 1; y < 10; y++)
    {
        for (int x = 1; x < 7; x++)
        {
            BlockView *blockView = [[BlockView alloc]initWithFrame:CGRectMake(40 * x, 20 * y + 60, 40, 20)];
            [self.view addSubview:blockView];
            [self.view bringSubviewToFront:blockView];
            [self.allBlockArray addObject:blockView];
            [self.allViewsArray addObject:blockView];
            [self.blockTrackingArray addObject:blockView];
            [self.collisionBehavior addItem:blockView];

            if ((x % 2) && (y % 2))
            {
                blockView.backgroundColor = [UIColor yellowColor]; 
            }
            else
            {
                blockView.backgroundColor = [UIColor redColor];

            }
        }
    }
    self.dynamicAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];

    self.pushBehavior = [[UIPushBehavior alloc] initWithItems:@[self.ballView] mode:UIPushBehaviorModeInstantaneous];

    self.collisionBehavior = [[UICollisionBehavior alloc] initWithItems:self.allViewsArray];
    self.collisionBehavior.collisionMode = UICollisionBehaviorModeEverything;
    self.collisionBehavior.collisionDelegate = self;
    self.collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    [self.dynamicAnimator addBehavior:self.collisionBehavior];

    self.paddleBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.paddleView]];
    self.paddleBehavior.allowsRotation = NO;
    self.paddleBehavior.density = 5000;
    [self.dynamicAnimator addBehavior:self.paddleBehavior];

    self.ballBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.ballView]];
    self.ballBehavior.allowsRotation = NO;
    self.ballBehavior.elasticity = 1;
    self.ballBehavior.friction = 0.0;
    self.ballBehavior.resistance = 0.0;
    [self.dynamicAnimator addBehavior:self.ballBehavior];

    self.blockBehavior = [[UIDynamicItemBehavior alloc] initWithItems:self.allBlockArray];
    self.blockBehavior.allowsRotation = NO;
    self.blockBehavior.density = 10000;
    [self.dynamicAnimator addBehavior:self.blockBehavior];
}

-(BOOL) shouldStartAgain
{
    if (self.blockTrackingArray.count == 0)
    {
        for (BlockView *block in self.allBlockArray)
        {

            if (block.backgroundColor == [UIColor blueColor]) {
                block.backgroundColor = [UIColor yellowColor];
            }

            [self.collisionBehavior addItem:block];
            [self.view addSubview:block];
            [self.blockBehavior addItem:block];
            [self.blockTrackingArray addObject:block];

        }
        return YES;
    }
    else
    {
        return NO;
    }
}

-(void) resetAfterHittingBottom
{
    for (BlockView *blocks in self.deletedBlockArray)
    {
        [self.collisionBehavior addItem:blocks];
        [self.view addSubview:blocks];
        [blocks setHidden:NO];
        [self.blockBehavior addItem:blocks];
        [self.blockTrackingArray addObject:blocks];
        [self.dynamicAnimator updateItemUsingCurrentState:blocks];

        NSLog(@"%d", self.deletedBlockArray.count);

    }
}
- (IBAction)onStartButtonPressed:(id)sender
{
    self.pushBehavior.pushDirection = CGVectorMake(0.2, 0.4);
    self.pushBehavior.magnitude = 0.1;
    self.pushBehavior.active = YES;
    [self.dynamicAnimator addBehavior:self.pushBehavior];
    [self.startButton setHidden:YES];
    [self.startButton setEnabled:NO];
    self.ballBehavior.resistance = 0.0;
    
}




@end
