//
//  SplashViewController.h
//  Vamu
//
//  Created by Guilherme Augusto on 16/07/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginService.h"
#import "AppHelper.h"

@interface SplashViewController : UIViewController<UIAlertViewDelegate>

@property (strong, nonatomic) LoginService *loginService;

@end
