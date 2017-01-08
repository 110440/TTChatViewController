//
//  TTChatViewController.m
//  TTChatViewController
//
//  Created by tanson on 2016/12/10.
//  Copyright © 2016年 chatchat. All rights reserved.

#import "TTChatViewController.h"

#define BGColor [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1]

@interface TTChatViewController ()<TTInputBarProtocol,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) TTInputView * theInputView;
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) UIImage * outgoingBubbleImage;
@property (nonatomic,strong) UIImage * incomeingBubbleImage;
@property (nonatomic,strong) NSIndexPath * longPressIndexPath;
@property (nonatomic,strong) UIView * headLoadView;
@end

@implementation TTChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _messages = @[].mutableCopy;
    _isLoading = NO;
    _isMoreData = YES;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.theInputView];
    [self.view sendSubviewToBack:self.theInputView];
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[TTChatBubbleCell class] forCellReuseIdentifier:@"bubbleCell"];
    [self.tableView registerClass:[TTChatTextCell class] forCellReuseIdentifier:@"textCell"];
}

- (void) appendMessage:(TTBubbleCellModel*)model{
    model.dateStr = [self dateStringForModel:model andPreModels:self.messages];
    [self.messages addObject:model];
}
- (void) appendMessages:(NSArray<TTBubbleCellModel*>*)models{
    [models enumerateObjectsUsingBlock:^(TTBubbleCellModel * model, NSUInteger idx, BOOL * stop) {
        [self appendMessage:model];
    }];
}
- (void) insertMessages:(NSArray<TTBubbleCellModel*>*)models{
    NSMutableArray * insertModels = @[].mutableCopy;
    [models enumerateObjectsUsingBlock:^(TTBubbleCellModel * model, NSUInteger idx, BOOL * stop) {
        model.dateStr = [self dateStringForModel:model andPreModels:insertModels];
        [insertModels addObject:model];
    }];
    [insertModels addObjectsFromArray:self.messages];
    self.messages = insertModels;
}
-(void)removeMessageWithIndex:(NSInteger)index{
    [self.messages removeObjectAtIndex:index];
    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    [self messageDidRemoveAtIndex:index];
}

-(void) appendMessageFinish{
    [self.tableView reloadData];
    [self.tableView scrollToBottom];
}

#pragma mark- @property

-(TTInputView *)theInputView{
    if(!_theInputView){
        NSBundle * b = [NSBundle bundleForClass:[self class]];
        _theInputView = [b loadNibNamed:@"TTInputView" owner:nil options:nil].firstObject;
        _theInputView.frame = self.view.bounds;
        _theInputView.delegate = self;
    }
    return _theInputView;
}

-(UITableView *)tableView{
    if(!_tableView){
        _tableView = [UITableView new];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = BGColor;
        _tableView.tableFooterView = [UIView new];
        UITapGestureRecognizer *tableViewGesture = [[UITapGestureRecognizer alloc]
                                                    initWithTarget:self
                                                    action:@selector(commentTableViewTouchInSide)];
        tableViewGesture.numberOfTapsRequired = 1;
        tableViewGesture.cancelsTouchesInView = NO;
        [_tableView addGestureRecognizer:tableViewGesture];
        _tableView.tableHeaderView = self.headLoadView;
        _tableView.contentInset = UIEdgeInsetsMake(-TTLoadingHeadHeight, 0, 0, 0);
    }
    return _tableView;
}

-(UIImage *)outgoingBubbleImage{
    if(!_outgoingBubbleImage){
        UIImage * bubble = [UIImage imageNamed:@"chat_ougoingBullbe"];
        bubble = [bubble resizableImageWithCapInsets:UIEdgeInsetsMake(26,8,5, 16) resizingMode:UIImageResizingModeStretch];
        _outgoingBubbleImage = bubble;
    }
    return _outgoingBubbleImage;
}

-(UIImage*)incomeingBubbleImage{
    if(!_incomeingBubbleImage){
        UIImage * bubble = [UIImage imageNamed:@"chat_incomingBubble"];
        bubble = [bubble resizableImageWithCapInsets:UIEdgeInsetsMake(28, 16, 6, 8) resizingMode:UIImageResizingModeStretch];
        _incomeingBubbleImage = bubble;
    }
    return _incomeingBubbleImage;
}

-(UIView *)headLoadView{
    if(!_headLoadView){
        CGRect frame = CGRectMake(0, 0, self.view.bounds.size.width, TTLoadingHeadHeight);
        _headLoadView = [[UIView alloc] initWithFrame:frame];
        UIActivityIndicatorView * loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        loadingView.frame = CGRectMake(0, 0, TTLoadingHeadHeight,TTLoadingHeadHeight);
        loadingView.center = _headLoadView.center;
        [loadingView startAnimating];
        [_headLoadView addSubview:loadingView];
    }
    return _headLoadView;
}

-(void)setIsSelectState:(BOOL)isSelectState{
    _isSelectState = isSelectState;
    [self.tableView reloadData];
}


#pragma mark- private
// tableView frame 调整
-(void)resetTableViewFrame{
    CGSize  viewSize = self.view.bounds.size;
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat topHeight  = self.navigationController.navigationBar.bounds.size.height + statusBarHeight;
    if(!self.navigationController.navigationBar.translucent){
        topHeight = 0;
    }
    CGFloat inputBarHeight = self.theInputView.inputBarHeight;
    CGFloat buttomHeight = self.theInputView.bottomViewHeight + inputBarHeight;
    CGFloat visibleHeight = viewSize.height - (topHeight + buttomHeight);
    
    CGRect frame = self.tableView.frame;
    frame.size = CGSizeMake(viewSize.width, visibleHeight);
    frame.origin.y = topHeight;
    self.tableView.frame = frame;
}

-(void) commentTableViewTouchInSide{
    [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
    [self.theInputView moveDown];
}

-(void) cancelSelectState:(id)sender{
    self.navigationItem.leftBarButtonItem = nil;
    self.isSelectState = NO;
    [self.messages enumerateObjectsUsingBlock:^(TTBubbleCellModel* obj, NSUInteger idx, BOOL * stop) {
        obj.isSelected = NO;
    }];
}
#pragma mark- 子类可重载提供不同的实现

-(UIImage*) bubbleImageForModel:(TTBubbleCellModel*)model atIndex:(NSInteger)index{
    if(model.isOutgoing){
        return self.outgoingBubbleImage;
    }else{
        return self.incomeingBubbleImage;
    }
}

- (NSString *) dateStringForModel:(TTBubbleCellModel*)model andPreModels:(NSArray*)preModels{
    if(!model.isBubbleCell) return nil;
    
    TTBubbleCellModel * preModel = nil;
    NSInteger count = preModels.count - 1;
    for (NSInteger i=count;i>=0;i--){
        TTBubbleCellModel * model = self.messages[i];
        if(model.isBubbleCell){
            preModel = model;
            break;
        }
    }
    if(preModel){
        if(model.dateStr == nil){
            NSTimeInterval secondsInterval= [model.date timeIntervalSinceDate:preModel.date];
            if(secondsInterval > 30){
                return [ChatViewHelper chat_stringForDate:model.date];
            }else{
                return nil;
            }
        }else {
            return model.dateStr;
        }
    }else{
        return [ChatViewHelper chat_stringForDate:model.date];
    }
}

-(void)bubbleLongPressAtIndex:(NSInteger)index bubbleView:(UIView *)bubbleView{
    self.longPressIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
    UIMenuController *menu=[UIMenuController sharedMenuController];
    UIMenuItem *deleteItem = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(deleteMessage:)];
    UIMenuItem *moreItem = [[UIMenuItem alloc] initWithTitle:@"更多" action:@selector(moreMenu:)];
    [menu setMenuItems:[NSArray arrayWithObjects:deleteItem,moreItem,nil]];
    [menu setTargetRect:bubbleView.bounds inView:bubbleView];
    [menu setMenuVisible:YES animated:YES];
}
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    if( action == @selector(deleteMessage:)||action==@selector(moreMenu:)){
        return YES;
    }
    return [super canPerformAction:action withSender:sender];
}

-(void)deleteMessage:(id)sender{
    if(self.longPressIndexPath){
        [self removeMessageWithIndex:self.longPressIndexPath.row];
        self.longPressIndexPath = nil;
    }
}
-(void) moreMenu:(id)sender{
    if(self.longPressIndexPath){
        TTBubbleCellModel * model = self.messages[self.longPressIndexPath.row];
        model.isSelected = YES;
        self.isSelectState = YES;
        UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelSelectState:)];
        self.navigationItem.leftBarButtonItem = cancel;
    }
}

-(void)resendMessageWihtIndex:(NSInteger)index{}
-(void)avatarTouchAtIndex:(NSInteger)index{}
-(void)messageDidRemoveAtIndex:(NSInteger)index{}
-(void)textMessageDidAddWithText:(NSString*)text{}
-(void)voiceMessageDidAddWithPath:(NSString*)path{}
-(void) loadMoreMessageWithDone:(void(^)(NSArray<TTBubbleCellModel*>* models))done{
    done(nil);
}


#pragma mark- tableView delagate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.messages.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TTBubbleCellModel * model = self.messages[indexPath.row];
    NSString * cellIdentifier = @"textCell";
    if(model.isBubbleCell) cellIdentifier = @"bubbleCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TTBubbleCellModel * model = self.messages[indexPath.row];
    TTChatBaseCell * theCell = (TTChatBaseCell*)cell;
    theCell.bubbleImageCreateBlock = ^(){
        return [self bubbleImageForModel:model atIndex:indexPath.row];
    };
    theCell.bubbleClickBlock = ^{
        NSInteger index = [self.messages indexOfObject:model];
        if([model.bubbleItem respondsToSelector:@selector(bubbleItemTouch:index:)]){
            [model.bubbleItem bubbleItemTouch:self index:index];
        }
    };
    theCell.failButtonClikBlock = ^{
        NSInteger index = [self.messages indexOfObject:model];
        [self resendMessageWihtIndex:index];
    };
    theCell.avatarClickBlock = ^{
        NSInteger index = [self.messages indexOfObject:model];
        [self avatarTouchAtIndex:index];
    };
    theCell.bubbleLongPressBlock = ^(UIView *bubbleView){
        NSInteger index = [self.messages indexOfObject:model];
        [self bubbleLongPressAtIndex:index bubbleView:bubbleView];
    };
    
    [UIView setAnimationsEnabled:NO];
    if(self.isSelectState){
        [theCell configCellInSelectState:model];
    }else{
        [theCell configCell:model];
    }
    [UIView setAnimationsEnabled:YES];
    
    if(model.progress < 0){
        [theCell showSendFaildStateView];
    }else if (model.progress < 100){
        [theCell showSendingStateView];
    }else{
        [theCell hideStateView];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    TTBubbleCellModel * model = self.messages[indexPath.row];
    if(model.isBubbleCell){
        return [TTChatBubbleCell heightForCell:model] ;
    }else{
        return [TTChatTextCell heightForCell:model];
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
    [self.theInputView moveDown];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(!self.isSelectState){
        return;
    }
    TTChatBaseCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    TTBubbleCellModel * modle = self.messages[indexPath.row];
    modle.isSelected = !modle.isSelected;
    [cell selectedChange];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (self.isMoreData && self.isLoading){
        self.isMoreData = NO;

        __weak typeof(self) wSelf = self;
        [self loadMoreMessageWithDone:^(NSArray<TTBubbleCellModel *> *models) {
            if(models ){
                if(models.count >= TTMessageNumPerPage){
                    wSelf.isMoreData = YES;
                }
                [wSelf insertMessages:models];
                [wSelf.tableView reloadData];
                NSIndexPath * pathForVisable = [NSIndexPath indexPathForRow:models.count inSection:0];
                CGRect rectForVisable = [wSelf.tableView rectForRowAtIndexPath:pathForVisable];
                wSelf.tableView.contentOffset = CGPointMake(0, rectForVisable.origin.y-TTLoadingHeadHeight);
            }
            wSelf.tableView.contentInset = UIEdgeInsetsMake(-TTLoadingHeadHeight, 0, 0, 0);
            wSelf.isLoading = NO;
        }];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.tableView.contentOffset.y <= -1 && self.isLoading == NO && self.isMoreData == YES ){
        self.isLoading = YES;
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
}

#pragma mark- inputView delegate

-(void)inputViewHeightDidChangeTo:(CGFloat)height{
    //[self.tableView scrollToBottom];
    //[self.view layoutIfNeeded];
    [self resetTableViewFrame];
    [self.tableView scrollToBottom];
}

-(void)inputViewWillMoveUp{
    [self.tableView scrollToBottom];
    [self.view layoutIfNeeded];
}

-(void)sendButtonDidTouch:(NSString *)text{
    id<BubbleItemProtocol>  item = [[BubbleTextItem alloc] initWithText:text];
    TTBubbleCellModel * model = [[TTBubbleCellModel alloc] initWithDisplayName:self.displayName
                                                                      date:[NSDate date]
                                                                bubbleItem:item
                                                                isOutgoing:YES];
    [self appendMessage:model];
    [self appendMessageFinish];
    [self textMessageDidAddWithText:text];
}

-(void)recordComplatedWithPath:(NSString *)path duration:(CGFloat)duration{
    id<BubbleItemProtocol>  item = [[BubbleVoiceItem alloc] initWithPath:path voiceDuration:duration];
    TTBubbleCellModel * model = [[TTBubbleCellModel alloc] initWithDisplayName:self.displayName
                                                                      date:[NSDate date]
                                                                bubbleItem:item
                                                                isOutgoing:YES];
    [self appendMessage:model];
    [self appendMessageFinish];
    [self voiceMessageDidAddWithPath:path];
}
@end
