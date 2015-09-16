//
//  AddConvertedString.h
//  StringsConvert
//
//  Created by baidu on 15/7/23.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AddConvertedStringClick.h"
@class ConvertedString;

@interface AddConvertedString : NSWindowController
@property (weak) IBOutlet NSTextField *Text_StrZh;
@property (weak) IBOutlet NSTextField *Text_StrEn;

- (IBAction)ClickAddConvertedString:(id)sender;
@property (nonatomic,strong) id<AddConvertedStringEvent> delegate;
@property (nonatomic,strong) ConvertedString *AddString;
@end
