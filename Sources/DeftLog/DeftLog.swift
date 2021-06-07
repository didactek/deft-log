//
//  DeftLog.swift
//  Centralized log level configuration
//
//  Created by Kit Transue on 2021-06-06.
//  Copyright © 2021 Kit Transue.
//  SPDX-License-Identifier: Apache-2.0
//

import Logging

public class DeftLog {
    /// Log levels to apply to Loggers fetched through this interface.
    ///
    /// When a new Logger is requested, its label is checked against each of the prefixes here
    /// (in order). If there is a match, the level from the first matching pair is applied to the Logger obtained.
    public static var settings: [(prefix: String, level: Logger.Level)] = []

    /// Create a new Logger. If the label matches a log level preference in `settings`, the corresponding
    /// log level will be applied to the new logger. Plumbing to the LogHandler is the same as if Logger was
    /// initialized directly.
    public static func logger(label: String) -> Logger {
        var logObject = Logger(label: label)

        if let match = settings.first(where: { (prefix: String, level: Logger.Level) in
            label.starts(with: prefix)
        }) {
            logObject.logLevel = match.level
        }

        return logObject
    }
}
