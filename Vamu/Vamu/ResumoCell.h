//
//  ResumoCell.h
//  Vamu
//
//  Created by Guilherme Augusto on 15/07/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResumoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgCarona;
@property (weak, nonatomic) IBOutlet UILabel *lblNomeCarona;
@property (weak, nonatomic) IBOutlet UILabel *lblHoraViagem;
@property (weak, nonatomic) IBOutlet UILabel *lblDistanciaPercorrida;

@end
