//
//  ApplicationManager.mm
//  iStroke
//
//  Created by dabao on 12-3-6.
//  Copyright 2012年 PKU. All rights reserved.
//

#import "ApplicationManager.hh"
#import "Application.hh"

@implementation ApplicationManager

@synthesize applications;
@synthesize curApp;

-(id) init
{
    self=[super init];
    if (self) {
        applications=[NSMutableArray new];
        curApp=[[Application alloc] init];
        curApp.name=NSLocalizedString(@"Default", @"");
        curApp.identifier=kiStrokeIdentifier;
        [applications addObject:[curApp retain]];
    }
    return self;
}

-(void) dealloc
{
    [commandTypeDelegate release];
}

-(Application *) findApplication:(NSString *)identifier
{
    NSMutableArray *queue=[NSMutableArray new];
    [queue addObjectsFromArray:applications];
    while ([queue count]>0) {
        Application *app=[queue objectAtIndex:0];
        [queue removeObjectAtIndex:0];
        if ([app.identifier isEqualToString:identifier]) {
            return app;
        }
        [queue addObjectsFromArray:app.children];
    }
    return nil;
}

-(void) addAction:(id)action
{
    assert([action isKindOfClass:[Action class]]);
    [curApp.actions addObject:[action retain]];
}

-(BOOL) addApplication:(NSString *)appIdentifier
{
    Application *app=[self findApplication:appIdentifier];
    if (app!=nil) {
        return NO;
    }
    app=[[Application alloc] init];
    app.identifier=appIdentifier;
    app.name=appIdentifier;
    
    Application *parent=curApp.parent;
    if (parent==nil) {
        [applications addObject:app];
    }
    else
    {
        [parent.children addObject:app];
    }
    return YES;
}

-(void) addGroup
{
    Application *app=[[Application alloc] init];
    app.name=[NSString stringWithFormat:NSLocalizedString(@"Group%i",@""),[applications count]];
    app.identifier=[NSString stringWithFormat:@"%ld",(long)(100*(double)[[NSDate date] timeIntervalSince1970])];
    app.parent=nil;
    [applications addObject:[app retain]];
    [applicationOutlineView reloadData];
}

-(void) save
{
    NSFileManager *fm=[NSFileManager defaultManager];
    NSString *dir=[NSHomeDirectory() stringByAppendingFormat:@"/Library/iStroke/settings/"];
    BOOL isDir=YES;
    if (![fm fileExistsAtPath:dir isDirectory:&isDir]) {
        if (![fm createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:nil]) 
        {
            NSLog(@"Error: Create folder failed %@",dir);
            return;
        }
    }
    
    NSString *path=[dir stringByAppendingString:@"applications.plist"];
    
    NSMutableArray *array=[NSMutableArray new];
    
    for (NSUInteger i=0,n=[applications count]; i<n; ++i) {
        NSDictionary *dict=[(Application*)[applications objectAtIndex:i] save];
        [array addObject:dict];
        [dict release];
    }
    
    [array writeToFile:path atomically:YES];
    [array release];
    
}

-(void) load
{
    
}

#pragma mark - NSOutlineView

-(id) outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item
{
    if (item) {
        return [[(Application*)item children] objectAtIndex:index];
    }
    else
    {
        return [applications objectAtIndex:index];
    }
}

-(BOOL) outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item
{
    if (!item) {
        return [applications count]>1;
    }
    return [[(Application*)item children] count]>0;
}

-(NSInteger) outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item
{
    if(item==nil)
        return [applications count];
    
    return [[(Application *)item children] count];
}

-(id) outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item
{
    return ((Application*)item).name;
}


-(void) outlineView:(NSOutlineView *)outlineView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn byItem:(id)item
{
    if ([item isKindOfClass:[Application class]]) {
        [(Application *)item setName:object];
    }
}

-(BOOL) outlineView:(NSOutlineView *)outlineView shouldSelectItem:(id)item
{
    [curApp release];
    curApp=[item retain];
    [gestureTableView reloadData];
    return YES;
}

#pragma mark - drag drop

-(BOOL) outlineView:(NSOutlineView *)outlineView writeItems:(NSArray *)items toPasteboard:(NSPasteboard *)pasteboard
{
    [pasteboard declareTypes:[NSArray arrayWithObject:ApplicationPasteType] owner:self];
    if ([items count]>0) {
        Application *app = [items objectAtIndex:0];
        NSData *data=[[app identifier] dataUsingEncoding:NSUTF8StringEncoding];
        [pasteboard setData:data forType:ApplicationPasteType];
    }
    
    return YES;
}

-(NSDragOperation) outlineView:(NSOutlineView *)outlineView validateDrop:(id<NSDraggingInfo>)info proposedItem:(id)item proposedChildIndex:(NSInteger)index
{
    return NSDragOperationMove;
}

-(BOOL) outlineView:(NSOutlineView *)outlineView acceptDrop:(id<NSDraggingInfo>)info item:(id)item childIndex:(NSInteger)index
{
    NSPasteboard *pasteboard=[info draggingPasteboard];
    NSData *data=[pasteboard dataForType:ApplicationPasteType];
    
    if (data) {
        NSString *identifier=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        Application *app=[self findApplication:identifier];
        if (app) {
            Application *from=app;
            Application *to=(Application*)item;
            
            if([to isEqual:from])
            {
                return YES;
            }
            
            if (to==nil) {
                if (from.parent) {
                    [from removeFromParent];
                    [applications addObject:from];
                }
                [applicationOutlineView reloadData];
                return YES;
            }
            
            Application *toParent=to.parent;
            while (toParent) {
                if ([toParent isEqual:from]) {
                    return YES;
                }
                toParent=toParent.parent;
            }
            
            if (from.parent) {
                [from removeFromParent];
            }
            else
            {
                [applications removeObject:from];
            }
            
            [to addChildApplication:from];
            
            [applicationOutlineView reloadData];
            return YES;
        }
    }
    return NO;
}

// drag operation stuff
- (BOOL)tableView:(NSTableView *)tv 
writeRowsWithIndexes:(NSIndexSet *)rowIndexes 
     toPasteboard:(NSPasteboard*)pboard {
    
    /*
     
     // Copy the row numbers to the pasteboard.
     NSData *zNSIndexSetData = 
     [NSKeyedArchiver archivedDataWithRootObject:rowIndexes];
     [pboard declareTypes:[NSArray arrayWithObject:MyPrivateTableViewDataType]
     owner:self];
     [pboard setData:zNSIndexSetData forType:MyPrivateTableViewDataType];*/
    return YES;
}

- (NSDragOperation)tableView:(NSTableView*)tv 
                validateDrop:(id )info 
                 proposedRow:(NSInteger)row 
       proposedDropOperation:(NSTableViewDropOperation)op {
    // Add code here to validate the drop
    
    NSLog(@"drop");
    return NSDragOperationEvery;
}

- (BOOL)tableView:(NSTableView *)aTableView 
       acceptDrop:(id )info
              row:(NSInteger)row 
    dropOperation:(NSTableViewDropOperation)operation {
    
    NSLog(@"Accept");/*
                      NSPasteboard* pboard = [info draggingPasteboard];
                      NSData* rowData = [pboard dataForType:MyPrivateTableViewDataType];
                      NSIndexSet* rowIndexes = 
                      [NSKeyedUnarchiver unarchiveObjectWithData:rowData];
                      NSInteger dragRow = [rowIndexes firstIndex];
                      
                      // Move the specified row to its new location...
                      // if we remove a row then everything moves down by one
                      // so do an insert prior to the delete
                      // --- depends which way were moving the data!!!
                      if (dragRow < row) {
                      [nsAryOfDataValues insertObject:
                      [nsAryOfDataValues objectAtIndex:dragRow] atIndex:row];
                      [nsAryOfDataValues removeObjectAtIndex:dragRow];
                      [self.nsTableViewObj noteNumberOfRowsChanged];
                      [self.nsTableViewObj reloadData];
                      
                      return YES;
                      
                      } // end if
                      
                      MyData * zData = [nsAryOfDataValues objectAtIndex:dragRow];
                      [nsAryOfDataValues removeObjectAtIndex:dragRow];
                      [nsAryOfDataValues insertObject:zData atIndex:row];
                      [self.nsTableViewObj noteNumberOfRowsChanged];
                      [self.nsTableViewObj reloadData];
                      */
    return YES;
}

#pragma mark - NSTableView


-(NSInteger) numberOfRowsInTableView:(NSTableView *)tableView
{
    return [curApp.actions count];
}

-(id) tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSString *col=[tableColumn identifier];
    Action *act=[curApp.actions objectAtIndex:row];
    
    if ([col isEqualToString:@"gesture"]) {
        return [act image];
    }
    if ([col isEqualToString:@"name"]) {
        return [act name];
    }
    if ([col isEqualToString:@"type"]) {
        return CommandType::ToString(act.cmd.type);
    }
    if ([col isEqualToString:@"cmd"]) {
        return [act name];
    }
    return nil;
}

-(void) tableView:(NSTableView *)tableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSString *col=[tableColumn identifier];
    Action *act=[curApp.actions objectAtIndex:row];
    
    if([col isEqualToString:@"type"])
    {
        act.cmd.type=[commandTypeDelegate index:object];
    }
}

-(void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    
    if([[tableColumn identifier] isEqual:@"type"] && [cell isKindOfClass:[NSComboBoxCell class]])
    {
        [cell setRepresentedObject:[commandTypeDelegate typeList]];
        [cell reloadData];
    }
    if ([cell isKindOfClass:[NSTextFieldCell class]]) {
        [(NSTextFieldCell *)cell setVerticalCentering:YES];
    }
}


@end

