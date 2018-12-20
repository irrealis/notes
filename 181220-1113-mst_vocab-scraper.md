---
title: "181220-1113-mst_vocab-scraper.md"
---

# Status:

- Yesterday, _181219-0957-mst_vocab-scraper.md_:
  - Tested, fixed, verified db interface code pertaining to `synonym` and `antonym` relationships between senses.
  - Annotated vocab-scraper code not in notes.
  - Recorded locations of vocab-scraper code and database.
  - Reconsidered whether to use Scrapy and Dramatiq. Decided to use neither for now.
  - Got skeletal scraper running manually, scraping just vocabulary lists.
    - See _spiders/gre_words/manual_scraper.py_.


# Thoughts:

I really want to get this done today, so I can move on to other things.

The scraper code I wrote uses generators/yields to pause between task steps. I could use this to move sleep-period computation out of the simulation loop. This would allow me to address a problem I noticed: the sleep periods are currently drawn from a probability distribution of times spent studying individual vocabulary words. These sleep periods don't make sense in certain other contexts, such as when I open https://www.vocabulary.com and then navigate to https://www.vocabulary.com/account/lists.

I could instead use whatever distribution I want to produce sleep periods inside of the generator, and yield these to the simulator.


# Plans:

- Vocab scraper:
  - First, write and manually test the rest of the scraping code.
  - Then plug it into the timing simulator.
  - Get it running in its own Python script.
  - Start scrape.
  - Then look at a cleaner, more modular version of the timing simulator.
    - If not too time-intensive, complete. Otherwise, move on.
  - Mock up vocab-sense flashcards.
    - If needed, modify database tables and scraper.
    - Once scraping is done, I'll generate the vocab-sense flashcards.
- Start more math flashcards.


# Log:

##### 1113: Status/thoughts/plans.

##### 1131: Starting remainder of scraper code.
