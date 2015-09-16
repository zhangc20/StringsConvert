//
//  ConvertedString.h
//  StringsConvert
//
//  Created by baidu on 15/7/20.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConvertedString : NSObject

-(id)initWithStringEn:(NSString *)en StringZh:(NSString *)zh;
@property(nonatomic,strong)NSString* string_zh;

@property(nonatomic,strong)NSString* string_en;

@end
