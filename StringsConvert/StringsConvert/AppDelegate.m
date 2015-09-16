//
//  AppDelegate.m
//  StringsConvert
//
//  Created by baidu on 15/7/20.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import "AppDelegate.h"
#import "ConvertedString.h"
#import "localString.h"
@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;

@end

@implementation AppDelegate

- (void)handleURLEvent:(NSAppleEventDescriptor*)theEvent withReplyEvent:(NSAppleEventDescriptor*)replyEvent {
     NSString* path = [[theEvent paramDescriptorForKeyword:keyDirectObject] stringValue];
    NSLog(@"%@",path);
//     NSAlert *alert = [[NSAlert alloc] init];
//     [alert setMessageText:@"URL Request"];
//     [alert setInformativeText:path];
//     [alert addButtonWithTitle:@"OK"];
//     [alert runModal];
 }
- (void)applicationWillFinishLaunching:(NSNotification *)notification
{
    [[NSAppleEventManager sharedAppleEventManager] setEventHandler:self andSelector:@selector(handleURLEvent:withReplyEvent:) forEventClass:kInternetEventClass andEventID:kAEGetURL];
}
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    self.convertedStrings = [[NSMutableArray alloc]initWithCapacity:0];
    self.localStrings = [[NSMutableArray alloc]initWithCapacity:0];
    self.Addwin = [[AddConvertedString alloc] initWithWindowNibName:@"AddConvertedString"];
    [self.Addwin setDelegate:self];
}
- (BOOL)applicationShouldHandleReopen:(NSApplication *)sender hasVisibleWindows:(BOOL)flag
{
    [self.window makeKeyAndOrderFront:self];
    return YES;
}
- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

#pragma mark - table delegate

- (NSInteger) numberOfRowsInTableView:(NSTableView *)tableView
{
    if([tableView.autosaveName isEqualToString:@"LocalStrings"])
    {
        NSString *str = [NSString stringWithFormat:@"记录数:%ld",self.localStrings.count];
        [self.localStringsLabel setStringValue:str];
        str = [NSString stringWithFormat:@"已翻译:%d",[self GetLocalStringsConvertNum]];
        [self.localStringsConverted setStringValue:str];
        return [self.localStrings count];
    }
    else
    {
        NSString *str = [NSString stringWithFormat:@"记录数:%ld",self.convertedStrings.count];
        [self.convertStringsNumLabel setStringValue:str];
        return [self.convertedStrings count];
    }
    return 0;
}
- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)rowIndex
{
    NSString *identifer = [tableColumn identifier];
    if ([identifer isEqualToString:@"keyvalue_zh-hans"]) {
        ConvertedString *str = [self.convertedStrings objectAtIndex:rowIndex];
        return str.string_zh;
    }
    else if ([identifer isEqualToString:@"keyvalue_en"]) {
        ConvertedString *str = [self.convertedStrings objectAtIndex:rowIndex];
        return str.string_en;
    }
    else if ([identifer isEqualToString:@"string_name"]){
        localString *str = [self.localStrings objectAtIndex:rowIndex];
        return str.name;
    }
    else if ([identifer isEqualToString:@"string_path"]){
        localString *str = [self.localStrings objectAtIndex:rowIndex];
        return str.path;
    }
    else if ([identifer isEqualToString:@"string_key"]){
        localString *str = [self.localStrings objectAtIndex:rowIndex];
        return str.key;
    }
    else if ([identifer isEqualToString:@"string_zh"]){
        localString *str = [self.localStrings objectAtIndex:rowIndex];
        return str.zh;
    }
    else if ([identifer isEqualToString:@"string_en"]){
        localString *str = [self.localStrings objectAtIndex:rowIndex];
        return str.en;
    }
    else if ([identifer isEqualToString:@"string_status"]){
        localString *str = [self.localStrings objectAtIndex:rowIndex];
        if(YES == str.status)
        {
            return @"已翻译";
        }
        else
        {
            return @"默认";
        }
    }
    return nil;
}
- (void)tableView:(NSTableView *)tableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSString *identifer = [tableColumn identifier];
    if ([identifer isEqualToString:@"string_en"]){
        localString *str = [self.localStrings objectAtIndex:row];
        str.en = object;
        if ([self IsContainzhHansStrings:str.en]) {
             if(str.status==YES)
             {
                 str.status = NO;
                 [self.localStringsTable reloadData];
             }
         }
         else{
             if(str.status==NO)
             {
                 str.status = YES;
                 [self.localStringsTable reloadData];
             }
         }
    }
    else if ([identifer isEqualToString:@"keyvalue_en"]) {
        ConvertedString *str = [self.convertedStrings objectAtIndex:row];
        str.string_en = object;
    }
}
- (void)tableView:(NSTableView *)tableView mouseDownInHeaderOfTableColumn:(NSTableColumn *)tableColumn
{
    NSString *identifer = [tableColumn identifier];
    if ([identifer isEqualToString:@"string_name"])
    {
        [self.localStrings sortUsingComparator:^NSComparisonResult(localString *obj1, localString *obj2) {
            return [obj1.name compare:obj2.name];
        }];
        [self.localStringsTable reloadData];
    }
    else if ([identifer isEqualToString:@"string_status"])
    {
        [self.localStrings sortUsingComparator:^NSComparisonResult(localString *obj1, localString *obj2) {
            return obj1.status < obj2.status;
        }];
        [self.localStringsTable reloadData];
    }
    else if ([identifer isEqualToString:@"keyvalue_en"])
    {
        [self.convertedStrings sortUsingComparator:^NSComparisonResult(ConvertedString *obj1, ConvertedString *obj2) {
            return [obj1.string_en compare:obj2.string_en];
        }];
        [self.convertedTable reloadData];
    }
    
}
-(void)AddUserConvertedString:(ConvertedString *)strs
{
    for (ConvertedString *str in self.convertedStrings) {
        if([str.string_zh isEqualToString:strs.string_zh])
        {
            return;
        }
    }
    [self.convertedStrings addObject:strs];
}
-(void)decodeConvertedString:(NSURL*)url
{
    NSError *error;
    NSString* content;
    content = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
    if (content==nil) {
        error = nil;
        content = [NSString stringWithContentsOfURL:url encoding:NSUnicodeStringEncoding error:&error];
        if (content==nil) {
            return;
        }
    }
//    const char *s = [content UTF8String];
//    for (int i=0,j=strlen(s); i<j; i++) {
//        NSLog(@"%d",*s);
//        s++;
//    }
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\s*en\\s*=\\s*(.+)\\s*\\r\\n\\s*zh-Hans\\s*=\\s*(.+)\\s*\\r\\n" options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *matches = [regex matchesInString:content options:NSMatchingReportCompletion range:NSMakeRange(0, content.length)];
    for (NSTextCheckingResult *match in matches)
    {
        NSString *str_en = [content substringWithRange:[match rangeAtIndex:1]];
        if([self IsContainzhHansStrings:str_en]==NO)
        {
            NSString *str_zh = [content substringWithRange:[match rangeAtIndex:2]];
            ConvertedString *convert = [[ConvertedString alloc] initWithStringEn:str_en StringZh:str_zh];
            [self AddUserConvertedString:convert];
            //NSLog(@"%@ %ld",str_zh,str_zh.length);
        }
        //NSLog(@"%@ %@",[content substringWithRange:[match rangeAtIndex:1]],[content substringWithRange:[match rangeAtIndex:2]]);
    }
    if(matches.count==0)
    {
        regex = [NSRegularExpression regularExpressionWithPattern:@"(.+)[\t;](.+)[\r\n]+" options:NSRegularExpressionCaseInsensitive error:&error];
        matches = [regex matchesInString:content options:NSMatchingReportCompletion range:NSMakeRange(0, content.length)];
        for (NSTextCheckingResult *match in matches)
        {
            NSString *str_en = [content substringWithRange:[match rangeAtIndex:2]];
            if([self IsContainzhHansStrings:str_en]==NO)
            {
                NSString *str_zh = [content substringWithRange:[match rangeAtIndex:1]];
                str_zh = [str_zh stringByReplacingOccurrencesOfString:@"\xef\xbb\xbf" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, 1)];
                ConvertedString *convert = [[ConvertedString alloc] initWithStringEn:str_en StringZh:str_zh];
                [self AddUserConvertedString:convert];
                //NSLog(@"%@ %ld",str_zh,str_zh.length);
            }
        }
    }
    return;
}
- (int)GetLocalStringsConvertNum
{
    int count=0;
    for (localString *str in self.localStrings) {
        if(str.status)
        {
            count++;
        }
    }
    return count;
}
-(BOOL)IsContainzhHansStrings:(NSString*)str
{
    NSRegularExpression *detectzh = [NSRegularExpression regularExpressionWithPattern:@".*[\u4E00-\u9FA5]+.*" options:NSRegularExpressionCaseInsensitive error:nil];
    if([detectzh numberOfMatchesInString:str options:NSMatchingReportCompletion range:NSMakeRange(0, str.length)]==0)
    {
        return NO;
    }
    return YES;
}
- (IBAction)RefreshLocalStringsFromConvertedString:(id)sender {
    [self.localStrings enumerateObjectsUsingBlock:^(localString *obj, NSUInteger idx, BOOL *stop) {
        for (ConvertedString *str in self.convertedStrings) {
            if([str.string_zh isEqualToString: obj.zh])
            {
                obj.en = str.string_en;
                if ([self IsContainzhHansStrings:obj.en]) {
                    obj.status = NO;
                }
                else
                {
                    obj.status = YES;
                }
                break;
            }
        }
    }];
    [self.localStringsTable reloadData];
}

- (IBAction)ClearConvertTable:(id)sender {
    [self.convertedStrings removeAllObjects];
    [self.convertedTable reloadData];
}

- (IBAction)ClearLocalStringsTable:(id)sender {
    [self.localStrings removeAllObjects];
    [self.localStringsTable reloadData];
}

- (IBAction)RefreshLocalStringsTable:(id)sender {
    [self.localStringsTable reloadData];
}

- (IBAction)RefreshConvertedStringsTable:(id)sender {
    [self.convertedTable reloadData];
}

- (IBAction)CreateCsvFileForLocalStrings:(id)sender {
    NSSavePanel *savePanel = [NSSavePanel savePanel];
    //[savePanel setAllowedFileTypes:@[@"csv"]];
    [savePanel setShowsTagField:NO];
    [savePanel setNameFieldStringValue:@"MacHiLocalStrings.csv"];
    NSInteger result = [savePanel runModal];
    if(result==NSFileHandlingPanelOKButton&&self.localStrings.count>0)
    {
        NSMutableString *strall = [[NSMutableString alloc]init];
        NSString *header = [NSString stringWithFormat:@"中文\t英文\r\n"];
        int count=0;
        [strall appendString:header];
        for (localString *str in self.localStrings) {
            NSString *content=[NSString stringWithFormat:@"%@\t%@\r\n",str.zh,str.en];
            if ([strall containsString:content]==NO) {
                [strall appendString:content];
                count++;
            }
        }
        [strall writeToFile:[[savePanel URL] path] atomically:YES encoding:NSUnicodeStringEncoding error:nil];
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:@"提示"];
        [alert setInformativeText:[NSString stringWithFormat:@"保存到文件成功!\r\n记录数:%d",count]];
        [alert addButtonWithTitle:@"确定"];
        [alert runModal];
    }
}

- (IBAction)CreateCsvFileForConvertedStrings:(id)sender {
    NSSavePanel *savePanel = [NSSavePanel savePanel];
    //[savePanel setAllowedFileTypes:@[@"csv"]];
    [savePanel setShowsTagField:NO];
    [savePanel setNameFieldStringValue:@"MacConvertedStrings.csv"];
    NSInteger result = [savePanel runModal];
    if(result==NSFileHandlingPanelOKButton&&self.convertedStrings.count>0)
    {
        NSMutableData *writer = [NSMutableData data];
        NSString *header = [NSString stringWithFormat:@"中文\t英文\r\n"];
        int count=0;
        [writer appendData:[header dataUsingEncoding:NSUnicodeStringEncoding]];
        for (ConvertedString *str in self.convertedStrings) {
            NSString *content=[NSString stringWithFormat:@"%@\t%@\r\n",str.string_zh,str.string_en];
            [writer appendData:[content dataUsingEncoding:NSUnicodeStringEncoding]];
            count++;
        }
        [writer writeToFile:[[savePanel URL] path] atomically:YES];
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:@"提示"];
        [alert setInformativeText:[NSString stringWithFormat:@"保存到文件成功!\r\n记录数:%d",count]];
        [alert addButtonWithTitle:@"确定"];
        [alert runModal];
    }
}

- (IBAction)UserAddConvertedString:(id)sender {
    [self.Addwin.window center];
    [self.Addwin.window makeKeyAndOrderFront:self];
}
-(void)AddConvertedStringClick:(ConvertedString *)strs
{
    [self AddUserConvertedString:strs];
    [self.convertedTable reloadData];
}
- (IBAction)AddConvertedString:(id)sender {
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setTitle:@"请选择文件"];
    [panel setCanChooseFiles:YES];
    [panel setCanChooseDirectories:NO];
    NSInteger result = [panel runModal];
    if(result==NSFileHandlingPanelOKButton)
    {
        NSArray *select_files = [panel URLs] ;
        
        for (int i=0; i<select_files.count; i++)
        {
            [self decodeConvertedString:[select_files objectAtIndex:i]];
            [self.convertedTable reloadData];
            //NSLog(@"%@",[[select_files objectAtIndex:i] path]);
        }
    }
}

- (IBAction)SaveLocalStringsToFile:(id)sender {
    if (self.localStrings.count==0) {
        return;
    }
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:@"提示"];
    [alert setInformativeText:@"该操作将写入翻译数据到所有文件,是否继续?"];
    [alert addButtonWithTitle:@"是"];
    [alert addButtonWithTitle:@"否"];
    NSModalResponse res = [alert runModal];
    if (res != NSAlertFirstButtonReturn) {
        return;
    }
    [self.localStrings sortUsingComparator:^NSComparisonResult(localString *obj1, localString *obj2) {
        return [obj1.path compare:obj2.path];
    }];
    [self.localStringsTable reloadData];
    int savecount=0;
    for (int i=0; i<self.localStrings.count; i++) {
        localString *mstrs = [self.localStrings objectAtIndex:i];
        int filereplacecount=0;
        NSString* content;
        NSMutableString* saveContent = [[NSMutableString alloc]init];
        content = [NSString stringWithContentsOfFile:mstrs.path encoding:NSUTF8StringEncoding error:nil];
        NSArray *lines = [content componentsSeparatedByString:@"\n"];
        if ([mstrs.name isEqualToString:@"Localizable.strings"]
            ||[mstrs.name isEqualToString:@"InfoPlist.strings"]) {
            for (int j=0; j<lines.count; j++) {
                NSString *matchstr = [lines objectAtIndex:j];
                NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\s*\\b(\\w+)\\s*=\\s*\"(.*)\";\\s*" options:NSRegularExpressionCaseInsensitive error:nil];
                NSTextCheckingResult *match = [regex firstMatchInString:matchstr options:NSMatchingReportCompletion range:NSMakeRange(0, matchstr.length)];
                if(match)
                {
                    NSString *key = [matchstr substringWithRange:[match rangeAtIndex:1]];
                    NSString *value = [matchstr substringWithRange:[match rangeAtIndex:2]];
                    for(int k=0; k<self.localStrings.count; k++)
                    {
                        localString *tstrs = [self.localStrings objectAtIndex:k];
                        if ([tstrs.path isEqualToString:mstrs.path]
                            &&[tstrs.key isEqualToString:key]) {
                            if (tstrs.status==YES) {
                                matchstr = [matchstr stringByReplacingOccurrencesOfString:value withString:tstrs.en];
                                filereplacecount++;
                            }
                            break;
                        }
                    }
                }
                [saveContent appendFormat:@"%@\n",matchstr];
            }
        }
        else{
            for (int j=0; j<lines.count; j++) {
                NSString *matchstr = [lines objectAtIndex:j];
                NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\"(.+)\"\\s*=\\s*\"(.*)\"" options:NSRegularExpressionCaseInsensitive error:nil];
                NSTextCheckingResult *match = [regex firstMatchInString:matchstr options:NSMatchingReportCompletion range:NSMakeRange(0, matchstr.length)];
                if(match)
                {
                    NSString *key = [matchstr substringWithRange:[match rangeAtIndex:1]];
                    NSString *value = [matchstr substringWithRange:[match rangeAtIndex:2]];
                    for(int k=0; k<self.localStrings.count; k++)
                    {
                        localString *tstrs = [self.localStrings objectAtIndex:k];
                        if ([tstrs.path isEqualToString:mstrs.path]
                            &&[tstrs.key isEqualToString:key]) {
                            if (tstrs.status==YES) {
                                matchstr = [matchstr stringByReplacingOccurrencesOfString:value withString:tstrs.en];
                                filereplacecount++;
                            }
                            break;
                        }
                    }
                }
                [saveContent appendFormat:@"%@\n",matchstr];
            }
        }
        if (filereplacecount>0) {
            NSError *error;
            [[saveContent substringToIndex:saveContent.length-1] writeToFile:mstrs.path atomically:YES encoding:NSUTF8StringEncoding error:&error];
            if (error!=nil) {
                NSAlert *alert = [[NSAlert alloc] init];
                ;
                [alert setMessageText:@"提示"];
                [alert setInformativeText:[NSString stringWithFormat:@"写入文件失败!\r\n文件名:%@",mstrs.name]];
                [alert addButtonWithTitle:@"OK"];
                [alert runModal];
            }
            savecount++;
        }
        while (i+1<self.localStrings.count) {
            localString *nstrs = [self.localStrings objectAtIndex:i+1];
            if([nstrs.path isEqualToString:mstrs.path]){
                i++;
            }
            else{
                break;
            }
        }
    }
    NSAlert *alert1 = [[NSAlert alloc] init];
    [alert1 setMessageText:@"提示"];
    [alert1 setInformativeText:[NSString stringWithFormat:@"保存到文件成功!\r\n修改文件数:%d",savecount]];
    [alert1 addButtonWithTitle:@"确定"];
    [alert1 runModal];
}


-(void)AddUserLocalString:(localString *)strs
{
    for (localString *str in self.localStrings) {
        if([str.name isEqualToString:strs.name]
           &&[str.path isEqualToString:strs.path]
           &&[str.key isEqualToString:strs.key]
           &&[str.zh isEqualToString:strs.zh])
        {
            return;
        }
    }
    [self.localStrings addObject:strs];
}

-(void)decodeLocalStringContent:(NSURL*)url
{
    NSError *error;
    NSString* content;
    content = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
    if (content==nil) {
        content = [NSString stringWithContentsOfURL:url encoding:NSUnicodeStringEncoding error:&error];
        if (content==nil) {
            return;
        }
        content = [content stringByReplacingPercentEscapesUsingEncoding:NSUTF16StringEncoding];
    }
    NSString *path = [url path];
    NSString *name = [[url path] lastPathComponent];
    
    if([name isEqualToString:@"Localizable.strings"] ||
       [name isEqualToString:@"InfoPlist.strings"])
    {
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\s*\\b(\\w+)\\s*=\\s*\"(.*[\u4E00-\u9FA5]+.*)\";\\s*" options:NSRegularExpressionCaseInsensitive error:&error];
        NSArray *matches = [regex matchesInString:content options:NSMatchingReportCompletion range:NSMakeRange(0, content.length)];
        for (NSTextCheckingResult *match in matches)
        {
            NSString *key = [content substringWithRange:[match rangeAtIndex:1]];
            NSString *zh = [content substringWithRange:[match rangeAtIndex:2]];
            NSString *en = [content substringWithRange:[match rangeAtIndex:2]];
            localString *local = [[localString alloc] initWithlocalString:name Path:path Key:key Zh:zh En:en Status:NO];
            [self AddUserLocalString:local];
            //NSLog(@"%@ %@",[content substringWithRange:[match rangeAtIndex:1]],[content substringWithRange:[match rangeAtIndex:2]]);
        }
        return;
    }
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@".*\".*\".*\"(.*[\u4E00-\u9FA5]+.*)\".*\".*\".*\n\"(.*)\"\\s*=\\s*\"(.*)\".*\n" options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *matches = [regex matchesInString:content options:NSMatchingReportCompletion range:NSMakeRange(0, content.length)];
    for (NSTextCheckingResult *match in matches)
    {
        NSString *zh = [content substringWithRange:[match rangeAtIndex:1]];
        NSString *key = [content substringWithRange:[match rangeAtIndex:2]];
        NSString *en = [content substringWithRange:[match rangeAtIndex:3]];
        BOOL status = YES;
        if([self IsContainzhHansStrings:en])
        {
            status = NO;
        }
        localString *local = [[localString alloc] initWithlocalString:name Path:path Key:key Zh:zh En:en Status:status];
        [self AddUserLocalString:local];
        //NSLog(@"%@ %@ %@",[content substringWithRange:[match rangeAtIndex:1]],[content substringWithRange:[match rangeAtIndex:2]],[content substringWithRange:[match rangeAtIndex:3]]);
    }
}
- (IBAction)loadLocalStrings:(id)sender {
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setTitle:@"请选择文件"];
    [panel setCanChooseFiles:YES];
    [panel setCanChooseDirectories:NO];
    [panel setAllowsMultipleSelection:YES];
    [panel setAllowedFileTypes:@[@"strings"]];
    NSInteger result = [panel runModal];
    if(result==NSFileHandlingPanelOKButton)
    {
        NSArray *select_files = [panel URLs] ;
        
        for (int i=0; i<select_files.count; i++)
        {
            [self decodeLocalStringContent:[select_files objectAtIndex:i]];
            [self.localStringsTable reloadData];
        }
    }
}
- (IBAction)ScanFromDir:(id)sender {
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setTitle:@"请选择源代码目录"];
    [panel setCanChooseFiles:NO];
    [panel setCanChooseDirectories:YES];
    [panel setAllowsMultipleSelection:NO];
    NSInteger result = [panel runModal];
    if(result==NSFileHandlingPanelOKButton)
    {
        NSArray *select_files = [panel URLs] ;
        NSString *path = [[select_files objectAtIndex:0] path];
        int count=0;
        NSArray *pathext = @[@"/en.lproj",
                            @"/base.lproj"];
        for (int i=0; i<2; i++) {
            NSString *pathdir = [[path stringByDeletingLastPathComponent] stringByAppendingPathComponent:[pathext objectAtIndex:i]];
            NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:pathdir];
            for (int j=0; j<files.count; j++) {
                NSString *mfile = [files objectAtIndex:j];
                if ([[mfile pathExtension] isEqualToString:@"strings"]) {
                    NSString *pathfile = [pathdir stringByAppendingPathComponent:mfile];
                    NSURL *murl = [NSURL URLWithString:pathfile relativeToURL:[[panel URLs] objectAtIndex:0]];
                    [self decodeLocalStringContent: murl];
                    [self.localStringsTable reloadData];
                    count++;
                }
            }
        }
        NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:path];
        for (int i=0; i<files.count; i++) {
            NSString *mfile = [files objectAtIndex:i];
            if ([[mfile pathExtension] isEqualToString:@"strings"]) {
                if (![mfile containsString:@"zh-Hans.lproj"])
                {
                    NSURL *murl = [NSURL URLWithString:mfile relativeToURL:[[panel URLs] objectAtIndex:0]];
                    [self decodeLocalStringContent: murl];
                    [self.localStringsTable reloadData];
                    count++;
                }
            }
        }
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:@"提示"];
        [alert setInformativeText:[NSString stringWithFormat:@"读取文件成功!\r\n文件数:%d",count]];
        [alert addButtonWithTitle:@"确定"];
        [alert runModal];
    }
}
@end
