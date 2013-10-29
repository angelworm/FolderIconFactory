/*
 * Copyright (c) 2007, karasu
 * 
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 * 
 * * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 * * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
 * CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
#import "IMDraggingImageView.h"

@implementation IMDraggingImageView

- (id)initWithFrame:(NSRect)rect
{
    self = [super initWithFrame:rect];
    if(self) {
		back = [[NSWorkspace sharedWorkspace] iconForFileType:NSFileTypeForHFSTypeCode('fldr')];
		foward = [[NSWorkspace sharedWorkspace] iconForFileType:NSFileTypeForHFSTypeCode('APPL')];
		point = NSMakePoint(48.0,8.0);
		[[back retain]   setSize : NSMakeSize(128.0, 128.0)];
		[[foward retain] setSize : NSMakeSize(80.0,80.0)];
	}
    return self;
}

-(void)awakeFromNib
{
	back   = [[NSWorkspace sharedWorkspace] iconForFileType:NSFileTypeForHFSTypeCode('fldr')];
	foward = [[NSWorkspace sharedWorkspace] iconForFileType:NSFileTypeForHFSTypeCode('APPL')];
	point = NSMakePoint(48.0,8.0);
	
	[[back retain]   setSize : NSMakeSize(128.0, 128.0)];
	[[foward retain] setSize : NSMakeSize(80.0,80.0)];
	
	[self displayIfNeeded];
}

-(void)dealloc {
	[back release];
	[foward release];
	
	[super dealloc];
}

-(void)displayIfNeeded
{
	icon   = [[NSImage alloc] init];
	
	[icon   setSize : NSMakeSize(128.0,128.0)];
	
	[icon lockFocus];
		[foward compositeToPoint:point
					   operation:NSCompositeDestinationOver];
		
		[back compositeToPoint:NSMakePoint(0.0,0.0)
					 operation:NSCompositeDestinationOver];
	[icon unlockFocus];
	[self setImage:icon];
	[icon release];
}

-(void)setPoint:(NSPoint)thePoint
{
	point = thePoint;
	[self displayIfNeeded];
}

-(NSPoint)point
{
	return point;
}

-(void)setScale:(int)theScale
{
	_scale = theScale;
//	[foward setSize : NSMakeSize(128.0 * theScale / 100 , 128.0 * theScale / 100)];
	IMResizeImageByLongerSide(foward, 128.0*theScale/100);
	[self displayIfNeeded];
}

- (void)setFowardImage:(NSImage *)theImage
{
	NSSize size = [foward size];
	[foward release];
	foward = [theImage retain];
	[foward setSize:size];
	[self displayIfNeeded];
}

- (void)setBackImage:(NSImage *)theImage
{
	NSSize size = [back size];
	[back release];
	
	[theImage setScalesWhenResized:YES];
	IMResizeImageByLongerSide(theImage, IMLongerSide(size));
	back = IMCreateSquareImage(theImage);
	
	[self displayIfNeeded];
}

-(int)scale
{
	return _scale;
}

#pragma mark MouseEvents
- (void)mouseDown:(NSEvent*)event
{
    mouse = [self convertPoint:[event locationInWindow] fromView:nil];
}

- (void)mouseDragged:(NSEvent*)event
{
	NSPoint newPoint = [self convertPoint:[event locationInWindow] fromView:nil];
	
	[self setPoint:NSMakePoint( point.x+ (newPoint.x - mouse.x) ,
								point.y+ (newPoint.y - mouse.y))];
	
	mouse = newPoint;

	if([self isContinuous]) {
		[self sendAction:[self action] to:[self target]];
	}
}

- (void)mouseUp:(NSEvent*)theEvent
{
	[self sendAction:[self action] to:[self target]];
}

@end
