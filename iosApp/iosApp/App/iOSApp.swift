import SwiftUI
import Navigator
import shared

@main
struct iOSApp: App {
    @StateObject private var viewModel = TodoListViewModel(repository: KMPTodoRepository())
    
    var body: some Scene {
        WindowGroup {
            // Use ManagedNavigationStack directly instead of NavigationManager
            ManagedNavigationStack(scene: "main") {
                TodoListView(viewModel: viewModel)
                    // Register the destinations
                    .navigationDestination(TodoDestinations.self)
                    // Establish the list checkpoint
                    .navigationCheckpoint(TodoCheckpoints.list)
            }
            .accentColor(.white) 
        }
    }
}
