---
title: "181129-0807-mst_math-studies_anki-hacks.md"
---

# Status:

- Yesterday, _181128-1433-mst_math-flashcards.md_:
  - Finished _Math/Textbooks/Calculus/Calculus-ConceptsAndContexts/01-7.yml_.
  - Finished _Math/Textbooks/Calculus/Calculus-ConceptsAndContexts/01-Review.yml_.
  - Finished CCAC chapter 1.
- Today:
  - Flashcard system:
    - Cleanup YAML editing.
    - Modify flashcard system to permit annotations.
  - Study math.


# Plans:

- Flashcard system:
  - Cleanup YAML editing:
    - Investigate _rtyaml_: https://github.com/unitedstates/rtyaml
    - Decide whether to switch.
    - If so, switch.
      - Plan next steps.
    - Otherwise, work on my own system.
      - Plan next steps.
  - Annotations:
    - Add annotation field with configurable name.
    - When creating new note, send annotations.
    - Otherwise, when updating note, receive and save annotations.
- Math: practice problems for bulk of day.

# Log:


##### 0807: Start; status/thoughts/plans

##### 0816: Flashcard system: cleanup YAML editing.

Thoughts:
- First, process all notes.
  - Extract defaults.
- Then add filtering.

Issues:
- Any changes to notes list result in changes to file.
  - I do want this for updated IDs and annotations.
  - I don't want this for defaults.
- The query system disconnects the query results from the rt data.
  - In old system, I handled by using two representations for each note: the not-rt data, and the rt data.
    - To keep things in sync, I added a 'node' attribute to the not-rt data, containing the rt-data.
    - I will still want a similar system.
    - What's a good way to distinguish between the non-rt and the rt data?


##### 1149: Replicated original functionality in new script _update_notes.py_.

New script uses _rtyaml_ to simplify round-trip editing of YAML file. Now adding annotations functionality.
