# ``DeftLog``

Centrally configure swift-log logLevel threshold based on logger label.

## Overview

DeftLog provides a factory for instantiating Loggers. This mechanism
can be adopted by both packages and application code.

Any Logger created through the factory can have its initial logLevel overridden
according to preferences. These log settings are specified at the global application
level, giving the application control over logging within packages.



## Topics

### Configuring Logging Preferences

- ``DeftLog/settings``

### Adopting Logging Configuration

- ``DeftLog/logger(label:)``

### Discussion

- <doc:ConfigurableLogging>
