//
//  HorizontalWaterfallFlowLayout.h
//  HorizontalWaterfall
//
//  Created by 薛坤龙 on 16/8/9.
//  Copyright © 2016年 sigboat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class HorizontalWaterfallFlowLayout;
@protocol HorizontalWaterfallFlowLayoutDelegate <NSObject>

// 动态获取 item 宽度
- (CGFloat) WaterfallFlowLayout:(HorizontalWaterfallFlowLayout *) layout widthForItemAtIndexPath:(NSIndexPath *) indexPath;

@end

@interface HorizontalWaterfallFlowLayout : UICollectionViewLayout

@property (nonatomic,assign) id <HorizontalWaterfallFlowLayoutDelegate> delegate;

@property (nonatomic) NSInteger numberOfColumns;
@property (nonatomic) CGFloat minimumLineSpacing;
@property (nonatomic) CGFloat minimumInteritemSpacing;
@property (nonatomic) UIEdgeInsets sectionInset;

@end
