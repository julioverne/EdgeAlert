#import <objc/runtime.h>
#import <notify.h>
#import <dlfcn.h>
#import <Security/Security.h>
#import <substrate.h>

extern const char *__progname;

#define NSLog(...)

#define PLIST_PATH_Settings "/var/mobile/Library/Preferences/com.julioverne.edgealert.plist"

@interface UIWindow ()
- (void)_setSecure:(BOOL)arg1;
@end

@interface EdgeAlert : NSObject
{
	BOOL isAnimating;
	UIWindow* springboardWindow1;
	UIWindow* springboardWindow2;
	UIWindow* springboardWindow3;
	UIWindow* springboardWindow4;
	
	UIWindow* springboardWindow1s;
	UIWindow* springboardWindow2s;
	UIWindow* springboardWindow3s;
	UIWindow* springboardWindow4s;
}
@property (assign) BOOL isAnimating;
@property (nonatomic, strong) UIWindow* springboardWindow1;
@property (nonatomic, strong) UIWindow* springboardWindow2;
@property (nonatomic, strong) UIWindow* springboardWindow3;
@property (nonatomic, strong) UIWindow* springboardWindow4;

@property (nonatomic, strong) UIWindow* springboardWindow1s;
@property (nonatomic, strong) UIWindow* springboardWindow2s;
@property (nonatomic, strong) UIWindow* springboardWindow3s;
@property (nonatomic, strong) UIWindow* springboardWindow4s;
+ (id)sharedInstance;
+ (BOOL)sharedInstanceExist;

- (void)startAnimationWithSpeed:(float)speed;
- (void)stopAnimation;
- (void)startWithSeconds:(int)secnds;
@end

static BOOL Enabled;

static float kScreenW;
static float kScreenH;

static float kWidth;
static float kSpeed;
static float proportionSize;
static float DurationTime;

static __strong NSString* alertHexColor;

static UIColor *colorFromString(NSString *value)
{
    if(value) {
		float currentAlpha = 1.0f;
		NSString *color = [value copy];
		if([color rangeOfString:@":"].location != NSNotFound){
			NSArray *colorAndOrAlpha = [color componentsSeparatedByString:@":"];
			color = colorAndOrAlpha[0];
			currentAlpha = [colorAndOrAlpha[1]?:@(1) floatValue];
        }
		unsigned int hexint  = 0;
		if(color) {
			NSScanner *scanner = [NSScanner scannerWithString:color];
			[scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@"#"]];
			[scanner scanHexInt:&hexint];
			return [UIColor colorWithRed:((CGFloat) ((hexint & 0xFF0000) >> 16))/255
			green:((CGFloat) ((hexint & 0xFF00) >> 8))/255
			blue:((CGFloat) (hexint & 0xFF))/255
			alpha:currentAlpha];
		}
    }
	return nil;
}

@implementation EdgeAlert
@synthesize isAnimating, springboardWindow1, springboardWindow2, springboardWindow3, springboardWindow4, springboardWindow1s, springboardWindow2s, springboardWindow3s, springboardWindow4s;
__strong static id _sharedObject;
+ (id)sharedInstance
{
	if (!_sharedObject) {
		_sharedObject = [[self alloc] init];
	}
	return _sharedObject;
}
+ (BOOL)sharedInstanceExist
{
	if (_sharedObject) {
		return YES;
	}
	return NO;
}
- (void)firstload
{
	return;
}
- (void)updateWindowsFrames
{
	springboardWindow1.frame = CGRectMake(0, -((kScreenH/proportionSize)), kWidth, (kScreenH/proportionSize));
	springboardWindow2.frame = CGRectMake(kScreenW - kWidth, -((kScreenH/proportionSize)), kWidth, (kScreenH/proportionSize));
	springboardWindow3.frame = CGRectMake(-((kScreenW/proportionSize)), 0, (kScreenW/proportionSize), kWidth);
	springboardWindow4.frame = CGRectMake(-((kScreenW/proportionSize)), kScreenH-(kWidth), (kScreenW/proportionSize), kWidth);
	
	springboardWindow1s.frame = CGRectMake(0, -((kScreenH/proportionSize)), kWidth, (kScreenH/proportionSize));
	springboardWindow2s.frame = CGRectMake(kScreenW - kWidth, -((kScreenH/proportionSize)), kWidth, (kScreenH/proportionSize));
	springboardWindow3s.frame = CGRectMake(-((kScreenW/1.5)), 0, (kScreenW/1.5), kWidth);
	springboardWindow4s.frame = CGRectMake(-((kScreenW/proportionSize)), kScreenH-(kWidth), (kScreenW/proportionSize), kWidth);
	
	[self updateGradientWithColor:colorFromString(alertHexColor)];
}
- (void)updateGradientInView:(UIWindow*)viewNow withColor:(UIColor*)colorGradient isVertical:(BOOL)isVertical
{
	UIView* gradViewNew = [UIView new];
	gradViewNew.tag = 2;
	gradViewNew.frame = viewNow.bounds;
	CAGradientLayer *gradient1 = [CAGradientLayer layer];
	gradient1.frame = gradViewNew.frame;
	gradient1.colors = @[(id)[UIColor clearColor].CGColor, (id)colorGradient.CGColor, (id)colorGradient.CGColor, (id)[UIColor clearColor].CGColor,];
	gradient1.locations = @[@(0.0),@(0.4),@(0.6),@(1.0),];
	if(!isVertical) {
		gradient1.startPoint = CGPointMake(0.0, 0.5);
		gradient1.endPoint = CGPointMake(1.0, 0.5);
	}
	[gradViewNew.layer insertSublayer:gradient1 atIndex:0];
	if(UIView* gradView = [viewNow viewWithTag:2]) {
		[gradView removeFromSuperview];
	}
	[viewNow addSubview:gradViewNew];
}
- (void)updateGradientWithColor:(UIColor*)colorGradient
{
	[self updateGradientInView:springboardWindow1 withColor:colorGradient isVertical:YES];
	[self updateGradientInView:springboardWindow2 withColor:colorGradient isVertical:YES];
	[self updateGradientInView:springboardWindow3 withColor:colorGradient isVertical:NO];
	[self updateGradientInView:springboardWindow4 withColor:colorGradient isVertical:NO];
	
	[self updateGradientInView:springboardWindow1s withColor:colorGradient isVertical:YES];
	[self updateGradientInView:springboardWindow2s withColor:colorGradient isVertical:YES];
	[self updateGradientInView:springboardWindow3s withColor:colorGradient isVertical:NO];
	[self updateGradientInView:springboardWindow4s withColor:colorGradient isVertical:NO];
}
- (UIWindow*)newSecureWindow
{
	UIWindow* springboardWindowNew = [[UIWindow alloc] initWithFrame:CGRectZero];
	springboardWindowNew.windowLevel = 9999999999;
	[springboardWindowNew setHidden:NO];
	springboardWindowNew.alpha = 1;
	[springboardWindowNew _setSecure:YES];
	[springboardWindowNew setUserInteractionEnabled:NO];
	springboardWindowNew.layer.masksToBounds = YES;
	springboardWindowNew.layer.shouldRasterize  = NO;
	return springboardWindowNew;
}
-(id)init
{
	self = [super init];
	if(self != nil) {
		@try {	
	
			springboardWindow1 = [self newSecureWindow];
			springboardWindow2 = [self newSecureWindow];
			springboardWindow3 = [self newSecureWindow];
			springboardWindow4 = [self newSecureWindow];
			
			springboardWindow1s = [self newSecureWindow];
			springboardWindow2s = [self newSecureWindow];
			springboardWindow3s = [self newSecureWindow];
			springboardWindow4s = [self newSecureWindow];
			
			
			[self updateWindowsFrames];
			
		} @catch (NSException * e) {
			
		}
	}
	return self;
}
- (void)startWithSeconds:(int)secnds
{
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopAnimation) object:nil];
	[self performSelector:@selector(stopAnimation) withObject:nil afterDelay:secnds];
	[self startAnimationWithSpeed:kSpeed];
}
- (void)stopAnimation
{
	[springboardWindow1.layer removeAllAnimations];
	[springboardWindow2.layer removeAllAnimations];
	[springboardWindow3.layer removeAllAnimations];
	[springboardWindow4.layer removeAllAnimations];
	
	[springboardWindow1s.layer removeAllAnimations];
	[springboardWindow2s.layer removeAllAnimations];
	[springboardWindow3s.layer removeAllAnimations];
	[springboardWindow4s.layer removeAllAnimations];
}
- (void)startAnimationWithSpeed:(float)speed
{
	CGRect viewGradient1Frame = springboardWindow1.frame;
	viewGradient1Frame.origin.y = kScreenH + springboardWindow1.frame.size.height;
	springboardWindow1.frame = viewGradient1Frame;
	
	CGRect viewGradient2Frame = springboardWindow2.frame;
	viewGradient2Frame.origin.y = -(springboardWindow2.frame.size.height);
	springboardWindow2.frame = viewGradient2Frame;
	
	CGRect viewGradient3Frame = springboardWindow3.frame;
	viewGradient3Frame.origin.x = -(springboardWindow3.frame.size.width);
	springboardWindow3.frame = viewGradient3Frame;
	
	CGRect viewGradient4Frame = springboardWindow4.frame;
	viewGradient4Frame.origin.x = kScreenW + springboardWindow4.frame.size.width;
	springboardWindow4.frame = viewGradient4Frame;
	
	
	CGRect viewGradient1sFrame = springboardWindow1s.frame;
	viewGradient1sFrame.origin.y = kScreenH + springboardWindow1s.frame.size.height;
	springboardWindow1s.frame = viewGradient1sFrame;
	
	CGRect viewGradient2sFrame = springboardWindow2s.frame;
	viewGradient2sFrame.origin.y = -(springboardWindow2s.frame.size.height);
	springboardWindow2s.frame = viewGradient2sFrame;
	
	CGRect viewGradient3sFrame = springboardWindow3s.frame;
	viewGradient3sFrame.origin.x = -(springboardWindow3s.frame.size.width);
	springboardWindow3s.frame = viewGradient3sFrame;
	
	CGRect viewGradient4sFrame = springboardWindow4s.frame;
	viewGradient4sFrame.origin.x = kScreenW + springboardWindow4s.frame.size.width;
	springboardWindow4s.frame = viewGradient4sFrame;
	
	
	float Delay1Anim = (speed/12);
	
	CABasicAnimation *viewAnim1 = [CABasicAnimation animationWithKeyPath:@"position.y"];
    viewAnim1.delegate = self;
    viewAnim1.fromValue = @(springboardWindow1.frame.origin.y);
    viewAnim1.toValue = @(-(springboardWindow1.frame.size.height));
    viewAnim1.repeatCount = HUGE_VALF;
    viewAnim1.duration = speed;
    viewAnim1.beginTime = Delay1Anim;
	viewAnim1.removedOnCompletion = NO;
    
	CABasicAnimation *viewAnim2 = [CABasicAnimation animationWithKeyPath:@"position.y"];
    viewAnim2.delegate = self;
    viewAnim2.fromValue = @(-(springboardWindow2.frame.size.height));
    viewAnim2.toValue = @(kScreenH + springboardWindow2.frame.size.height);
    viewAnim2.repeatCount = HUGE_VALF;
    viewAnim2.duration = speed;
    viewAnim2.beginTime = Delay1Anim;
	viewAnim2.removedOnCompletion = NO;
	
	CABasicAnimation *viewAnim3 = [CABasicAnimation animationWithKeyPath:@"position.x"];
    viewAnim3.delegate = self;
    viewAnim3.fromValue = @(-(springboardWindow3.frame.size.width));
    viewAnim3.toValue = @(kScreenW + springboardWindow3.frame.size.width);
    viewAnim3.repeatCount = HUGE_VALF;
    viewAnim3.duration = speed;
    viewAnim3.beginTime = Delay1Anim;
    viewAnim3.removedOnCompletion = NO;
	
	CABasicAnimation *viewAnim4 = [CABasicAnimation animationWithKeyPath:@"position.x"];
    viewAnim4.delegate = self;
    viewAnim4.fromValue = @(kScreenW + springboardWindow4.frame.size.width);
    viewAnim4.toValue = @(-(springboardWindow4.frame.size.width));
    viewAnim4.repeatCount = HUGE_VALF;
    viewAnim4.duration = speed;
    viewAnim4.beginTime = Delay1Anim;
    viewAnim4.removedOnCompletion = NO;
	
	float Delay2Anim = speed + Delay1Anim + (6*Delay1Anim);
	
	CABasicAnimation *viewAnim1s = [CABasicAnimation animationWithKeyPath:@"position.y"];
    viewAnim1s.delegate = self;
    viewAnim1s.fromValue = @(springboardWindow1s.frame.origin.y);
    viewAnim1s.toValue = @(-(springboardWindow1s.frame.size.height));
    viewAnim1s.repeatCount = HUGE_VALF;
    viewAnim1s.duration = speed;
    viewAnim1s.beginTime = Delay2Anim;
    viewAnim1s.removedOnCompletion = NO;
	
	CABasicAnimation *viewAnim2s = [CABasicAnimation animationWithKeyPath:@"position.y"];
    viewAnim2s.delegate = self;
    viewAnim2s.fromValue = @(-(springboardWindow2s.frame.size.height));
    viewAnim2s.toValue = @(kScreenH + springboardWindow2s.frame.size.height);
    viewAnim2s.repeatCount = HUGE_VALF;
    viewAnim2s.duration = speed;
	viewAnim2s.beginTime = Delay2Anim;
	viewAnim2s.removedOnCompletion = NO;
	
	CABasicAnimation *viewAnim3s = [CABasicAnimation animationWithKeyPath:@"position.x"];
    viewAnim3s.delegate = self;
    viewAnim3s.fromValue = @(-(springboardWindow3s.frame.size.width));
    viewAnim3s.toValue = @(kScreenW + springboardWindow3s.frame.size.width);
    viewAnim3s.repeatCount = HUGE_VALF;
    viewAnim3s.duration = speed;
    viewAnim3s.beginTime = Delay2Anim;
	viewAnim3s.removedOnCompletion = NO;
	
	CABasicAnimation *viewAnim4s = [CABasicAnimation animationWithKeyPath:@"position.x"];
    viewAnim4s.delegate = self;
    viewAnim4s.fromValue = @(kScreenW + springboardWindow4s.frame.size.width);
    viewAnim4s.toValue = @(-(springboardWindow4s.frame.size.width));
    viewAnim4s.repeatCount = HUGE_VALF;
    viewAnim4s.duration = speed;
    viewAnim4s.beginTime = Delay2Anim;
	viewAnim4s.removedOnCompletion = NO;
	
	
	[springboardWindow1.layer addAnimation:viewAnim1 forKey:@"anim"];
	[springboardWindow2.layer addAnimation:viewAnim2 forKey:@"anim"];
	[springboardWindow3.layer addAnimation:viewAnim3 forKey:@"anim"];
	[springboardWindow4.layer addAnimation:viewAnim4 forKey:@"anim"];
	
	[springboardWindow1s.layer addAnimation:viewAnim1s forKey:@"anim"];
	[springboardWindow2s.layer addAnimation:viewAnim2s forKey:@"anim"];
	[springboardWindow3s.layer addAnimation:viewAnim3s forKey:@"anim"];
    [springboardWindow4s.layer addAnimation:viewAnim4s forKey:@"anim"];
}
@end


static void EdgeAlertNotify()
{
	if([EdgeAlert sharedInstanceExist]) {
		[[EdgeAlert sharedInstance] startWithSeconds:DurationTime];
	}
}


%hook SpringBoard
- (void)applicationDidFinishLaunching:(id)application
{
	%orig;
	[[EdgeAlert sharedInstance] firstload];
}
%end

%hook BBServer
- (void)_publishBulletinRequest:(id)request forSectionID:(NSString *)sectionID forDestinations:(unsigned long long)destination alwaysToLockScreen:(BOOL)onLockscreen
{
	%orig(request, sectionID, destination, onLockscreen);
	if(Enabled) {
		notify_post("com.julioverne.edgealert/notify");
	}
}
%end


static void settingsChangedEdgeAlert()
{	
	@autoreleasepool {
		NSDictionary *EdgeAlertPrefs = [[[NSDictionary alloc] initWithContentsOfFile:@PLIST_PATH_Settings]?:[NSDictionary dictionary] copy];
		Enabled = (BOOL)[[EdgeAlertPrefs objectForKey:@"Enabled"]?:@YES boolValue];
		float newkWidth = (float)[[EdgeAlertPrefs objectForKey:@"Width.0"]?:@(4) floatValue];
		float newProportionSize = (float)[[EdgeAlertPrefs objectForKey:@"proportionSize"]?:@(1.4f) floatValue];
		float newkSpeed = (float)[[EdgeAlertPrefs objectForKey:@"Speed.0"]?:@(2.0f) floatValue];
		float newDurationTime = (float)[[EdgeAlertPrefs objectForKey:@"DurationTime"]?:@(10) floatValue];
		NSString* newAlertHexColor = [[EdgeAlertPrefs objectForKey:@"Color"]?:@"#0090ff" copy];
		if(newAlertHexColor != alertHexColor) {
			alertHexColor = newAlertHexColor;
			if([EdgeAlert sharedInstanceExist]) {
				[[EdgeAlert sharedInstance] updateWindowsFrames];
				[[EdgeAlert sharedInstance] stopAnimation];
				EdgeAlertNotify();
			}
		}
		if(newkWidth != kWidth) {
			kWidth = newkWidth;
			if([EdgeAlert sharedInstanceExist]) {
				[[EdgeAlert sharedInstance] updateWindowsFrames];
				[[EdgeAlert sharedInstance] stopAnimation];
				EdgeAlertNotify();
			}
		}
		if(newProportionSize != proportionSize) {
			proportionSize = newProportionSize;
			if([EdgeAlert sharedInstanceExist]) {
				[[EdgeAlert sharedInstance] updateWindowsFrames];
				[[EdgeAlert sharedInstance] stopAnimation];
				EdgeAlertNotify();
			}
		}
		if(newkSpeed != kSpeed) {
			kSpeed = newkSpeed;
			if([EdgeAlert sharedInstanceExist]) {
				[[EdgeAlert sharedInstance] stopAnimation];
				EdgeAlertNotify();
			}
		}
		if(newDurationTime != DurationTime) {
			DurationTime = newDurationTime;
			if([EdgeAlert sharedInstanceExist]) {
				[[EdgeAlert sharedInstance] stopAnimation];
				EdgeAlertNotify();
			}
		}
	}
}

%ctor
{
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)EdgeAlertNotify, CFSTR("com.julioverne.edgealert/notify"), NULL, CFNotificationSuspensionBehaviorCoalesce);
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)settingsChangedEdgeAlert, CFSTR("com.julioverne.edgealert/SettingsChanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
	settingsChangedEdgeAlert();
	kScreenW = [[UIScreen mainScreen] bounds].size.width;
	kScreenH = [[UIScreen mainScreen] bounds].size.height;
	%init;
}
