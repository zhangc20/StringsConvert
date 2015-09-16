//
//  AddConvertedStringClick.h
//  StringsConvert
//
//  Created by baidu on 15/7/23.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ConvertedString;

@protocol AddConvertedStringEvent <NSObject>

-(void)AddConvertedStringClick:(ConvertedString *)strs;
@end
