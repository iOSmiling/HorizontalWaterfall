//
//  ViewController.m
//  HorizontalWaterfall
//
//  Created by 薛坤龙 on 16/8/9.
//  Copyright © 2016年 sigboat. All rights reserved.
//

#import "ViewController.h"
#import "HorizontalWaterfallFlowLayout.h"

@interface ViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,HorizontalWaterfallFlowLayoutDelegate>
{
    UICollectionView * _collectionView;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // 创建集合视图
    [self createCollectionView];
}

- (UICollectionViewLayout *)createLayout
{
#if 1
    HorizontalWaterfallFlowLayout * layout = [[HorizontalWaterfallFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 20;
    layout.numberOfColumns = 3;
    layout.delegate = self;
    [self performSelector:@selector(changeLayout:) withObject:layout afterDelay:3];
    
#else
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 10;
    layout.itemSize = CGSizeMake(150, 100);
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
#endif
    
    return layout;
}

- (void)changeLayout:(HorizontalWaterfallFlowLayout *)layout
{
    layout.numberOfColumns = 3;
}

- (void)createCollectionView
{
    CGRect frame = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height-20);
    _collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:[self createLayout]];
    
    _collectionView.backgroundColor = [UIColor cyanColor];
    // 设置代理
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    // 注册cell 类型 及 复用标识
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellId"];
    
    
    [self.view addSubview:_collectionView];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 102;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    
    UILabel * label = nil;
    NSArray * array = cell.contentView.subviews;
    if (array.count)
    {
        label = array[0];
    }else
    {
        label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:50];
        [cell.contentView addSubview:label];
    }
    label.frame = cell.bounds;
    label.text = [NSString stringWithFormat:@"%ld",indexPath.item];
    label.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];;
    
    return cell;
}

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake( arc4random()%100+200, 110);
}

-(CGFloat) WaterfallFlowLayout:(HorizontalWaterfallFlowLayout *)layout widthForItemAtIndexPath:(NSIndexPath *)indexPath{
    return arc4random()%150+50;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击了第 %ld 组，第 %ld 行",indexPath.section,indexPath.row);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
