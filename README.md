ToDo List: my first app!

Hello! I'm Martina and this is my first iOS app! 
I created this app because I was tired of having post-it notes everywhere and always forgetting what I needed to buy at the supermarket. A simple and intuitive iOS application, developed in SwiftUI following the MVVM architecture.


What is this app?

It's a to-do list app, like a digital shopping list.

I divided everything into 4 categories:
• Today → Things to do today (like "Call Mom")
• Tomorrow → Things I can put off until tomorrow
• Groceries → The shopping! (so I don't forget the milk anymore)
• Some day → Future plans and dreams

What can you do?
The basic things:
• Add to-dos - Click the "+" and type
• Complete them - One tap and it turns green ✓
• Edit them - Double tap if you misspelled
• Delete them - Swipe left when you're done
• Tidy them up - Hold down and drag wherever you want
• Change category names - If you don't like "Today", change it to "Urgent!"
• Is changing the title - "ToDo List" boring? Call it "My Things"!
• Everything saves itself with UserDefaults and the data persists even after the app closes


How is it structured?
ItemModel.swift
It defines two main data structures:
CategoryModel
struct CategoryModel: Codable, Identifiable, Equatable {
    let id: String
    var title: String }
• Manages the categories in the list
• Includes 4 predefined categories: today, tomorrow, groceries, someday
• Titles are user-editable
ItemModel
struct ItemModel: Identifiable, Codable {
    let id: String
    let title: String
    let isCompleted: Bool
    let categoryId: String }
• Represents a single task
• Immutable (struct)
• Linked to a category via categoryId






ListViewModel.swift
The "brain" of the application that manages:
• Items array (all tasks)
• Array of categories (all categories)
• CRUD operations (Create, Read, Update, Delete)
• Saving and loading from UserDefaults
Main functions:
• addItem(title:categoryId:) - Adds a new task
• updateItem(item:) - Completes/discompletes a task
• editItem(item:newTitle:) - Edits the text of a task
• deleteItem(indexSet:) - Delete task
• updateCategory(category:newTitle:) - Changes the name of a category
• items(for:) - Filter tasks by category


ListView.swift
The main app view showing:
• All categories in separate sections
• TextField inline to add/edit texts
• Toolbar with "Done" button
• Keyboard focus management
Managed states:
• isEditingTitle - Changing the main title
• editingCategoryId - Category being edited
• addingToCategoryId - Category where you are adding a task
• editingItemId - Task being edited


ListRowView.swift
View for each individual task showing:
• Status icon (red/green circle with check)
• Task title
• Responds to tap (completion) and double tap (edit)


How is it used?
Add a Task
1.Click the "+" button next to the category name
2.Type task text (minimum 2 characters)
3.Press "Done" at the top right or Enter on the keyboard
Complete/Do not complete a Task
1.Single tap on the task
2.The icon will change from red circle to green circle (or vice versa)
Modify a Task
1.Double tap on the task
2.Edit text
3.Press "Done" at the top right or Enter
Delete a Task
1.Swipe left on task
2.Press the red "Delete" button
Change the Name of a Category
1.Tap on the category title (e.g. "Today")
2.Edit text
3.Press "Done" at the top right
Amend the Main Title
1.Tap on the title "ToDo List📝" at the top
2.Edit text
3.Press "Done" at the top right




Things I don't know how to do yet, but I want to add in the future
• Cloud Sync → I would like it to work on all my devices 
• Sharing with friends → Type "Family shopping list"
• Notifications → "Hey, you forgot to buy milk!"
• Widget → See my tasks from home
• Custom Colors → Why Does Everything Have to Be Apple Blue?


The apps I took inspiration from
Apple Reminders → I got: the idea of the sections, the minimalist design → I didn't like it: too simple, missing features
Any.do → I got: the division into categories


Reasons why I'm glad I did
1.I'm learning to program → From scratch to a working app
2.I have an app I actually use → I don't have post-its everywhere anymore!
3.I solved my problem → It's mine, it works the way I want it to
4.I enjoy → Yes, even when everything breaks




App version: 1.0
Date: November 2025
Status: It works!
Programming level: Beginner (but proud!)
iOS: 15.0+
Xcode: 14.0+
Swift: 5.5+
Framework: SwiftUI


Thanks to...
• YouTube for endless tutorials

• Claude AI for answering my every question 

• My Mac so it doesn't explode 

• Coffee to exist



Developer 
Martina Maria Bruno, Beginner iOS Developer
License
This project was created for educational purposes.
Project developed while learning SwiftUI and iOS development.
