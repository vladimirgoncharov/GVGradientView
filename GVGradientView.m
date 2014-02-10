#import "GVGradientView.h"

#import "CAAnimation+Blocks.h"

static NSString *const kColorAnimationKey                   = @"animateColors";

static NSString *const kStartPointAnimationKey              = @"animateStartPoint";
static NSString *const kEndPointAnimationKey                = @"animateEndPoint";

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
    self.direction      = GVGradientDirectionVertical;
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
    
    __weak typeof(self) wself           = self;
    [self _performAnimationsWithKeyPath:NSStringFromSelector(@selector(colors))
                           keyAnimation:kColorAnimationKey
                               duration:duration
                              fromValue:self.gradientLayer.colors
                                toValue:cgColors
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

- (BOOL)isRunningAnimationLocation
{
    return ([self.gradientLayer animationForKey:kLocationsAnimationKey] != nil);
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
    
    __weak typeof(self) wself           = self;
    [self _performAnimationsWithKeyPath:NSStringFromSelector(@selector(locations))
                           keyAnimation:kLocationsAnimationKey
                               duration:duration
                              fromValue:self.gradientLayer.locations
                                toValue:locations
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
    if (direction == _direction)
        return;
    
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
            return;
            break;
    }
    
    _direction              = direction;
    CFTimeInterval duration = DURATION_NO_ANIMATION;
    
    if (animated)
    {
        duration            = DURATION_DEFAULT_ANIMATION;
    }
    
    __block BOOL startPointFinished         = NO;
    __block BOOL endPointFinished           = NO;
    __block BOOL result                     = YES;
    
    void(^callback)() = ^()
    {
        if (startPointFinished && endPointFinished)
        {
            if (finished)
            {
                finished(result);
            }
        }
    };

    __weak typeof(self) wself           = self;
    [self _performAnimationsWithKeyPath:NSStringFromSelector(@selector(startPoint))
                           keyAnimation:kStartPointAnimationKey
                               duration:duration
                              fromValue:[NSValue valueWithCGPoint:self.gradientLayer.startPoint]
                                toValue:[NSValue valueWithCGPoint:startPoint]
                             completion:^(BOOL completed) {
                                 if (!wself)
                                     return;
                                 
                                 if (completed)
                                 {
                                     wself.gradientLayer.startPoint       = startPoint;
                                 }
                                 
                                 startPointFinished = YES;
                                 if (result)
                                 {
                                     result     = completed;
                                 }
                                 
                                 callback();
                             }];
    [self _performAnimationsWithKeyPath:NSStringFromSelector(@selector(endPoint))
                           keyAnimation:kEndPointAnimationKey
                               duration:duration
                              fromValue:[NSValue valueWithCGPoint:self.gradientLayer.endPoint]
                                toValue:[NSValue valueWithCGPoint:endPoint]
                             completion:^(BOOL completed) {
                                 if (!wself)
                                     return;
                                 
                                 if (completed)
                                 {
                                     wself.gradientLayer.endPoint       = endPoint;
                                 }
                                 
                                 endPointFinished = YES;
                                 if (result)
                                 {
                                     result     = completed;
                                 }
                                 
                                 callback();
                             }];
}

- (BOOL)isRunningAnimationDirection
{
    return  ([self.gradientLayer animationForKey:kStartPointAnimationKey] != nil) &&
            ([self.gradientLayer animationForKey:kEndPointAnimationKey] != nil);
}

#pragma mark - private

- (void)_performAnimationsWithKeyPath:(NSString *)keyPath
                         keyAnimation:(NSString *)keyAnimation
                             duration:(CFTimeInterval)duration
                            fromValue:(id)fromValue
                              toValue:(id)toValue
                           completion:(void(^)(BOOL completed))completion
{
    void(^blockAction)() =
    ^{
        [self.gradientLayer removeAnimationForKey:keyAnimation];
        
        __weak typeof(self) wself       = self;
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
            CABasicAnimation *animation     = [CABasicAnimation animationWithKeyPath:keyPath];
            animation.duration              = duration;
            animation.fromValue             = fromValue;
            animation.toValue               = toValue;
            animation.fillMode              = kCAFillModeForwards;
            animation.removedOnCompletion   = NO;
            [animation setCompletion:blockCompleted];
            [self.gradientLayer addAnimation:animation
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

@end


