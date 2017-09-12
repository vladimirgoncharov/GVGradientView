//
//  GVViewController.m
//  Project
//
//  Created by admin on 25.02.14.
//  Copyright (c) 2014 Goncharov Vladimir. All rights reserved.
//

#import "GVViewController.h"

#import "GVGradientView.h"

@interface GVViewController ()

@property (weak, nonatomic) IBOutlet GVGradientView *gradientView;

@end

@implementation GVViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.gradientView setDirection:GVGradientDirectionVertical
                               animated:YES
                               finished:nil];
        [self.gradientView setColors:@[[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0f],
                                       [UIColor colorWithRed:1.0f green:180/255.0f blue:0.0f alpha:1.0f]]
                            animated:YES
                            finished:nil];
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
