//
//  ImageViewerPresentTransition.m
//  ChatViewController
//
//  Created by tanson on 16/8/25.
//  Copyright © 2016年 QDYongGong. All rights reserved.
//

#import "ImageViewerPresentTransition.h"
#import "ImageViewerController.h"
#import "ImageViewerItem.h"
#import "ImageViewerCell.h"

@implementation ImageViewerPresentTransition

-(instancetype)initWithDuration:(NSTimeInterval)d{
    if([super init]){
        self.duration = d;
    }
    return self;
}

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return self.duration;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    UIView * container = [transitionContext containerView];
    ImageViewerController * toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    // toView
    toViewController.view.frame = [UIScreen mainScreen].bounds;
    [container addSubview:toViewController.view];
    
    NSIndexPath * curCellIndexPath = toViewController.curCellIndexPath;
    ImageViewerItem * viewerItem = toViewController.imageItems[curCellIndexPath.row];
    UIImageView * desSnapshotView = viewerItem.thumbImageView;
    
    // snapshotView
    CGRect snapshotFrame = [container convertRect:desSnapshotView.frame fromView:desSnapshotView.superview];
    UIImageView * snapshotView = [UIImageView new];
    snapshotView.image = desSnapshotView.image;
    snapshotView.contentMode = desSnapshotView.contentMode;
    snapshotView.frame = snapshotFrame;
    snapshotView.clipsToBounds = desSnapshotView.clipsToBounds;
    [container addSubview:snapshotView];
    
    //tempView for frame
    CGRect rect = [UIScreen mainScreen].bounds;
    ImageViewerCell * tempView = [[ImageViewerCell alloc] initWithFrame:CGRectMake(0, 0, rect.size.width+imagePageSpace*2, rect.size.height)];
    
    tempView.scrollView.imageViewContentMode = toViewController.imageViewContentMode;
    [tempView.scrollView setImage:snapshotView.image size:CGSizeMake(0, 0)];
    
    //动画
    toViewController.view.alpha = 0;
    toViewController.collectionView.hidden = YES;
    
    [UIView animateWithDuration:self.duration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        toViewController.view.alpha = 1;
        snapshotView.frame = tempView.scrollView.imageView.frame;
    } completion:^(BOOL finished) {
        toViewController.collectionView.hidden = NO;
        [snapshotView removeFromSuperview];
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        
    }];
}

@end
