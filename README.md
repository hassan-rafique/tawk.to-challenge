# tawk.to iOS Developer Test

This task follows the instructions mentioned in [this pdf](https://github.com/hassan-rafique/tawk.to-challenge/blob/main/tawk_iOS_interview_practical_test_v.1.7.pdf)

## Notes for the reviewer

- All Bonus points are covered.

- Because of time limitation, least priority is given to the aesthetic UI part. Very basic UI elements are used for demo purposes. For example, user will see a UI Alert if internet goes offline. A more better option could to display banner that auto swipes from top when internet goes offline. 

- Code demonstrate usage of MVVM & Coordinator design pattern.

- If you experience slowness in data loading then it's because all network operations are queued and limited to 1 request at a time, including images loading.

- If internet goes offline, then network requests stays in the operation queue and attempts to retry using exponential back off.

- If local data is available then it will be displayed first and in parallel App will update using remote data.

- All Core Data write queries are perfomed on a separate thread EXEPT note editing, which is a user generated action and done on main thread (using main managed object context).

- All Core Data write operations are done in a private managed object context and gets merged into the parent (main) managed object context and reflected to the user interface immediately. However, parent managed object context saves all changes to persistant store only when App goes to backgoround or application gets terminated and when user writes a note. Detaching a debugger doesn't trigger save request to persistant store. 

- 2 basic Unit tests are added. 

- Skeleton is added only on user details screen.

- Users list UI is done in code and Profile with Interface Builder.

- App supports dark mode.
