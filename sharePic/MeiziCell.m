//
//  RosiCell.m
//  sharePic
//
//  Created by etta cai on 2017/8/28.
//  Copyright © 2017年 johnqzheng. All rights reserved.
//

#import "MeiziCell.h"
#import "Meizi.h"

@interface MeiziCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation MeiziCell

#pragma mark - Public method

- (void)setRosi:(Meizi *)rosi {
    NSURL *imageURL = [NSURL URLWithString:rosi.thumb_url];
    [self.imageView setImageWithURL:imageURL usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
}

@end
