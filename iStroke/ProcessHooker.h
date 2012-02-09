//
//  Created by dabao on 12-2-9.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface ProcessHooker : NSObject {

}

+(NSDictionary *) getActiveProcess;
+(NSString *) getActiveProcessIdentifier;
+(bool) isSelfProcess;

@end