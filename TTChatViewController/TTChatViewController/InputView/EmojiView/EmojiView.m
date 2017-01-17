//
//  EmojiView.m
//  TTChatViewController
//
//  Created by tanson on 2017/1/8.
//  Copyright © 2017年 chatchat. All rights reserved.
//

#import "EmojiView.h"
#import "EmojiPageCell.h"

@interface EmojiView ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageCtl;
@property (strong ,nonatomic) NSArray * data;
@end

@implementation EmojiView


-(void)awakeFromNib{
    [super awakeFromNib];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"EmojiPageCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    
    NSDictionary * emoji = [self emojiData];
    _data = [self prePageData:emoji[@"people"]];
    _pageCtl.numberOfPages = _data.count;
    _pageCtl.currentPage = 0;
    [self.collectionView reloadData];
}
-(void)show{
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    //[self.collectionView reloadData];
}

-(NSArray*)prePageData:(NSArray*)data{
    NSMutableArray * allData = @[].mutableCopy;
    __block NSMutableArray * pageData = @[].mutableCopy;
    int numPerPage = emojiColNumb * emojiRowNumb - 1;
    [data enumerateObjectsUsingBlock:^(id  obj, NSUInteger idx, BOOL * stop) {
        if(idx !=0 && idx % numPerPage == 0 ){
            [pageData addObject:@"del"];
            [allData addObject:pageData];
            pageData = @[].mutableCopy;
        }
        [pageData addObject:obj];
    }];
    
    [pageData addObject:@"del"];
    [allData addObject:pageData];
    return allData;
}

-(NSDictionary*)emojiData{
    static NSDictionary *__emojis = nil;
    if (!__emojis){
        NSString *path = [[NSBundle mainBundle] pathForResource:@"emoji" ofType:@"json"];
        NSData *emojiData = [[NSData alloc] initWithContentsOfFile:path];
        __emojis = [NSJSONSerialization JSONObjectWithData:emojiData options:NSJSONReadingAllowFragments error:nil];
    }
    return __emojis;
}

- (IBAction)onSendButton:(id)sender {
    self.sendButtonDidTapBlock? self.sendButtonDidTapBlock():nil;
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
    EmojiPageCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell configCell:self.data[indexPath.row]];
    cell.emojiCellDidSelected = ^(NSString * str){
        self.emojiCellDidSelected? self.emojiCellDidSelected(str):nil;
    };
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return collectionView.bounds.size;
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
