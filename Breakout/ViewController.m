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
@property (weak, nonatomic) IBOutlet BlockView *blockView;
@property (strong ,nonatomic) IBOutlet BlockView *blockView1;
@property (strong, nonatomic) IBOutlet BlockView *blockView2;
@property (strong, nonatomic) IBOutlet BlockView *blockView3;
@property (strong, nonatomic) IBOutlet BlockView *blockView4;
@property (strong, nonatomic) IBOutlet BlockView *blockView5;
@property (strong, nonatomic) IBOutlet BlockView *blockView6;
@property (strong, nonatomic) IBOutlet BlockView *blockView7;
@property (strong, nonatomic) IBOutlet BlockView *blockView8;
@property (strong, nonatomic) IBOutlet BlockView *blockView9;
@property (strong, nonatomic) IBOutlet BlockView *blockView10;
@property UIDynamicAnimator *dynamicAnimator;
@property UIPushBehavior *pushBehavior;
@property UICollisionBehavior *collisionBehavior;
@property UIDynamicItemBehavior *paddleBehavior;
@property UIDynamicItemBehavior *ballBehavior;
@property UIDynamicItemBehavior *blockBehavior;
@property NSMutableArray *blockArray;
@property NSMutableArray *pAndBArray;
@property NSMutableArray *allViewsArray;
@property NSMutableArray *blockTrackingArray;
@property CGRect blockOneRect;
@property CGRect blockTwoRect;
@property CGRect blockThreeRect;
@property CGRect blockFourRect;
@property CGRect blockFiveRect;
@property CGRect blockSixRect;
@property CGRect blockSevenRect;
@property CGRect blockEightRect;
@property CGRect blockNineRect;
@property CGRect blockTenRect;


@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self blockCGRectHelperEasy];
    [self createdBlocks];

    self.allViewsArray = [NSMutableArray arrayWithObjects:self.paddleView, self.ballView,self.blockView1,
                          self.blockView2,
                          self.blockView3,
                          self.blockView4,
                          self.blockView5,
                          self.blockView6,
                          self.blockView7,
                          self.blockView8,
                          self.blockView9,
                          self.blockView10, nil];

    self.blockArray = [NSMutableArray arrayWithObjects:self.blockView1,
                        self.blockView2,
                        self.blockView3,
                        self.blockView4,
                        self.blockView5,
                        self.blockView6,
                        self.blockView7,
                        self.blockView8,
                        self.blockView9,
                        self.blockView10, nil];
   self.blockTrackingArray = [NSMutableArray arrayWithObjects:self.blockView1, self.blockView2, self.blockView3, self.blockView4, self.blockView5, self.blockView6, self.blockView7, self.blockView8, self.blockView9, self.blockView10, nil];

	self.dynamicAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];

    self.pushBehavior = [[UIPushBehavior alloc] initWithItems:@[self.ballView] mode:UIPushBehaviorModeInstantaneous];
    self.pushBehavior.pushDirection = CGVectorMake(1, 0.4);
    self.pushBehavior.magnitude = 0.2;
    self.pushBehavior.active = YES;
    [self.dynamicAnimator addBehavior:self.pushBehavior];

    self.collisionBehavior = [[UICollisionBehavior alloc] initWithItems:self.allViewsArray];
    [self collisionBehaviorHelper];

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

    self.blockBehavior = [[UIDynamicItemBehavior alloc] initWithItems:self.blockArray];
    [self blockBehaviorHelper];

}

-(IBAction)dragPaddle:(UIPanGestureRecognizer *)gestureRecognizer
{
    self.paddleView.center = CGPointMake([gestureRecognizer locationInView:self.view].x, self.paddleView.center.y);
    [self.dynamicAnimator updateItemUsingCurrentState:self.paddleView];
}

-(void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item withBoundaryIdentifier:(id<NSCopying>)identifier atPoint:(CGPoint)p
{
    if (self.ballView.center.y > 500)
    {

        self.ballView.center = self.view.center;
        self.pushBehavior.pushDirection = CGVectorMake(0, 1);
        self.pushBehavior.magnitude = 0.1;



        [self.dynamicAnimator updateItemUsingCurrentState:self.ballView];
    }
}

-(void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(BallView *)item1 withItem:(BlockView *)item2 atPoint:(CGPoint)p
{

    for (BlockView *blockView in self.blockArray)
    {
        if (blockView == item2)
        {
            [item2 removeFromSuperview];
            [self.collisionBehavior removeItem:item2];
            NSLog(@"block %@", blockView);
            NSLog(@"item %@", item2);
        }

    }
    [self.blockTrackingArray removeObject:item2];
    [self shouldStartAgain];
    [self.dynamicAnimator updateItemUsingCurrentState:item2];
}

-(void)createdBlocks
{
    CGRect bounds1 = self.blockOneRect;
    self.blockView1 = [[BlockView alloc] initWithFrame:bounds1];
    self.blockView1.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.blockView1];

    CGRect bounds2 = self.blockTwoRect;
    self.blockView2 = [[BlockView alloc] initWithFrame:bounds2];
    self.blockView2.backgroundColor = [UIColor greenColor];
    [self.view addSubview:self.blockView2];

    CGRect bounds3 = self.blockThreeRect;
    self.blockView3 = [[BlockView alloc] initWithFrame:bounds3];
    self.blockView3.backgroundColor = [UIColor magentaColor];
    [self.view addSubview:self.blockView3];

    CGRect bounds4 = self.blockFourRect;
    self.blockView4 = [[BlockView alloc] initWithFrame:bounds4];
    self.blockView4.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.blockView4];

    CGRect bounds5 = self.blockFiveRect;
    self.blockView5 = [[BlockView alloc] initWithFrame:bounds5];
    self.blockView5.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:self.blockView5];

    CGRect bounds6 = self.blockSixRect;
    self.blockView6 = [[BlockView alloc] initWithFrame:bounds6];
    self.blockView6.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:self.blockView6];

    CGRect bounds7 = self.blockSevenRect;
    self.blockView7 = [[BlockView alloc] initWithFrame:bounds7];
    self.blockView7.backgroundColor = [UIColor greenColor];
    [self.view addSubview:self.blockView7];

    CGRect bounds8 = self.blockEightRect;
    self.blockView8 = [[BlockView alloc] initWithFrame:bounds8];
    self.blockView8.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.blockView8];

    CGRect bounds9 = self.blockNineRect;
    self.blockView9 = [[BlockView alloc] initWithFrame:bounds9];
    self.blockView9.backgroundColor = [UIColor blueColor];
    [self.view addSubview:self.blockView9];

    CGRect bounds10 = self.blockTenRect;
    self.blockView10 = [[BlockView alloc] initWithFrame:bounds10];
    self.blockView10.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.blockView10];


}

-(void) blockCGRectHelperEasy
{
    self.blockOneRect = CGRectMake(100, 50, 50, 20);
    self.blockTwoRect = CGRectMake(1, 50, 50, 20);
    self.blockThreeRect = CGRectMake(220, 50, 50, 20);
    self.blockFourRect = CGRectMake(160, 50, 50, 20);
    self.blockFiveRect = CGRectMake(280, 50, 50, 20);
    self.blockSixRect = CGRectMake(1, 70, 50, 20);
    self.blockSevenRect = CGRectMake(60, 70, 50, 20);
    self.blockEightRect = CGRectMake(110, 70, 50, 20);
    self.blockNineRect = CGRectMake(170, 70, 50, 20);
    self.blockTenRect = CGRectMake(230, 70, 50, 20);
}

-(void) collisionBehaviorHelper
{
    self.collisionBehavior.collisionMode = UICollisionBehaviorModeEverything;
    self.collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    self.collisionBehavior.collisionDelegate = self;
    [self.dynamicAnimator addBehavior:self.collisionBehavior];
}

-(void) blockBehaviorHelper
{
    self.blockBehavior.allowsRotation = NO;
    self.blockBehavior.density = 5000;
    [self.dynamicAnimator addBehavior:self.blockBehavior];
}

-(BOOL) shouldStartAgain
{


    if (self.blockTrackingArray.count == 0)
    {
        for (BlockView *block in self.blockArray)
        {
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

//-(void) createBlocksHelper
//{
//    for (int y = 40; y < 120; y += 20) {
//        for (int x = 1; x < 280; x += 50) {
//
//        }
//    }
//}


@end
