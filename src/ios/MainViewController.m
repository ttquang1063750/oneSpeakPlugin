/*
Licensed to the Apache Software Foundation (ASF) under one
or more contributor license agreements.  See the NOTICE file
distributed with this work for additional information
regarding copyright ownership.  The ASF licenses this file
to you under the Apache License, Version 2.0 (the
"License"); you may not use this file except in compliance
with the License.  You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing,
software distributed under the License is distributed on an
"AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
KIND, either express or implied.  See the License for the
specific language governing permissions and limitations
under the License.
*/

//
//  MainViewController.h
    //  OfficialApplication
    //
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright ___ORGANIZATIONNAME___ ___YEAR___. All rights reserved.
//

#import "MainViewController.h"
#import "MapViewController.h"

    @implementation MainViewController

    - (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
if (self) {
// Uncomment to override the CDVCommandDelegateImpl used
    // _commandDelegate = [[MainCommandDelegate alloc] initWithViewController:self];
// Uncomment to override the CDVCommandQueue used
    // _commandQueue = [[MainCommandQueue alloc] initWithViewController:self];
}
return self;
}

- (id)init
{
  self = [super init];
if (self) {
// Uncomment to override the CDVCommandDelegateImpl used
    // _commandDelegate = [[MainCommandDelegate alloc] initWithViewController:self];
// Uncomment to override the CDVCommandQueue used
    // _commandQueue = [[MainCommandQueue alloc] initWithViewController:self];
}
return self;
}

- (void)didReceiveMemoryWarning
{
// Releases the view if it doesn't have a superview.
[super didReceiveMemoryWarning];

// Release any cached data, images, etc that aren't in use.
}

#pragma mark View lifecycle

    - (void)viewWillAppear:(BOOL)animated
{
// View defaults to full size.  If you want to customize the view's size, or its subviews (e.g. webView),
// you can do so here.
//Lower screen 20px on ios 7
if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
  if(self.webView.frame.origin.y == 0) {
    CGRect viewBounds = [self.webView bounds];
viewBounds.origin.y = 20;
viewBounds.size.height = viewBounds.size.height - 20;
self.webView.frame = viewBounds;
}
}
[super viewWillAppear:animated];
}

- (void)viewDidLoad
{
[super viewDidLoad];
// Do any additional setup after loading the view from its nib.
// 画面のサイズを取得
CGRect viewBounds = [[UIScreen mainScreen] applicationFrame];
// 店舗マップのViewのサイズの設定
// header 49, footer 60の想定
if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
  customView_ = [[UIView alloc]
initWithFrame:CGRectMake(0.0,
69.0,
viewBounds.size.width,
viewBounds.size.height - 69 - 60)];
}
else {
  customView_ = [[UIView alloc]
initWithFrame:CGRectMake(0.0,
49.0,
viewBounds.size.width,
viewBounds.size.height - 49 - 60)];
}
// 背景色の設定
customView_.backgroundColor = [UIColor colorWithRed:1.0f green:0.0f blue:0.0f alpha:0.5f];
// viewの初期状態は、非表示状態
customView_.hidden = true;
    // customViewを追加する。
[self.view addSubview:customView_];
}

- (void)viewDidUnload
{
[super viewDidUnload];
// Release any retained subviews of the main view.
// e.g. self.myOutlet = nil;
map_ = nil;
customView_ = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
// Return YES for supported orientations
return [super shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}

/* Comment out the block below to over-ride */

/*
- (UIWebView*) newCordovaViewWithFrame:(CGRect)bounds
{
  return[super newCordovaViewWithFrame:bounds];
}
    */

#pragma mark UIWebDelegate implementation

    - (void)webViewDidFinishLoad:(UIWebView*)theWebView
{
// Black base color for background matches the native apps
theWebView.backgroundColor = [UIColor blackColor];

NSString* URLString = [[theWebView.request.URL standardizedURL] absoluteString];
// map.htmlを開いているかどうか判断する。
NSRange match_map = [URLString rangeOfString:@"map.html"];



// map.htmlの場合
if (match_map.location != NSNotFound) {

// viewを表示状態にする。
if( customView_ != nil ){

// mapの呼び出し
if (map_ == nil) {

  map_ = [[MapViewController alloc] initWithView:self];
[map_ viewLoad:customView_];
}
else {
  map_.reloadView.hidden = NO;
  [map_ setUpMap];
}

customView_.hidden = NO;
}

}
// map.htmlではない場合、表示しない。
else{

// viewを非表示状態にする。
if( customView_ != nil ){
  customView_.hidden = YES;

  if (map_ != nil) {
    map_.reloadView.hidden = YES;
    [map_ gpsLocationOff];
  }
}
}


return [super webViewDidFinishLoad:theWebView];
}

/* Comment out the block below to over-ride */

/*

- (void) webViewDidStartLoad:(UIWebView*)theWebView
{
  return [super webViewDidStartLoad:theWebView];
}

    - (void) webView:(UIWebView*)theWebView didFailLoadWithError:(NSError*)error
{
  return [super webView:theWebView didFailLoadWithError:error];
}
    */

- (BOOL) webView:(UIWebView*)theWebView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType
{
  return [super webView:theWebView shouldStartLoadWithRequest:request navigationType:navigationType];
}

    @end

    @implementation MainCommandDelegate

    /* To override the methods, uncomment the line in the init function(s)
in MainViewController.m
    */

#pragma mark CDVCommandDelegate implementation

    - (id)getCommandInstance:(NSString*)className
{
  return [super getCommandInstance:className];
}

    - (NSString*)pathForResource:(NSString*)resourcepath
{
  return [super pathForResource:resourcepath];
}

    @end

    @implementation MainCommandQueue

    /* To override, uncomment the line in the init function(s)
in MainViewController.m
    */
- (BOOL)execute:(CDVInvokedUrlCommand*)command
{
  return [super execute:command];
}

    @end
