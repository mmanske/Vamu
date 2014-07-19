//
//  ReceberAvisoViewController.h
//  Vamu
//
//  Created by Guilherme Augusto on 19/07/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReceberAvisoViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tabela;

@end
