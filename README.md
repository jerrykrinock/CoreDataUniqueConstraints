# CoreDataUniqueConstraints

Swift 5 fork of Zach Orr's project demonstrating the *Unique Constraints* feature of Core Data.  This project illustrates what I feel are two bugs in this feature.

1.  [Exceptions are raised when the feature works](https://stackoverflow.com/questions/56108300/core-data-unique-constraint-raises-exceptions-when-it-works); that is, when it merges duplicates as expected.

2.  [Feature does not work when using In Memory persistent store](https://stackoverflow.com/questions/56077716/core-data-of-type-nsinmemorystoretype-ignores-entitys-constraints/56109460#56109460).  To demo this, search project for "// Choose to compile with SQLite or In Memory store" and change the condition.
