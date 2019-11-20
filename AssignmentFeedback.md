## Assignment Feedback

### Task completion - 4/5 points
- If Tartu, Tallinn, or Contacts request fails, nothing is shown;
- If refreshing fails, and you hit cancel in the alert, the activity indicator stays visible and you cannot refresh the screen anymore.

### Architecture - 1/1 points
- **MVVM-C**;
- Nicely separated logic, UI in **View**, business logic in **ViewModel**;
- `fetchEmployeeList()` function should be separated on smaller operations.

### Code style - 1/1 points
- Some too long lines;
- Overall very clean.

### Professionality - 0.5/1 points
- No localisation, plain strings in code;
- With **Swift 5.1** you don’t need to use return in simple functions;
- Some long, complex functions that should be sliced into smaller blocks, or try to create providers that do data conversion from API responses in to local entity map;
- **Storyboards** instead of programmatic **AutoLayout**;
- Instead of fetching Tartu and then Tallinn employees, you should fetch them at the same time, this will reduce the lag, and you should also update the UI when either one completes;
- No copied code;
- No unused code;
- **Git**.

### Cherry on top - 0.5/1 points
- Not saving the last result;
- Great `README`;
- Search works great, but does not handle multiple words.

### Tests - 0/1 points
- No **Unit tests** were written.

### TOTAL: 7/10 points
