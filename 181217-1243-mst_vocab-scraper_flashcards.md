---
title: "181217-1243-mst_vocab-scraper_flashcards.md"
---

# Status:

- Friday, _181214-1306-mst_vocab-scraper_flashcards.md_
  - Planned upcoming work on vocab scraper.


# Plans:

- As from Friday, for vocab scraper:
  - Start with Scrapy tutorial.
  - Then look at wiring up Selenium/Chrome.
  - Use "irrealis" profile in Scrapy/Selenium/Chrome setup.
  - Learn about and enable caching.
  - Manually setup first exploratory scrape: word lists.
    - **Is there a natural word-list identifier on the vocab site I can use as a database primary ID?**
      - **How to scrape it?**
  - Begin setting up database interface and tables.
    - SQLAlchemy-based ORM.
    - `words`:
      - `id`
        - **Is there a natural ID in the vocab html?**
      - `word`
      - `task_was_executed`
    - `word_lists`:
      - `id`
        - **Is there a natural ID in the vocab html?**
      - `task_was_executed`
    - `word_list join`.
    - `definitions`:
      - `id`
        - **Is there a natural ID in the vocab html?**
          - _Probably not. In this case it will probably be best to use a autoincrementing numeric ID._
      - `short_definition`
      - `short_blurb`
      - `long_blurb`
    - `word_definition_join`
  - Setup a scheduling system.
    - Let's try Dramatiq: https://dramatiq.io/
  - Make a setup script:
    - Check for word list in database. If not present, populate.
      - Will need info about ID/URL for word list.
      - **How to manage task list?**
        - **How to know what still needs to be done?**
          - _Computationally. Some condition isn't met, therefore task needs to be done._
        - **How to handle situation in which something may already be scheduled?**
          - _Idempotency. Allow it to be scheduled again, when task is dequeued for execution, check whether it's already been done. Only execute if not already done._
        - **How to limit resource burden resulting from scheduling the same task more than once?**
          - _Chunking. A higher-level task schedules lower-level tasks. If the higher-level task is scheduled more than once, but is idempotent, then it should schedule the lower-level tasks only a limited number of times._
        - _Add flag 'task_was_executed' to word_list entries._
        - _Similarly, add flag 'task_was_executed' to word entries._
      - Initially, null word list task.
      - Verify null word list task executed.
      - Setup and verify stochastic delay on tasks.
        - Let's use the estimated probability distribution from _181203-1124-mst_anki-connect_study-simulator_math.md_.
      - Setup and verify word list task to scrape word list.
        - If word list task not executed:
          - Download and scrape word list.
          - For each word in list:
            - Check if word in database. If not:
              - Add with definition.
            - Verify entry in join table.
              - _This is important; it will be used later to annotate Anki cards._
                - There will be a section for each list, that shows the synonyms in that list.
                  - If a word is in multiple lists (as should occasionally happen) then its primary list membership will be considered the smallest list.
                    - Or, in any case, the lists will have an ordering, and the primary list will be considered the lowest in the list order.
                - There will be a final section for words not in any list.
            - If word task not executed, schedule.
          - At completion of task, mark word list's `task_was_executed`.
    - For each entry in word lists:
      - Find or create word in database.
      - Update `short_definition`.
      - Check if word task executed. If not, schedule.
    - For each word in words, check if word task executed. If not, schedule.
      - Initially, null word task.
      - Verify null word task executed.
      - Setup and verify word task to scrape word definition and synonym senses.
        - At this point, setup more tables:
          - `senses`:
            - `id`
              - **Is there a natural ID in the vocab html?**
            - `sense`
          - `word_sense_join`
          - `related_sense_join`
        - _When I scrape this section, I'll be creating word entries for synonyms that aren't already in the database._
        - If word task was not executed:
          - Download and scrape word definition.
            - Update `short_blurb` and `long_blurb`.
          - For each primary synonym sense:
            - Find or create synonym sense in database.
              - **How?**
                - _Hopefully I can lookup by some natural ID._
                - _Otherwise, I may have to lookup by sense text._
            - Find or create primary-sense/word join.
            - For each synonym sense:
              - If sense text is blank, then the listed synonyms are for the primary sense.
              - Otherwise:
                - Find or create synonym sense in database.
                - Find or create related sense join.
              - Find or create sense/word join.
              - For each synonym:
                - Find or create synonym in database.
                - Find or create synonym/sense join.
  - After verifying setup and scheduling, try setting up Anki flashcard:
    - Front: sense text.
    - Back:
      - Synonyms, grouped by primary list (or none).
    - Related senses:
      - **What about related senses and word lists?**
        - Order by:
          - For each related sense, consider joining synonyms.
          - Each synonym has a primary list.
          - Collect these synonym primary lists.
          - _The primary list of the related sense is the first of the synonym primary lists, according to list ordering._


# Log:

##### 1243: Start ; status/thoughts/plans.

##### 1246: Vocab scraper; Scrapy tutorial

- Wkpt: _kaben@ares:/mnt/Work/Repos/irrealis/flashcards/spiders_
  - Uses Pyenv _atom-3.7.0_.
- Following tutorial at https://doc.scrapy.org/en/latest/intro/tutorial.html
- I had previously created a project `gre_words` via:
  ```
  scrapy startproject gre_words.
  ```
  Reusing this project.

- Added _gre_words/gre_words/spiders/quotes_spider.py:
  ```{python evaluate = False}
  import scrapy

  class QuotesSpider(scrapy.Spider):
    name = "quotes"

    def start_requests(self):
      urls = [
        'http://quotes.toscrape.com/page/1/',
        'http://quotes.toscrape.com/page/2/',
      ]
      for url in urls:
        yield scrapy.Request(url = url, callback = self.parse)

    def parse(self, response):
      page = response.url.split("/")[-2]
      filename = 'quotes-%s.html' % page
      with open(filename, 'wb') as f:
        f.write(response.body)
      self.log('Saved file %s' % filename)
  ```

  Ran using command:
  ```
  scrapy crawl quotes
  ```

  Works as expected.


##### 1339: Wiring up Selenium/Chrome.

- Installed _scrapy-selenium_ into `atom-3.7.0`:
  ```
  pip3 install scrapy-selenium
  ```
- Modified settings:
  ```{patch }
diff --git a/spiders/gre_words/gre_words/settings.py b/spiders/gre_words/gre_words/settings.py
index 638a977..295a984 100644
--- a/spiders/gre_words/gre_words/settings.py
+++ b/spiders/gre_words/gre_words/settings.py
@@ -9,6 +9,12 @@
 #     https://doc.scrapy.org/en/latest/topics/downloader-middleware.html
 #     https://doc.scrapy.org/en/latest/topics/spider-middleware.html

+from shutil import which
+
+SELENIUM_DRIVER_NAME = 'chrome'
+SELENIUM_DRIVER_EXECUTABLE_PATH = which('chromedriver')
+SELENIUM_DRIVER_ARGUMENTS = []
+
 BOT_NAME = 'gre_words'

 SPIDER_MODULES = ['gre_words.spiders']
@@ -52,9 +58,10 @@ ROBOTSTXT_OBEY = True

 # Enable or disable downloader middlewares
 # See https://doc.scrapy.org/en/latest/topics/downloader-middleware.html
-#DOWNLOADER_MIDDLEWARES = {
+DOWNLOADER_MIDDLEWARES = {
 #    'gre_words.middlewares.GreWordsDownloaderMiddleware': 543,
-#}
+  'scrapy_selenium.SeleniumMiddleware': 800,
+}

 # Enable or disable extensions
 # See https://doc.scrapy.org/en/latest/topics/extensions.html
  ```

- Added _gre_words/gre_words/spiders/selenium_quotes_spider.py:
  ```{python evaluate = False}
  import scrapy
  from scrapy_selenium import SeleniumRequest

  class SeleniumQuotesSpider(scrapy.Spider):
    name = "selenium_quotes"

    def start_requests(self):
      urls = [
        'http://quotes.toscrape.com/page/1/',
        'http://quotes.toscrape.com/page/2/',
      ]
      for url in urls:
        yield SeleniumRequest(url = url, callback = self.parse)

    def parse(self, response):
      print(response.meta['driver'].title)
      page = response.url.split("/")[-2]
      filename = 'quotes-%s.html' % page
      with open(filename, 'wb') as f:
        f.write(response.body)
      self.log('Saved file %s' % filename)
  ```

  Ran using command:
  ```
  scrapy crawl selenium_quotes
  ```

  Works as expected, this time using a chrome browser.


##### 1347: Use "irrealis" profile in setup.

Took some time to figure this out. Can't specify a specific profile path. Can only use 'Default' profile in user data dir.
- Created user data dir _/mnt/Work/Repos/irrealis/flashcards/spiders/google-chrome-config_.
- Used code below to launch.
  ```{python }
  import time

  from selenium import webdriver
  import selenium.webdriver.chrome.service as service
  import selenium.webdriver.chrome.options as options

  opts = options.Options()
  opts.binary_location = '/opt/google/chrome/google-chrome'
  opts.add_argument(
    'user-data-dir=/mnt/Work/Repos/irrealis/flashcards/spiders/google-chrome-config'
  )
  opts.to_capabilities()

  svc = service.Service('/home/kaben/.local/bin/chromedriver-2.45.615279')
  svc.start()
  driver = webdriver.Remote(svc.service_url, opts.to_capabilities())
  driver.get('http://www.google.com/xhtml');
  # time.sleep(5) # Let the user actually see something!
  # driver.quit()
  ```

- Manually signed into 'irrealis.chomp@gmail.com'.
- Manually signed into vocabulary.com.
- Exited Selenium-controlled browser:
  ```{python }
  driver.quit()
  ```

- Relaunched using above code. Verified:
  - Still signed in as 'irrealis.chomp@gmail.com'.
  - Still signed into vocabulary.com.


- Modified settings again, to enact user data dir:
  ```{diff }
diff --git a/spiders/gre_words/gre_words/settings.py b/spiders/gre_words/gre_words/settings.py
index 295a984..8418165 100644
--- a/spiders/gre_words/gre_words/settings.py
+++ b/spiders/gre_words/gre_words/settings.py
@@ -13,7 +13,10 @@ from shutil import which

 SELENIUM_DRIVER_NAME = 'chrome'
 SELENIUM_DRIVER_EXECUTABLE_PATH = which('chromedriver')
-SELENIUM_DRIVER_ARGUMENTS = []
+SELENIUM_DRIVER_ARGUMENTS = [
+  'user-data-dir=/mnt/Work/Repos/irrealis/flashcards/spiders/google-chrome-config'
+]
+

 BOT_NAME = 'gre_words'
  ```

##### 1347: Learn about and enable caching.
