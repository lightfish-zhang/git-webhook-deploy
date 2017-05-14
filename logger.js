'use strict';
const log4js = require('log4js'); // include log4js
const path = require('path');

/**
 * @description Then initial logging would create a file called "debug.log".
 *              At midnight, the current "blah.log" file would be renamed to "debug.log-2012-09-26" (for example), and a new "debug.log" file created.
 */
log4js.configure({ // configure to use all types in different files.
    appenders: [
        {   type: 'file',
            filename: path.resolve(__dirname, './logs') + "/debug.log", // specify the path where u want logs folder error.log
            absolute: true, // use absolute file path
            pattern: "-yyyy-MM-dd.log",
            alwaysIncludePattern: true,
            category: 'log',
            //maxLogSize: 2048000, //2000KB
            //backups: 1000
        },
    ]
});

const loggerDebug = log4js.getLogger('log'); // initialize the var to use.

module.exports = loggerDebug;


// logger.trace('Entering cheese testing');
//
// logger.debug('Got cheese.');
//
// logger.info('Cheese is Gouda.');
//
// logger.warn('Cheese is quite smelly.');
//
// logger.error('Cheese %s is too ripe!', "gouda");
//
// logger.fatal('Cheese was breeding ground for listeria.');