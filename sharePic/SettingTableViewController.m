//
//  SettingTableViewController.m
//  sharePic
//
//  Created by etta cai on 2017/8/27.
//  Copyright © 2017年 johnqzheng. All rights reserved.
//

#import "SettingTableViewController.h"
#import "CacheSizeLable+Manager.h"

@interface SettingTableViewController ()
@property (weak, nonatomic) IBOutlet CacheSizeLabel *cacheSizeLabel;
@end

@implementation SettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.cacheSizeLabel reloadCacheSize];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        [self.cacheSizeLabel clearCache];
    }
    if (indexPath.section == 1) {
        [self shareLogout];
    }
}

- (void)shareLogout {
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UITabBarController *loginVC = [story instantiateViewControllerWithIdentifier:@"loginVC"];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:loginVC animated:YES completion:nil];
    });
}

@end
