//
//  main.m
//  PartRetard
//

#import <UIKit/UIKit.h>
#import "PixnetAppDelegate.h"

int main(int argc, char *argv[])
{
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	int retVal = UIApplicationMain(argc, argv, nil, NSStringFromClass([PixnetAppDelegate class]));
	[pool release];
	return retVal;
}
