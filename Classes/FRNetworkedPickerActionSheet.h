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

- (NSArray *)sortedPickerOptionKeys;

- (id)initWithTitle:(NSString *)aString
            handler:(FRActionSheetHandlerBlock)aBlock;

- (id)initWithTitle:(NSString *)aString
            request:(NSURLRequest *)aRequest
      titlesKeyPath:(NSString *)titleKeyPath
      valuesKeyPath:(NSString *)valueKeyPath
            handler:(FRActionSheetHandlerBlock)aBlock;

@end
