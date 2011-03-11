//
//  TapTarget.mm
//  ProjectSkirmish
//
//  Created by Tony Luk on 30/12/10.
//  Copyright 2010 ImpactBlue Studios™. All rights reserved.
//

#import "TapTarget.h"


@implementation TapTarget
@synthesize isActive,tapPosition;

- (void) onEnterTransitionDidFinish
{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:1 swallowsTouches:YES];
}

- (void) onExit
{
	[[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
}

-(id) initWithMinTouchDuration:(float)time
{	
	self = [super init];
	minTapTime = time;
	ignoreZones = [[NSMutableArray alloc] init];
	return self;
}

-(void) addIgnoreZone:(CGRect)zone
{
	[ignoreZones addObject:[NSValue valueWithBytes:&zone objCType:@encode(struct CGRect)]];
}

-(bool) shouldIgnore:(CGPoint)point
{
	for (NSUInteger i = 0; i < [ignoreZones count];i++)
	{
		NSValue* val = [ignoreZones objectAtIndex:i];
		CGRect zone;
		[val getValue:&zone]; 
		if(point.x >= zone.origin.x && point.y >= zone.origin.y && point.x <= (zone.origin.x + zone.size.width) && point.y <= (zone.origin.y + zone.size.height))
			return true;
	}
	return false;
}

-(void) clearTap:(float)delta
{
	[self unschedule:@selector(clearTap:)];
	isActive = false;
}

#pragma mark Touch Delegate

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
	if (isActive) return NO;
	
	CGPoint location = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
	if([self shouldIgnore:location])
		return NO;
	
	tapPosition = location;
	isActive = true;
	[self schedule:@selector(clearTap:) interval:minTapTime];
	return YES;
	/*location = [self convertToNodeSpace:location];
	//Do a fast rect check before doing a circle hit check:
	if(location.x < -radius || location.x > radius || location.y < -radius || location.y > radius){
		return NO;
	}else{
		float dSq = location.x*location.x + location.y*location.y;
		if(radiusSq > dSq){
			active = YES;
			if (!isHoldable && !isToggleable){
				value = 1;
				[self schedule: @selector(limiter:) interval:rateLimit];
			}
			if (isHoldable) value = 1;
			if (isToggleable) value = !value;
			return YES;
		}
	}
	return NO;*/
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
}

- (void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
}

@end
