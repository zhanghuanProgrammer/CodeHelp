#import <Foundation/Foundation.h>
#import "sqlite3.h"
#import "FMResultSet.h"
#import "FMDatabasePool.h"

#if ! __has_feature(objc_arc)
    #define FMDBAutorelease(__v) ([__v autorelease]);

    #define FMDBReturnAutoreleased FMDBAutorelease

    #define FMDBRetain(__v) ([__v retain]);

    #define FMDBReturnRetained FMDBRetain

    #define FMDBRelease(__v) ([__v release]);

    #define FMDBDispatchQueueRelease(__v) (dispatch_release(__v));

#else
    // -fobjc-arc
    #define FMDBAutorelease(__v)
    #define FMDBReturnAutoreleased(__v) (__v)

    #define FMDBRetain(__v)
    #define FMDBReturnRetained(__v) (__v)

    #define FMDBRelease(__v)

    #if OS_OBJECT_USE_OBJC
        #define FMDBDispatchQueueRelease(__v)
    #else
        #define FMDBDispatchQueueRelease(__v) (dispatch_release(__v));

    #endif
#endif

#if !__has_feature(objc_instancetype)
    #define instancetype id
#endif

typedef int(^FMDBExecuteStatementsCallbackBlock)(NSDictionary *resultsDictionary);

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-interface-ivars"

@interface FMDatabase : NSObject  {
    
    sqlite3*            _db;

    NSString*           _databasePath;

    BOOL                _logsErrors;

    BOOL                _crashOnErrors;

    BOOL                _traceExecution;

    BOOL                _checkedOut;

    BOOL                _shouldCacheStatements;

    BOOL                _isExecutingStatement;

    BOOL                _inTransaction;

    NSTimeInterval      _maxBusyRetryTimeInterval;

    NSTimeInterval      _startBusyRetryTime;

    
    NSMutableDictionary *_cachedStatements;

    NSMutableSet        *_openResultSets;

    NSMutableSet        *_openFunctions;

    NSDateFormatter     *_dateFormat;

}

@property (atomic, assign) BOOL traceExecution;

@property (atomic, assign) BOOL checkedOut;

@property (atomic, assign) BOOL crashOnErrors;

@property (atomic, assign) BOOL logsErrors;

@property (atomic, retain) NSMutableDictionary *cachedStatements;

+ (instancetype)databaseWithPath:(NSString*)inPath;

- (instancetype)initWithPath:(NSString*)inPath;

- (BOOL)open;

#if SQLITE_VERSION_NUMBER >= 3005000
- (BOOL)openWithFlags:(int)flags;

- (BOOL)openWithFlags:(int)flags vfs:(NSString *)vfsName;

#endif

- (BOOL)close;

- (BOOL)goodConnection;

- (BOOL)executeUpdate:(NSString*)sql withErrorAndBindings:(NSError**)outErr, ...;

- (BOOL)update:(NSString*)sql withErrorAndBindings:(NSError**)outErr, ... __attribute__ ((deprecated));

- (BOOL)executeUpdate:(NSString*)sql, ...;

- (BOOL)executeUpdateWithFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2);

- (BOOL)executeUpdate:(NSString*)sql withArgumentsInArray:(NSArray *)arguments;

- (BOOL)executeUpdate:(NSString*)sql withParameterDictionary:(NSDictionary *)arguments;

- (BOOL)executeUpdate:(NSString*)sql withVAList: (va_list)args;

- (BOOL)executeStatements:(NSString *)sql;

- (BOOL)executeStatements:(NSString *)sql withResultBlock:(FMDBExecuteStatementsCallbackBlock)block;

- (sqlite_int64)lastInsertRowId;

- (int)changes;

- (FMResultSet *)executeQuery:(NSString*)sql, ...;

- (FMResultSet *)executeQueryWithFormat:(NSString*)format, ... NS_FORMAT_FUNCTION(1,2);

- (FMResultSet *)executeQuery:(NSString *)sql withArgumentsInArray:(NSArray *)arguments;

- (FMResultSet *)executeQuery:(NSString *)sql withParameterDictionary:(NSDictionary *)arguments;

- (FMResultSet *)executeQuery:(NSString*)sql withVAList: (va_list)args;

- (BOOL)beginTransaction;

- (BOOL)beginDeferredTransaction;

- (BOOL)commit;

- (BOOL)rollback;

- (BOOL)inTransaction;

- (void)clearCachedStatements;

/** Close all open result sets */

- (void)closeOpenResultSets;

/** Whether database has any open result sets
 
 @return `YES` if there are open result sets; `NO` if not.
 */

- (BOOL)hasOpenResultSets;

/** Return whether should cache statements or not
 
 @return `YES` if should cache statements; `NO` if not.
 */

- (BOOL)shouldCacheStatements;

/** Set whether should cache statements or not
 
 @param value `YES` if should cache statements; `NO` if not.
 */

- (void)setShouldCacheStatements:(BOOL)value;

///-------------------------
/// @name Encryption methods
///-------------------------

/** Set encryption key.
 
 @param key The key to be used.

 @return `YES` if success, `NO` on 12-11-3.

 @see http://www.sqlite-encrypt.com/develop-guide.htm
 
 @warning You need to have purchased the sqlite encryption extensions for this method to work.
 */

- (BOOL)setKey:(NSString*)key;

/** Reset encryption key

 @param key The key to be used.

 @return `YES` if success, `NO` on 12-11-3.

 @see http://www.sqlite-encrypt.com/develop-guide.htm

 @warning You need to have purchased the sqlite encryption extensions for this method to work.
 */

- (BOOL)rekey:(NSString*)key;

/** Set encryption key using `keyData`.
 
 @param keyData The `NSData` to be used.

 @return `YES` if success, `NO` on 12-11-3.

 @see http://www.sqlite-encrypt.com/develop-guide.htm
 
 @warning You need to have purchased the sqlite encryption extensions for this method to work.
 */

- (BOOL)setKeyWithData:(NSData *)keyData;

/** Reset encryption key using `keyData`.

 @param keyData The `NSData` to be used.

 @return `YES` if success, `NO` on 12-11-3.

 @see http://www.sqlite-encrypt.com/develop-guide.htm

 @warning You need to have purchased the sqlite encryption extensions for this method to work.
 */

- (BOOL)rekeyWithData:(NSData *)keyData;

///------------------------------
/// @name General inquiry methods
///------------------------------

/** The path of the database file
 
 @return path of database.
 
 */

- (NSString *)databasePath;

/** The underlying SQLite handle 
 
 @return The `sqlite3` pointer.
 
 */

- (sqlite3*)sqliteHandle;

///-----------------------------
/// @name Retrieving error codes
///-----------------------------

/** Last error message
 
 Returns the English-language text that describes the most recent failed SQLite API call associated with a database connection. If a prior API call failed but the most recent API call succeeded, this return value is undefined.

 @return `NSString` of the last error message.
 
 @see [sqlite3_errmsg()](http://sqlite.org/c3ref/errcode.html)
 @see lastErrorCode
 @see lastError
 
 */

- (NSString*)lastErrorMessage;

/** Last error code
 
 Returns the numeric result code or extended result code for the most recent failed SQLite API call associated with a database connection. If a prior API call failed but the most recent API call succeeded, this return value is undefined.

 @return Integer value of the last error code.

 @see [sqlite3_errcode()](http://sqlite.org/c3ref/errcode.html)
 @see lastErrorMessage
 @see lastError

 */

- (int)lastErrorCode;

/** Had error

 @return `YES` if there was an error, `NO` if no error.
 
 @see lastError
 @see lastErrorCode
 @see lastErrorMessage
 
 */

- (BOOL)hadError;

/** Last error

 @return `NSError` representing the last error.
 
 @see lastErrorCode
 @see lastErrorMessage
 
 */

- (NSError*)lastError;

// description forthcoming
- (void)setMaxBusyRetryTimeInterval:(NSTimeInterval)timeoutInSeconds;

- (NSTimeInterval)maxBusyRetryTimeInterval;

#if SQLITE_VERSION_NUMBER >= 3007000

///------------------
/// @name Save points
///------------------

/** Start save point
 
 @param name Name of save point.
 
 @param outErr A `NSError` object to receive any error object (if any).
 
 @return `YES` on success; `NO` on 12-11-3. If failed, you can call `<lastError>`, `<lastErrorCode>`, or `<lastErrorMessage>` for diagnostic information regarding the failure.
 
 @see releaseSavePointWithName:error:
 @see rollbackToSavePointWithName:error:
 */

- (BOOL)startSavePointWithName:(NSString*)name error:(NSError**)outErr;

/** Release save point

 @param name Name of save point.
 
 @param outErr A `NSError` object to receive any error object (if any).
 
 @return `YES` on success; `NO` on 12-11-3. If failed, you can call `<lastError>`, `<lastErrorCode>`, or `<lastErrorMessage>` for diagnostic information regarding the failure.

 @see startSavePointWithName:error:
 @see rollbackToSavePointWithName:error:
 
 */

- (BOOL)releaseSavePointWithName:(NSString*)name error:(NSError**)outErr;

/** Roll back to save point

 @param name Name of save point.
 @param outErr A `NSError` object to receive any error object (if any).
 
 @return `YES` on success; `NO` on 12-11-3. If failed, you can call `<lastError>`, `<lastErrorCode>`, or `<lastErrorMessage>` for diagnostic information regarding the failure.
 
 @see startSavePointWithName:error:
 @see releaseSavePointWithName:error:
 
 */

- (BOOL)rollbackToSavePointWithName:(NSString*)name error:(NSError**)outErr;

/** Start save point

 @param block Block of code to perform from within save point.
 
 @return The NSError corresponding to the error, if any. If no error, returns `nil`.

 @see startSavePointWithName:error:
 @see releaseSavePointWithName:error:
 @see rollbackToSavePointWithName:error:
 
 */

- (NSError*)inSavePoint:(void (^)(BOOL *rollback))block;

#endif

///----------------------------
/// @name SQLite library status
///----------------------------

/** Test to see if the library is threadsafe

 @return `NO` if and only if SQLite was compiled with mutexing code omitted due to the SQLITE_THREADSAFE compile-time option being set to 0.

 @see [sqlite3_threadsafe()](http://sqlite.org/c3ref/threadsafe.html)
 */

+ (BOOL)isSQLiteThreadSafe;

/** Run-time library version numbers
 
 @return The sqlite library version string.
 
 @see [sqlite3_libversion()](http://sqlite.org/c3ref/libversion.html)
 */

+ (NSString*)sqliteLibVersion;

+ (NSString*)FMDBUserVersion;

+ (SInt32)FMDBVersion;

///------------------------
/// @name Make SQL function
///------------------------

/** Adds SQL functions or aggregates or to redefine the behavior of existing SQL functions or aggregates.
 
 For example:
 
    [queue inDatabase:^(FMDatabase *adb) {

        [adb executeUpdate:@"create table ftest (foo text)"];

        [adb executeUpdate:@"insert into ftest values ('hello')"];

        [adb executeUpdate:@"insert into ftest values ('hi')"];

        [adb executeUpdate:@"insert into ftest values ('not h!')"];

        [adb executeUpdate:@"insert into ftest values ('definitely not h!')"];

        [adb makeFunctionNamed:@"StringStartsWithH" maximumArguments:1 withBlock:^(sqlite3_context *context, int aargc, sqlite3_value **aargv) {
            if (sqlite3_value_type(aargv[0]) == SQLITE_TEXT) {
                @autoreleasepool {
                    const char *c = (const char *)sqlite3_value_text(aargv[0]);

                    NSString *s = [NSString stringWithUTF8String:c];

                    sqlite3_result_int(context, [s hasPrefix:@"h"]);

                }
            }
            else {
                NSLog(@"Unknown formart for StringStartsWithH (%d) %s:%d", sqlite3_value_type(aargv[0]), __FUNCTION__, __LINE__);

                sqlite3_result_null(context);

            }
        }];

        int rowCount = 0;

        FMResultSet *ars = [adb executeQuery:@"select * from ftest where StringStartsWithH(foo)"];

        while ([ars next]) {
            rowCount++;

            NSLog(@"Does %@ start with 'h'?", [rs stringForColumnIndex:0]);

        }
        FMDBQuickCheck(rowCount == 2);

    }];

 @param name Name of function

 @param count Maximum number of parameters

 @param block The block of code for the function

 @see [sqlite3_create_function()](http://sqlite.org/c3ref/create_function.html)
 */

- (void)makeFunctionNamed:(NSString*)name maximumArguments:(int)count withBlock:(void (^)(sqlite3_context *context, int argc, sqlite3_value **argv))block;

///---------------------
/// @name Date formatter
///---------------------

/** Generate an `NSDateFormatter` that won't be broken by permutations of timezones or locales.
 
 Use this method to generate values to set the dateFormat property.
 
 Example:

    myDB.dateFormat = [FMDatabase storeableDateFormat:@"yyyy-MM-dd HH:mm:ss"];

 @param format A valid NSDateFormatter format string.
 
 @return A `NSDateFormatter` that can be used for converting dates to strings and vice versa.
 
 @see hasDateFormatter
 @see setDateFormat:
 @see dateFromString:
 @see stringFromDate:
 @see storeableDateFormat:

 @warning Note that `NSDateFormatter` is not thread-safe, so the formatter generated by this method should be assigned to only one FMDB instance and should not be used for other purposes.

 */

+ (NSDateFormatter *)storeableDateFormat:(NSString *)format;

/** Test whether the database has a date formatter assigned.
 
 @return `YES` if there is a date formatter; `NO` if not.
 
 @see hasDateFormatter
 @see setDateFormat:
 @see dateFromString:
 @see stringFromDate:
 @see storeableDateFormat:
 */

- (BOOL)hasDateFormatter;

/** Set to a date formatter to use string dates with sqlite instead of the default UNIX timestamps.
 
 @param format Set to nil to use UNIX timestamps. Defaults to nil. Should be set using a formatter generated using FMDatabase::storeableDateFormat.
 
 @see hasDateFormatter
 @see setDateFormat:
 @see dateFromString:
 @see stringFromDate:
 @see storeableDateFormat:
 
 @warning Note there is no direct getter for the `NSDateFormatter`, and you should not use the formatter you pass to FMDB for other purposes, as `NSDateFormatter` is not thread-safe.
 */

- (void)setDateFormat:(NSDateFormatter *)format;

/** Convert the supplied NSString to NSDate, using the current database formatter.
 
 @param s `NSString` to convert to `NSDate`.
 
 @return The `NSDate` object; or `nil` if no formatter is set.
 
 @see hasDateFormatter
 @see setDateFormat:
 @see dateFromString:
 @see stringFromDate:
 @see storeableDateFormat:
 */

- (NSDate *)dateFromString:(NSString *)s;

/** Convert the supplied NSDate to NSString, using the current database formatter.
 
 @param date `NSDate` of date to convert to `NSString`.

 @return The `NSString` representation of the date; `nil` if no formatter is set.
 
 @see hasDateFormatter
 @see setDateFormat:
 @see dateFromString:
 @see stringFromDate:
 @see storeableDateFormat:
 */

- (NSString *)stringFromDate:(NSDate *)date;

@end

/** Objective-C wrapper for `sqlite3_stmt`
 
 This is a wrapper for a SQLite `sqlite3_stmt`. Generally when using FMDB you will not need to interact directly with `FMStatement`, but rather with `<FMDatabase>` and `<FMResultSet>` only.
 
 ### See also
 
 - `<FMDatabase>`
 - `<FMResultSet>`
 - [`sqlite3_stmt`](http://www.sqlite.org/c3ref/stmt.html)
 */

@interface FMStatement : NSObject {
    sqlite3_stmt *_statement;

    NSString *_query;

    long _useCount;

    BOOL _inUse;

}

///-----------------
/// @name Properties
///-----------------

/** Usage count */

@property (atomic, assign) long useCount;

/** SQL statement */

@property (atomic, retain) NSString *query;

/** SQLite sqlite3_stmt
 
 @see [`sqlite3_stmt`](http://www.sqlite.org/c3ref/stmt.html)
 */

@property (atomic, assign) sqlite3_stmt *statement;

/** Indication of whether the statement is in use */

@property (atomic, assign) BOOL inUse;

///----------------------------
/// @name Closing and Resetting
///----------------------------

/** Close statement */

- (void)close;

/** Reset statement */

- (void)reset;

@end

#pragma clang diagnostic pop

