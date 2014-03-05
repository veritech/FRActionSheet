//
//  FRPickerActionSheet.m
//  Pods
//
//  Created by Jonathan Dalrymple on 12/12/2013.
//
//

#import "FRNetworkedPickerActionSheet.h"

@interface FRPickerActionSheet (protected)

- (UIView *)sheetView;
- (UILabel *)labelWithTitle:(NSString *)aTitle;
- (UIButton *)buttonWithTitle:(NSString *)aTitle
                      atIndex:(NSInteger)aIdx;
- (NSArray *)allButtonsInView:(UIView *)aView;
- (FRActionSheetHandlerBlock)handlerBlock;

@end

@interface FRNetworkedPickerActionSheet ()
//
//@property (nonatomic,strong) UIActivityIndicatorView *activityIndicatorView;
//@property (nonatomic,strong) UIPickerView *pickerView;
//@property (nonatomic,copy) NSArray *buttonTitles;

@property (nonatomic,strong) NSURLRequest *URLRequest;
@property (nonatomic,strong) NSString *JSONKeyPath;
@property (nonatomic,copy) FRNetworkedPickerActionSheetMappingBlock mappingBlock;

@end

#define kOptionsTitlesKeyPath @"pickerOptions"

@implementation FRNetworkedPickerActionSheet

- (id)initWithTitle:(NSString *)aString
            request:(NSURLRequest *)aRequest
            keyPath:(NSString *)aKeyPath
            mapping:(FRNetworkedPickerActionSheetMappingBlock)mappingBlock
            handler:(FRActionSheetHandlerBlock)aBlock
{
    self = [super initWithTitle:aString
                        handler:aBlock];
    
    if (self) {
        [self setURLRequest:aRequest];
        [self setJSONKeyPath:aKeyPath];
        [self setMappingBlock:mappingBlock];
    }
    return self;
}

- (void)showInView:(UIView *)aView
{
    [super showInView:aView];
    
    NSOperationQueue *operationQueue;
    
    operationQueue = [[NSOperationQueue alloc] init];
    
    [operationQueue setName:@"com.float-right.FRNetworkedPickerActionSheet"];
    
    [[self activityIndicatorView] startAnimating];
    
    [NSURLConnection sendAsynchronousRequest:[self URLRequest]
                                       queue:operationQueue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                              
                               id JSON;
                               NSError *error;
                               NSDictionary *options;
                               NSUInteger statusCode = 0;
                               
                               if ([response respondsToSelector:@selector(statusCode)]) {
//                                   NSLog(@"Status code %d",[(NSHTTPURLResponse *)response statusCode]);
                                   statusCode = [(NSHTTPURLResponse *)response statusCode];
                               }
                               
                               if (statusCode == 200 && (JSON = [NSJSONSerialization JSONObjectWithData:data
                                                                                                options:0
                                                                                                  error:&error])){
                                   
                                   options = [self optionsDictionaryWithJSON:JSON];
                                   
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       [self setPickerOptions:options];
                                   });
                               }
                               else {
                                   NSLog(@"Error %d %@",statusCode,error);
                               }
                           }];
}

- (void)handleError
{
    
}

- (NSDictionary *)optionsDictionaryWithJSON:(id)JSON
{
    NSMutableDictionary *options = [NSMutableDictionary dictionary];
    
    for (id object in [JSON valueForKeyPath:[self JSONKeyPath]]) {
        [options addEntriesFromDictionary:[self mappingBlock](object)];
    }
    return [options copy];
}

@end
