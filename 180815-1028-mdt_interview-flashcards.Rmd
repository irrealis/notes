---
title: "180815-1028-mdt_interview-flashcards.Rmd"
---

Related private notes: _180815-1101-mdt_

# Status:

- Notebooks:
  - Switched to GitHub for non-private notes.
- Flashcards:
  - Working system in place for YAML-based Anki flashcard definitions.
  - Workflow established for flashcard management.
  - Began generating coding-interview drills.


# Thoughts:

- Notebooks:
  - Will store all new non-private notes on GitHub.
  - Will continue to use existing notebook management (non-GitHub) for private notes.
  - Won't transfer existing notes to public GitHub repo.
    - May in future transfer them to a private repo.

- Working with _Algorithms for Interviews_ (AFI) by Aziz and Prakash.
  - I have this book in paperback.
  - I'm generating flashcards drills using interview questions from this book.
  - Are these flashcards in violation of copyright? I don't believe so, as each flashcard cites the book, the flashcards are for the purpose of study, and I'm not reproducing the entire book. OTOH, IANAL.
    - Won't worry about this unless some related problem arises, which I think unlikely.

- I've been thinking some more about reproducibilty.
  - WRT Nix/NixOS:
    - Singularity doesn't seem suitable for generating Nix/NixOS images, because Singularity images must be created as superuser, but used as non-superuser. This leads to permissions-/ownership-related problems.
    - Docker may be a bit more flexible, might work well for generating the images, which can then be imported for use with Singularity.
  - Currently **low-priority**.


# Plans:

- Generate flashcard fronts for all AFI questions. Leave most backs "To-do".
- Generate flashcards (front & back) for all coding exercises completed so far.
  - This includes AFI questions as well as various algorithm analyses and implementations of various data structures.
- Complete flashcard backs, Python only, for all AFI questions.
- Begin drills.
- Plan next steps. See _180813-1221-mdt_interview-flashcards.Rmd_ (in private notes) for related brainstorms.


# Notes:

- AnkiConnect repo: https://github.com/FooSoft/anki-connect
- Advanced Python:
  - Scipy lecture notes, Advanced Python Constructs: https://www.scipy-lectures.org/advanced/advanced_python/index.html
  - Python Course, Advanced Topics with Python: https://www.python-course.eu/advanced_topics.php
- How to build a rails-JSON API:
  - Will Van Wart, Oct 8, 2016: https://medium.com/@willvanwart/how-to-build-a-rails-json-api-fb199429760e
- Data science:
  - Topcoder, Data Science Tutorials: https://www.topcoder.com/community/data-science/data-science-tutorials/
  - Data Science Lab, Projects: https://sites.google.com/site/datascienceslab/projects
- Steven Skiena, Algorist:
  - http://www.algorist.com/
  - http://algorist.com/algorist.html
  - Solutions, _The Algorithm Design Manual_:
    -  http://www.algorist.com/algowiki/index.php/Introduction-TADM2E
  - Solutions, _The Data Science Design Manual_:
    - http://data-manual.com/datawiki/index.php/The_Data_Science_Design_Manual


# Log:

##### 1028: Status/thoughts/plans.

##### 1111: AFI-question flashcard fronts, chapter 1.

##### 1247: Completed chapter 1. Break.

##### 1344: Resume. AFI chapter 2.

##### 1518: Completed chapter 2. Break.

##### 1553: Resume. AFI chapter 3.

##### 1722: Completed AFI chapter 3, section _Dynamic Programming_. Stopping.
