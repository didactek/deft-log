# Configurable Logging


Swift-log classifies messages by severity and provides each Logger a logLevel
to suppress messages that don't meet a severity threshold. DeftLog lets Logger
clients opt in to centralized control of logLevel, and lets users of an application
set Logger attenuation threshold at runtime without modifying library source.

## Overview

Logging systems encourage developers to consider the conditions under which a
message should be logged. An important factor in this encouragement is a
mechanism that allows logging to be turned off for messages that don't meet
a threshold that the developer may adjust during the development lifecycle.
Highly-detailed messages that are added to the source during debugging can
be left in place when the debugging is over: the developer simply adjusts the log
level so the messages no longer distract from output. Non-logged messages incur
very little overhead. The messages can be quickly re-enabled if they are needed for
future debugging work.

Some log systems allow user access to the latent messages that are ordinarily
below the reporting threshold. This can be helpful when:

- debugging a system that is not working
- adopting a library whose mechanics and requisites are unfamiliar
- or simply: seeking to learn more about a system

- Note: An example of late-configuration logging is the macOS `log` utility 
(notably its `stream --level`/`--type` options) that let administrators
access additional logging detail for processes that use some system
logging libraries.


## Configuration in swift-log

In swift-log, the decision about whether to log a message is made by each logger;
an extension of Logger checks the message against each instance's logLevel and
does not forward the message to the log hander if the message does not reach the
configured threshold. LogLevel is intended to be part of the Logger state; implementors
of alternate Loggers are discouraged from centrally adjusting logLevel.

swift-log doesn't suggest any particular pattern for setting logLevel. For implementors
of package libraries who want to allow library consumers to adjust logLevel, they are left
on their own to expose a mechanism to set logLevel for private Loggers.


## DeftLog

DeftLog lets the main runtime describe desired log levels early in execution, and
then the library's Logger factory will offer Loggers to the implementor that default to the
logLevel specified *by the main executable*.

### Configuring

Near the start of the program--before libraries start requesting their loggers--describe
any log level overrides according to the Logger label prefix:

    DeftLog.settings = [
        ("com.didactek.deft-log", .critical),
        ("com.didactek.deft-mcp2221.usb", .trace),
        ("com.didactek.deft-mcp2221", .debug),
    ]

### Adopting

Simply obtain the logger from DeftLog:

    let logger = DeftLog.logger(label: "com.didactek.deft-mcp2221.hidapi") // .debug

This replaces the typical `var logger = Logger(label: "com.didactek.deft-mcp2221.hidapi"`
file-level declaration that is often paired somewhere else with setting the log level
(`logger.logLevel = .debug`). Note the logger can usually be a `let`, since its logLevel
is pre-set and there should not be a need to change it.


## Topics

### Configuring DeftLog Logger Output

- ``DeftLog/settings``

### Adopting DeftLog

- ``DeftLog/logger(label:)``
