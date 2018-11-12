import UIKit

extension StringProtocol {
    var firstUppercased: String {
        guard let first = first else { return "" }
        return String(first).uppercased() + dropFirst()
    }
    var firstCapitalized: String {
        guard let first = first else { return "" }
        return String(first).capitalized + dropFirst()
    }
}

let debug: Bool = true // No possible failure in random initialiser

class TorchFactory {
    var employees: [Employee]!
    var timeMinutes: Int!       // Max: 30 minutes
    var numberOfTorches: Int!   // Equals: 40
    var batchSize: Int!         // Equals: 5
    var torches: [Torch]?       // ColorSequence: Yellow-Black-Yellow
    
    // Parametric initialiser
    init(employees: [Employee],
         timeMinutes: Int,
         numberOfTorches: Int,
         batchSize: Int) {
        self.employees = []
        self.torches = []
        
        self.employees = employees
        self.timeMinutes = timeMinutes
        self.numberOfTorches = numberOfTorches
        self.batchSize = batchSize
    }
    
    // Default random initialiser
    init() {
        // Implicit optionals initialisation
        self.employees = []
        self.torches = []
        
        // Random employees
        // ---
        // Always generate 6 employees
        for index in 0 ... 5 {
            var tmpEmployee: Employee
            let name: String = randomString(length: Int.random(in: 4 ... 8)).firstCapitalized
            let jobFunction: Role = Role(rawValue: index)!
            tmpEmployee = Employee(name: name, jobFunction: jobFunction)
            self.employees.append(tmpEmployee)
        }
        
        if (debug) {
            self.timeMinutes = 30
            self.numberOfTorches = 40
            self.batchSize = 5
        } else {
            self.timeMinutes = Int.random(in: 1 ... 40)
            self.numberOfTorches = Int.random(in: 39 ... 41)
            self.batchSize = Int.random(in: 4 ... 6)
        }
    }
    
    func Start() -> Bool {
        print("The factory has started working.\n\n")
        
        assembleTorches()
        
        if (!qualityCheck()) {
            return false
        }
        
        if (!checkTime()) {
            return false
        }
        
        print("- The quality check has delivered the torches to the customer. Everything worked.")
        return true
    }
    
    private func qualityCheck() -> Bool {
        print("-- Quality Check --\n")
        if (numberOfTorches != 40 || batchSize != 5) {
            print("- The number of torches is not 40 (\(numberOfTorches!)) or the batch size isn't 5 (\(batchSize!)), exiting.\n\n")
            return false
        }
        if let _ = torches {
            for torch in torches! {
                if (torch.colourSequence != [.Yellow, .Black, .Yellow]) {
                    print("- One of the torches does not conform to the wanted colour pattern.\n\n")
                    return false
                }
            }
        }
        print("- Everything okay.\n\n")
        return true
    }
    
    private func assembleTorches() {
        print("-- Operators Assembling --\n")
        for _ in 1 ... numberOfTorches {
            torches!.append(Torch())
        }
        print("- \(String(numberOfTorches)) have been assembled.\n\n")
    }
    
    private func checkTime() -> Bool {
        if (timeMinutes <= 30) {
            return true
        }
        return false
    }
    
    private func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyz"
        return String((0 ..< length).map{ _ in letters.randomElement()! })
    }
}

struct Employee {
    var name: String
    var jobFunction: Role
    
    init(name: String, jobFunction: Role) {
        self.name = name
        self.jobFunction = jobFunction
    }
}

struct Torch {
    var colourSequence: [Colour]
    
    init(colours: [Colour]) {
        self.colourSequence = colours
    }
    
    init() {
        var seq: [Colour] = []
        for _ in 0 ... 2 {
            if (Bool.random()) {
                seq.append(.Black)
            } else {
                seq.append(.Yellow)
            }
        }
        if (!debug) {
            self.colourSequence = seq
        } else {
            self.colourSequence = [.Yellow, .Black, .Yellow]
        }
    }
}

enum Role: Int {
    case Customer = 0
    case Supervisor
    case TimeKeeper
    case Operator1
    case Operator2
    case QualityChecker
}

enum Colour {
    case Yellow
    case Black
}
