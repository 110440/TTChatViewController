//
//  TTMoreViewPageCell.m
//  TTChatViewController
//
//  Created by tanson on 2017/1/17.
//  Copyright © 2017年 chatchat. All rights reserved.
//

#import "TTMoreViewPageCell.h"
#import "TTMoreViewCell.h"
#import "TTMoreView.h"

#define colSpace 35
#define lineSpace 20
#define hMargin 35
#define vMargin 15

@interface TTMoreViewPageCell ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic,strong) NSArray * data;
@end

@implementation TTMoreViewPageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"TTMoreViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
}


-(void)configCellWithData:(NSArray *)data{
    self.data = data;
    [self.collectionView reloadData];
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
    TTMoreViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    TTMoreViewCellModel * model = self.data[indexPath.row];
    UIImage * image = [[UIImage imageNamed:model.iconName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [cell configCell:image title:model.title];
    
    cell.itemTapBlock = ^ (NSString * title){
        self.itemTapBlock? self.itemTapBlock(title):nil;
    };
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize size = collectionView.bounds.size;
    CGFloat w = (size.width - (hMargin * 2) - (moreViewColNum - 1) * colSpace)/moreViewColNum;
    CGFloat h = (size.height - (vMargin * 2) - (moreViewRowNum -1) * lineSpace)/moreViewRowNum;
    return  CGSizeMake(w, h);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return lineSpace;
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return colSpace;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(vMargin, hMargin, vMargin, hMargin);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
}


@end
