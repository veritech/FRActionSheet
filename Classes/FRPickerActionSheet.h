//
//  FRPickerActionSheet.h
//  Pods
//
//  Created by Jonathan Dalrymple on 12/12/2013.
//
//

#import "FRActionSheet.h"

typedef NS_OPTIONS(NSInteger, FRPickerActionSheetOption){
    FRPickerActionSheetOptionAccept,
    FRPickerActionSheetOptionCancel
};

@interface FRPickerActionSheet : FRActionSheet

@property (nonatomic,copy) NSArray *optionTitles;

- (id)initWithTitle:(NSString *)aString
            handler:(FRActionSheetHandlerBlock)aBlock;

@end
