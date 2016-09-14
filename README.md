# Todo
Create a XCode project with the following specifications:
• Supports iOS 9
• 100% Swi  (although third-party frameworks can contain Objective-C)
• Uses auto-layout
• iPhone only
•Is shared in a Github repository


The goal of this project is to create a simple TO-DO list app with the following features:
•Fetches the initial list of tasks from https://dl.dropboxusercontent.com/u/
6890301/tasks.json . State 0 is "pending", 1 is "done".
• Contains a tab bar with two tabs: “pending” and “done”.
• Each tab shows a table view with the list of tasks in that state.
• Allows the user to create a new task by tapping on a "+" button in the navigation bar (only in the “pending” tab). The user can then enter a name for the task. You can do this either on the same screen or on a separate screen.
• Allows the user to delete a task by swiping it right to left.
• Allows the user to change a task's state to “done” or “pending” by simply tapping on it. Once the user tapped on a task, a “Cancel” button should appear over the cell for five seconds, allowing the user to stop the operation. If the button is not pressed, the task transitions its state and appears on the other tab. (Think of it as similar to the Gmail feature to “Undo” a deleted message)

Please keep the following in mind:
• Retrieving the tasks from the network should be done on the background, showing a “loading indicator” while the operation is performed.

Bonus points:
• UI details 
• Adding persistency to the app (Core Data)
• Well organised code, separating concerns (network operations, business logic, UI, model, etc)
