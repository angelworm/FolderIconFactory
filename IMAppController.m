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
#import "IMAppController.h"

@implementation IMAppController

-(void)awakeFromNib
{
	[prefWindow initializeDefaults];
}

- (NSImage *)getIcon:(NSString *)path
{
	return [[NSWorkspace sharedWorkspace] iconForFile:path];
}
- (NSImage *)getThumbnail:(NSString *)path
{
	NSImage *file = [[NSImage alloc] initWithContentsOfFile:path];
	NSImage *data;
	
	if(file == nil) {
		return [self getIcon:path];
	}
	
	[file setScalesWhenResized:YES];
	
	IMResizeImageByLongerSide(file, 512);
	data = IMCreateSquareImage(file);
	[file release];
	
	[data setScalesWhenResized:YES];
	return data;
}
- (NSImage *)createIcon:(NSString *)path
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[prefWindow initializeDefaults];
	
	NSImage *imagebase = [[NSImage alloc] initWithContentsOfFile:
						  [defaults stringForKey:@"backImagePath"]];
	NSImage *folder;
		
	[imagebase setScalesWhenResized:YES];
	IMResizeImageByLongerSide(imagebase, 512);
	folder = IMCreateSquareImage(imagebase);
	
	[imagebase release];
	
	NSImage *image;
	
	switch([[NSUserDefaults standardUserDefaults] integerForKey:@"pictureAction"]) {
		case 0:
			image = [self getIcon:path];
			break;
		case 1:
			image = [self getThumbnail:path];
			break;
		default:
			return nil;
	}
	
	[folder setScalesWhenResized:YES];
	
	[folder size];
	NSPoint _point = NSMakePoint([folder size].width / 128 *
									[defaults integerForKey:@"frontImagePointX"],
								 [folder size].height / 128 * 
									[defaults integerForKey:@"frontImagePointY"]);
	
	[image setSize:[folder size]];
	[image setSize:NSMakeSize([folder size].width *
								([defaults integerForKey:@"frontImageScale"] /100.0)
                              ,[folder size].height *
								([defaults integerForKey:@"frontImageScale"] /100.0))];

    // 貼付け
    [folder lockFocus];
	[image compositeToPoint:_point
				  operation:NSCompositeSourceOver];
    [folder unlockFocus];
    
	return folder;
}

#pragma mark IBAction

- (IBAction)droppedIcon:(id)sender
{
	[imageView setImage:[self createIcon:[sender stringValue]]];
}


-(IBAction)doIcon:(id)sender 
{
	[self pasteIcon :[imageView image] forPath:[imageView stringValue]];
}

#pragma mark paste Folder Icon

-(BOOL) pasteFolderIcon :(NSImage *)icon forPath:(NSString *)forPath
{
	NSString *full = [NSString stringWithFormat:@"%@%@",
		[forPath stringByDeletingPathExtension],@"_ICON"];
	NSFileManager *fm = [ NSFileManager defaultManager];
	NSWorkspace *workspase = [NSWorkspace sharedWorkspace];
	BOOL boo; 
	
	if(![fm fileExistsAtPath:full]) {
	
		boo = [fm createDirectoryAtPath:full
							 attributes:nil];
		if(!boo)
		{
			NSLog(@"cannot create file.");
			return NO;
		}
	}
	
	boo =  [workspase setIcon: icon
					  forFile: full
					  options: NSExcludeQuickDrawElementsIconCreationOption];
	
	[workspase fileSystemChanged];
	
	return YES;
}
- (BOOL) pasteFolderIconForFolder :(NSImage *)icon iconPath:(NSString *)iconPath
{
	NSString *full = [iconPath stringByDeletingLastPathComponent];
	NSWorkspace *workspase = [NSWorkspace sharedWorkspace];
	BOOL boo; 
	
	boo =  [workspase setIcon: icon
					  forFile: full
					  options: NSExcludeQuickDrawElementsIconCreationOption];
	
	[workspase fileSystemChanged];
	
	return boo;	
}
- (BOOL) pasteFolderIconForPBoard :(NSImage *)icon
{
	NSPasteboard *pb = [NSPasteboard generalPasteboard];
	[pb declareTypes:[NSArray arrayWithObjects:NSTIFFPboardType, nil] owner:self];	
	
	return [pb setData:[icon TIFFRepresentation] forType:NSTIFFPboardType];	
}

- (BOOL) pasteIcon:(NSImage *)icon forPath:(NSString *)iconPath
{
	switch([[NSUserDefaults standardUserDefaults] integerForKey:@"makeButtonAction"]) {
		case 0:
			return [self pasteFolderIcon :icon
								  forPath:iconPath];
		case 1:
			return [self pasteFolderIconForFolder :icon
										  iconPath:iconPath];
		case 2:
			return [self pasteFolderIconForPBoard :icon];
	}
	return NO;
}

#pragma mark NSApplication delegate
- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication
{
	return YES;
}

- (BOOL)application:(NSApplication *)theApplication openFile:(NSString *)filename
{
	BOOL b =[self pasteIcon:[self createIcon:filename] forPath:filename];
	if([[NSUserDefaults standardUserDefaults] boolForKey:@"autoTerminate"])
		[NSApp terminate:nil];
	return b;
}

- (void)application:(NSApplication *)sender openFiles:(NSArray *)filenames
{
	NSEnumerator *efile = [filenames objectEnumerator];
	NSString *filename;
	
	while(filename = [efile nextObject]) {
		[self pasteIcon:[self createIcon:filename] forPath:filename];
	}
	
	if([[NSUserDefaults standardUserDefaults] boolForKey:@"autoTerminate"])
		[NSApp terminate:sender];
}
@end
