//
//  DeftLog.swift
//  Centralized log level configuration
//
//  Created by Kit Transue on 2021-06-06.
//  Copyright © 2021 Kit Transue.
//  SPDX-License-Identifier: Apache-2.0
//

import Logging
import Synchronization

protocol LogFactory: Sendable {
    func prefixLevels() -> [(prefix: String, level: Logger.Level)]
    func setPrefixLevels(_ settings: [(prefix: String, level: Logger.Level)])
    func logger(label: String) -> Logger
}

/// Centrally configure swift-log logLevel threshold based on logger label.
public class DeftLog {
    /// Configure log levels for Loggers obtained via DeftLog.
    ///
    /// When a new `Logger` is requested through ``logger(label:)``, its label is checked against
    /// each of the prefixes in this array (in order). If there is a match, the level from the first
    /// matching pair is applied to the Logger before it is returned.
    public static var settings: [(prefix: String, level: Logger.Level)] {
        get {
            singleton.prefixLevels()
        }
        set {
            singleton.setPrefixLevels(newValue)
        }
    }
    
    /// Create a new `Logger` and set its `logLevel`.
    ///
    /// After the new Logger is initialized, its label is checked against ``settings``. If there is a match, the
    /// corresponding log level will be applied to the new logger before it is returned.
    ///
    /// - Note: LogHandler assignment continues to use the same bootstrap mechanism as
    /// if the Logger were initialized directly. Back-ends continue to be wired as they would be without using DeftLog.
    public static func logger(label: String) -> Logger {
        return singleton.logger(label: label)
    }
    
    static let singleton: LogFactory = {
#if swift(>=6.0) && !UNSAFEDEFTLOG
        return MutexDeftLog()  // add "-D UNSAFEDEFTLOG" to run an unsafe log factory with Swift 6 and pre-Synchroniztion targets
#else
        if #available(macOS 15.0, iOS 18.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *) {
            return MutexDeftLog()
        }
        return UnsafeDeftLog()
#endif
    }()
    
}

@available(macOS 15.0, iOS 18.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
internal final class MutexDeftLog: LogFactory, Sendable {
    private let logSettings = Mutex<[(prefix: String, level: Logger.Level)]>([])
    
    internal func prefixLevels() -> [(prefix: String, level: Logger.Level)] {
        return logSettings.withLock {
            return $0
        }
    }
    
    internal func setPrefixLevels(_ settings: [(prefix: String, level: Logger.Level)]) {
        logSettings.withLock {
            $0 = settings
        }
    }

    internal func logger(label: String) -> Logger {
        var logObject = Logger(label: label)

        if let match = prefixLevels().first(where: { (prefix: String, level: Logger.Level) in
            label.starts(with: prefix)
        }) {
            logObject.logLevel = match.level
        }

        return logObject
    }
}

#if swift(<6.0) || UNSAFEDEFTLOG
internal final class UnsafeDeftLog: Sendable, LogFactory {
    // FIXME: serialize access on pre-Synchronization platforms
    // Fix options are:
    // - add SPM version of Atomics (complicated for the most-interesting macos14+swift6 case)
    // - add Semaphore
#if UNSAFEDEFTLOG
#warning("Log factory is not concurrency safe on pre-Synchronization platforms.")
    nonisolated(unsafe)  // say this is internally protected when it is not. But most access is reading, so hope for the best.
    private var logSettings = [(prefix: String, level: Logger.Level)]([])
#else
    private var logSettings = [(prefix: String, level: Logger.Level)]([])
#endif

    
    internal func prefixLevels() -> [(prefix: String, level: Logger.Level)] {
        return logSettings
    }
    
    internal func setPrefixLevels(_ settings: [(prefix: String, level: Logger.Level)]) {
        logSettings = settings
    }

    internal func logger(label: String) -> Logger {
        var logObject = Logger(label: label)

        if let match = prefixLevels().first(where: { (prefix: String, level: Logger.Level) in
            label.starts(with: prefix)
        }) {
            logObject.logLevel = match.level
        }

        return logObject
    }
}
#endif
