import Foundation


public class CSV {
    
    public static func write(data: [Int:Int], filename: String) {
        var csvstr = ""
        for (k, v) in data {
            csvstr += "\(k),\(v),\(KeyCount.getKeyChar(code: k))\n"
        }
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(filename)
            debugPrint(dir)
            
            do {
                try csvstr.write(to: fileURL, atomically: false, encoding: .utf8)
                print("Successfully CSV was created")
            } catch {
                print("Failed to create CSV: \(error.localizedDescription)")
            }
        }
    }
    
    public static func read(filename: String) -> [Int:Int] {
        let fileManager = FileManager.default
        var kh:[Int:Int] = [:]

        do {
            let documentsURL = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            
            if let csvFileURL = fileURLs.first(where: { $0.lastPathComponent == filename }) {
                let csvData = try String(contentsOfFile: csvFileURL.path, encoding: .utf8)
                let rows = csvData.components(separatedBy: "\n")
                
                for row in rows {
                    if row == "" {
                        continue
                    }
                    let columns = row.components(separatedBy: ",")
                    kh[Int(columns[0])!] = Int(columns[1])
                }
            }
        } catch {
            print("Failed to read CSV: \(error.localizedDescription)")
        }
        return kh
    }
}
