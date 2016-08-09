//
//  HorizontalWaterfallFlowLayout.m
//  HorizontalWaterfall
//
//  Created by 薛坤龙 on 16/8/9.
//  Copyright © 2016年 sigboat. All rights reserved.
//

#import "HorizontalWaterfallFlowLayout.h"

@interface HorizontalWaterfallFlowLayout ()
{
    // 用于记录每一列布局到的宽度
    NSMutableArray * _widthOfColumns;
    // 用于保存所有item的属性 (frame)
    NSMutableArray * _itemsAttributes;

}

@end

@implementation HorizontalWaterfallFlowLayout

- (void) setNumberOfColumns:(NSInteger)numberOfColumns
{
    if (_numberOfColumns != numberOfColumns)
    {
        _numberOfColumns = numberOfColumns;
        // 让原有布局失效，需要重新布局
        [self invalidateLayout];
    }
}

- (void)setMinimumLineSpacing:(CGFloat)minimumLineSpacing
{
    if (_minimumLineSpacing != minimumLineSpacing)
    {
        _minimumLineSpacing = minimumLineSpacing;
        [self invalidateLayout];
    }
}

- (void)setMinimumInteritemSpacing:(CGFloat)minimumInteritemSpacing
{
    if (_minimumInteritemSpacing != minimumInteritemSpacing)
    {
        _minimumInteritemSpacing = minimumInteritemSpacing;
        [self invalidateLayout];
    }
}

- (void)setSectionInset:(UIEdgeInsets)sectionInset
{
    if (!UIEdgeInsetsEqualToEdgeInsets(_sectionInset, sectionInset))
    {
        _sectionInset = sectionInset;
        [self invalidateLayout];
    }
}

//重写方法 1: 准备布局
-(void)prepareLayout
{
    [super prepareLayout];
    // 真正的布局在这里完成
    if (_itemsAttributes)
    {
        [_itemsAttributes removeAllObjects];
    }else
    {
        _itemsAttributes = [[NSMutableArray alloc] init];
    }
    if (_widthOfColumns)
    {
        [_widthOfColumns removeAllObjects];
    }else
    {
        _widthOfColumns = [[NSMutableArray alloc] init];
    }
    
    for (NSInteger i = 0; i < self.numberOfColumns; i++)
    {
        // 初始化每一列的宽度(默认为上边距)
        //        _heightOfColumns[i] = @(self.sectionInset.top);
        [_widthOfColumns addObject:@(self.sectionInset.left)];
    }
    // item的总数
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    
    //    CGFloat itemWidth = (self.collectionView.frame.size.width - self.sectionInset.left - self.sectionInset.right - (_numberOfColumns-1) * _minimumInteritemSpacing )/_numberOfColumns;
    
    // 总的高度 (集合视图的宽度)
    CGFloat totalHeight = self.collectionView.frame.size.height;
    // 有效的高度 (出去间隔及边界)
    CGFloat validHeight = totalHeight - self.sectionInset.top - self.self.sectionInset.bottom - (self.numberOfColumns-1) * self.minimumInteritemSpacing;
    // 每一个item的高度
    CGFloat itemHeight = validHeight/self.numberOfColumns;
    
    // 设置item的默认宽度
    CGFloat itemWidth = itemHeight;
    for (NSInteger i = 0; i<count; i++)
    {
        // 最短列的下标
        NSInteger index = [self indexOfShortestColumn];
        CGFloat originY = self.sectionInset.top + index * (itemHeight +self.minimumInteritemSpacing);
        CGFloat originX = [_widthOfColumns[index] floatValue];
        // 构造 indexPath
        NSIndexPath * indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        // 动态的获取宽度
        if ([self.delegate respondsToSelector:@selector(WaterfallFlowLayout:widthForItemAtIndexPath:)])
        {
            itemWidth = [self.delegate WaterfallFlowLayout:self widthForItemAtIndexPath:indexPath];
        }
        UICollectionViewLayoutAttributes * attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        
        attr.frame = CGRectMake(originX, originY, itemWidth, itemHeight);
        // 保存 item 的属性 到数组中
        [_itemsAttributes addObject:attr];
        // 更新布局到的一列(最短列) 的高度
        _widthOfColumns[index] = @(originX + itemWidth + self.minimumLineSpacing);
    }
    // 刷新显示
    [self.collectionView reloadData];
}

//重写方法 2: 返回指定区域的item的属性(frame)
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray * array = [NSMutableArray array];
    
    for (UICollectionViewLayoutAttributes * attr in _itemsAttributes)
    {
        // 判断两个矩形是否有交集
        if (CGRectIntersectsRect(attr.frame, rect))
        {
            [array addObject:attr];
        }
    }
    return array;
}

//重写方法 3: 返回内容的尺寸
-(CGSize)collectionViewContentSize
{
    CGFloat height = self.collectionView.frame.size.height;
    NSInteger index = [self indexOfLongestColumn];
    CGFloat width = [_widthOfColumns[index] floatValue] + self.sectionInset.right - self.minimumLineSpacing;
    return CGSizeMake(width, height);
}

- (NSInteger) indexOfLongestColumn
{
    NSInteger index = 0;
    for (NSInteger i = 0; i<_numberOfColumns; i++)
    {
        if ([_widthOfColumns[i] floatValue] > [_widthOfColumns[index] floatValue])
        {
            index = i;
        }
    }
    
    return index;
}

- (NSInteger) indexOfShortestColumn
{
    NSInteger index = 0;
    for (NSInteger i = 0; i<_numberOfColumns; i++)
    {
        if ([_widthOfColumns[i] floatValue] < [_widthOfColumns[index] floatValue])
        {
            index = i;
        }
    }
    
    return index;
}

@end
