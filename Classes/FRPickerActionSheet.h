//
//  FRPickerActionSheet.h
//  Pods
//
//  Created by Jonathan Dalrymple on 12/12/2013.
//
//

#import "FRActionSheet.h"

@interface FRPickerActionSheet : FRActionSheet

@property (nonatomic,copy) NSArray *buttonTitles;

- (id)initWithTitle:(NSString *)aString
            handler:(FRActionSheetHandlerBlock)aBlock;

@end
