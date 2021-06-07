# DeftLog

A factory for building [swift-log](https://github.com/apple/swift-log) Loggers while adding
centralized control over logLevel. Can be used by libraries to surface their logging options
to applications.

## Need

DeftLog provides a way for a program to configure log levels for all DeftLog-enabled
libraries at logger label granularity.

In swift-log, the decision about whether to log a message is made by each logger;
the Logger's extension checks the message against each instance's logLevel and
does not forward the message to the log hander if the message does not reach the
configured threshold. LogLevel is intended to be part of the Logger state; implementers
of alternate Loggers are discouraged from centrally adjusting logLevel.

Swift Log doesn't suggest any particular pattern for setting logLevel. For implementors
of package libraries who want to allow library consumers to adjust logLevel, they are left
on their own to plumb the setting of logLevel into private Loggers. This library offers a
pattern where the main runtime can describe desired log levels early in execution, and
then the library's Logger factory will offer Loggers to the implmentor that default to the
logLevel specified *at the executable level*.


## Usage

### Configuring

Near the start of the program, before libraries start requesting their loggers, set the configuration:

    DeftLog.settings = [
        ("com.didactek.deft-log", .critical),
        ("com.didactek.deft-mcp2221.usb", .trace),
        ("com.didactek.deft-mcp2221", .debug),
    ]

### Obtaining Loggers

    let logger = DeftLog.logger(label: "com.didactek.deft-mcp2221.hidapi") // .debug

The settings are searched from start to end, looking for the first match against a label prefix. If no
match is found, the default logLevel (as set by the initializer) is unchanged .

DeftLog.logger(label:) returns a Logger created from swift-log. It will be connnected to the
bootstrapped log handler backend in the usual manner.
