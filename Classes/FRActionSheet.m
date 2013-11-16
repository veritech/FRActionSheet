//
//  FRActionSheet.m
//
//  Created by Jonathan Dalrymple on 09/11/2013.
//

#import "FRActionSheet.h"

@interface FRActionSheet ()

@property (nonatomic,weak) UIView *sheetView;

@property (nonatomic,copy) NSString *nibName;
@property (nonatomic,copy) NSArray *buttonTitles;
@property (nonatomic,copy) NSString *sheetTitle;

@property (nonatomic,copy) FRActionSheetHandlerBlock handlerBlock;

@end

#define kAnimationDuration 0.15f

@implementation FRActionSheet

@synthesize sheetBackgroundColor = _sheetBackgroundColor;

#pragma mark - Object life cycle
- (id)initWithNibNamed:(NSString *)nibName
               handler:(FRActionSheetHandlerBlock)aBlock
{
    self = [self initWithFrame:CGRectZero];
    if (self) {
        [self setNibName:nibName];
        [self setHandlerBlock:aBlock];
    }
    return self;
}

- (id)initWithButtonsTitles:(NSArray *)buttonTitles
                    handler:(FRActionSheetHandlerBlock)aBlock
{
    return [self initWithTitle:nil
                 buttonsTitles:buttonTitles
                       handler:aBlock];
}

- (id)initWithTitle:(NSString *)aString
      buttonsTitles:(NSArray *)buttonTitles
            handler:(FRActionSheetHandlerBlock)aBlock
{
    self = [self initWithFrame:CGRectZero];
    if (self) {
        [self setSheetTitle:aString];
        [self setButtonTitles:buttonTitles];
        [self setHandlerBlock:aBlock];
        [self setSheetBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}

#pragma mark - forwarded messages
- (void)setSheetBackgroundColor:(UIColor *)aSheetBackgroundColor
{
    [[self sheetView] setBackgroundColor:aSheetBackgroundColor];
    
    _sheetBackgroundColor = aSheetBackgroundColor;
}

- (UIColor *)sheetBackgroundColor
{
    if ([[self sheetView] backgroundColor]) {
        return [self sheetBackgroundColor];
    }
    return _sheetBackgroundColor;
}

#pragma mark - sheet view
- (UIView *)sheetViewWithNibNamed:(NSString *)aNibName
{

    UIView *subview;
    CGRect sheetFrame;
    
    subview = [[[UINib nibWithNibName:aNibName
                               bundle:nil] instantiateWithOwner:nil
                options:nil] firstObject];
    
    sheetFrame = [subview frame];
    
    //Position off screen
    sheetFrame.origin.y = CGRectGetHeight([self frame]);
    
    [subview setFrame:sheetFrame];
    
    return subview;
}

- (UIView *)sheetViewWithTitle:(NSString *)aTitle
                  buttonTitles:(NSArray *)buttons
{
    
    UILabel *titleLabel;
    UIButton *button;
    UIView *sheetView = [[UIView alloc] initWithFrame:CGRectZero];
    
    titleLabel = [self labelWithTitle:aTitle];
    
    [sheetView addSubview:titleLabel];

    for (NSUInteger i=0; i< [buttons count]; i++) {
        
        button = [self buttonWithTitle:[buttons objectAtIndex:i]
                               atIndex:i];
        
        [sheetView addSubview:button];
    }
    
    [self layoutTitleLabel:titleLabel
                   buttons:[self allButtonsInView:sheetView]
                    inView:sheetView];

    return sheetView;
}

#pragma mark - Layout
///Customize the layout by overloading this method
- (void)layoutTitleLabel:(UILabel *)titleLabel
                 buttons:(NSArray *)buttons
                  inView:(UIView*)aView
{
 
    NSDictionary *views;
    NSDictionary *metrics = @{@"margin":@10};
    UIButton *button;
    
    [titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [aView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[titleLabel]-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(titleLabel)]];
    
    [aView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[titleLabel]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(titleLabel)]];
    
    for (NSUInteger i=0; i < [buttons count]; i++) {
        
        //Turn off resizing masks
        button = [buttons objectAtIndex:i];
        
        [button setTranslatesAutoresizingMaskIntoConstraints:NO];
       
        if (i==0) {
            views = @{
                      @"button":button,
                      @"neighbour":titleLabel
                      };
        }
        else {
            views = @{
                      @"button": button,
                      @"neighbour":[buttons objectAtIndex:i-1]
                      };
        }
        
        [aView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[neighbour]-(==margin)-[button(==40)]"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:views]];
        
        [aView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[button(==280)]-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
        
        if (i== ([buttons count]-1)) { //Bottom item is also pinned to the bottom

            [aView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[button]-(==margin)-|"
                                                                          options:0
                                                                          metrics:metrics
                                                                            views:views]];
        }

    }

}

#pragma mark - Display and dismiss the view
- (void)showInView:(UIView *)view
{

    UIView *sheetView;
    CGRect sheetFrame = CGRectZero;
    
    //Use a nib?
    if ([self nibName]) {
        sheetView = [self sheetViewWithNibNamed:[self nibName]];
        sheetFrame = [sheetView frame];
    }
    else {
        sheetView = [self sheetViewWithTitle:[self sheetTitle]
                                buttonTitles:[self buttonTitles]];
        
        sheetFrame.size = [sheetView systemLayoutSizeFittingSize:UILayoutFittingExpandedSize];
        sheetFrame.size.width = CGRectGetWidth([view frame]);
    }

    //Position off screen
    sheetFrame.origin.y = CGRectGetHeight([view frame]);
    
    [sheetView setFrame:sheetFrame];
    
    [self setSheetView:sheetView];
    
    [self setSheetBackgroundColor:_sheetBackgroundColor];
    
    //Register all the buttons
    for (UIButton *button in [self allButtonsInView:sheetView]) {
        [button addTarget:self
                   action:@selector(didSelectButton:)
         forControlEvents:UIControlEventTouchUpInside];
    }
    
    //Configure the overlay
    [self setBackgroundColor:[UIColor colorWithWhite:1.0f
                                               alpha:0.0f]];
    [self setFrame:[view frame]];
    [self addSubview:sheetView];
    
    //Add the overlay & sheet to the view
    [[view superview] addSubview:self];

    //Setup the overlay catcher
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                       action:@selector(dismiss)]];
    
    [[[self gestureRecognizers] firstObject] setNumberOfTapsRequired:1];
    
    [self setUserInteractionEnabled:YES];
    
    //Animate on screen
    sheetFrame.origin.y -= CGRectGetHeight(sheetFrame);
    
    [UIView animateWithDuration:kAnimationDuration
                     animations:^{
                         [[self sheetView] setFrame:sheetFrame];
                         [self setBackgroundColor:[UIColor colorWithWhite:0.0f
                                                                    alpha:0.5f]];
                     }
                     completion:nil];
    
}

- (void)dismiss
{
    CGRect sheetFrame = [[self sheetView] frame];
    
    sheetFrame.origin.y += CGRectGetHeight(sheetFrame);
    
    [UIView animateWithDuration:kAnimationDuration
                     animations:^{
                         [[self sheetView] setFrame:sheetFrame];
                         [self setBackgroundColor:[UIColor clearColor]];
                     }
                     completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];

}

- (void)didSelectButton:(UIButton *)aButton
{
    [self handlerBlock](self,[aButton tag]);
}

#pragma mark - Utilities
- (UIButton *)buttonWithTitle:(NSString *)aTitle
                      atIndex:(NSInteger)aIdx
{
    
    UIButton *button;
    
    if ([[self decorator] respondsToSelector:@selector(actionSheet:buttonWithTitle:atIndex:)]) {
        button = [[self decorator] actionSheet:self
                               buttonWithTitle:aTitle
                                       atIndex:aIdx];
    }
    else {
        
        button = [UIButton buttonWithType:UIButtonTypeSystem];
        
        [button setTitle:aTitle
                forState:UIControlStateNormal];
        
    }

    [button setTag:aIdx];
    
    return button;
}

- (UILabel *)labelWithTitle:(NSString *)aTitle
{
    UILabel *titleLabel;
    
    if ([[self decorator] respondsToSelector:@selector(actionSheet:labelWithTitle:)]){
        titleLabel = [[self decorator] actionSheet:self
                                    labelWithTitle:aTitle];
    }
    else {
        titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        
        [titleLabel setText:aTitle];
        
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
    }
    
    return titleLabel;
}

- (NSArray *)allButtonsInView:(UIView *)aView
{
    NSPredicate *predicate;
    
    predicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        
        if ([evaluatedObject isKindOfClass:[UIButton class]]) {
            return YES;
        }
        return NO;
    }];
    
    return [[aView subviews] filteredArrayUsingPredicate:predicate];
}


@end
