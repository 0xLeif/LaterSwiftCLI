import Foundation
import ArgumentParser
import Later

struct LaterCLI: ParsableCommand {
    @Argument()
    var delay: UInt32
    
    @Argument()
    var value: String
    
    func doThings() {
        let fetchNumber = 80
        var finishCount = 0
        let start = Date().timeIntervalSince1970
        (1 ... fetchNumber)
            .map { "https://jsonplaceholder.typicode.com/todos/\($0)" }
            .compactMap { URL(string: $0) }
            .forEach { url in
                Later.fetch(url: url) { data in
                    finishCount += 1
                    print("FETCHED: \(String(data: data, encoding: .utf8) ?? "-1")")
                    if finishCount == fetchNumber {
                        print("\(#function) took \(Date().timeIntervalSince1970 - start) seconds")
                    }
                }
        }
    }
    
    mutating func run() throws {
        let localValue = value
        let sema = DispatchSemaphore(value: 0)
        print("Waiting... \(delay) seconds")
        Later.do(withDelay: delay) {
            print("LaterCLI: \(localValue)")
            sema.signal()
        }
        
        doThings()
        
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/todos/\(Int.random(in: 1 ... 100))") else {
            print("bad url string")
            return
        }
        
        Later.fetch(url: url).whenSuccess { (data, response, error) in
            guard let data = data else {
                print("bad data")
                return
            }
            print(String(data: data, encoding: .utf8) ?? "-1")
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
