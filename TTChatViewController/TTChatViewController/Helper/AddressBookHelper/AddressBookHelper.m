//
//  AddressBookHelper.m
//  PPGetAddressBook
//
//  Created by tanson on 2017/1/8.
//  Copyright © 2017年 AndyPang. All rights reserved.
//

#import "AddressBookHelper.h"
#import <AddressBookUI/AddressBookUI.h>

@interface AddressBookHelper ()<ABPeoplePickerNavigationControllerDelegate,ABNewPersonViewControllerDelegate>

@property (nonatomic,weak) UIViewController * showVC;
@property (nonatomic,strong) NSString * phone;
@end

@implementation AddressBookHelper{
    ABRecordRef _ABRecord;
}

+(instancetype)sharedInstance{
    static AddressBookHelper * ins;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ins = [AddressBookHelper new];
    });
    return ins;
}

#pragma mark- private

/**
 *  检测权限并作响应的操作
 */
- (void)checkAuthorizationStatus:(void(^)(BOOL))complate
{
    switch (ABAddressBookGetAuthorizationStatus())
    {
            //存在权限
        case kABAuthorizationStatusAuthorized:
            //获取通讯录
            complate(YES);
            break;
            
            //权限未知
        case kABAuthorizationStatusNotDetermined:
        {
            //请求权限
            [self requestAuthorizationStatus:^(BOOL ret) {
                complate(ret);
            }];
        }
            break;
            
            //如果没有权限
        case kABAuthorizationStatusDenied:
        case kABAuthorizationStatusRestricted://需要提示
            complate(NO);
            break;
            
        default:
            break;
    }
}

/**
 *  请求通讯录的权限
 */
- (void)requestAuthorizationStatus:(void(^)(BOOL))complate
{
    //避免强引用
    ABAddressBookRef addrRef = ABAddressBookCreate();
    ABAddressBookRequestAccessWithCompletion(addrRef, ^(bool granted, CFErrorRef error) {
        //权限得到允许
        if (granted == true)
        {
            //主线程获取联系人
            dispatch_async(dispatch_get_main_queue(), ^{
                complate(YES);
            });
        }else{
            complate(NO);
        }
    });
}

-(void)showABPeoplePicker{
    ABPeoplePickerNavigationController *pNC = [[ABPeoplePickerNavigationController alloc] init];
    pNC.peoplePickerDelegate = self;
    [self.showVC presentViewController:pNC animated:YES completion:nil];
}

//过滤指定字符串(可自定义添加自己过滤的字符串)
- (NSString *)removeSpecialSubString: (NSString *)string
{
    string = [string stringByReplacingOccurrencesOfString:@"+86" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"-" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"(" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@")" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    return string;
}

#pragma mark- public

-(void)addContactFromAddrBook:(NSString *)phone showVC:(id)vc{
    self.phone = phone;
    self.showVC = vc;
    [self checkAuthorizationStatus:^(BOOL ret) {
        if(ret){
            [self showABPeoplePicker];
        }else{
            //没有权限
            UIAlertView * a = [[UIAlertView alloc] initWithTitle:nil message:@"请到设置里允许APP访问你的联系人权限" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [a show];
        }
    }];
}

-(void)willShow{
    if(_ABRecord){
        
        CFErrorRef error =NULL;
        ABMutableMultiValueRef multi = ABMultiValueCreateMutable(kABMultiStringPropertyType);
        
        //所有的电话号码
        ABMultiValueRef phones = ABRecordCopyValue(_ABRecord, kABPersonPhoneProperty);
        CFIndex phoneCount = ABMultiValueGetCount(phones);
        for (CFIndex i = 0; i < phoneCount; i++)
        {
            // 号码
            NSString *phoneValue = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(phones, i);
            NSString *mobile = [self removeSpecialSubString:phoneValue];
            CFStringRef aCFString = (__bridge CFStringRef)mobile;
            ABMultiValueAddValueAndLabel(multi, aCFString, kABPersonPhoneMobileLabel, NULL);
        }
        CFStringRef aCFString = (__bridge CFStringRef)self.phone;
        ABMultiValueAddValueAndLabel(multi, aCFString, kABPersonPhoneMobileLabel, NULL);
        ABRecordSetValue(_ABRecord, kABPersonPhoneProperty, multi, &error);
        
        ABNewPersonViewController * abVC = [[ABNewPersonViewController alloc] init];
        abVC.displayedPerson = _ABRecord;
        abVC.newPersonViewDelegate = self;
        UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:abVC];
        [self.showVC presentViewController:nav animated:YES completion:nil];
    }
}

-(void)callPhone:(NSString*)phone{
    NSURL *telURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", phone]];
    [[UIApplication sharedApplication] openURL:telURL];
}

-(void)addNewContact:(NSString *)phone showVC:(UIViewController *)vc{
    self.phone = phone;
    self.showVC = vc;
    [self checkAuthorizationStatus:^(BOOL ret) {
        if(ret){
            
            ABRecordRef personRef = ABPersonCreate();
            CFErrorRef error =NULL;
            ABMutableMultiValueRef multi = ABMultiValueCreateMutable(kABMultiStringPropertyType);
            
            CFStringRef aCFString = (__bridge CFStringRef)phone;
            ABMultiValueAddValueAndLabel(multi, aCFString, kABPersonPhoneMobileLabel, NULL);
            ABRecordSetValue(personRef, kABPersonPhoneProperty, multi, &error);
            
            ABNewPersonViewController * abVC = [[ABNewPersonViewController alloc] init];
            abVC.displayedPerson = personRef;
            abVC.newPersonViewDelegate = self;
            UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:abVC];
            [self.showVC presentViewController:nav animated:YES completion:nil];
            
        }else{
            UIAlertView * a = [[UIAlertView alloc] initWithTitle:nil message:@"请到设置里允许APP访问你的联系人权限" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [a show];
        }
    }];
}

#pragma mark- peoplePickerNavigationController delegate
// < ios 8
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker{
    _ABRecord = NULL;
    [self.showVC dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier NS_DEPRECATED_IOS(2_0, 8_0){
    _ABRecord = person;
    return NO;
}

//  > ios 8
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person NS_AVAILABLE_IOS(8_0){
    _ABRecord = person;
}

#pragma mark - newPersonViewController delegate
-(void)newPersonViewController:(ABNewPersonViewController *)newPersonView didCompleteWithNewPerson:(ABRecordRef)person{
    _ABRecord = NULL;
    [self.showVC dismissViewControllerAnimated:YES completion:nil];
}

@end
