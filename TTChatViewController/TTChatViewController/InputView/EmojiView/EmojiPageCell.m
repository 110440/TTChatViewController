//
//  EmojiPageCell.m
//  TTChatViewController
//
//  Created by tanson on 2017/1/8.
//  Copyright © 2017年 chatchat. All rights reserved.
//

#import "EmojiPageCell.h"
#import "EmojiCell.h"
#import "EmojiView.h"

@interface EmojiPageCell ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong,nonatomic) NSArray * data;
@end

@implementation EmojiPageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"EmojiCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
}

-(void)configCell:(NSArray *)data{
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
    EmojiCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    NSString * emojiStr = self.data[indexPath.row];
    if([emojiStr isEqualToString:@"del"]){
        cell.imageView.image = [UIImage imageNamed:@"face_del"];
        cell.imageView.hidden = NO;
        cell.emojiText.text = nil;
    }else{
        cell.emojiText.text = emojiStr;
        cell.imageView.hidden = YES;
    }
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize size = collectionView.bounds.size;
    CGFloat w = size.width / emojiColNumb;
    CGFloat h = size.height/ emojiRowNumb;
    return  CGSizeMake(w, h);
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

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString * emojiStr = self.data[indexPath.row];
    self.emojiCellDidSelected? self.emojiCellDidSelected(emojiStr):nil;
}

@end
