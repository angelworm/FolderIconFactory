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
#import "IMImageView.h"

#define ERROR_MESSAGE(bool,message ) \
	(bool ? \
	: NSLog(message));

@implementation IMImageView

- (id)initWithFrame:(NSRect)rect
{
    self = [super initWithFrame:rect];
    if(self) {
        NSArray* array = 
            [NSArray arrayWithObject:NSFilenamesPboardType];
        [self registerForDraggedTypes:array];
		_path = nil;
    }
    return self;
}

-(NSImage *) createFolderIcon : (NSImage *)im
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSWorkspace *workspase = [NSWorkspace sharedWorkspace];
	NSImage *folder = [workspase iconForFileType:NSFileTypeForHFSTypeCode('fldr')];
	NSImage *icon   = [[NSImage alloc] init];
	_point       = NSMakePoint([defaults integerForKey:@"frontImagePointX"],
								  [defaults integerForKey:@"frontImagePointY"]);
		
	[icon   setSize : NSMakeSize(128.0, 128.0)];
	[im     setSize : NSMakeSize(128.0 * [defaults integerForKey:@"frontImageScale"] / 100 ,
								 128.0 * [defaults integerForKey:@"frontImageScale"] / 100)];
	[folder setSize : NSMakeSize(128.0,128.0)];
	
	[icon lockFocus];
		[im compositeToPoint:_point
			operation:NSCompositeDestinationOver];
		
		[folder compositeToPoint:NSMakePoint(0.0,0.0)
					   operation:NSCompositeDestinationOver];
	[icon unlockFocus];

	return icon;
}

#pragma mark Drag&Drop
-(BOOL) prepareForDragOperation:(id )sender
{
	return YES;
}

- (void)draggingExited:(id <NSDraggingInfo>)sender
{
	NSPasteboard *ps = [sender draggingPasteboard];
	NSString *s = [[ps propertyListForType:NSFilenamesPboardType] objectAtIndex:0];
	NSWorkspace *workspase = [NSWorkspace sharedWorkspace];
	
	_path  = [s retain];
	front = [[workspase iconForFile:_path] retain];
	
	[self setImage: [self createFolderIcon : front]];
}

#pragma mark front image
-(void)setPoint:(NSPoint)thePoint
{
	_point = thePoint;
}

-(NSPoint)point
{
	return _point;
}

-(void)setScale:(int)theScale
{
	_scale = theScale;
	[front setSize : NSMakeSize(128.0 * theScale / 100 , 128.0 * theScale / 100)];
}

-(int)scale
{
	return _scale;
}

-(NSString *)path
{
	return _path;
}
@end
