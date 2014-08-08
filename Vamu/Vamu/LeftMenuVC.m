//
//  LeftMenuVC.m
//  Vamu
//
//  Created by Guilherme Augusto on 10/05/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import "LeftMenuVC.h"
#import "AppHelper.h"
#import "LogoutService.h"

@interface LeftMenuVC ()

@end

@implementation LeftMenuVC

@synthesize imgParticipante, lblNomeParticipante, participanteLogado;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg-menu_4.png"]]];
    
    participanteLogado = [AppHelper getParticipanteLogado];
    
    imgParticipante.layer.cornerRadius = imgParticipante.bounds.size.width/2;
    imgParticipante.layer.masksToBounds = YES;
    imgParticipante.layer.borderWidth = 2;
    imgParticipante.layer.borderColor = [UIColor whiteColor].CGColor;
    imgParticipante.layer.backgroundColor = [UIColor colorWithWhite:1 alpha:0.2].CGColor;
    
    lblNomeParticipante.text = participanteLogado.nome;
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg", participanteLogado.cpf];
    NSString *imageFileName = [AppHelper getAbsolutePathForImageFile:fileName];
    imgParticipante.image = [UIImage imageWithContentsOfFile:imageFileName];
}


- (IBAction)btnSairClick:(id)sender {
    LogoutService *service = [LogoutService new];
    [service logout:participanteLogado.cpf];

    [AppHelper apagarUsuarioLogado];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

@end
