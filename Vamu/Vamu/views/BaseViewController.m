//
//  BaseViewController.m
//  Vamu
//
//  Created by Guilherme Augusto on 11/03/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

@synthesize exibirNavigationBar;

-(void)viewWillAppear:(BOOL)animated{
//    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.4 green:0.667 blue:0.267 alpha:1.0]];
    self.navigationController.navigationBarHidden = !exibirNavigationBar;
    
//    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
//                                    [UIColor whiteColor],NSForegroundColorAttributeName,
//                                    [UIColor whiteColor],NSBackgroundColorAttributeName,nil];
    
//    self.navigationController.navigationBar.titleTextAttributes = textAttributes;
    
//    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.backItem.title = @" ";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
