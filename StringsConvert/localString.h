//
//  localString.h
//  StringsConvert
//
//  Created by baidu on 15/7/20.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface localString : NSObject
-(id)initWithlocalString:(NSString *)name Path:(NSString *)path Key:(NSString *)key Zh:(NSString*)zh En:(NSString*)en Status:(BOOL)status;
@property(nonatomic,strong)NSString* name;

@property(nonatomic,strong)NSString* path;

@property(nonatomic,strong)NSString* key;

@property(nonatomic,strong)NSString* zh;

@property(nonatomic,strong)NSString* en;

@property(nonatomic,assign) BOOL status;

@end
