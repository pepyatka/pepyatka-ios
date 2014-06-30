#import "AppDelegate.h"
#import "APIClient.h"

static NSString *baseURL = @"http://pepyatka.com/";

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [APIClient setDefaultClient:[[APIClient alloc] initWithBaseURL:[NSURL URLWithString:baseURL]]];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {}
- (void)applicationDidEnterBackground:(UIApplication *)application {}
- (void)applicationWillEnterForeground:(UIApplication *)application {}
- (void)applicationDidBecomeActive:(UIApplication *)application {}
- (void)applicationWillTerminate:(UIApplication *)application {}

@end
