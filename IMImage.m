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

#include "IMImage.h"

BOOL IMResizeImageByLongerSide( NSImage* img, double Maxside) {
	if(img == nil) return NO;
	
	NSSize s = [img size];
	if(s.width == 0.0 && s.height == 0.0) return NO;
	
	[img retain];
	double longside = IMLongerSide(s);
	double d = Maxside / longside;
	
	[img setSize: NSMakeSize(s.width * d, s.height * d)];
	
	[img release];
	return YES;
}

NSImage *IMCreateSquareImage( NSImage *img ){
	[img retain];
	NSSize size = IMLongerAndShorterSide([img size]);
	NSImage *ret = [[NSImage alloc] initWithSize:NSMakeSize(size.height, size.height)];
	NSPoint pos = NSMakePoint( (size.height - [img size].width)/2.0
							  ,(size.height - [img size].height)/2.0 );
	
	[ret lockFocus];
	[img compositeToPoint:pos
				operation:NSCompositeSourceOver];
	[ret unlockFocus];
	
	[img release];
	return ret;
}
