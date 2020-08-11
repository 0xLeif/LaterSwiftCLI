import Foundation
import ArgumentParser
import Later

struct LaterCLI: ParsableCommand {
    @Argument()
    var delay: UInt32
    
    @Argument()
    var value: String
    
    mutating func run() throws {
        let localValue = value
        let sema = DispatchSemaphore(value: 0)
        print("Waiting... \(delay) seconds")
        Later.do(withDelay: delay) {
            print("LaterCLI: \(localValue)")
            sema.signal()
        }
        
        var count = delay
        Later.scheduleRepeatedTask(delay: .seconds(1)) { (task) in
            print(count)
            count -= 1
        }
        
        sema.wait()
    }
}


LaterCLI.main()
