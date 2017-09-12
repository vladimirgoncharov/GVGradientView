#import "GVGradientView.h"

#import <CAAnimationBlocks/CAAnimation+Blocks.h>

static NSString *const kColorAnimationKey                   = @"animateColors";
static NSString *const kStartEndPointAnimationKey           = @"animateStartEndPoint";
static NSString *const kLocationsAnimationKey               = @"animateLocations";

#define DURATION_DEFAULT_ANIMATION          0.5f
#define DURATION_NO_ANIMATION               0.0f

#define HORIZONTAL_START_POINT  CGPointMake(0, 0.5)
#define HORIZONTAL_END_POINT    CGPointMake(1, 0.5)
#define VERTICAL_START_POINT    CGPointMake(0.5, 0)
#define VERTICAL_END_POINT      CGPointMake(0.5, 1)

@interface GVGradientView ()

@end

@implementation GVGradientView

- (id)initWithFrame:(CGRect)frame
{
    self                    = [super initWithFrame:frame];
    if (self)
    {
        [self _loadDefaulSettings];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self                    = [super initWithCoder:aDecoder];
    if (self)
    {
        [self _loadDefaulSettings];
    }
    return self;
}

- (void)_loadDefaulSettings
{
    self.direction      = GVGradientDirectionHorizontal;
}

#pragma mark -
#pragma mark - OVERLAY

+ (Class)layerClass
{
    return [CAGradientLayer class];
}

#pragma mark -
#pragma mark - ACCESSORY && METHOD's

- (CAGradientLayer *)gradientLayer
{
    return (CAGradientLayer *)self.layer;
}

#pragma mark - colors

- (void)setColors:(NSArray *)colors
{
    [self setColors:colors
           animated:NO
           finished:nil];
}

- (void)setColors:(NSArray *)colors
         animated:(BOOL)animated
         finished:(void (^)(BOOL))finished
{
    NSMutableArray *cgColors = [NSMutableArray arrayWithCapacity:colors.count];
    for (UIColor *color in colors)
    {
        [cgColors addObject:(id)[color CGColor]];
    }
    CFTimeInterval duration     = DURATION_NO_ANIMATION;
    
    if (animated)
    {
        NSUInteger oldCountColors          = self.gradientLayer.colors.count;
        NSUInteger newCountColors          = cgColors.count;
        if (oldCountColors == 0)
        {
            NSMutableArray *mTempFromValue      = [[NSMutableArray alloc] initWithCapacity:newCountColors];
            for (NSUInteger i = 0; i < newCountColors; i++)
            {
                [mTempFromValue addObject:[UIColor clearColor]];
            }
            self.gradientLayer.colors       = [mTempFromValue copy];
        }
        duration                            = DURATION_DEFAULT_ANIMATION;
    }
    
    CAAnimation *colorAnimation   =
    [self _animationWithKeyPath:NSStringFromSelector(@selector(colors))
                      fromValue:self.gradientLayer.colors
                        toValue:cgColors];
    
    __weak typeof(self) wself           = self;
    [self _performAnimations:@[colorAnimation]
                    duration:duration
                keyAnimation:kColorAnimationKey
                  completion:^(BOOL completed) {
                      if (!wself)
                          return;
                      
                      if (completed)
                      {
                          wself.gradientLayer.colors       = cgColors;
                      }
                      
                      if (finished)
                      {
                          finished(completed);
                      }
                  }];
}

- (NSArray *)colors
{
    NSMutableArray *uiColors = [NSMutableArray arrayWithCapacity:self.gradientLayer.colors.count];
    for (id color in self.gradientLayer.colors)
    {
        [uiColors addObject:[UIColor colorWithCGColor:(CGColorRef)color]];
    }
    
    return uiColors;
}

- (BOOL)isRunningAnimationColor
{
    return ([self.gradientLayer animationForKey:kColorAnimationKey] != nil);
}

#pragma mark - locations

- (void)setLocations:(NSArray *)locations
{
    [self setLocations:locations
              animated:NO
              finished:nil];
}

- (void)setLocations:(NSArray *)locations
            animated:(BOOL)animated
            finished:(void(^)(BOOL))finished
{
    CFTimeInterval duration     = DURATION_NO_ANIMATION;
    
    if (animated)
    {
        NSUInteger oldCountLocations          = self.gradientLayer.locations.count;
        NSUInteger newCountLocations          = locations.count;
        if (oldCountLocations == 0)
        {
            NSMutableArray *mTempFromValue      = [[NSMutableArray alloc] initWithCapacity:newCountLocations];
            for (NSUInteger i = 0; i < newCountLocations; i++)
            {
                [mTempFromValue addObject:[NSNumber numberWithFloat:i / (float)(newCountLocations - 1)]];
            }
            self.gradientLayer.locations       = [mTempFromValue copy];
        }
        duration                            = DURATION_DEFAULT_ANIMATION;
    }
    
    CAAnimation *locationAnimation   =
    [self _animationWithKeyPath:NSStringFromSelector(@selector(locations))
                      fromValue:self.gradientLayer.locations
                        toValue:locations];
    
    __weak typeof(self) wself           = self;
    [self _performAnimations:@[locationAnimation]
                    duration:duration
                keyAnimation:kLocationsAnimationKey
                  completion:^(BOOL completed) {
                      if (!wself)
                          return;
                      
                      if (completed)
                      {
                          wself.gradientLayer.locations       = locations;
                      }
                      
                      if (finished)
                      {
                          finished(completed);
                      }
                  }];
}

- (NSArray<NSNumber *> *)locations {
    return self.gradientLayer.locations;
}

- (BOOL)isRunningAnimationLocation
{
    return ([self.gradientLayer animationForKey:kLocationsAnimationKey] != nil);
}

#pragma mark - direction

- (void)setDirection:(GVGradientDirection)direction
{
    [self setDirection:direction
              animated:NO
              finished:nil];
}

- (void)setDirection:(GVGradientDirection)direction
            animated:(BOOL)animated
            finished:(void (^)(BOOL))finished
{
    CGPoint startPoint      = CGPointZero;
    CGPoint endPoint        = CGPointZero;
    
    switch (direction)
    {
        case GVGradientDirectionHorizontal:
        {
            startPoint      = HORIZONTAL_START_POINT;
            endPoint        = HORIZONTAL_END_POINT;
        }; break;
            
        case GVGradientDirectionVertical:
        {
            startPoint      = VERTICAL_START_POINT;
            endPoint        = VERTICAL_END_POINT;
        }; break;
            
        default:
            NSLog(@"Use startPoint and endPoint for setting custom values");
            return;
            break;
    }
    
    CFTimeInterval duration = DURATION_NO_ANIMATION;
    
    if (animated)
    {
        duration            = DURATION_DEFAULT_ANIMATION;
    }
    
    CAAnimation *startAnimation         =
    [self _animationWithKeyPath:NSStringFromSelector(@selector(startPoint))
                      fromValue:[NSValue valueWithCGPoint:self.gradientLayer.startPoint]
                        toValue:[NSValue valueWithCGPoint:startPoint]];
    
    CAAnimation *endAnimation           =
    [self _animationWithKeyPath:NSStringFromSelector(@selector(endPoint))
                      fromValue:[NSValue valueWithCGPoint:self.gradientLayer.endPoint]
                        toValue:[NSValue valueWithCGPoint:endPoint]];
    
    __weak typeof(self) wself           = self;
    [self _performAnimations:@[startAnimation, endAnimation]
                    duration:duration
                keyAnimation:kStartEndPointAnimationKey
                  completion:^(BOOL completed) {
                      if (!wself)
                          return;
                      
                      if (completed)
                      {
                          wself.gradientLayer.startPoint     = startPoint;
                          wself.gradientLayer.endPoint       = endPoint;
                      }
                      
                      if (finished)
                      {
                          finished(completed);
                      }
                  }];
}

- (GVGradientDirection)direction {
    if (self.startPoint.x == HORIZONTAL_START_POINT.x &&
        self.startPoint.y == HORIZONTAL_START_POINT.y &&
        self.endPoint.x == HORIZONTAL_END_POINT.x &&
        self.endPoint.y == HORIZONTAL_END_POINT.y) {
        return GVGradientDirectionHorizontal;
    }
    if (self.startPoint.x == VERTICAL_START_POINT.x &&
        self.startPoint.y == VERTICAL_START_POINT.y &&
        self.endPoint.x == VERTICAL_END_POINT.x &&
        self.endPoint.y == VERTICAL_END_POINT.y) {
        return GVGradientDirectionVertical;
    }
    return GVGradientDirectionCustom;
}

- (BOOL)isRunningAnimationDirection
{
    return ([self.gradientLayer animationForKey:kStartEndPointAnimationKey] != nil);
}

#pragma mark - private

- (CAAnimation *)_animationWithKeyPath:(NSString *)keyPath
                             fromValue:(id)fromValue
                               toValue:(id)toValue
{
    CABasicAnimation *animation     = [CABasicAnimation animationWithKeyPath:keyPath];
    animation.fromValue             = fromValue;
    animation.toValue               = toValue;
    animation.removedOnCompletion   = NO;
    animation.fillMode              = kCAFillModeForwards;
    return animation;
}

- (void)_performAnimations:(NSArray *)animations
                  duration:(CFTimeInterval)duration
              keyAnimation:(NSString *)keyAnimation
                completion:(void(^)(BOOL completed))completion
{
    __weak typeof(self) wself       = self;
    void(^blockAction)() =
    ^{
        [wself.gradientLayer removeAnimationForKey:keyAnimation];
        
        void(^blockCompleted)(BOOL) =
        ^(BOOL completed)
        {
            [wself.gradientLayer removeAnimationForKey:keyAnimation];
            if (completion)
            {
                completion(completed);
            }
        };
        
        if (duration != DURATION_NO_ANIMATION)
        {
            CAAnimationGroup *animationGroup     = [CAAnimationGroup animation];
            animationGroup.animations            = animations;
            animationGroup.duration              = duration;
            [animationGroup setCompletion:blockCompleted];
            animationGroup.fillMode              = kCAFillModeForwards;
            animationGroup.removedOnCompletion   = NO;
            [wself.gradientLayer addAnimation:animationGroup
                                       forKey:keyAnimation];
        }
        else
        {
            blockCompleted(YES);
        }
    };
    
    if ([NSThread isMainThread])
    {
        blockAction();
    }
    else
    {
        dispatch_sync(dispatch_get_main_queue(), blockAction);
    }
}

#pragma mark - IB

- (void)setStartPoint:(CGPoint)startPoint {
    self.gradientLayer.startPoint = startPoint;
}

- (CGPoint)startPoint {
    return self.gradientLayer.startPoint;
}

- (void)setEndPoint:(CGPoint)endPoint {
    self.gradientLayer.endPoint = endPoint;
}

- (CGPoint)endPoint {
    return self.gradientLayer.endPoint;
}

#define DefineColorAndLocationSetters(i) \
- (void)setColor##i:(UIColor *)color##i { \
    NSMutableArray *uiColors = [self.colors mutableCopy]; \
    if (uiColors.count > i) { \
        [uiColors replaceObjectAtIndex:i withObject:color##i]; \
    } else { \
        [uiColors addObject:color##i]; \
    } \
    [self setColors:uiColors]; \
} \
\
- (UIColor *)color##i { \
    if ([self.colors count] > i) { \
        return self.colors[i]; \
    } \
    return nil; \
} \
\
- (void)setLocation##i:(CGFloat)location##i { \
    NSMutableArray *locations = [self.locations mutableCopy]; \
    if (locations.count > i) { \
        [locations replaceObjectAtIndex:i withObject:@(location##i)]; \
    } else { \
        [locations addObject:@(location##i)]; \
    } \
    [self setLocations:locations]; \
} \
\
- (CGFloat)location##i { \
    if ([self.locations count] > i) { \
        return [self.locations[i] floatValue]; \
    } \
    return NSNotFound; \
}

DefineColorAndLocationSetters(0)
DefineColorAndLocationSetters(1)
DefineColorAndLocationSetters(2)
DefineColorAndLocationSetters(3)
DefineColorAndLocationSetters(4)
DefineColorAndLocationSetters(5)

@end
