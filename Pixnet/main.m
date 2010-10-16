//
//  main.m
//  PartRetard
//

#import <UIKit/UIKit.h>
#import "PartRetardAppDelegate.h"

int main(int argc, char *argv[])
{
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	int retVal = UIApplicationMain(argc, argv, nil, NSStringFromClass([PartRetardAppDelegate class]));
	[pool release];
	return retVal;
}
