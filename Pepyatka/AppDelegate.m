#import "AppDelegate.h"
#import "APIClient.h"
#import "Server.h"

static NSString *singleBaseURL = @"https://try.pepyatka.com/";

@implementation AppDelegate

- (void)makeSingleEntryPoint {
    Server *pepyatka = [Server MR_findFirstByAttribute:@"baseURL" withValue:singleBaseURL];
    if(!pepyatka) {
        pepyatka = [Server MR_createEntity];
        pepyatka.baseURL = singleBaseURL;
        [pepyatka.managedObjectContext MR_saveToPersistentStoreAndWait];
    }
}

- (void)makeClientsForEntryPoints {
    NSArray *servers = [Server MR_findAll];
    [servers apply:^(Server *server) {
        APIClient *client = [[APIClient alloc] initWithBaseURL:[NSURL URLWithString:server.baseURL]];
        [client saveClient];
    }];
}

- (void)applyUIRules {
    [[UITableViewCell appearance] setTintColor:[UIColor blueButtonColor]];
//    [[UIBarButtonItem appearance] setTintColor:[UIColor blueButtonColor]];
    [[UINavigationBar appearance] setTintColor:[UIColor blueButtonColor]];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [MagicalRecord setupAutoMigratingCoreDataStack];
    [self makeSingleEntryPoint];
    [self makeClientsForEntryPoints];
    [self applyUIRules];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {}
- (void)applicationDidEnterBackground:(UIApplication *)application {}
- (void)applicationWillEnterForeground:(UIApplication *)application {}
- (void)applicationDidBecomeActive:(UIApplication *)application {}
- (void)applicationWillTerminate:(UIApplication *)application {}

@end
