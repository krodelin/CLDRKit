@import <Foundation/Foundation.j>
@import "../CLDRKit.j"

@implementation CLDRDatabaseTest : OJTestCase
{
    CLDRDatabase sharedDatabase;
}

- (void)setUp
{
    [CLDRDatabase reset];
    sharedDatabase = [CLDRDatabase sharedDatabase];
}

- (void)testSharedInstance
{
    [self assertNoThrow:(function(){
        [CLDRDatabase sharedDatabase];
    })];
    [self assert:[CLDRDatabase sharedDatabase] same:[CLDRDatabase sharedDatabase]];
    [self assert:sharedDatabase notSame:[[CLDRDatabase alloc] init]];
}

- (void)testAvailableLocaleIdentifiers
{
    [self assertTrue:[[sharedDatabase availableLocaleIdentifiers] count] > 0];
}

- (void)testLoadLanguage
{
    [self assertNoThrow:(function() {
        [sharedDatabase _loadLanguage:@"de"];
    })]
}

- (void)testLoadInitial
{
    var root;
    [self assertNoThrow:(function() {
        root = [sharedDatabase _loadInitial];
    })];
    [self assertTrue:[[root class] isSubclassOfClass:[CPDictionary class]]];
    [self assertNotNull:[root objectForKey:@"locales"]];
    [self assertNotNull:[root objectForKey:@"available"]];
    // [self assertNotNull:[root objectForKey:@"rootLocales"]];
}

- (void)__testLoadNonExistentLanguage
{
    [self assertThrows:(function (){
        [sharedDatabase _loadLanguage:@"und"];
    })];
}

- (void)testLoadAdditialLanguage
{
    [self assert:1 equals:[[sharedDatabase loadedLocaleIdentifiers] count]];
    [self assertTrue:[[sharedDatabase loadedLocaleIdentifiers] containsObject:@"root"]];
    [self assertFalse:[[sharedDatabase loadedLocaleIdentifiers] containsObject:@"it"]];
    [sharedDatabase _mergeLanguage:@"it"];
    [self assert:3 equals:[[sharedDatabase loadedLocaleIdentifiers] count]];
    [self assertTrue:[[sharedDatabase loadedLocaleIdentifiers] containsObject:@"it_CH"]];
}

- (void)testLoadedLocaleIdentifiers
{
    [self assert:1 equals:[[sharedDatabase loadedLocaleIdentifiers] count]];
    [self assertTrue:[[sharedDatabase loadedLocaleIdentifiers] containsObject:@"root"]];
}

- (void)testMergedLocaleWithIdentifier
{
    var locale;
    [self assertNoThrow:(function (){
        locale = [sharedDatabase mergedLocaleWithIdentifier:@"de-AT"];
    })];
    [self assert:@"de" equals:[locale valueForKeyPath:CPLocaleLanguageCode]];
    [self assert:@"AT" equals:[locale valueForKeyPath:CPLocaleCountryCode]];
}

@end

