//
//  testFlowLayoutWithAnimations.h
//  testCollectionView
//
//  Created by 沈 晨豪 on 15/4/7.
//  Copyright (c) 2015年 sch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface testFlowLayoutWithAnimations : UICollectionViewFlowLayout
- (void)resizeItemAtIndexPath:(NSIndexPath*)indexPath withPinchDistance:(CGFloat)distance;
- (void)resetPinchedItem;

@end
