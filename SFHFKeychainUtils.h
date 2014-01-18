//
//  SFHFKeychainUtils.h
//  ReadingBook
//
//  Created by Jeff.King on 13-11-4.
//  Copyright (c) 2013年 Jeff.King. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SFHFKeychainUtils : NSObject {
	
}

+ (NSString *) getPasswordForUsername: (NSString *) username andServiceName: (NSString *) serviceName error: (NSError **) error;
+ (BOOL) storeUsername: (NSString *) username andPassword: (NSString *) password forServiceName: (NSString *) serviceName updateExisting: (BOOL) updateExisting error: (NSError **) error;
+ (BOOL) deleteItemForUsername: (NSString *) username andServiceName: (NSString *) serviceName error: (NSError **) error;

@end