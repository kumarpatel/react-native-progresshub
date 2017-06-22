//
//  RNProgressHUB.m
//  RNProgressHUB
//
//  Created by ma arno on 16/9/12.
//  Copyright © 2016年 amsoft. All rights reserved.
//

#import "RNProgressHUB.h"
#import "MBProgressHUD.h"


typedef NS_ENUM(NSInteger, RNProgressHUBMode) {
    /// Ring-shaped progress view.
    RNProgressHUBModeAnnularDeterminate,
    /// Horizontal progress bar.
    RNProgressHUBModeDeterminateHorizontalBar
};

@interface RNProgressHUB()


@property (nonatomic,strong) MBProgressHUD *hub;
@property (nonatomic,strong) UIWindow *window;


@end

@implementation RNProgressHUB


-(UIWindow *)window{
    if (!_window) {
        _window = [UIApplication sharedApplication].keyWindow;
    }
    return _window;
}

+(UIColor *)colorFromHexString:(NSString *)hexString {
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString: @"#" withString: @""] uppercaseString];
    CGFloat alpha, red, blue, green;
    switch ([colorString length]) {
        case 3: // #RGB
            alpha = 1.0f;
            red   = [RNProgressHUB colorComponentFrom: colorString start: 0 length: 1];
            green = [RNProgressHUB colorComponentFrom: colorString start: 1 length: 1];
            blue  = [RNProgressHUB colorComponentFrom: colorString start: 2 length: 1];
            break;
        case 4: // #ARGB
            alpha = [RNProgressHUB colorComponentFrom: colorString start: 0 length: 1];
            red   = [RNProgressHUB colorComponentFrom: colorString start: 1 length: 1];
            green = [RNProgressHUB colorComponentFrom: colorString start: 2 length: 1];
            blue  = [RNProgressHUB colorComponentFrom: colorString start: 3 length: 1];
            break;
        case 6: // #RRGGBB
            alpha = 1.0f;
            red   = [RNProgressHUB colorComponentFrom: colorString start: 0 length: 2];
            green = [RNProgressHUB colorComponentFrom: colorString start: 2 length: 2];
            blue  = [RNProgressHUB colorComponentFrom: colorString start: 4 length: 2];
            break;
        case 8: // #AARRGGBB
            alpha = [RNProgressHUB colorComponentFrom: colorString start: 0 length: 2];
            red   = [RNProgressHUB colorComponentFrom: colorString start: 2 length: 2];
            green = [RNProgressHUB colorComponentFrom: colorString start: 4 length: 2];
            blue  = [RNProgressHUB colorComponentFrom: colorString start: 6 length: 2];
            break;
        default:
            [NSException raise:@"Invalid color value" format: @"Color value %@ is invalid.  It should be a hex value of the form #RBG, #ARGB, #RRGGBB, or #AARRGGBB", hexString];
            break;
    }
    return [UIColor colorWithRed: red green: green blue: blue alpha: alpha];
    
}

+ (CGFloat) colorComponentFrom: (NSString *) string start: (NSUInteger) start length: (NSUInteger) length
{
    NSString *substring = [string substringWithRange: NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    return hexComponent / 255.0;
}

RCT_EXPORT_MODULE();


RCT_EXPORT_METHOD(showSimpleTextWithBackgroundColor:(NSString *)message duration:(NSInteger)duration backgroundColor:(NSString *)backgroundColor)
{

    dispatch_async(dispatch_get_main_queue(), ^{
        if(self.hub){
            [self.hub hideAnimated:YES];
        }
        self.hub = [MBProgressHUD showHUDAddedTo:self.window animated:YES];
        self.hub.mode = MBProgressHUDModeText;
        self.hub.detailsLabel.text = message;
        self.hub.bezelView.backgroundColor = [RNProgressHUB colorFromHexString:backgroundColor];

        if (self.hub) {
            [self.hub hideAnimated:YES afterDelay:duration / 1000];
            self.hub = NULL;
        }
    });

}

RCT_EXPORT_METHOD(showSimpleText:(NSString *)message duration:(NSInteger)duration)
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if(self.hub){
            [self.hub hideAnimated:YES];
        }
        self.hub = [MBProgressHUD showHUDAddedTo:self.window animated:YES];
        self.hub.mode = MBProgressHUDModeText;
        self.hub.label.text = message;
        
        if (self.hub) {
            [self.hub hideAnimated:YES afterDelay:duration / 1000];
            self.hub = NULL;
        }
    });
    
}
RCT_EXPORT_METHOD(showSpinIndeterminate)
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if(self.hub){
            [self.hub hideAnimated:YES];
        }
        self.hub = [MBProgressHUD showHUDAddedTo:self.window animated:YES];
        self.hub.mode = MBProgressHUDModeIndeterminate;
    });
}
RCT_EXPORT_METHOD(showSpinIndeterminateWithTitle:(NSString *)title)
{

    dispatch_async(dispatch_get_main_queue(), ^{
        if(self.hub){
            [self.hub hideAnimated:YES];
        }
        self.hub = [MBProgressHUD showHUDAddedTo:self.window animated:YES];
        self.hub.mode = MBProgressHUDModeIndeterminate;
        self.hub.label.text = title;
    });
    
}
RCT_EXPORT_METHOD(showSpinIndeterminateWithTitleAndDetails:(NSString *)title content:(NSString *)details)
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if(self.hub){
            [self.hub hideAnimated:YES];
        }
        self.hub = [MBProgressHUD showHUDAddedTo:self.window animated:YES];
        self.hub.mode = MBProgressHUDModeIndeterminate;
        self.hub.label.text = title;
        self.hub.detailsLabel.text = details;
    });
}
RCT_EXPORT_METHOD(showDeterminate:(NSInteger *)mode title:(NSString *)title details:(NSString *)details)
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if(self.hub){
            [self.hub hideAnimated:YES];
        }
        self.hub = [MBProgressHUD showHUDAddedTo:self.window animated:YES];
    
        if(mode == RNProgressHUBModeAnnularDeterminate){
            self.hub.mode = MBProgressHUDModeAnnularDeterminate;
        } else if(mode == RNProgressHUBModeDeterminateHorizontalBar){
            self.hub.mode = MBProgressHUDModeDeterminateHorizontalBar;
        }
        
        if (title) {
            self.hub.label.text = title;
        }
        if(details){
            self.hub.detailsLabel.text = details;
        }
     
    });
}

RCT_EXPORT_METHOD(setProgress:(CGFloat)progress )
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_hub) {
            [MBProgressHUD HUDForView:self.window].progress = progress;
        }
    });
}

RCT_EXPORT_METHOD(dismiss)
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if(self.hub){
            [self.hub hideAnimated:YES];
            self.hub = NULL;
        }
    });
}


@end
