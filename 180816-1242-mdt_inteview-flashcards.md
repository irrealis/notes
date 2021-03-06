---
title: "180816-1242-mdt_inteview-flashcards.Rmd"
---

Related private notes: _180816-1242-mdt_

# Status:

- Yesterday, _180815-1028-mdt_interview-flashcards.Rmd_:
  - AFI flashcard fronts through c3, _Dynamic Programming_.
  - GitHub repo for nonprivate notes: https://github.com/irrealis/notes


# Thoughts:

- Flashcards:
  - Found need to use multiple models in same section. Achieved using multiple YAML files; would rather keep in single file, with overrides for particular flashcards. Thoughts: move fields into "fields" section, add overrides in note dict.
  - Will require:
    - Rewrite all notes.
    - Rewrite parser.
    - Error detection in parser.

- Questions:
  - **What is a _union-find_ data structure?**


# Plans:

- Flashcards:
  - Per-note overrides:
    - Rewrite parser.
    - Demo with experimental YAML file.
    - Add error detection (missing required fields).
    - Trigger error in experimental file.
    - Try to run all YAML files; they should all fail.
    - Begin conversions to new format. Test each file.
    - At end of conversions, try to run all YAML files; they should all pass.
  - Resume AFI c3.


# Log:

##### 1242: Start; status/thoughts/plans.

##### 1304: Per-note flashcard overrides: parsers.

##### 1353: Parser, flashcards rewritten. Resume AFI c3.

##### 1522: Completed chapter 3. Break.

##### 1537: Resume. AFI c4.

##### 1616: Completed AFI c4 problems 1-3. Switch to private tasks.
