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
/* mainWindowPosition */
/* IMAppController */

#import <Cocoa/Cocoa.h>
#import "IMImageView.h"
#import "IMDroppingImageView.h"
#import "IMPreferencesController.h"

@interface IMAppController : NSObject
{
    IBOutlet IMDroppingImageView *imageView;
    IBOutlet IMPreferencesController *prefWindow;
}
//crate icon
//- (NSImage *)getIcon:(NSString *)path;
//- (NSImage *)getThumbnail:(NSString *)path;
- (NSImage *)createIcon:(NSString *)path;

//paste icon
//- (BOOL) pasteFolderIcon :(NSImage *)icon forPath:(NSString *)forPath;
//- (BOOL) pasteFolderIconForFolder :(NSImage *)icon iconPath:(NSString *)iconPath;
//- (BOOL) pasteFolderIconForPBoard :(NSImage *)icon;
- (BOOL) pasteIcon :(NSImage *)icon forPath:(NSString *)iconPath;

- (IBAction)doIcon:(id)sender;
- (IBAction)droppedIcon:(id)sender;


@end
