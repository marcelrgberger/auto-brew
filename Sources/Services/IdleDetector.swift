import Foundation
import IOKit

enum IdleDetector: Sendable {
    static func systemIdleTime() -> TimeInterval? {
        var iterator: io_iterator_t = 0
        let result = IOServiceGetMatchingServices(
            kIOMainPortDefault,
            IOServiceMatching("IOHIDSystem"),
            &iterator
        )
        guard result == KERN_SUCCESS else { return nil }
        defer { IOObjectRelease(iterator) }

        let entry = IOIteratorNext(iterator)
        guard entry != 0 else { return nil }
        defer { IOObjectRelease(entry) }

        var properties: Unmanaged<CFMutableDictionary>?
        guard IORegistryEntryCreateCFProperties(
            entry, &properties, kCFAllocatorDefault, 0
        ) == KERN_SUCCESS else { return nil }

        guard let dict = properties?.takeRetainedValue() as? [String: Any],
              let idleNS = dict["HIDIdleTime"] as? Int64 else { return nil }

        return TimeInterval(idleNS) / 1_000_000_000
    }
}
