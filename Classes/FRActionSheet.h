//
//  FRActionSheet.h
//
//  Created by Jonathan Dalrymple on 09/11/2013.
//
#import <UIKit/UIKit.h>

@class FRActionSheet;

@protocol FRActionSheetDecorator <NSObject>

/**
 *  Provide a label with the give title
 */
- (UILabel *)actionSheet:(FRActionSheet *)sheet
          labelWithTitle:(NSString *)aTitle;

/**
 *  Provide a button for a given index
 */
- (UIButton *)actionSheet:(FRActionSheet *)sheet
          buttonWithTitle:(NSString *)aString
                  atIndex:(NSInteger)index;

@end

typedef void(^FRActionSheetHandlerBlock)(FRActionSheet *sheet, NSInteger idx);

@interface FRActionSheet : UIView

///The decorator object
@property (nonatomic,weak) id<FRActionSheetDecorator>decorator;

///Sheet background color
@property (nonatomic,copy) UIColor *sheetBackgroundColor;


/**
 *  @param nibName  The Nibname
 *  @param aBlock   The block to be called when a button inside the nib is touched, the buttons tag is passed to the block
 */
- (id)initWithNibNamed:(NSString *)nibName
               handler:(FRActionSheetHandlerBlock)aBlock;

/**
 *  @param buttonTitles The titles of the buttons to show
 *  @param aBlock The block to be called when a button inside the nib is touched, the buttons tag is passed to the block
 */
- (id)initWithButtonsTitles:(NSArray *)buttonTitles
                    handler:(FRActionSheetHandlerBlock)aBlock;

/**
 *  @param Sheet title text
 *  @param buttonTitles The titles of the buttons to show
 *  @param aBlock The block to be called when a button inside the nib is touched, the buttons tag is passed to the block
 */
- (id)initWithTitle:(NSString *)aString
      buttonsTitles:(NSArray *)buttonTitles
            handler:(FRActionSheetHandlerBlock)aBlock;

/**
 *  Present the actionsheet in the given view animated
 *  @param aView    The view to present the sheet in
 */
- (void)showInView:(UIView *)aView;

/**
 *  Dismiss the view
 */
- (void)dismiss;

@end