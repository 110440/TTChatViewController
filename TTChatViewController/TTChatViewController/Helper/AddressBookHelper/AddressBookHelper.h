//
//  AddressBookHelper.h
//  PPGetAddressBook
//
//  Created by tanson on 2017/1/8.
//  Copyright © 2017年 AndyPang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface AddressBookHelper : NSObject

+(instancetype)sharedInstance;
-(void)addContactFromAddrBook:(NSString*)phone showVC:(UIViewController*)vc;
-(void)addNewContact:(NSString*)phone showVC:(UIViewController*)vc;
-(void)willShow;
-(void)callPhone:(NSString*)phone;
@end
