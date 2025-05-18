# User Stories
- [ ] As a user, I want to be able to automatically schedule my reminders into task blocks on my calendar.
- [ ] As a user, I want to be able to set my preferences for scheduling reminders.
- [ ] As a user, I want to be able to postpone reminders to a later date.
- [ ] As a user, I want to be able to manually fix blocks of time for a certain reminder.

# Structure of project

- Data Models
  - `EventModel` (EventKit)
    - id, title, startDate, endDate, isScheduled
  - `ReminderModel` (EventKit)
    - id, title, dueDate, priority, notes, estimatedDuration
  - `UserPreferences` (UserDefaults)
    - defaultDuration, bufferTimeBetweenTasks, schedulingHours, ignoreCalendars
- Repositories
  - `CalendarRepository` depends on UserPreferences
    - scheduleCalendar, busyCalendars, fetchEvents(from:), delete(event:), save(event:)
  - `ReminderRepository` depends on UserPreferences
    - scheduleList, fetchReminders(from:), delete(reminder:), save(reminder:)
  - `UserPreferencesRepository`
    - fetchUserPreferences(), saveUserPreferences()
- Services
  - `ScheduleService` depends on CalendarRepository and ReminderRepository
    - scheduleEvents(), scheduleReminders()
- View Models
  - `CalendarViewModel`
    - fetchEvents(), deleteEvent(), saveEvent()
  - `ReminderViewModel`
    - fetchReminders(), deleteReminder(), saveReminder()
  - `UserPreferencesViewModel`
    - fetchUserPreferences(), saveUserPreferences()
