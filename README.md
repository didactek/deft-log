# DeftLog

A factory for building [swift-log](https://github.com/apple/swift-log) Loggers offering
centralized control over logLevel.

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



### Obtaining Loggers
