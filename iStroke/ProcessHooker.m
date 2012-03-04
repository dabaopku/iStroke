//
//  Created by dabao on 12-2-9.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "ProcessHooker.h"

@implementation ProcessHooker

+ (NSDictionary *)getActiveProcess {
	NSDictionary *dict = [[NSWorkspace sharedWorkspace] activeApplication];
	return dict;
	/*
This is sample result of chrome
We can use NSApplicationBundleIdentifier to distinguish applications
{
	NSApplicationBundleIdentifier = "com.google.Chrome";
	NSApplicationName = "Google Chrome \U6d4f\U89c8\U5668";
	NSApplicationPath = "/Applications/\U7f51\U7edc/Google Chrome.app";
	NSApplicationProcessIdentifier = 1784;
	NSApplicationProcessSerialNumberHigh = 0;
	NSApplicationProcessSerialNumberLow = 393312;
	NSWorkspaceApplicationKey = "<NSRunningApplication: 0x101e5df50 (com.google.Chrome - 1784)>";
}
*/
}

+ (NSString *)getActiveProcessIdentifier {
	NSDictionary *dict = [self getActiveProcess];
	return [dict objectForKey:@"NSApplicationBundleIdentifier"];
}

static NSString *iStrokeIdentifier = kiStrokeIdentifier;

+ (bool)isStroke {
	NSString *str = [self getActiveProcessIdentifier];
	bool res = [str isEqualToString:iStrokeIdentifier];
	return res;
}

@end