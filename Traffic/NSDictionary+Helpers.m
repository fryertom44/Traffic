//
//  NSDictionary+Helpers.m
//  Greenhouse
//
//  Created by Roy Clarkson on 6/28/10.
//  Copyright 2010 VMware. All rights reserved.
//

#import "NSDictionary+Helpers.h"


@implementation NSDictionary (NSDictionary_Helpers)

- (NSString *)stringForKey:(id)aKey 
{		
	NSString *s;
	
	@try 
	{
		NSObject *o = [self objectForKey:aKey];
		
		if (o == nil || o == [NSNull null]) 
		{
			s = nil;
		}
		else 
		{
			if ([o isKindOfClass:[NSString class]])
			{
				s = (NSString *)o;
			}			
			else if ([o isKindOfClass:[NSNumber class]])
			{
				s = [(NSNumber *)o stringValue];
			}
		}
	}
	@catch (NSException *e) 
	{
		NSLog(@"Caught %@%@", [e name], [e reason]);
		s = nil;
	}
	@finally 
	{ 
		return s;
	}
}

- (NSString *)stringByReplacingPercentEscapesForKey:(id)aKey usingEncoding:(NSStringEncoding)encoding
{		
	NSString *s;
	
	@try 
	{
		NSObject *o = [self objectForKey:aKey];
		
		if (o == nil || o == [NSNull null]) 
		{
			s = nil;
		}
		else 
		{
			s = [[NSString stringWithString:(NSString *)o] stringByReplacingPercentEscapesUsingEncoding:encoding];
		}
	}
	@catch (NSException *e) 
	{
		NSLog(@"Caught %@%@", [e name], [e reason]);
		s = nil;
	}
	@finally 
	{ 
		return s;
	}
}

- (NSInteger)integerForKey:(id)aKey 
{	
	NSInteger i;
	
	@try 
	{
		NSObject *o = [self objectForKey:aKey];
		
		if (o == nil || o == [NSNull null]) 
		{
			i = 0;
		}
		else 
		{
			i = [(NSNumber *)o integerValue];
		}
	}
	@catch (NSException *e) 
	{
		NSLog(@"Caught %@%@", [e name], [e reason]);
		i = 0;
	}
	@finally 
	{ 
		return i;
	}
}

- (double)doubleForKey:(id)aKey 
{	
	double d;
	
	@try 
	{
		NSObject *o = [self objectForKey:aKey];
		
		if (o == nil || o == [NSNull null]) 
		{
			d = 0.0f;
		}
		else 
		{
			d = [(NSNumber *)o doubleValue];
		}
	}
	@catch (NSException *e) 
	{
		NSLog(@"Caught %@%@", [e name], [e reason]);
		d = 0.0f;
	}
	@finally 
	{ 
		return d;
	}
}

- (BOOL)boolForKey:(id)aKey
{
	BOOL b;
	
	@try 
	{
		NSObject *o = [self objectForKey:aKey];
		
		if (o == nil || o == [NSNull null])
		{
			b = NO;
		}
		else 
		{
			b = [(NSNumber *)o boolValue];
		}
	}
	@catch (NSException * e) 
	{
		NSLog(@"Caught %@%@", [e name], [e reason]);
		b = NO;
	}
	@finally 
	{
		return b;
	}
}

- (NSDate *)dateWithMillisecondsSince1970ForKey:(id)aKey 
{	
	NSDate *date;
	
	@try 
	{
		double milliseconds = [self doubleForKey:aKey];
		NSTimeInterval unixDate = (milliseconds * .001);
		date = [NSDate dateWithTimeIntervalSince1970:unixDate];
	}
	@catch (NSException *e) 
	{
		NSLog(@"Caught %@%@", [e name], [e reason]);
		date = nil;
	}
	@finally 
	{
		return date;
	}
}


- (NSDate *)dateFromJSONStringForKey:(id)aKey
{
	NSString *s;
    NSDate *date;

    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:kJSONDateFormat];
    
	@try
	{
		NSObject *o = [self objectForKey:aKey];
		
		if (o == nil || o == [NSNull null])
		{
			date = nil;
		}
		else
		{
			if ([o isKindOfClass:[NSString class]])
			{
				s = (NSString *)o;
                date = [df dateFromString:s];
			}
			else if ([o isKindOfClass:[NSNumber class]])
			{
				s = [(NSNumber *)o stringValue];
			}
		}
    }
	@catch (NSException *e)
	{
		NSLog(@"Caught %@%@", [e name], [e reason]);
		date = nil;
	}
	@finally
	{
		return date;
	}
}

- (NSURL *)urlForKey:(id)aKey
{
	NSURL *url;
	
	@try 
	{
		url = [NSURL URLWithString:[self stringByReplacingPercentEscapesForKey:aKey usingEncoding:NSUTF8StringEncoding]];
	}
	@catch (NSException * e) 
	{
		NSLog(@"Caught %@%@", [e name], [e reason]);
		url = nil;
	}
	@finally 
	{
		return url;
	}
}


@end
