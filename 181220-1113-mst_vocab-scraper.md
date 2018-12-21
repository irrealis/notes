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

- I've noticed the following pattern in the code my simulator uses to decide how long to sleep:
  ```{python evaluate = False}
  wake += dt.timedelta(seconds = sleep_period)
  now = dt.datetime.now()
  sleep_dt = wake - now
  sleep_seconds = sleep_dt.seconds + sleep_dt.microseconds / 1e6
  # It's possible the wake time is in the past, which we would have to fix.
  print(" Sleep: {} sec".format(sleep_seconds))
  print(" Next wake: {}".format(wake.strftime('%H:%M:%S.%f')))
  if sleep_dt < dt.timedelta(0):
    wake = now
    sleep_dt = dt.timedelta(0)
    print(" Wake is in past; adusted next wake: {}".format(wake.strftime('%H:%M:%S.%f')))
  sleep_seconds = sleep_dt.seconds + sleep_dt.microseconds / 1e6
  ```

  Here's a rough encapsulation to dry things up:
  ```{python evaluate = False}
  def get_wakesleep(wake, intertask_period):
    next_wake = wake + dt.timedelta(seconds = sleep_period)
    now = dt.datetime.now()
    sleep_dt = wake - now
    sleep_seconds = sleep_dt.seconds + sleep_dt.microseconds / 1e6
    # It's possible the wake time is in the past, which we would have to fix.
    print(" Sleep: {} sec".format(sleep_seconds))
    print(" Next wake: {}".format(wake.strftime('%H:%M:%S.%f')))
    if sleep_dt < dt.timedelta(0):
      wake = now
      sleep_dt = dt.timedelta(0)
      sleep_seconds = sleep_dt.seconds + sleep_dt.microseconds / 1e6
      print(" Wake is in past; adusted next wake: {}".format(wake.strftime('%H:%M:%S.%f')))
    return next_wake, sleep_seconds
  ```


- Parsing the word-definition page:
  ```{python evaluate = False}
  sel = sp.Selector(text = html)
  word = sel.css('.dynamictext::text').extract_first()
  short_blurb = sel.css('p.short').extract_first()
  long_blurb = sel.css('p.long').extract_first()

  for sense_div in sel.css('div.sense'):
    sense_def = sense_div.css('h3.definition::text').extract()[-1].strip()
    for instance in sense_div.css('dl.instances'):
      kind = instance.css('dt::text').extract_first().lower()
      # Need to handle each kind of sense instance differently.
      if kind.startswith('synonyms'):
        for related_sense_dd in instance.css('dd'):
          related_words = related_sense_dd.css('a.word::text').extract()
          if not related_words:
            # This section has no words, is probably used for JavaScript.
            continue
          related_sense_def = related_sense_dd.css('div.definition::text').extract_first()
          if not related_sense_def:
            # If there's no text here, it means "use the sense, not the related sense."
            related_sense_def = '(no related sense)'
      elif kind.startswith('antonyms'):
      elif kind.startswith('types'):
      elif kind.startswith('type of'):
  ```


##### 2107: Automated scraper is up and running. Stopping for night.
