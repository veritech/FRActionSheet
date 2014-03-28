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

@interface FRDateActionSheet()<UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic,copy) FRDateActionSheetHandlerBlock handlerBlock;
@property (nonatomic,copy) NSDate *maximumDate;
@property (nonatomic,copy) NSDate *minimumDate;
@property (nonatomic,assign) NSInteger pickerMode;
@property (nonatomic,strong) NSDateFormatter *dateFormatter;
@property (nonatomic,copy) NSDate *defaultDate;

@end

#define kAnimationDuration 0.15f

@implementation FRDateActionSheet

#pragma mark - Object life cycle
- (id)initWithTitle:(NSString *)aString
        minimumDate:(NSDate *)startDate
        maximumDate:(NSDate *)endDate
        defaultDate:(NSDate *)aDate
     datePickerMode:(NSInteger)mode
            handler:(FRDateActionSheetHandlerBlock)aBlock
{
    
    self = [self initWithTitle:aString
                   minimumDate:startDate
                   maximumDate:endDate
                datePickerMode:mode
                       handler:aBlock];
    if (self) {
        [self setDefaultDate:aDate];
    }
    return self;
}

- (id)initWithTitle:(NSString *)aString
        minimumDate:(NSDate *)startDate
        maximumDate:(NSDate *)endDate
     datePickerMode:(NSInteger)mode
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
    id datePicker;
    UIView *sheetView = [[UIView alloc] initWithFrame:CGRectZero];
    
    titleLabel = [self labelWithTitle:aTitle];
    
    [sheetView addSubview:titleLabel];

    for (NSUInteger i=0; i< [buttons count]; i++) {
        
        button = [self buttonWithTitle:[buttons objectAtIndex:i]
                               atIndex:i];
        
        [sheetView addSubview:button];
    }
    
    if ([self pickerMode] == FRDateActionSheetMonthMode) {
        
        datePicker = [[UIPickerView alloc] initWithFrame:CGRectZero];
        
        [datePicker setDelegate:self];
        
        if ([self defaultDate]) {
            [datePicker selectRow:([self monthForDate:[self defaultDate]] - 1)
                      inComponent:0
                         animated:NO];
        }

    }
    else {
        datePicker = [[UIDatePicker alloc] initWithFrame:CGRectZero];
        
        [datePicker setMaximumDate:[self maximumDate]];
        [datePicker setMinimumDate:[self minimumDate]];
        [datePicker setDatePickerMode:[self pickerMode]];
        
        if ([self defaultDate]) {
            [datePicker setDate:[self defaultDate]];
        }
    }
    
    [datePicker setTag:20];
    
    [sheetView addSubview:datePicker];
    
    [self layoutTitleLabel:titleLabel
                   buttons:[self allButtonsInView:sheetView]
                    inView:sheetView];

    return sheetView;
}

#pragma mark -
- (UIDatePicker *)datePickerView
{
    return (UIDatePicker *)[[self sheetView] viewWithTag:20];
}

- (UIPickerView *)pickerView
{
    return (UIPickerView *)[[self sheetView] viewWithTag:20];
}

#pragma mark - UIPickerDataSource
- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    return [[self localizedMonths] objectAtIndex:row];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    return [[self localizedMonths] count];;
}

#pragma mark -
- (NSUInteger)monthForDate:(NSDate*)aDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitMonth
                                               fromDate:aDate];
    
    return [components month];
}

- (NSArray *)localizedMonths
{
    static NSArray *localizedMonths;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableArray *months;
        NSRange range;
        
        range = [[NSCalendar currentCalendar] rangeOfUnit:NSMonthCalendarUnit
                                                   inUnit:NSYearCalendarUnit
                                                  forDate:[NSDate date]];
        
        months = [NSMutableArray arrayWithCapacity:range.length];
        
        for (NSInteger i=1; i<=range.length;i++){
            [months addObject:[[self dateFormater] stringFromDate:[self dateWithMonth:i]]];
        }
        
        localizedMonths = [months copy];
    });
    
    return localizedMonths;
}

- (NSDateFormatter *)dateFormater
{
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        
        [_dateFormatter setDateFormat:@"MMMM"];
    }
    return _dateFormatter;
}

- (NSDate *)dateWithMonth:(NSInteger)aMonth
{
    NSDateComponents *components;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit
                             fromDate:[NSDate date]];
    
    [components setMonth:aMonth];
    
    return [calendar dateFromComponents:components];
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
    if ([self handlerBlock] && [aButton tag] == 1) {   //Cancel button
        [self handlerBlock](self,nil);
    }
    else if ([self handlerBlock] && [self pickerMode] == FRDateActionSheetMonthMode){
        [self handlerBlock](self,[self dateWithMonth:[[self pickerView] selectedRowInComponent:0]+1]);
    }
    else {
        [self handlerBlock](self,[[self datePickerView] date]);
    }
    
    [self dismiss];
}

@end
