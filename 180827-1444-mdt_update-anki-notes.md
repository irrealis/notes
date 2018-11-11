---
title: "180827-1444-mdt_update-anki-notes.Rmd"
---

# Status:

- Weekend: _180826-1317-mdt_update-anki-notes.Rmd_
  - Brainstorms to address updating notes in Anki.
- Weekend: _180825-1639-mdt_cpp-atom-hydrogen.Rmd_
  - Got more languages working in Atom/Hydrogen:
    - C++
    - JavaScript
    - Julia
    - Ruby
- _180824-0833-mdt_interview-flashcards_backs.Rmd_:
  - Setup flashcard fronts and backs for recently-studied algorithms and data structures outside of AFI.


# Thoughts:

- Personal things to attend to this week.
- Updating notes in Anki:
  - From _180826-1317-mdt_, I think I have enough info about PyYAML to update Anki notes, as follows:
    - Use `yaml.load(...)` to obtain Python representation of YAML file.
      - Use this data, together with existing system in _add_yaml_notes.py_, to check note specs in file.
        - If any note is missing "`id`" field, we switch modes.
          - In this case, we'll also now record the returned note ID, and generate a new version of the input file.
        - Otherwise, we simply use this data to update existing note.
    - If any note is missing "`id`" field, we switch modes.
      - Load file a second time, this time using `yaml.compose(...)`, obtaining nodes.
      - Extract the "`notes`" node.
        - For each note:
          - Extract its node.
          - Convert note node to YAML, then to Python representation.
          - If ID node is already present:
            - Based on previous work in _add_yaml_notes.py_, we convert this representation, and send to Anki as update.
            - This will use defaults from the originally-parsed Python representation for the full file.
          - If ID node not present:
            - Based on previous work in _add_yaml_notes.py_, we convert this representation, send to Anki as new note, and record the returned note ID.
            - This will use defaults from the originally-parsed Python representation for the full file.
            - Modify the note node, adding to it a new ID node.
      - Use `yaml.serialize(...)` on nodes, generating new version of file.
      - Save new version of file.
  - Not pursuing this today, except possibly this evening.


# Plans:

Personal things to attend to today.


# Log:

##### 1444: Start; status/thoughts/plans.

##### 1511: Switching to personal tasks.
