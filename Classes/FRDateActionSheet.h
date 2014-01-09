//
//  FRDateActionSheet.h
//
//  Created by Jonathan Dalrymple on 09/11/2013.
//
#import <UIKit/UIKit.h>

#import "FRActionSheet.h"

@class FRDateActionSheet;

typedef void(^FRDateActionSheetHandlerBlock)(FRDateActionSheet *sheet, NSDate *date);

@interface FRDateActionSheet : FRActionSheet

/**
 *  @param Sheet title text
 *  @param startDate
 *  @param endDate
 *  @param datePickerMode
 *  @param aBlock
 */
- (id)initWithTitle:(NSString *)aString
        minimumDate:(NSDate *)startDate
        maximumDate:(NSDate *)endDate
     datePickerMode:(UIDatePickerMode)mode
            handler:(FRDateActionSheetHandlerBlock)aBlock;


@end