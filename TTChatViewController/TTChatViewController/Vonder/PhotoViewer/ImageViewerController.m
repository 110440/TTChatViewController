//
//  ImageViewerController.m
//  ChatViewController
//
//  Created by tanson on 16/8/25.
//  Copyright © 2016年 QDYongGong. All rights reserved.
//

//TODO:检查泻漏

#import "ImageViewerController.h"
#import "ImageViewerItem.h"
#import "ImageViewerPresentTransition.h"
#import "ImageViewerDismissTransition.h"

@interface ImageViewerController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIViewControllerTransitioningDelegate>

@end

@implementation ImageViewerController

-(UICollectionView *)collectionView{
    
    if(!_collectionView){
        
        CGSize size = self.view.bounds.size;
        CGRect frame = CGRectMake(-imagePageSpace, 0, size.width + imagePageSpace*2, size.height);
        
        UICollectionViewFlowLayout * layout = [UICollectionViewFlowLayout new];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 0;
        layout.itemSize = CGSizeMake(frame.size.width, frame.size.height);
        
        _collectionView= [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
        _collectionView.pagingEnabled = true;
        [_collectionView registerClass:[ImageViewerCell class] forCellWithReuseIdentifier:@"cell"];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
    }
    return _collectionView;
}

-(CGFloat)pageWidth {
    return self.collectionView.frame.size.width;
}
-(CGFloat)pageHeight{
    return self.collectionView.frame.size.height;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.collectionView];
    
    self.view.backgroundColor = [UIColor blackColor];
    self.collectionView.contentOffset = CGPointMake([self pageWidth] * self.curCellIndexPath.row, 0);
    [self.collectionView reloadData];
    
}

-(instancetype) initWithItmes:(NSArray*)items showIndex:(NSInteger)index{
    if([super init]){
        self.imageItems = items;
        self.curCellIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
        self.transitioningDelegate = self;
    }
    return self;
}

#pragma mark - delegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imageItems.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ImageViewerCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    ImageViewerItem * item = self.imageItems[indexPath.row];
    [cell setImageCellItem:item];
    cell.cellClickBlock = ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    return cell;
}

//MARK: UIViewControllerTransitioningDelegate
-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    return [[ImageViewerPresentTransition alloc]initWithDuration:0.25];
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    return [[ImageViewerDismissTransition alloc] initWithDuration:0.25];
}

//
//func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
//    let x = scrollView.contentOffset.x
//    let page = x / scrollView.bounds.size.width
//    self.pageCtl.currentPage = Int(page)
//}

@end
