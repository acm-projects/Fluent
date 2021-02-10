# Fluent
A socially-oriented language learning mobile app that connects you with fluent speakers to level up your language training.

## Minimum Viable Product (MVP)
- User accounts
  * User authentication & profile creation (e.g. name, bio, languages, interests, etc.)
  * Ability to edit your own profile and view others'
- Matching algorithm
  * Match users based on their languages and preferences
  * Ability to find a new match
- Inbox to see current conversations
- In-app text chat
- In-app voice chat

## Stretch Goals
- Chat Features
  * In-app video chat
  * Group chats
  * Chatbot assistant to help generate more conversation/add structure
- Learning Features
  * Learning section (eg. basic phrases, alphabet, etc. for major languages)
- Tracking Features
  * Daily interaction streak/points system with rewards
- Social Features
  * Ability to block another user
  
## Resources
### General Software
- [Git Bash](https://git-scm.com/downloads) 
  * For command line Git
- Text Editors/IDEs
  * [Visual Studio Code](https://code.visualstudio.com/): useful text editor with lots of plugins & customization
  * [Android Studio](https://developer.android.com/studio): IDE designed specifically for Android app development, works well with Flutter 
- UI/UX Design Tool options: 
  * [Figma](https://www.figma.com/): free web-based design tool
  * [Adobe XD](https://www.adobe.com/products/xd.html): more powerful design tool, can have 1 project for free

### Tech Stack
**Mobile Application Framework Options**
- [Flutter](https://flutter.dev/)
  * Uses [Dart](https://dart.dev/): used less by developers than JavaScript, but has great documentation
  * Lots of built-in components
- [React Native](https://reactnative.dev/)
  * Uses JavaScript: pretty popular with an active and established dev community
  * Less built-in components, reliant on third-party libraries
- [Article comparing Flutter and React Native](https://blog.codemagic.io/flutter-vs-react-native-a-developers-perspective/)

**Database Options**
- [Firebase](https://firebase.google.com/)
  * Works well with Flutter (b/c also released by Google)
  * Real-time database, cross-platform API
  * Whole ecosystem for mobile development, also includes user authentication and text chat
  * Free up to 1 GB of storage (see plans [here](https://firebase.google.com/pricing))
- [MongoDB](https://www.mongodb.com/)
  * More advanced querying than Firebase
  * More flexible & scalable, but lacks a complete ecosystem for mobile development
  * Start with 512 MB and scale up to 5 GB for free
- [Article comparing Firebase and MongoDB](https://dzone.com/articles/firebase-vs-mongodb-which-database-to-use-for-your)

**Chat APIs**
- [Twilio Conversations API](https://www.twilio.com/conversations-api)
  * Scalable, multiparty conversations
  * Free up to 200 users
- [Twilio VOIP (Voice Over Internet Protocol)](https://www.twilio.com/client)
  * $0.0040 per minute for calls to or from mobile devices

**Additional Software**
- [NodeJS](https://nodejs.org/en/): install if using React Native
  * Runtime environment that allows software developers to launch both the frontend and backend of web apps using JavaScript
- [Homebrew](https://brew.sh/): install if using React Native and/or macOS
  * Software package management system that simplifies the installation of software on macOS

### [Getting Started](https://docs.google.com/document/d/17Tu3zG0fuDVQO7FjPYxGqbTPvIRuphNbcDw4orascy8/edit?usp=sharing)
^ A general installation guide. Please feel free to find additional resources that work for you!

#### Learning Resources
Look through all of these resources at the beginning :)
- [How to be successful in ACM Projects](https://docs.google.com/document/d/1mRIWzmfmJO3MCsvR9vr6VI94GnVYtHqZiq4sqMd3fic/edit?usp=sharing)
- [Overview of making API calls](https://snipcart.com/blog/apis-integration-usage-benefits)
- [Professor Cole's How to Program](https://personal.utdallas.edu/~jxc064000/HowToProgram.html)

#### Common GitHub Commands
[GitHub Cheatsheet PDF](https://education.github.com/git-cheat-sheet-education.pdf)

Login/Setup:
| Command | Description |
| :-----: | :---------: |
| git config --global user.name "username" | Set username |
| git config --global user.email "email" | Set email |
| git config user.name | Checks that you're in, in case you're unsure |

First Time Setup: 
| Command | Description |
| :-----: | :---------: |
| git clone [url] | Creates local copy of remote repo. Try not to do this again. |

General Use:
| Command | Description |
| :-----: | :---------: |
| cd "Fluent" | Change directories to our repository |
| git branch | Lists branches |
| git branch "branch name " | Makes a new branch |
| git checkout "branch name" | Switch to branch |
| git checkout -b "branch name" | 2 previous commands combined |
| git add . | Finds and adds all changed files to your next commit |
| git commit -m "msg" | Commit with message |
| git push origin "branch" | Push to branch |
| git pull origin "branch" | Pull updates from a specific branch |
