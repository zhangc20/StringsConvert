//
//  AddConvertedString.m
//  StringsConvert
//
//  Created by baidu on 15/7/23.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import "AddConvertedString.h"
#import "ConvertedString.h"
@interface AddConvertedString ()

@end

@implementation AddConvertedString

- (void)windowDidLoad {
    [super windowDidLoad];
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (IBAction)ClickAddConvertedString:(id)sender {
    self.AddString = [[ConvertedString alloc]initWithStringEn:@"" StringZh:@""];
    self.AddString.string_en = [self.Text_StrEn stringValue];
    self.AddString.string_zh = [self.Text_StrZh stringValue];
    if(![self.AddString.string_zh isEqualToString:@""])
    {
        if (self.delegate) {
            [self.delegate AddConvertedStringClick:self.AddString];
        }
    }
    [self.window close];
}
@end
