//
//  localString.m
//  StringsConvert
//
//  Created by baidu on 15/7/20.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import "localString.h"

@implementation localString
-(id)initWithlocalString:(NSString *)name Path:(NSString *)path Key:(NSString *)key Zh:(NSString*)zh En:(NSString*)en Status:(BOOL)status
{
    self = [super init];
    if(self)
    {
        self.name = name;
        self.path = path;
        self.key = key;
        self.zh = zh;
        self.en= en;
        self.status = status;
    }
    return self;
}
@end
