//
//  ViewController.m
//  testCollectionView
//
//  Created by 沈 晨豪 on 15/4/7.
//  Copyright (c) 2015年 sch. All rights reserved.
//

#import "ViewController.h"
#import "testFlowLayoutWithAnimations.h"
@interface ViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic,weak) IBOutlet UICollectionView *testCollectionView;

@property (nonatomic)        NSInteger       sectionCount;
@property (nonatomic,strong) NSMutableArray *itemArray;
@property (nonatomic,strong) testFlowLayoutWithAnimations *smallLayout;
@property (nonatomic,strong) testFlowLayoutWithAnimations *largeLayout;
@property (nonatomic)        NSInteger       selectedItem;
@property (nonatomic, strong) UIPinchGestureRecognizer *pincher;
@property (nonatomic) BOOL largeItems;
@end

@implementation ViewController

#pragma mark - 
#pragma mark - view life

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _sectionCount = 3;
    
    self.itemArray = [NSMutableArray arrayWithArray:@[@(2), @(5), @(2)]];
    
    self.smallLayout = [testFlowLayoutWithAnimations new];
    self.largeLayout = [testFlowLayoutWithAnimations new];
    
    _smallLayout.itemSize = CGSizeMake(50, 50);
    _largeLayout.itemSize = CGSizeMake(160, 160);
    
    
    _testCollectionView.collectionViewLayout = _smallLayout;
    
    UIBarButtonItem *insertItem = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                   target:self
                                   action:@selector(insertItem)];
    
    UIBarButtonItem *deleteItem = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemTrash
                                   target:self
                                   action:@selector(deleteItem)];
    
    UIBarButtonItem *toggleSizeItem = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemSearch
                                       target:self
                                       action:@selector(toggleItemSize)];
    
    self.navigationItem.rightBarButtonItems = @[toggleSizeItem, insertItem, deleteItem];
    
    self.pincher = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    self.largeItems = YES;
    [_testCollectionView addGestureRecognizer:_pincher];
    
    
    [_testCollectionView registerNib:[UINib nibWithNibName:@"testCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"testCollectionReusableView"];
}


- (void)handlePinch:(UIPinchGestureRecognizer *)sender {
    if ([sender numberOfTouches] != 2)
        return;
    
    
    if (sender.state == UIGestureRecognizerStateBegan ||
        sender.state == UIGestureRecognizerStateChanged) {
        // Get the pinch points.
        CGPoint p1 = [sender locationOfTouch:0 inView:[self testCollectionView]];
        CGPoint p2 = [sender locationOfTouch:1 inView:[self testCollectionView]];
        
        // Compute the new spread distance.
        CGFloat xd = p1.x - p2.x;
        CGFloat yd = p1.y - p2.y;
        CGFloat distance = sqrt(xd*xd + yd*yd);
        
        // Update the custom layout parameter and invalidate.
        testFlowLayoutWithAnimations* layout = (testFlowLayoutWithAnimations*)[[self testCollectionView] collectionViewLayout];
        
        NSIndexPath *pinchedItem = [self.testCollectionView indexPathForItemAtPoint:CGPointMake(0.5*(p1.x+p2.x), 0.5*(p1.y+p2.y))];
        [layout resizeItemAtIndexPath:pinchedItem withPinchDistance:distance];
        [layout invalidateLayout];
        
    }
    else if (sender.state == UIGestureRecognizerStateCancelled ||
             sender.state == UIGestureRecognizerStateEnded){
        testFlowLayoutWithAnimations* layout = (testFlowLayoutWithAnimations*)[[self testCollectionView] collectionViewLayout];
        [self.testCollectionView
         performBatchUpdates:^{
             [layout resetPinchedItem];
         }
         completion:nil];
    }
}

- (void)insertItem
{
    NSInteger randomSection = arc4random_uniform((int)_sectionCount);
    
    NSInteger item = [_itemArray[randomSection] integerValue] + 1;
    _itemArray[randomSection] = @(item);
    
    [self.testCollectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:arc4random_uniform((int)item) inSection:randomSection]]];
}

- (void)deleteItem
{
    NSInteger randomSection = arc4random_uniform((int)_sectionCount);
    NSInteger item = [_itemArray[randomSection] integerValue];
    
    if (item) {
        _itemArray[randomSection] = @(item-1);
        [self.testCollectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:arc4random_uniform((int)item) inSection:randomSection]]];
    }
    else {
        NSInteger totalItems = 0;
        for (NSNumber *num in _itemArray)
        {
            totalItems += [num integerValue];
        }
        if (totalItems) {
            [self deleteItem];
        }
        
    }
    
}

- (void)toggleItemSize
{
    
    if (_largeItems) {
        _largeItems = NO;
        [self.testCollectionView setCollectionViewLayout:_smallLayout animated:YES];
    }
    else {
        [self.testCollectionView setCollectionViewLayout:_largeLayout animated:YES];
        _largeItems = YES;
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 
#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _sectionCount;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    static NSString *sectionIndentifier = @"testCollectionReusableView";
    UICollectionReusableView *v = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:sectionIndentifier forIndexPath:indexPath];
    v.backgroundColor = [UIColor grayColor];
    return v;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_itemArray[section] integerValue];
}



- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SimpleCell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSInteger itemCount = [self collectionView:collectionView numberOfItemsInSection:indexPath.section];
    CGFloat colorValue = 1.0-(indexPath.item+1.0)/(2*itemCount);
    
    cell.backgroundColor = [UIColor colorWithRed:(indexPath.section==0)?colorValue:0.0
                                           green:(indexPath.section==1)?colorValue:0.0
                                            blue:(indexPath.section==2)?colorValue:0.0
                                           alpha:1.0];
    
    return cell;
}



- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(320.0f, 20.0f);
}

#pragma mark -
#pragma mark - UICollectionViewDelegate



#pragma mark -
#pragma mark - dealloc 

- (void)dealloc
{
    
}

@end



























































