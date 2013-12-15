//
//  FRPickerActionSheet.m
//  Pods
//
//  Created by Jonathan Dalrymple on 12/12/2013.
//
//

#import "FRPickerActionSheet.h"

@interface FRPickerActionSheet (protected)

- (UIView *)sheetView;
- (UILabel *)labelWithTitle:(NSString *)aTitle;
- (UIButton *)buttonWithTitle:(NSString *)aTitle
                      atIndex:(NSInteger)aIdx;
- (NSArray *)allButtonsInView:(UIView *)aView;

@end

@interface FRPickerActionSheet ()<UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic,strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic,strong) UIPickerView *pickerView;

@end

@implementation FRPickerActionSheet

- (id)initWithTitle:(NSString *)aString
            handler:(FRActionSheetHandlerBlock)aBlock
{
    
    self = [self initWithTitle:aString
                 buttonsTitles:@[NSLocalizedString(@"Accept",nil),NSLocalizedString(@"Cancel", nil)]
                       handler:aBlock];
    if (self) {
        
        [self addObserver:self
               forKeyPath:@"buttonTitles"
                  options:NSKeyValueObservingOptionNew
                  context:NULL];
        
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:@"buttonTitles"]) {
        [[self activityIndicatorView] setHidden:YES];
        [[self pickerView] setHidden:NO];
        [[self pickerView] reloadAllComponents];
    }
}

- (void)dealloc
{
    [self removeObserver:self
              forKeyPath:@"buttonTitles"];
}

- (UIView *)sheetViewWithTitle:(NSString *)aTitle
                  buttonTitles:(NSArray *)buttons
{
    
    UILabel *titleLabel;
    UIButton *button;
    UIPickerView *picker;
    UIView *sheetView = [[UIView alloc] initWithFrame:CGRectZero];
    
    titleLabel = [self labelWithTitle:aTitle];
    
    [sheetView addSubview:titleLabel];
    
    for (NSUInteger i=0; i< [buttons count]; i++) {
        
        button = [self buttonWithTitle:[buttons objectAtIndex:i]
                               atIndex:i];
        
        [sheetView addSubview:button];
    }
    
    [[self pickerView] setHidden:YES];
    [sheetView addSubview:[self activityIndicatorView]];
    [sheetView addSubview:[self pickerView]];
    
    [self layoutTitleLabel:titleLabel
                   buttons:[self allButtonsInView:sheetView]
                    inView:sheetView];
    
    return sheetView;
}

- (void)layoutActivityViewInView:(UIView *)aView
{
    
    [aView addSubview:[self activityIndicatorView]];
    
    [aView addConstraint:[NSLayoutConstraint constraintWithItem:aView
                                                      attribute:NSLayoutAttributeCenterX
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:[self activityIndicatorView]
                                                      attribute:NSLayoutAttributeCenterX
                                                     multiplier:1.0f
                                                       constant:0.0f]];
    
    [aView addConstraint:[NSLayoutConstraint constraintWithItem:aView
                                                      attribute:NSLayoutAttributeCenterY
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:[self activityIndicatorView]
                                                      attribute:NSLayoutAttributeCenterY
                                                     multiplier:1.0f
                                                       constant:0.0f]];
    
}

- (UIActivityIndicatorView *)activityIndicatorView
{
    if (!_activityIndicatorView) {
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
        [_activityIndicatorView startAnimating];
    }
    return _activityIndicatorView;
}

- (UIPickerView *)pickerView
{
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectZero];
        
        [_pickerView setDelegate:self];
        
        [_pickerView setDataSource:self];
    }
    
    return _pickerView;
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    return [[self buttonTitles] count];
}

#pragma mark - UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    return [[self buttonTitles] objectAtIndex:row];
}

#pragma mark -
///Customize the layout by overloading this method
- (void)layoutTitleLabel:(UILabel *)titleLabel
                 buttons:(NSArray *)buttons
                  inView:(UIView*)aView
{
    
    NSDictionary *views;
    NSDictionary *metrics = @{@"margin":@20};
    UIButton *button;
    
    views = @{
              @"okButton":[buttons firstObject],
              @"cancelButton":[buttons lastObject],
              @"titleLabel":titleLabel,
              @"picker":[self pickerView],
              @"activityIndicatorView":[self activityIndicatorView]
              };
    
    [[views allValues] setValue:@NO
                     forKeyPath:@"translatesAutoresizingMaskIntoConstraints"];
    
    [self layoutActivityViewInView:aView];
    
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

@end