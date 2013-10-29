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
/* IMPreferencesController */

#import <Cocoa/Cocoa.h>
#import "IMDraggingImageView.h"
#import "IMImage.h"

/*
 @"frontImageScale"	 0~100	手前の画像の縮小率
 @"frontImagePointX" int	手前の画像のx座標
 @"frontImagePointY" int	手前の画像のy座標
 @"backImagePath"	 string	後ろの画像までのパス
 @"makeButtonAction" 0or1	0:ICONファイルを作る
							1:親フォルダに張り付け
 @"pictureAction"	 0or1	0:ファイルアイコンを使用
 							1:ファイルのサムネを使用
 @"autoTerminate"	 BOOL	NO:Dockに放り込んでも終了しない
							YES:終了する
 @"defaultData"	     dict	設定したデフォルト
*/
@interface IMPreferencesController : NSWindowController
{
    IBOutlet NSTextField *_x;
    IBOutlet NSTextField *_y;
    IBOutlet NSTextField *dispImageSize;
    IBOutlet NSSlider *imageSizeBar;
    IBOutlet NSPopUpButton *imageType;
    IBOutlet IMDraggingImageView *imageView;
	IBOutlet NSMatrix *makeActionView;
	IBOutlet NSMatrix *pictActionView;
	IBOutlet NSButton *autoTerminateButton;
	NSArray* typelists_;
	NSDictionary *defaultData;
}
- (IBAction)showWindow:(id)sender;
- (IBAction)drag:(id)sender;
- (IBAction)reset:(id)sender;
- (IBAction)selectItem:(id)sender;
- (IBAction)setSize:(id)sender;
- (IBAction)setX:(id)sender;
- (IBAction)setY:(id)sender;
- (IBAction)selectItem:(id)sender;
- (IBAction)setMakeAction:(id)sender;
- (IBAction)setPictAction:(id)sender;
- (IBAction)setAutoTerminate:(id)sender;
- (IBAction)setDefault:(id)sender;
- (void)setValue;

- (void)initializeDefaults;
- (IBAction)showWindow:(id)sender;
@end
