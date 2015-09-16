//
//  AppDelegate.h
//  StringsConvert
//
//  Created by baidu on 15/7/20.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AddConvertedString.h"
#import "AddConvertedStringClick.h"
@interface AppDelegate : NSObject <NSApplicationDelegate,AddConvertedStringEvent>
@property (weak) IBOutlet NSTableView *localStringsTable;
@property (weak) IBOutlet NSTextField *localStringsLabel;
@property (weak) IBOutlet NSTextField *localStringsConverted;
- (IBAction)RefreshLocalStringsFromConvertedString:(id)sender;
- (IBAction)ClearConvertTable:(id)sender;
- (IBAction)ClearLocalStringsTable:(id)sender;
- (IBAction)RefreshLocalStringsTable:(id)sender;
- (IBAction)RefreshConvertedStringsTable:(id)sender;
- (IBAction)CreateCsvFileForLocalStrings:(id)sender;
- (IBAction)CreateCsvFileForConvertedStrings:(id)sender;
- (IBAction)UserAddConvertedString:(id)sender;
- (IBAction)AddConvertedString:(id)sender;
- (IBAction)SaveLocalStringsToFile:(id)sender;
- (IBAction)ScanFromDir:(id)sender;

@property (weak) IBOutlet NSTableView *convertedTable;
@property (weak) IBOutlet NSTextField *convertStringsNumLabel;
- (IBAction)loadLocalStrings:(id)sender;
- (void)decodeConvertedString:(NSURL*)url;
- (BOOL)IsContainzhHansStrings:(NSString*)str;
- (int)GetLocalStringsConvertNum;
@property (nonatomic,strong) NSMutableArray *convertedStrings;
@property (nonatomic,strong) NSMutableArray *localStrings;

@property (nonatomic,strong) AddConvertedString *Addwin;
@end

