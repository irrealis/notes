---
title: "180905-1131-mdt_flashcards-and-datascience.Rmd"
---

# Status:

Several days since switching to personal tasks. Today, continuing work on personal tasks, and also resuming:
- Work on updating Anki flashcards.
- Datascience studies.


# Thoughts:

- As top priorities, I'm going to split my time three ways, with the goal of:
  - 1/3 time spent on flashcards.
  - 1/3 time spent on studies.
  - 1/3 time spent on personal projects.

- Re. flashcard updates:
  - I currently (clumsily) handle the following:
    - Field updates: I think this code is in okay shape.
    - Tag updates: needless deletion and replacement of tags when nothing changed.
  - Lacking:
    - Can't update deck name for a card. This can be done using `changeDeck` API call.
    - Can't update model name for a card.
      - I can't see any way to update this using the Anki-Connect API.
      - I could probably add this to the API.
        - I suspect the reason for its absence from API is that the choice of model determines which and how many cards are created from the note. This would mean that changing the model would require regenerating the cards. This in turn would reset stats for all cards.
        - So the best approach here would be to delete and recreate the note.

- There are a number of skills I'd like to refresh/maintain. This will have to be an ongoing background project.
  - GPU programming:
    - OpenCL.
      - Would like to also work on latest version, with C++ interface.
    - Would like to bring Vulkan up to speed.
  - Photogrammetry.
  - Kinect Fusion.
  - Artificial life.
    - Avida platform.
  - Bioinformatics.
  - Rails frontend/API; backend logic; Python-mediated backend computation.
  - Realtime pipeline in C++.
  - ROS
  - Qt GUI work.
  - macOS app work.
  - Android app work.
  - iOS app work.
  - Linear algebra.
  - Advanced calculus.
  - Abstract algebra.
  - Probability.
  - Languages:
    - French
    - Spanish
    - German
    - Latin


# Plan:

- Flashcards:
  - From _180827-1444-mdt_:
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

- Datascience:
  - Transfer and reorganize datascience flashcards to new YAML system under version control.
  - To get self back up to speed, review previous courses.
    - Go over lectures again, taking notes.
    - Try to move quickly on this. Focus on review.


# Log:

##### 1131: Start; status/thoughts/plans.

##### 1152: Work on updating Anki flashcards.


```{python }
import sys

print("Python version: {}".format(sys.version))
print("Python executable: {}".format(sys.executable))
```

- Notes from _180826-1317-mdt_update-anki-notes.Rmd_:

```{python }
%pushd /mnt/Work/Repos/irrealis/flashcards
```

```{python }
import yaml
```

Stream to representation graph to stream
```{python }
import yaml
nodes = yaml.compose(open("markdown_mathjax_demo.yml"))
print(nodes)
print(yaml.serialize(nodes))
for node in nodes:
  print(yaml.serialize(node))
```

```{python }
x = yaml.compose(open("markdown_mathjax_demo.yml"))
d = {x.value:v.value for x, v in x.value}
print(yaml.load(yaml.serialize(d['notes'][0])))

[(k,v) for k,v in x.value if k.value == 'notes']
[(k,v) for k,v in x.value if k.value == 'defaults']

print(yaml.serialize(yaml.MappingNode(tag='tag:yaml.org,2002:map', value = [(k,v) for k,v in x.value if k.value == 'notes'])))


```



```{python }
nodes = yaml.compose(open("markdown_mathjax_demo.yml"))
top_map = {k.value:v.value for k,v in nodes.value}
note_nodes = top_map['notes']
note_nodes

note_nodes[0]
note_nodes[0].value
note = yaml.load(yaml.serialize(note_nodes[0]))
print("note: {}".format(note))

if 'id' in note:
  print("would update")
else:
  print("would create")
  note_id = 1234
  note_nodes[0].value.insert(
    0,
    (
      yaml.ScalarNode(tag='tag:yaml.org,2002:str', value='id'), yaml.ScalarNode(tag='tag:yaml.org,2002:int', value=str(note_id))
    )
  )
# data = yaml.load(yaml.serialize(nodes))
# for note in data['notes']:
#   print(note)

note = yaml.load(yaml.serialize(note_nodes[0]))
print("note: {}".format(note))

nodes
```


##### 1652: Got basic updates for Anki flashcards. Needs cleanup. Break.

##### 1715: Resume; cleanup Anki-update code.

##### 1856: Done with this round of cleanup.

The code in _update_yaml_notes.py_ still has these flaws:
- Overly complex
- Repetitive patterns around `send_as_json` calls
- `load_and_send_flashcards` is huge and monolithic
- No formal testing

However, it's late, so I'm stopping for the night. Today's main goal achieved for flashcard system.

##### 1902: Stopping.

##### 2151: Late-night changes: only update note tagset if changed.

Also assigned IDs to all _Code/_ flashcards, and updated _markdown_mathjax_demo.yml_.
