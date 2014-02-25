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

///The Keys are displayed, values are provided
@property (nonatomic,copy) NSDictionary *pickerOptions;
@property (nonatomic,copy) NSArray *sortDescriptors;

@property (nonatomic,strong,readonly) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic,strong,readonly) UIPickerView *pickerView;

- (NSArray *)sortedPickerOptionKeys;

- (id)initWithTitle:(NSString *)aString
            handler:(FRActionSheetHandlerBlock)aBlock;

@end
