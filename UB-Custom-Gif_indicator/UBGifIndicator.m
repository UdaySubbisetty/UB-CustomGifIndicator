//
//  UBGifIndicator.m
//  UB-Custom-Gif_indicator
//
//  Created by Uday on 30/08/17.
//  Copyright © 2017 rutherford.com. All rights reserved.
//

#import "UBGifIndicator.h"
#import <ImageIO/ImageIO.h>
@interface UBGifIndicator ()

@end

@implementation UBGifIndicator
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}
+(void)showSpinnerGif : (UIView *)gifView
{
    
    UIImageView * gif = [[UIImageView alloc]initWithFrame:CGRectMake((gifView.frame.size.width/2)-40, (gifView.frame.size.height/2)-40, 80,80)];
    gif.backgroundColor = [UIColor clearColor];
    NSURL * url = [[NSBundle mainBundle] URLForResource:@"Tic-Tac-Toe" withExtension:@"gif"];
    //gif.image =  [UIImage animatedImageWithAnimatedGIFURL:url];
    
   
   
    [[self class]loadGIFData:[NSData dataWithContentsOfURL:url] to:gif];
    
    
    
    
    [gifView addSubview:gif];
    
    
}

+ (void)loadGIFData:(NSData *)data to:(UIImageView *)imageView
{
    NSMutableArray *frames = nil;
    CGImageSourceRef src = CGImageSourceCreateWithData((CFDataRef)data, NULL);
    CGFloat animationTime = 0.f;
    if (src) {
        size_t l = CGImageSourceGetCount(src);
        frames = [NSMutableArray arrayWithCapacity:l];
        for (size_t i = 0; i < l; i++) {
            CGImageRef img = CGImageSourceCreateImageAtIndex(src, i, NULL);
            NSDictionary *properties = (NSDictionary *)CFBridgingRelease(CGImageSourceCopyPropertiesAtIndex(src, i, NULL));
            NSDictionary *frameProperties = [properties objectForKey:(NSString *)kCGImagePropertyGIFDictionary];
            NSNumber *delayTime = [frameProperties objectForKey:(NSString *)kCGImagePropertyGIFUnclampedDelayTime];
            animationTime += [delayTime floatValue];
            if (img) {
                [frames addObject:[UIImage imageWithCGImage:img]];
                CGImageRelease(img);
            }
        }
        CFRelease(src);
    }
    [imageView setImage:[frames objectAtIndex:0]];
    [imageView setAnimationImages:frames];
    [imageView setAnimationDuration:animationTime];
    [imageView startAnimating];
}
@end
