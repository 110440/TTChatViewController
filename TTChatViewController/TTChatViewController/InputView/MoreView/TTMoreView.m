//
//  TTMoreView.m
//  TTChatViewController
//
//  Created by tanson on 2017/1/17.
//  Copyright © 2017年 chatchat. All rights reserved.
//

#import "TTMoreView.h"
#import "TTMoreViewPageCell.h"

@interface TTMoreView ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageCtl;
@property (strong ,nonatomic) NSArray * data;

@end

@implementation TTMoreView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"TTMoreViewPageCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    
    _data = [self prePageData:[self moreData]];
    _pageCtl.numberOfPages = _data.count;
    _pageCtl.currentPage = 0;
    [self.collectionView reloadData];
}

-(NSArray*) moreData{
    TTMoreViewCellModel * photo = [TTMoreViewCellModel new];
    photo.title = @"相册";
    photo.iconName = @"chat_more_pic";
    TTMoreViewCellModel * camera = [TTMoreViewCellModel new];
    camera.title = @"拍摄";
    camera.iconName = @"chat_more_video";
    TTMoreViewCellModel * video = [TTMoreViewCellModel new];
    video.title = @"视频聊天";
    video.iconName = @"chat_more_videovoip";
    TTMoreViewCellModel * location = [TTMoreViewCellModel new];
    location.title = @"位置";
    location.iconName = @"chat_more_location";
    return @[photo,camera,video,location];
}

-(void)reloadData{
    [self.collectionView reloadData];
}

-(NSArray*)prePageData:(NSArray*)data{
    NSMutableArray * allData = @[].mutableCopy;
    __block NSMutableArray * pageData = @[].mutableCopy;
    int numPerPage = moreViewColNum * moreViewRowNum;
    [data enumerateObjectsUsingBlock:^(id  obj, NSUInteger idx, BOOL * stop) {
        if(idx !=0 && idx % numPerPage == 0 ){
            [allData addObject:pageData];
            pageData = @[].mutableCopy;
        }
        [pageData addObject:obj];
    }];
    [allData addObject:pageData];
    return allData;
}

#pragma mark- collection deleage
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger count = self.data.count;
    return count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TTMoreViewPageCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell configCellWithData:self.data[indexPath.row]];
    cell.itemTapBlock = ^(NSString *title){
        self.itemTapBlock? self.itemTapBlock(title):nil;
    };
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize size = collectionView.bounds.size;
    return size;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsZero;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger willToIndex = round(scrollView.contentOffset.x / scrollView.bounds.size.width);
    self.pageCtl.currentPage = willToIndex;
}

@end

@implementation TTMoreViewCellModel

@end
