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

//#define colSpace 35
//#define lineSpace 20
//#define hMargin 35
//#define vMargin 15

#define itemWidth 50
#define itemHeight 70

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
    return  CGSizeMake(itemWidth, itemHeight);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    CGSize size = self.bounds.size;
    return (size.height - moreViewRowNum * itemHeight) / (moreViewRowNum+1);
    //return lineSpace;
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    CGSize size = self.bounds.size;
    return (size.width - moreViewColNum * itemWidth) / (moreViewColNum+1);
    //return colSpace;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    CGSize size = self.bounds.size;
    CGFloat v = (size.height - moreViewRowNum * itemHeight) / (moreViewRowNum+1);
    CGFloat h = (size.width - moreViewColNum * itemWidth) / (moreViewColNum+1);
    return UIEdgeInsetsMake(v, h, v, h);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
}


@end
