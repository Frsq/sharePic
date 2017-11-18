//
//  MeiziTableViewController.m
//  sharePic
//
//  Created by etta cai on 2017/8/26.
//  Copyright © 2017年 johnqzheng. All rights reserved.
//

#import "MeiziViewController.h"
#import "SYNavigationDropdownMenu.h"
#import "MeiziRequest.h"
#import "MeiziCell.h"
#import "Meizi.h"
#import "AppDelegate.h"

@interface MeiziViewController () <UICollectionViewDelegateFlowLayout, SYNavigationDropdownMenuDataSource, SYNavigationDropdownMenuDelegate>

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) MeiziCategory category;
@property (nonatomic, strong) NSMutableArray *meiziArray;

@end

@implementation MeiziViewController

#pragma mark - LifeCycle

//如果使用storyboard或者xib时，使用initWithCorder
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        //一般在前面加“_”表示私有变量，下划线加变量名的话，只是直接设置了变量的值。而通过self来访问的话，是调用了getter和setter方法
        _page = 1;
        _category = MeiziCategoryAll;
    }
    return self;
}

//调用viewDidLoad之前还有一个loadView,新版本之后就自动调用，主要还是因为用了storyboard的缘故
- (void)viewDidLoad {
    NSLog(@"--- %s ---",__func__);//__func__打印方法名
    [super viewDidLoad];
    [self.collectionView.mj_header beginRefreshing];
}

#pragma mark - Orientation method

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    NSLog(@"--- %s ---",__func__);//__func__打印方法名
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [self.collectionView.collectionViewLayout invalidateLayout];
    [self.collectionView.collectionViewLayout finalizeCollectionViewUpdates];
}

//CollectioinView API文档 http://www.cnblogs.com/markstray/p/5677269.html
#pragma mark - CollectionView DataSource
//返回对应section中item的数量
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    NSLog(@"--- %s ---",__func__);//__func__打印方法名
    return 1;
}

//配置UICollectionView的section对应item的数量
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSLog(@"--- %s ---numberOfItemsInSection",__func__);//__func__打印方法名
    collectionView.mj_footer.hidden = self.meiziArray.count == 0;
    return self.meiziArray.count;
}

//设置具体indexPath的item大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"--- %s ---sizeForItemAtIndexPath",__func__);//__func__打印方法名
    CGFloat screeWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
    NSInteger perLine = ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait)?3:5;
    return CGSizeMake(screeWidth/perLine-1, screeWidth/perLine-1);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"--- %s ---cellForItemAtIndexPath",__func__);//__func__打印方法名
    MeiziCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MeiziCell" forIndexPath:indexPath];
    [cell setRosi:self.meiziArray[indexPath.row]];
    return cell;
}

#pragma mark - CollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"--- %s ---didSelectItemAtIndexPath",__func__);//__func__打印方法名
    NSMutableArray *photoURLArray = [NSMutableArray array];
    for (Meizi *rosi in self.meiziArray) {
        [photoURLArray addObject:rosi.image_url];
    }
    SYPhotoBrowser *photoBrowser = [[SYPhotoBrowser alloc] initWithImageSourceArray:photoURLArray caption:nil delegate:self];
    photoBrowser.enableStatusBarHidden = NO;
    photoBrowser.pageControlStyle = SYPhotoBrowserPageControlStyleLabel;
    photoBrowser.initialPageIndex = indexPath.item;
//    [((AppDelegate *)[UIApplication sharedApplication].delegate).window.rootViewController presentViewController:photoBrowser animated:YES completion:nil];
    [self presentViewController:photoBrowser animated:YES completion:nil];
    
}

//这里添加一个长按显示菜单键
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"--- %s ---shouldShowMenuForItemAtIndexPath",__func__);//__func__打印方法名
    return YES;
}

// 使copy和paste有效
- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender {
    NSLog(@"--- %s ---canPerformAction",__func__);//__func__打印方法名
    if ([NSStringFromSelector(action) isEqualToString:@"copy:"] || [NSStringFromSelector(action) isEqualToString:@"paste:"])
    {
        return YES;
    }
    
    return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender {
    NSLog(@"--- %s ---performAction",__func__);//__func__打印方法名
    if([NSStringFromSelector(action) isEqualToString:@"copy:"])
    {
        NSLog(@"-------------执行拷贝-------------");
        [self.collectionView performBatchUpdates:^{
            [self.meiziArray removeObjectAtIndex:indexPath.row];
            [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
        } completion:nil];
    }
    else if([NSStringFromSelector(action) isEqualToString:@"paste:"])
    {
        NSLog(@"-------------执行粘贴-------------");
    }
}

#pragma mark - NavigationDropdownMenu DataSource

- (NSArray<NSString *> *)titleArrayForNavigationDropdownMenu:(SYNavigationDropdownMenu *)navigationDropdownMenu {
    NSLog(@"--- %s ---",__func__);//__func__打印方法名
    return @[@"所有", @"大胸", @"翘臀", @"黑丝", @"美腿", @"清新", @"杂烩"];
}

- (UIImage *)arrowImageForNavigationDropdownMenu:(SYNavigationDropdownMenu *)navigationDropdownMenu {
    NSLog(@"--- %s ---",__func__);//__func__打印方法名
    return [UIImage imageNamed:@"Arrow"];
}

- (CGFloat)arrowPaddingForNavigationDropdownMenu:(SYNavigationDropdownMenu *)navigationDropdownMenu {
    NSLog(@"--- %s ---",__func__);//__func__打印方法名
    return 8.0;
}

- (BOOL)keepCellSelectionForNavigationDropdownMenu:(SYNavigationDropdownMenu *)navigationDropdownMenu {
    NSLog(@"--- %s ---",__func__);//__func__打印方法名
    return NO;
}

#pragma mark - NavigationDropdownMenu Delegate

- (void)navigationDropdownMenu:(SYNavigationDropdownMenu *)navigationDropdownMenu didSelectTitleAtIndex:(NSUInteger)index {
    NSLog(@"--- %s ---",__func__);//__func__打印方法名
    self.category = index;
    [self.collectionView.mj_header beginRefreshing];
}

#pragma mark - Refresh method

- (void)refreshMeizi {
    NSLog(@"--- %s ---",__func__);//__func__打印方法名
    self.page = 1;
    [MeiziRequest requestWithPage:self.page category:self.category success:^(NSArray<Meizi *> *meiziArray) {
        [self.collectionView.mj_header endRefreshing];
        [self reloadDataWithMeiziArray:meiziArray emptyBeforeReload:YES];
    } failure:^(NSString *message) {
        [SVProgressHUD showErrorWithStatus:message];
        [self.collectionView.mj_header endRefreshing];
    }];
}

- (void)loadMoreMeizi {
    NSLog(@"--- %s ---",__func__);//__func__打印方法名
    [MeiziRequest requestWithPage:self.page+1 category:self.category success:^(NSArray<Meizi *> *meiziArray) {
        [self.collectionView.mj_footer endRefreshing];
        [self reloadDataWithMeiziArray:meiziArray emptyBeforeReload:NO];
    } failure:^(NSString *message) {
        [SVProgressHUD showErrorWithStatus:message];
        [self.collectionView.mj_footer endRefreshing];
    }];
}

- (void)reloadDataWithMeiziArray:(NSArray<Meizi *> *)meiziArray emptyBeforeReload:(BOOL)emptyBeforeReload {
    NSLog(@"--- %s ---",__func__);//__func__打印方法名
    if (emptyBeforeReload) {
        self.page = 1;
        [self.meiziArray removeAllObjects];
        [self.meiziArray addObjectsFromArray:meiziArray];
        [self.collectionView.mj_footer resetNoMoreData];
    } else {
        if (meiziArray.count) {
            [self.meiziArray addObjectsFromArray:meiziArray];
            self.page++;
        } else {
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        }
    }
    [self.collectionView reloadData];
}

#pragma mark - Property method

- (UINavigationItem *)navigationItem {
    NSLog(@"--- %s ---",__func__);//__func__打印方法名
    UINavigationItem *navigationItem = [super navigationItem];
    if (navigationItem.titleView == nil) {
        SYNavigationDropdownMenu *dropdownMenu = [[SYNavigationDropdownMenu alloc] initWithNavigationController:self.navigationController];
        dropdownMenu.dataSource = self;
        dropdownMenu.delegate = self;
        navigationItem.titleView = dropdownMenu;
    }
    return navigationItem;
}

- (UICollectionView *)collectionView {
    NSLog(@"--- %s ---",__func__);//__func__打印方法名
    UICollectionView *collectionView = [super collectionView];
    if (collectionView.mj_header == nil) {
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshMeizi)];
        header.automaticallyChangeAlpha = YES;
        collectionView.mj_header = header;
    }
    if (collectionView.mj_footer == nil) {
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreMeizi)];
        footer.automaticallyRefresh = YES;
        collectionView.mj_footer = footer;
    }
    return collectionView;
}

- (NSMutableArray *)meiziArray {
    NSLog(@"--- %s ---meiziArray",__func__);//__func__打印方法名
    if (_meiziArray == nil) {
        _meiziArray = [NSMutableArray arrayWithArray:[MeiziRequest cachedMeiziArrayWithCategory:MeiziCategoryAll]];
    }
    return _meiziArray;
}

- (void)setCategory:(MeiziCategory)category {
    NSLog(@"--- %s ---",__func__);//__func__打印方法名
    _category = category;
    [self.meiziArray removeAllObjects];
    [self.meiziArray addObjectsFromArray:[MeiziRequest cachedMeiziArrayWithCategory:category]];
    [self.collectionView reloadData];
}

@end
