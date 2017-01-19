//
//  ImageViewerDismissTransition.m
//  ChatViewController
//
//  Created by tanson on 16/8/25.
//  Copyright © 2016年 QDYongGong. All rights reserved.
//

#import "ImageViewerDismissTransition.h"
#import "ImageViewerController.h"
#import "ImageViewerItem.h"
#import "ImageViewerCell.h"

@implementation ImageViewerDismissTransition

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
    
    UIViewController * toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
    [container addSubview:toViewController.view];
    
    ImageViewerController * fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    [container addSubview:fromViewController.view];
    
    NSIndexPath * curCellIndexPath = fromViewController.curCellIndexPath;
    ImageViewerItem * viewerItem = fromViewController.imageItems[curCellIndexPath.row];
    UIImageView * desSnapshotView = viewerItem.thumbImageView;
    
    ImageViewerCell * imageCell = (ImageViewerCell*)[fromViewController.collectionView cellForItemAtIndexPath:curCellIndexPath];
    imageCell.scrollView.imageView.clipsToBounds = desSnapshotView.clipsToBounds;
    //imageCell.scrollView.imageView.contentMode = desSnapshotView.contentMode;
    
    CGRect frame = [imageCell.scrollView convertRect:desSnapshotView.frame fromView:desSnapshotView.superview];
    
    [UIView animateWithDuration:self.duration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        fromViewController.view.backgroundColor = [UIColor clearColor];
        imageCell.scrollView.imageView.frame = frame;
    } completion:^(BOOL finished) {
        [fromViewController.view removeFromSuperview];
        [transitionContext completeTransition:YES];
        
    }];
    
}

@end
