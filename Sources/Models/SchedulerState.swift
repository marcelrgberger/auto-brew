import Foundation

enum SchedulerState: Equatable, Sendable {
    case idle
    case waitingForIdle
    case waitingForSchedule
    case running(BrewStage)
    case completed(Date)
    case failed(String)
}
