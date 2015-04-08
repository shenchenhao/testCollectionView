//
//  testFlowLayoutWithAnimations.m
//  testCollectionView
//
//  Created by 沈 晨豪 on 15/4/7.
//  Copyright (c) 2015年 sch. All rights reserved.
//

#import "testFlowLayoutWithAnimations.h"

@implementation testFlowLayoutWithAnimations
{
    CGSize          _previousSize;        //之前的尺寸
    NSMutableArray *_indexPathsToAnimate; //需要做动画的item
    NSIndexPath    *_pinchedItem;
    CGSize          _pinchedItemSize;
}


- (void)commonInit
{
    self.itemSize           = CGSizeMake(40,40);
    self.minimumLineSpacing = 16.0f;
    self.sectionInset       = UIEdgeInsetsMake(8,
                                               8,
                                               8,
                                               8);
    
}

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        [self commonInit];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        [self commonInit];
    }
    
    return self;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *attrs = [super layoutAttributesForElementsInRect:rect];
    
    if (_pinchedItem)
    {
        UICollectionViewLayoutAttributes *attr = [[attrs filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"indexPath == %@", _pinchedItem]] firstObject];
        
        attr.size   = _pinchedItemSize;
        attr.zIndex = 100;
    }
    
    
    return attrs;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    /*显示*/
    UICollectionViewLayoutAttributes *attr = [super layoutAttributesForItemAtIndexPath:indexPath];
    
    if ([indexPath isEqual:_pinchedItem])
    {
        attr.size   = _pinchedItemSize;
        attr.zIndex = 100;
    }
    return attr;
}

- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    NSLog(@"出现");

    UICollectionViewLayoutAttributes *attr = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
    
    if ([_indexPathsToAnimate containsObject:itemIndexPath])
    {
        attr.transform = CGAffineTransformRotate(CGAffineTransformMakeScale(0.2, 0.2), M_PI);
        attr.center = CGPointMake(CGRectGetMidX(self.collectionView.bounds), CGRectGetMaxY(self.collectionView.bounds));
        
        [_indexPathsToAnimate removeObject:itemIndexPath];
    }
    
    return attr;
}

- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    NSLog(@"消失");

    UICollectionViewLayoutAttributes *attr = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
    
    if ([_indexPathsToAnimate containsObject:itemIndexPath])
    {
        attr.transform = CGAffineTransformRotate(CGAffineTransformMakeScale(3.1, 3.1), 0);
        attr.alpha = 0.2f;
        [_indexPathsToAnimate removeObject:itemIndexPath];
    }
    else{
        attr.alpha = 1.0;
    }
    

    return attr;
}

- (void)prepareLayout
{
    [super prepareLayout];
    
    NSLog(@"准备 prepareLayout");
    _previousSize = self.collectionView.bounds.size;
}

- (void)prepareForCollectionViewUpdates:(NSArray *)updateItems
{
    NSLog(@"更新 collection");
    
    [super prepareForCollectionViewUpdates:updateItems];
    
    NSMutableArray *indexPathArray = [@[] mutableCopy];
    
    for (UICollectionViewUpdateItem *updateItem in updateItems)
    {
        switch (updateItem.updateAction) {
            case UICollectionUpdateActionInsert:
                [indexPathArray addObject:updateItem.indexPathAfterUpdate];
                break;
            case UICollectionUpdateActionDelete:
                [indexPathArray addObject:updateItem.indexPathBeforeUpdate];
                break;
            case UICollectionUpdateActionMove:
                [indexPathArray addObject:updateItem.indexPathBeforeUpdate];
                [indexPathArray addObject:updateItem.indexPathAfterUpdate];
                break;
            default:
                NSLog(@"unhandled case: %@", updateItem);
                break;
        }
    }
    
    _indexPathsToAnimate = indexPathArray;
}

- (void)finalizeCollectionViewUpdates
{
    NSLog(@"-- finalizeCollectionViewUpdates");
    [super finalizeCollectionViewUpdates];
    _indexPathsToAnimate = nil;
}

- (void)prepareForAnimatedBoundsChange:(CGRect)oldBounds
{
    NSLog(@"--prepareForAnimatedBoundsChange");
    [super prepareForAnimatedBoundsChange:oldBounds];
}

- (void)finalizeAnimatedBoundsChange
{
    NSLog(@"--finalizeAnimatedBoundsChange");
    [super finalizeAnimatedBoundsChange];
}


#pragma mark -
#pragma mark - public 

- (void)resizeItemAtIndexPath:(NSIndexPath*)indexPath withPinchDistance:(CGFloat)distance
{
    _pinchedItem = indexPath;
    _pinchedItemSize = CGSizeMake(distance, distance);
    
}

- (void)resetPinchedItem
{
    _pinchedItem = nil;
    _pinchedItemSize = CGSizeZero;
}



@end













































