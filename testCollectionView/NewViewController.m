//
//  NewViewController.m
//  testCollectionView
//
//  Created by 沈 晨豪 on 15/4/7.
//  Copyright (c) 2015年 sch. All rights reserved.
//

#import "NewViewController.h"

@interface NewViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic,weak) IBOutlet UICollectionView *testCollectionView;

@end

@implementation NewViewController

#pragma mark -
#pragma mark - view life

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - dealloc

- (void)dealloc
{
    
}

@end
