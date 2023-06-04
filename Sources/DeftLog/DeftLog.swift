//
//  DeftLog.swift
//  Centralized log level configuration
//
//  Created by Kit Transue on 2021-06-06.
//  Copyright © 2021 Kit Transue.
//  SPDX-License-Identifier: Apache-2.0
//

import Logging

/// Centrally configure swift-log logLevel threshold based on logger label.
public class DeftLog {
    /// Configure log levels for Loggers obtained via DeftLog.
    ///
    /// When a new `Logger` is requested through ``logger(label:)``, its label is checked against
    /// each of the prefixes in this array (in order). If there is a match, the level from the first
    /// matching pair is applied to the Logger returned.
    public static var settings: [(prefix: String, level: Logger.Level)] = []

    /// Create a new `Logger` and set its `logLevel`.
    ///
    /// After the new Logger is initialized, its label is checked against ``settings``. If there is a match, the
    /// corresponding log level will be applied to the new logger before it is returned.
    ///
    /// - Note: LogHandler assignment continues to use the same bootstrap mechanism as
    /// if the Logger were initialized directly. Back-ends are wired as they would be without using DeftLog.
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
