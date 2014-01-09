//
//  FRDateActionSheet.m
//
//  Created by Jonathan Dalrymple on 09/11/2013.
//

#import "FRDateActionSheet.h"

@interface FRDateActionSheet (protected)

- (UIView *)sheetView;
- (UILabel *)labelWithTitle:(NSString *)aTitle;
- (UIButton *)buttonWithTitle:(NSString *)aTitle
                      atIndex:(NSInteger)aIdx;
- (NSArray *)allButtonsInView:(UIView *)aView;

@end

@interface FRDateActionSheet()

@property (nonatomic,copy) FRDateActionSheetHandlerBlock handlerBlock;
@property (nonatomic,copy) NSDate *maximumDate;
@property (nonatomic,copy) NSDate *minimumDate;
@property (nonatomic,assign) UIDatePickerMode pickerMode;

@end

#define kAnimationDuration 0.15f

@implementation FRDateActionSheet

#pragma mark - Object life cycle
- (id)initWithTitle:(NSString *)aString
        minimumDate:(NSDate *)startDate
        maximumDate:(NSDate *)endDate
     datePickerMode:(UIDatePickerMode)mode
            handler:(FRDateActionSheetHandlerBlock)aBlock
{
    
    self = [self initWithTitle:aString
                 buttonsTitles:@[NSLocalizedString(@"Accept",nil),NSLocalizedString(@"Cancel", nil)]
                       handler:nil];
    if (self) {
        [self setHandlerBlock:aBlock];
        [self setMinimumDate:startDate];
        [self setMaximumDate:endDate];
        [self setPickerMode:mode];
    }
    return self;
}


#pragma mark - sheet view
- (UIView *)sheetViewWithTitle:(NSString *)aTitle
                  buttonTitles:(NSArray *)buttons
{
    
    UILabel *titleLabel;
    UIButton *button;
    UIDatePicker *datePicker;
    UIView *sheetView = [[UIView alloc] initWithFrame:CGRectZero];
    
    titleLabel = [self labelWithTitle:aTitle];
    
    [sheetView addSubview:titleLabel];

    for (NSUInteger i=0; i< [buttons count]; i++) {
        
        button = [self buttonWithTitle:[buttons objectAtIndex:i]
                               atIndex:i];
        
        [sheetView addSubview:button];
    }
    
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectZero];
    
    [datePicker setMaximumDate:[self maximumDate]];
    [datePicker setMinimumDate:[self minimumDate]];
    [datePicker setDatePickerMode:[self pickerMode]];
    
    [datePicker setTag:20];
    
    [sheetView addSubview:datePicker];
    
    [self layoutTitleLabel:titleLabel
                   buttons:[self allButtonsInView:sheetView]
                    inView:sheetView];

    return sheetView;
}

- (UIDatePicker *)datePickerView
{
    return (UIDatePicker *)[[self sheetView] viewWithTag:20];
}

#pragma mark - Layout
///Customize the layout by overloading this method
- (void)layoutTitleLabel:(UILabel *)titleLabel
                 buttons:(NSArray *)buttons
                  inView:(UIView*)aView
{
 
    NSDictionary *views;
    NSDictionary *metrics = @{@"margin":@20};
    
    views = @{
              @"okButton":[buttons firstObject],
              @"cancelButton":[buttons lastObject],
              @"titleLabel":titleLabel,
              @"picker":[[aView subviews] lastObject],
              };
    
    [[views allValues] setValue:@NO
                     forKeyPath:@"translatesAutoresizingMaskIntoConstraints"];
    
    //Vertical
    [aView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(<=margin)-[titleLabel]-[picker]-[okButton]-|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
    
    //Align the buttons
    [aView addConstraint:[NSLayoutConstraint constraintWithItem:[views objectForKey:@"okButton"]
                                                      attribute:NSLayoutAttributeCenterY
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:[views objectForKey:@"cancelButton"]
                                                      attribute:NSLayoutAttributeCenterY
                                                     multiplier:1.0f
                                                       constant:0.0f]];
    
    //Horizontal layout
    [aView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(==margin)-[titleLabel]-(==margin)-|"
                                                                  options:0
                                                                  metrics:metrics
                                                                    views:views]];
    
    [aView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[picker]-|"
                                                                  options:0
                                                                  metrics:metrics
                                                                    views:views]];
    
    [aView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(==margin)-[okButton(==cancelButton)]-[cancelButton]-(==margin)-|"
                                                                  options:0
                                                                  metrics:metrics
                                                                    views:views]];

}

- (void)didSelectButton:(UIButton *)aButton
{
    if ([self handlerBlock]){
        [self handlerBlock](self,[[self datePickerView] date]);
    }
    
    [self dismiss];
}

@end
