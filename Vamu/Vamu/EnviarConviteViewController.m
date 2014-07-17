//
//  EnviarConviteViewController.m
//  Vamu
//
//  Created by Guilherme Augusto on 16/07/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import "EnviarConviteViewController.h"

@interface EnviarConviteViewController ()

@property (strong, nonatomic) NSMutableArray *grupos;

@end

@implementation EnviarConviteViewController

@synthesize edtEmail, tabela, grupos;

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)btnCancelarClick:(id)sender {
}

- (IBAction)btnEnviarClick:(id)sender {
}

#pragma mark - UITableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [grupos count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    
    return cell;
}

@end
