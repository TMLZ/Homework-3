//
//  OnlyViewController.m
//  Paper5
//
//  Created by Tyler Miller on 6/23/14.
//  Copyright (c) 2014 Tyler Miller. All rights reserved.
//

#import "OnlyViewController.h"

@interface OnlyViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *headlineImageView;
@property (nonatomic, assign) CGPoint previousPosition;
@property (weak, nonatomic) IBOutlet UIScrollView *newsScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *newsImageView;
@property (weak, nonatomic) IBOutlet UIView *containingView;

@end

@implementation OnlyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Initialize Pan Gesture Recognizer
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onCustomPan:)];
    [self.view addGestureRecognizer:panGestureRecognizer];
    [self.view setUserInteractionEnabled:YES];
    
    // Initialize Scroll View
    [self.newsScrollView setScrollEnabled:YES];
    [self.newsScrollView setContentSize:CGSizeMake(1444, 253)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

    // Pan action
- (void)onCustomPan:(UIPanGestureRecognizer *)panGestureRecognizer {
    CGPoint point = [panGestureRecognizer locationInView:self.view];
    CGPoint velocity = [panGestureRecognizer velocityInView:self.view];
 
    // Calculate offset
    int difference = 0;
    
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        self.previousPosition = point;
    }
    else if (panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        difference = self.previousPosition.y - point.y;
        self.previousPosition = point;
    }
    else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        difference = self.previousPosition.y - point.y;
    }
    
    // Set Offset
    self.containingView.center = CGPointMake(self.containingView.center.x, self.containingView.center.y - difference);
    
    // You hit the ceiling
    if (self.containingView.center.y < 284) {
        
        if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
            
            [UIView animateWithDuration: 2
                                  delay: 0
                 usingSpringWithDamping: .9
                  initialSpringVelocity: 5
                                options: 0
                             animations: ^
             {
                 self.containingView.center = CGPointMake(160, 284);
             }
                             completion: nil
             ];
            
        }
        else if(panGestureRecognizer.state == UIGestureRecognizerStateChanged && self.containingView.center.y < 244) {
            self.containingView.center = CGPointMake(160, 244);
        }
    }

    else if(self.containingView.center.y == 852) {
        self.containingView.center = CGPointMake(160, 812);
    }


    // Resting place
    if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        if (self.containingView.center.y > 300 && velocity.y > 10) {
            [UIView animateWithDuration:.5 animations:^{
                self.containingView.center = CGPointMake(160, 812);
            }];
        }
    
        // Come back up here
        else if(self.containingView.center.y < 800 && velocity.y < -10) {
            [UIView animateWithDuration:.5 animations:^{
                self.containingView.center = CGPointMake(160, 284);
            }];
        }
    }
}

@end
