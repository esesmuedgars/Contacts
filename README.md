# Work Contacts

#### Technical assignment for iOS developer role at [Mooncascade](https://mooncascade.com/).
[Technical requirement document](https://github.com/esesmuedgars/WorkContacts/blob/master/RequirementsDocument.md)

## Installation

There are no specific installation requirements
- Clone the repository `git clone https://github.com/esesmuedgars/WorkContacts.git`;
- Open `WorkContacts.xcodeproj` build and run iOS application `⌘ + R`.

## Preview

<img alt="Preview GIF" src="https://github.com/esesmuedgars/WorkContacts/blob/assets/preview.gif" width="50%" />

- [X] Added `UIAlertController` if failed to fetch employees or contacts with call-to-action to retry fetch;
- [X] Added `UISearchController` to filter results by first name, last name, email, position or projects;
- [X] User interface adjusted for all screen sizes and orientations;
- [X] Not using any third-party libraries.


## Structural design pattern

Decided to use Model-View-ViewModel-Coordinator structural design pattern due to familiarity and ease of use. The separation of responsibilities helps avoid unmanageably large files and helps with maintainability. Dependency injection used for testability.

- **Flow Coordinator** - Responsible for navigation. Vends and present _view cotrollers_ with their _view models_.
- **View Controller** - Owns _view model_ and uses it to configure _views_, acts on _view model_ delegate methods. _View controller_ also owns _views_ and observes user interactions with user interface. Binding between _view model_ and _view_.
- **View Model** - The core of application, contains all business logic, it is crucial to test _view model_ implementation. Dependencies, such as services, are injected into _view model_ and are mocked in test cases. _View model_ owns _model_, uses services to fetch _models_, manipulates data.
- **View** - Uses _view model_ to display data. Uses delegate methods and actions to forward user interactions to _view controller_.
- **Model** - Data objects, usually parsed from services. Contain information that is accessible to _view model_.

<img alt="Structural design pattern diagram" src="https://github.com/esesmuedgars/WorkContacts/blob/assets/design.png" />
