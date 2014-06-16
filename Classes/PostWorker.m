//
// PostWorker.m
//
// Created by RYAN CHRISTIANSON on 1/19/09. Reused with permission.
// Copyright querp 2009. All rights reserved.
//

#import "PostWorker.h"
#import "DrivingAppDelegate.h"

@implementation PostWorker

@synthesize url;
@synthesize usePost;
@synthesize params;
@synthesize responseCookies;
@synthesize responseData;
@synthesize requestCookies;


- (BOOL) start {
	
	// build post data
	NSData * postData = nil;
	if ( params != nil && [params count] > 0 ) {
		
		NSMutableString * postString = [[NSMutableString alloc] initWithCapacity:500];
		
		NSArray * allKeys = [params allKeys];
		NSInteger count = [allKeys count];
		for ( int i = 0; i < count; i++ ) {
			NSString * key = [allKeys objectAtIndex:i];
			NSString * value = [params objectForKey:key];
			
			[postString appendString: @"&"];
			[postString appendString: [DrivingAppDelegate urlEncode:key]];
			[postString appendString: @"="];
			[postString appendString: [DrivingAppDelegate urlEncode:value]];
		}
		
		
		postData = [postString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
		[postString release];
	}
	
	
	//TODO: encrypt request

	
	// setup the request object
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	[request setURL:[NSURL URLWithString:url]];
	
	
	// see if we have cookies to send
	if ( requestCookies != nil && [requestCookies count] > 0 ) {
		NSDictionary * cookieHeaders = [NSHTTPCookie requestHeaderFieldsWithCookies: requestCookies];
		NSMutableDictionary * mutableCookieHeaders =[[NSMutableDictionary alloc] initWithDictionary:cookieHeaders];
		[request setAllHTTPHeaderFields:mutableCookieHeaders];
		[mutableCookieHeaders release];
	}
	
	// add the params
	if ( usePost ) {
		[request setHTTPMethod:@"POST"];
		
		if ( postData != nil ) {
			NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
			[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
			[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
			[request setHTTPBody:postData];
			
			//NSString *postDataLog = [[NSString alloc] initWithData:postData encoding:NSASCIIStringEncoding];
			//NSLog(@"%@", postDataLog);
		}
		
	}
	else {
		[request setHTTPMethod:@"GET"];
	}
	
	
	
	NSURLResponse *response = nil;
	NSError *error = nil;
	
	responseData = [NSURLConnection sendSynchronousRequest: request returningResponse: &response error: &error];
	[responseData retain];
	
	
	/*
	 NSString * responseBody = [[NSString alloc] initWithData:responseData encoding: NSASCIIStringEncoding];
	 NSLog( @"%@", responseBody );
	 [responseBody release];
	*/
	 
	
	if ( error == nil && response != nil ) {
		responseCookies = [NSHTTPCookie cookiesWithResponseHeaderFields:[ (NSHTTPURLResponse*)response allHeaderFields] forURL:[NSURL URLWithString:url]];
		[responseCookies retain];
	}
	
	
	return (error == nil);
	
}






- (void) dealloc {
	[responseData release];
	[url release];
	[params release];
	[urlConnection release];
	[responseCookies release];
	[requestCookies release];
	[super dealloc];
}

- (id) init
{
	self = [super init];
	if (self != nil) {
		usePost = YES;
		
	}
	return self;
}



@end

