#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef NS_ENUM(NSUInteger, GVGradientDirection)
{
    GVGradientDirectionHorizontal       = 1 << 0,
    GVGradientDirectionVertical         = 1 << 1
};

NS_CLASS_AVAILABLE_IOS(3_0) @interface GVGradientView : UIView 

@property (nonatomic, readonly, strong) CAGradientLayer *gradientLayer;

/*!
 @code
 NSArray *colors     = @[[UIColor blackColor], [UIColor redColor], [UIColor blueColor]];
 self.colors         = colors;
 @endcode
 */
@property (nonatomic, readwrite, strong) NSArray *colors;                                               //UIColor
@property (nonatomic, readonly, assign) BOOL isRunningAnimationColor;
- (void)setColors:(NSArray *)colors
         animated:(BOOL)animated
         finished:(void(^)(BOOL))finished;
/*!
 @code
 NSArray *locations     = @[[NSNumber numberWithFloat:0.0f], [NSNumber numberWithFloat:0.4f], [NSNumber numberWithFloat:1.0f]];
 self.locations         = locations;
 @endcode
 */
@property (nonatomic, readwrite, strong) NSArray *locations;                                            //NSNumber
@property (nonatomic, readonly, assign) BOOL isRunningAnimationLocation;
- (void)setLocations:(NSArray *)locations
         animated:(BOOL)animated
         finished:(void(^)(BOOL))finished;

@property (nonatomic, readwrite, assign) GVGradientDirection direction;                                 //def. GVGradientDirectionVertical
@property (nonatomic, readonly, assign) BOOL isRunningAnimationDirection;
- (void)setDirection:(GVGradientDirection)direction
            animated:(BOOL)animated
            finished:(void (^)(BOOL))finished;

@end
