# 📚 Bash Programming Learning Guide

A comprehensive learning guide for Bash programming designed specifically for the **Operating Systems Laboratory Project - Library System** (2026).

## 🎯 Course Info
- **Course**: Operating Systems Laboratory
- **Project**: Library System Implementation
- **Language**: Bash & C
- **Difficulty**: Beginner to Intermediate

## 📋 Table of Contents

1. **[Topic 1: Introduction to Bash & Basic Syntax](topics/01-intro-basics.md)** ✅ Ready
2. **[Topic 2: Variables and User Input](topics/02-variables.md)** ✅ Ready
3. **Topic 3: Control Flow (if/else, loops)** (Coming Soon)
4. **Topic 4: Functions & Modular Code** (Coming Soon)
5. **Topic 5: File Operations & I/O** (Coming Soon)
6. **Topic 6: Interprocess Communication (IPC)** (Coming Soon)
7. **Topic 7: Error Handling & Debugging** (Coming Soon)

## 📁 Repository Structure

```
bash-learning-repo/
├── README.md                 # This file
├── topics/                   # Topic content
│   ├── 01-intro-basics.md
│   ├── 02-variables.md
│   ├── 03-control-flow.md
│   ├── 04-functions.md
│   ├── 05-file-operations.md
│   ├── 06-ipc.md
│   └── 07-debugging.md
├── code-examples/            # Ready-to-run examples
│   ├── hello-world.sh
│   ├── variables-example.sh
│   └── ...
├── exercises/                # Practice problems
│   ├── exercise-set-1.md
│   ├── exercise-set-2.md
│   └── solutions/
├── project-scripts/          # Scripts for your library project
│   ├── bootstrap.sh
│   ├── user.sh
│   ├── library.c
│   └── manage.sh
└── PROGRESS.md              # Your learning progress tracker
```

## 🚀 Getting Started

### Prerequisites
- A Linux/Unix terminal (Ubuntu 24.04 or similar)
- A text editor (vim, nano, VS Code, etc.)
- Basic familiarity with the terminal

### How to Use This Repo

1. **Read the Topic Files**: Each topic in `/topics` is a complete lesson
2. **Review Code Examples**: Check `/code-examples` for working code
3. **Try the Exercises**: Practice with exercises in `/exercises`
4. **Build Your Project**: Use project scripts as templates for your library system

### Suggested Learning Path

```
Week 1: Topics 1-2 (Basics & Variables)
  └─ Complete exercises 1-2
  └─ Understand command-line arguments

Week 2: Topics 3-4 (Control Flow & Functions)
  └─ Complete exercises 3-4
  └─ Start writing bootstrap.sh

Week 3: Topics 5-6 (File I/O & IPC)
  └─ Complete exercises 5-6
  └─ Write user.sh and manage.sh

Week 4: Topic 7 (Debugging & Testing)
  └─ Debug your project
  └─ Complete final implementation
```

## 🎓 Learning Objectives

By the end of this course, you will be able to:

- ✅ Write and execute Bash scripts
- ✅ Use variables, arrays, and data structures
- ✅ Implement control flow (if/else, loops, case statements)
- ✅ Create reusable functions and modular code
- ✅ Perform file operations and I/O handling
- ✅ Implement IPC mechanisms (pipes, FIFOs, message queues)
- ✅ Handle errors gracefully
- ✅ Debug Bash scripts effectively
- ✅ Write production-ready shell scripts

## 📖 How to Read the Topics

Each topic follows this structure:

```
## Topic Title
### What is [Concept]?
[Explanation of the concept]

### Key Concepts
[Table of concepts]

### Example Code
[Working code examples]

### Practice Exercises
[Hands-on exercises]

### Common Pitfalls
[Things to watch out for]

### Next Steps
[Preview of next topic]
```

## 🛠️ Project Scripts

Your library project requires these main scripts:

- **bootstrap.sh**: Initialize the system with N libraries
- **user.sh**: User interface to interact with libraries
- **library.c**: C program for library process
- **manage.sh**: Management interface for the system

Each is documented with examples in the `/project-scripts` folder.

## 💡 Tips for Success

1. **Code Along**: Don't just read - write and test every example
2. **Modify Examples**: Change values, add features, break things intentionally
3. **Use the Terminal**: Run scripts immediately after learning
4. **Ask Questions**: If something doesn't make sense, review or ask
5. **Test Edge Cases**: Think about what could go wrong
6. **Document Your Code**: Comment your scripts as you write

## 🐛 Debugging Resources

- Use `bash -x script.sh` to debug (execute with debug info)
- Use `echo` statements to trace execution
- Check return codes with `echo $?`
- Read error messages carefully - they're helpful!

## 📝 Progress Tracking

Use `PROGRESS.md` to track your learning:
- Mark topics as completed
- Note areas of difficulty
- Record time spent on each topic

## 🤝 Contributing to Your Learning

- Add your own notes and insights to topics
- Create additional examples
- Share solutions to exercises
- Build a personal reference library

## 📚 Additional Resources

### Bash Documentation
- [GNU Bash Manual](https://www.gnu.org/software/bash/manual/)
- [ShellCheck](https://www.shellcheck.net/) - Script analysis tool
- [Bash Hackers Wiki](https://wiki.bash-hackers.org/)

### For Your Project
- Course syllabus and specifications
- Previous project examples (if available)
- Instructor office hours

## 📞 Questions?

If something is unclear:
1. Re-read the section with fresh eyes
2. Check the "Common Pitfalls" section
3. Try modifying the example code
4. Ask your instructor during office hours

## 📄 License

This learning guide is created for the Operating Systems Laboratory Course (2026).

---

**Happy Learning! 🎉**

Start with [Topic 1: Introduction to Bash & Basic Syntax](topics/01-intro-basics.md)
