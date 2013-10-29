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
#import "IMPreferencesController.h"

#define NS_USER_DEFAULTS [NSUserDefaults standardUserDefaults]

@implementation IMPreferencesController
- (id)init
{
	if(self = [super init]) {
		typelists_ = [[NSArray arrayWithObjects:
			@"/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/GenericFolderIcon.icns"
			,@"/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/OpenFolderIcon.icns"
			,@"/System/Library/Extensions/IOStorageFamily.kext/Contents/Resources/Internal.icns"
			,@"/System/Library/Extensions/IOStorageFamily.kext/Contents/Resources/Removable.icns"
			,@"/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/CDAudioVolumeIcon.icns"
			,@"/System/Library/Extensions/IOSCSIArchitectureModelFamily.kext/Contents/Resources/FireWireHD.icns"
			,@"/System/Library/Extensions/IOSCSIArchitectureModelFamily.kext/Contents/Resources/USBHD.icns"
			,@""
			,@"/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/GenericApplicationIcon.icns"
			,@"/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/KEXT.icns"
			,@""
			,@"/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/TrashIcon.icns"
			,@"/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/FullTrashIcon.icns"
			,@""
			,@"/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/HomeFolderIcon.icns"
			,@"/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/ApplicationsFolderIcon.icns"
			,@"/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/DesktopFolderIcon.icns"
			,@"/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/DocumentsFolderIcon.icns"
			,@"/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/MovieFolderIcon.icns"
			,@"/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/MusicFolderIcon.icns"
			,@"/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/LibraryFolderIcon.icns"
			,@"/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/SitesFolderIcon.icns"
			,@""
			,@"/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/SystemFolderIcon.icns"
			,@"/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/SmartFolderIcon.icns"
			,@""
			//,@"その他..."「[NSArray count]」
			,nil] retain];
		
		defaultData = [[NSDictionary dictionaryWithObjectsAndKeys:
					   [NSNumber numberWithInt:65]	,@"frontImageScale",
					   [NSNumber numberWithInt:46]	,@"frontImagePointX",
					   [NSNumber numberWithInt:8]	,@"frontImagePointY",
					   [typelists_ objectAtIndex:0]	,@"backImagePath",
						[NSNumber numberWithInt:0]	,@"makeButtonAction",
						[NSNumber numberWithInt:0]	,@"pictureAction",
						[NSNumber numberWithBool:NO]	,@"autoTerminate",
						nil]
					   retain];
		
	}
	
	return self;
}

- (void)setValue
{
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	NSPoint p;
	
	int row = [defaults integerForKey:@"frontImageScale"];
	[dispImageSize setIntValue:row];
	[imageSizeBar  setIntValue:row];
	[imageView setScale:row];
	
	row = [defaults integerForKey:@"frontImagePointX"];
	[_x setIntValue:row];
	p.x = (float)row;
	
	row = [defaults integerForKey:@"frontImagePointY"];
	[_y setIntValue:row];
	p.y = (float)row;
	
	[imageView setPoint:p];
	
	row = [typelists_ indexOfObject:[defaults stringForKey:@"backImagePath"]];
	[imageType selectItemAtIndex: (row == NSNotFound ? [typelists_ count]:row)];
	[imageView setBackImage:[[NSImage alloc] initWithContentsOfFile:[defaults stringForKey:@"backImagePath"]]];	
	
	row = [defaults integerForKey:@"makeButtonAction"];
	[makeActionView selectCellAtRow:row
							 column:0];
	
	row = [defaults integerForKey:@"pictureAction"];
	[pictActionView selectCellAtRow:row
							 column:0];	
}


- (void)initializeDefaults
{
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	
	NSDictionary *d = [defaults dictionaryForKey:@"defaultData"];
	d = (d == nil ? defaultData : d);
	[defaults setObject: d
				 forKey: @"defaultData"];	
	
	int row = [defaults integerForKey:@"frontImageScale"];
	[defaults setInteger: (row == 0 ? 
						   [[d objectForKey:@"frontImageScale"] intValue]
						   : row) 
				  forKey: @"frontImageScale"];
	
	row = [defaults integerForKey:@"frontImagePointX"];
	[defaults setInteger: (row == 0 ? 
						   [[d objectForKey:@"frontImagePointX"] intValue]
						   : row) 
				  forKey:@"frontImagePointX"];
	
	row = [defaults integerForKey:@"frontImagePointY"];
	[defaults setInteger: (row == 0 ? 
						   [[d objectForKey:@"frontImagePointY"] intValue]
						   : row) 
				  forKey: @"frontImagePointY"];
	
	if([defaults stringForKey:@"backImagePath"] == nil || 
	   ![[NSFileManager defaultManager] fileExistsAtPath:
			[defaults stringForKey:@"backImagePath"]]){
		[defaults setObject: [d objectForKey:@"backImagePath"]
					 forKey: @"backImagePath"];
	}
	
	row = [defaults integerForKey:@"makeButtonAction"];
	[defaults setInteger: (row < 0 || row > 2 ?
						   [[d objectForKey:@"makeButtonAction"] intValue]
						   : row) 
				  forKey: @"makeButtonAction"];
	
	row = [defaults integerForKey:@"pictureAction"];
	[defaults setInteger: (row < 0 || row > 1 ?
						   [[d objectForKey:@"pictureAction"] intValue]
						   : row)
				  forKey: @"pictureAction"];
}

- (IBAction)showWindow:(id)sender
{
	[self setValue];
	[super showWindow:sender];
}

#pragma mark IBAction
- (IBAction)reset:(id)sender
{
	NSDictionary *dic = [NS_USER_DEFAULTS objectForKey:@"defaultData"];
	[NS_USER_DEFAULTS registerDefaults:dic];
	
	[NSUserDefaults resetStandardUserDefaults];	
	[NS_USER_DEFAULTS registerDefaults:dic];
	
	NSUserDefaults* defaults =  [NSUserDefaults standardUserDefaults];
	
	NSEnumerator *e = [dic keyEnumerator];
	id key;
	while(key = [e nextObject]) {
		[defaults setObject:[dic objectForKey:key] forKey:key];
	}
	
	[self initializeDefaults];
	[self setValue];
}

- (IBAction)drag:(id)sender
{
	NSPoint p = [imageView point];
	[_x setIntValue:(int)p.x];
	[_y setIntValue:(int)p.y];
	[NS_USER_DEFAULTS setInteger:[_x intValue] forKey:@"frontImagePointX"];
	[NS_USER_DEFAULTS setInteger:[_y intValue] forKey:@"frontImagePointY"];
	
}

- (IBAction)setSize:(id)sender
{
	[dispImageSize setIntValue:[sender intValue]];
	[imageView	   setScale:[sender intValue]];
	[NS_USER_DEFAULTS	   setInteger:[sender intValue] forKey:@"frontImageScale"];
}

- (IBAction)setX:(id)sender
{
	NSPoint p = [imageView point];
	p.x = [sender intValue];
	[imageView setPoint:p];
	[NS_USER_DEFAULTS setInteger:[_x intValue] forKey:@"frontImagePointX"];
}

- (IBAction)setY:(id)sender
{
	NSPoint p = [imageView point];
	p.y = [sender intValue];
	[imageView setPoint:p];
	[NS_USER_DEFAULTS setInteger:[_y intValue] forKey:@"frontImagePointY"];
	
}

- (IBAction)selectItem:(id)sender
{
	int selected = [sender indexOfSelectedItem];
	NSString *path = nil;
	
	if( selected == [typelists_ count] ) {
		//「その他...」ならファイル選択を要求
		NSOpenPanel *opanel = [NSOpenPanel openPanel];
		[opanel setCanChooseDirectories:NO];
		[opanel setCanChooseFiles:YES];
		int result = [opanel runModalForTypes: [NSImage imageFileTypes]];
		
		if(result != NSOKButton)
			path = [typelists_ objectAtIndex:0];
		else
			path = [opanel filename];
	} else {
		path = [typelists_ objectAtIndex:[sender indexOfSelectedItem]];
	}
	
	[NS_USER_DEFAULTS setObject: path
				 forKey: @"backImagePath"];
	[imageView setBackImage:[[NSImage alloc] initWithContentsOfFile:path]];
}

- (IBAction)setMakeAction:(id)sender
{
	[NS_USER_DEFAULTS setInteger:[sender selectedRow] forKey:@"makeButtonAction"];
}
- (IBAction)setPictAction:(id)sender 
{
	[NS_USER_DEFAULTS setInteger:[sender selectedRow] forKey:@"pictureAction"];
}
- (IBAction)setAutoTerminate:(id)sender
{
	[NS_USER_DEFAULTS setBool:([sender state] == NSOnState) forKey:@"autoTerminate"];
}
- (IBAction)setDefault:(id)sender {
	NSUserDefaults* defaults = NS_USER_DEFAULTS;
	NSDictionary *data = [defaults dictionaryRepresentation];
	
	NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:[defaultData count]];
	NSEnumerator *keys = [defaultData keyEnumerator];
	id key ;
	
	while(key = [keys nextObject]) {
		[dic setObject:[data objectForKey:key] forKey:key];
	}
	
	[defaults setObject:dic forKey:@"defaultData"];
}

#pragma mark その他
-(void)awakeFromNib
{
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	
	[self initializeDefaults];
	[defaults registerDefaults:defaultData];
}

- (void)dealloc 
{
	[typelists_ release];
	[super dealloc];
}
@end