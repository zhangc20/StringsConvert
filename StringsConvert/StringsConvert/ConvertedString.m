//
//  ConvertedString.m
//  StringsConvert
//
//  Created by baidu on 15/7/20.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import "ConvertedString.h"

@implementation ConvertedString
-(id)initWithStringEn:(NSString *)en StringZh:(NSString *)zh
{
    self = [super init];
    if(self)
    {
        self.string_en = en;
        self.string_zh = zh;
    }
    return self;
}

@end
