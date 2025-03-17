import SwiftUI
import Navigator
import shared

@main
struct iOSApp: App {
    var body: some Scene {
        WindowGroup {
            // Use ManagedNavigationStack directly instead of NavigationManager
            ManagedNavigationStack(scene: "main") {
                TodoListView()
                    // Register the destinations
                    .navigationDestination(TodoDestinations.self)
                    // Establish the list checkpoint
                    .navigationCheckpoint(TodoCheckpoints.list)
            }
            // Optional: Handle deep links
//            .onOpenURL { url in
//                handleDeepLink(url: url)
//            }
        }
    }
    
    // Optional: Deep link handling
//    private func handleDeepLink(url: URL) {
//        guard url.scheme == "checkmate" else { return }
//        
//        let components = url.pathComponents
//        
//        // Handle deep links to specific todos
//        // Example: checkmate://todo/123
//        if components.count >= 2 && components[1] == "todo" {
//            if let todoId = Int32(components[2]) {
//                // In a real app, you would fetch the todo with this ID
//                // and then navigate to it
//                print("Deep link to todo ID: \(todoId)")
//                // This would be where you fetch and navigate to the todo
//            }
//        }
//    }
}
