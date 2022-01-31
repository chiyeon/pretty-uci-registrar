var og_log = console.log;

/**
 * Custom logger with prefix for console clarity
 */
var purl = function () {
    a = [];
    a.push('[PUR]\t');
    for (var i = 0; i < arguments.length; i++) {
        a.push(arguments[i]);
    }
    og_log.apply(console, a);
};

purl("Extension Activated");