#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef NS_ENUM(NSUInteger, GVGradientDirection)
{
    GVGradientDirectionHorizontal,
    GVGradientDirectionVertical,
    GVGradientDirectionCustom
};

NS_CLASS_AVAILABLE_IOS(3_0) IB_DESIGNABLE @interface GVGradientView : UIView

@property (nonatomic, readonly, strong, nonnull) CAGradientLayer *gradientLayer;

/*!
 @code
 NSArray *colors     = @[[UIColor blackColor], [UIColor redColor], [UIColor blueColor]];
 self.colors         = colors;
 @endcode
 */
@property (nonatomic, copy, nullable) NSArray<UIColor *> *colors;
@property (nonatomic, readonly, assign) BOOL isRunningAnimationColor;
- (void)setColors:(NSArray * _Nullable)colors
         animated:(BOOL)animated
         finished:(void(^_Nullable)(BOOL))finished;
/*!
 @code
 NSArray *locations     = @[[NSNumber numberWithFloat:0.0f], [NSNumber numberWithFloat:0.4f], [NSNumber numberWithFloat:1.0f]];
 self.locations         = locations;
 @endcode
 */
@property (nonatomic, copy, nullable) NSArray<NSNumber *> *locations;
@property (nonatomic, readonly, assign) BOOL isRunningAnimationLocation;
- (void)setLocations:(NSArray *_Nullable)locations
         animated:(BOOL)animated
         finished:(void(^_Nullable)(BOOL))finished;

/*!
 @code
 self.direction = GVGradientDirectionHorizontal;
 @endcode
 */
@property (nonatomic, assign) GVGradientDirection direction; //def. GVGradientDirectionHorizontal
@property (nonatomic, readonly, assign) BOOL isRunningAnimationDirection;
- (void)setDirection:(GVGradientDirection)direction
            animated:(BOOL)animated
            finished:(void (^_Nullable)(BOOL))finished;

#pragma mark - IB

@property (nonatomic) IBInspectable CGPoint startPoint;
@property (nonatomic) IBInspectable CGPoint endPoint;

@property (nonatomic, strong, nullable) IBInspectable UIColor *color0;
@property (nonatomic) IBInspectable CGFloat location0;

@property (nonatomic, strong, nullable) IBInspectable UIColor *color1;
@property (nonatomic) IBInspectable CGFloat location1;

@property (nonatomic, strong, nullable) IBInspectable UIColor *color2;
@property (nonatomic) IBInspectable CGFloat location2;

@property (nonatomic, strong, nullable) IBInspectable UIColor *color3;
@property (nonatomic) IBInspectable CGFloat location3;

@property (nonatomic, strong, nullable) IBInspectable UIColor *color4;
@property (nonatomic) IBInspectable CGFloat location4;

@property (nonatomic, strong, nullable) IBInspectable UIColor *color5;
@property (nonatomic) IBInspectable CGFloat location5;

@end
