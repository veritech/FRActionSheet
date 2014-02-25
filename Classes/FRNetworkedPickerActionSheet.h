//
//  FRNetworkedPickerActionSheet.h
//  Pods
//
//  Created by Jonathan Dalrymple on 24/02/2014.
//
//

#import "FRPickerActionSheet.h"

typedef NSDictionary *(^FRNetworkedPickerActionSheetMappingBlock)(id obj);

@interface FRNetworkedPickerActionSheet : FRPickerActionSheet

- (id)initWithTitle:(NSString *)aString
            request:(NSURLRequest *)aRequest
            keyPath:(NSString *)aKeyPath
            mapping:(FRNetworkedPickerActionSheetMappingBlock)mappingBlock
            handler:(FRActionSheetHandlerBlock)aBlock;

@end
