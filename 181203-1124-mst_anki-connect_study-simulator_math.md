---
title: "181203-1124-mst_anki-connect_study-simulator_math.md"
---

# Status:

- Thursday: _181129-0807-mst_math-studies_anki-hacks.md_:
  - Cleaned up the YAML flashcard spec system.
    - Rewrote to _update_notes.py_. This version adds a system for annotating flashcards while studying, makes it easier to query flashcard annotations, and adds a special mode for displaying query results without updating anything.
      - Flashcard annotation system: this adds an "annotations" field to flashcards that the user can edit while studying, and adds notation for "annotation" tags that the use can edit while studying. Ordinarily all flashcard definitions are synced in the direction from the YAML file definitions, to the flashcard, so the YAML file is the master. Annotations, on the other hand, are created/edited while studying, so are synced in the other direction: from the flashcards to the YAML file.
      - Special "question" mode: in this mode, nothing is updated; instead, the results of a query are displayed. This displays the following for flashcard definitions that match the query: each matching flashcards ID, tags, annotations, and field definitions.
- Over the weekend:
  - More updates to _update_notes.py_. This adds a special mode for quickly updating only annotations. In this mode, flashcard annotations are still transferred to the YAML file, but flashcard field definitions aren't transferred in the other direction; this makes the time-consuming process of typesetting those fields unnecessary, which is why this mode runs quickly.
  - Completed, but didn't test, _anki_connect_client.py_.
    - This adds the rest of the methods corresponding to the Anki-Connect API.
    - This also completes the documentation for these methods.
    - I still need to write tests to verify all of these methods.
  - Wrote most of a simulator of a person studying definitions on vocabulary.com.
    - This models the time spent studying each vocabulary definition's web page.
    - Collection of data used to create the model:
      - I spent an hour studying words from top-800 high-frequency GRE vocabulary lists, during which I tallied the number of words I studied over that period. During this period I studied 76 words, averaging about 47 seconds per word.
      - I then spent another hour, this time recording when I began studying; and then for each word, when I finished studying that word. This time I studied 71 words, averaging about 51 seconds per word.
    - I also recalled that when I decided to skip studying a word (that I knew well), it took me 5-10 seconds to load and read the webpage before skipping to the next word. This is just anecdotal, from when I wasn't trying to collect data while studying.
    - Creating the model:
      - From the timestamps recorded above, I reconstructed for each word a "word study period" of how long I spent studying that word.
      - I built a gaussian KDE from the distribution of word study periods.
    - Simulating time studying:
      - This simulates 50-minute study sessions with 10-minute breaks.
      - For each study session, word study periods are sampled using the KDE. As many periods are sampled as fit into the 50-minute session.
        - To simulate words that are "skipped", I model reading enough of a word's webpage in order to decide to skip that word.
        - I assume a minimum of 12.30987 seconds (an arbitary mean) on average to decide to skip the word. This includes time spent to load the webpage, identify the word's short definition, and skim the definition.
        - A standard deviation of 2.23487 is used (ar arbitrary SD).
      - After each study session, a break is taken to round out the hour. This break has standard deviation of 154 seconds (an arbitrarily chosen SD). This simulates taking a brief break from studying, and coming back at about the start of the next hour to begin another study session.
    - The simulation makes room to plug in a computational task during simulation, but I haven't plugged anything in yet. I plan to use this to add a web scraper. The idea is to scrape vocubulary definitions while modeling the behavior of a person studying those definitions.


# Thoughts:

I want to spend a good period of time studying math today, but I also want to spend some time setting up a scraper for vocabulary web pages, so I can start studying those concurrently. I also need to document the work I did over the weekend.


# Plans:

- Document work done over weekend.
- Study math for at least three hours.
- Spend some time building a web scraper for vocabulary definitions. Limit to an hour for today, spend more on this tomorrow.
- Exercise.
- Study some more.


# Log:

##### 1124: Start; status/thoughts/plans.

##### 1239: Document work done over weekend.
