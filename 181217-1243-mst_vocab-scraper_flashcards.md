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
          - _Not that I can see; so use a regular db primary key for this._
      - `word`
      - `short_blurb`
      - `long_blurb`
      - `task_was_executed`
    - `word_lists`:
      - `id`
        - **Is there a natural ID in the vocab html?**
          - _Yep. Embedded in the URL for the list._
      - `task_was_executed`
    - `word_list join`.
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

- Enabled caching:
  ```{diff }
diff --git a/spiders/gre_words/gre_words/settings.py b/spiders/gre_words/gre_words/settings.py
index 8418165..78f049d 100644
--- a/spiders/gre_words/gre_words/settings.py
+++ b/spiders/gre_words/gre_words/settings.py
@@ -93,8 +93,8 @@ DOWNLOADER_MIDDLEWARES = {

 # Enable and configure HTTP caching (disabled by default)
 # See https://doc.scrapy.org/en/latest/topics/downloader-middleware.html#httpcache-middleware-settings
-#HTTPCACHE_ENABLED = True
-#HTTPCACHE_EXPIRATION_SECS = 0
-#HTTPCACHE_DIR = 'httpcache'
-#HTTPCACHE_IGNORE_HTTP_CODES = []
-#HTTPCACHE_STORAGE = 'scrapy.extensions.httpcache.FilesystemCacheStorage'
+HTTPCACHE_ENABLED = True
+HTTPCACHE_EXPIRATION_SECS = 3600
+HTTPCACHE_DIR = 'httpcache'
+HTTPCACHE_IGNORE_HTTP_CODES = []
+HTTPCACHE_STORAGE = 'scrapy.extensions.httpcache.FilesystemCacheStorage'
  ```

  After running the _selenium_quotes_ crawler, I verified that a cache directory was created: _./.scrapy/httpcache_.

  Moreover, Scrapy stats recorded the caching --- see `httpcach/*` stats below:

  ```
  2018-12-17 14:58:28 [scrapy.statscollectors] INFO: Dumping Scrapy stats:
  {'downloader/request_bytes': 228,
   'downloader/request_count': 1,
   'downloader/request_method_count/GET': 1,
   'downloader/response_bytes': 25192,
   'downloader/response_count': 3,
   'downloader/response_status_count/200': 2,
   'downloader/response_status_count/404': 1,
   'finish_reason': 'finished',
   'finish_time': datetime.datetime(2018, 12, 17, 21, 58, 28, 916200),
   'httpcache/firsthand': 3,
   'httpcache/miss': 1,
   'httpcache/store': 3,
   'log_count/DEBUG': 38,
   'log_count/INFO': 7,
   'memusage/max': 54833152,
   'memusage/startup': 54833152,
   'response_received_count': 3,
   'scheduler/dequeued': 2,
   'scheduler/dequeued/memory': 2,
   'scheduler/enqueued': 2,
   'scheduler/enqueued/memory': 2,
   'start_time': datetime.datetime(2018, 12, 17, 21, 58, 27, 895225)}
  ```

  After running a second time, Scrapy believed the cache was used:

  ```
  2018-12-17 15:00:51 [scrapy.statscollectors] INFO: Dumping Scrapy stats:
  {'downloader/request_bytes': 228,
   'downloader/request_count': 1,
   'downloader/request_method_count/GET': 1,
   'downloader/response_bytes': 25192,
   'downloader/response_count': 3,
   'downloader/response_status_count/200': 2,
   'downloader/response_status_count/404': 1,
   'finish_reason': 'finished',
   'finish_time': datetime.datetime(2018, 12, 17, 22, 0, 51, 356537),
   'httpcache/firsthand': 2,
   'httpcache/hit': 1,
   'httpcache/store': 2,
   'log_count/DEBUG': 38,
   'log_count/INFO': 7,
   'memusage/max': 54984704,
   'memusage/startup': 54968320,
   'response_received_count': 3,
   'scheduler/dequeued': 2,
   'scheduler/dequeued/memory': 2,
   'scheduler/enqueued': 2,
   'scheduler/enqueued/memory': 2,
   'start_time': datetime.datetime(2018, 12, 17, 22, 0, 20, 585463)}
  ```

  But I'm not convinced that the cache was used as expected. The cache contains three stores, but only one hit, and it looks like two pages are downloaded and stored a second time.

  In any case, if I handle tasks correctly, I shouldn't have much need for the cache. Moving on.


##### 1510: Break; then setup first exploratory scrape.

- How to use _scrapy-selenium_ from within the Scrapy shell:
  - Launch shell using the _selenium_quotes_ spider:
    ```
    scrapy shell --spider=selenium_quotes
    ```

  - From within shell:
    ```{python evaluate = False}
    In [1]: from scrapy_selenium import SeleniumRequest
    In [2]: request = SeleniumRequest(url = 'http://quotes.toscrape.com/page/1/')
    In [3]: fetch(request)
    2018-12-17 15:29:35 [scrapy.core.engine] INFO: Spider opened
    2018-12-17 15:29:35 [scrapy.extensions.httpcache] DEBUG: Using filesystem cache storage in /mnt/Work/Repos/irrealis/flashcards/spiders/gre_words/.scrapy/httpcache
    2018-12-17 15:29:35 [scrapy.core.engine] DEBUG: Crawled (404) <GET http://quotes.toscrape.com/robots.txt> (referer: None) ['cached']
    2018-12-17 15:29:35 [selenium.webdriver.remote.remote_connection] DEBUG: POST http://127.0.0.1:34057/session/3dcfb637d9a9f9f6f694cb545a555e1a/url {"url": "http://quotes.toscrape.com/page/1/", "sessionId": "3dcfb637d9a9f9f6f694cb545a555e1a"}
    2018-12-17 15:29:36 [urllib3.connectionpool] DEBUG: http://127.0.0.1:34057 "POST /session/3dcfb637d9a9f9f6f694cb545a555e1a/url HTTP/1.1" 200 72
    2018-12-17 15:29:36 [selenium.webdriver.remote.remote_connection] DEBUG: Finished Request
    2018-12-17 15:29:36 [selenium.webdriver.remote.remote_connection] DEBUG: GET http://127.0.0.1:34057/session/3dcfb637d9a9f9f6f694cb545a555e1a/source {"sessionId": "3dcfb637d9a9f9f6f694cb545a555e1a"}
    2018-12-17 15:29:36 [urllib3.connectionpool] DEBUG: http://127.0.0.1:34057 "GET /session/3dcfb637d9a9f9f6f694cb545a555e1a/source HTTP/1.1" 200 13361
    2018-12-17 15:29:36 [selenium.webdriver.remote.remote_connection] DEBUG: Finished Request
    2018-12-17 15:29:36 [selenium.webdriver.remote.remote_connection] DEBUG: GET http://127.0.0.1:34057/session/3dcfb637d9a9f9f6f694cb545a555e1a/url {"sessionId": "3dcfb637d9a9f9f6f694cb545a555e1a"}
    2018-12-17 15:29:36 [urllib3.connectionpool] DEBUG: http://127.0.0.1:34057 "GET /session/3dcfb637d9a9f9f6f694cb545a555e1a/url HTTP/1.1" 200 104
    2018-12-17 15:29:36 [selenium.webdriver.remote.remote_connection] DEBUG: Finished Request
    2018-12-17 15:29:36 [scrapy.core.engine] DEBUG: Crawled (200) <GET http://quotes.toscrape.com/page/1/> (referer: None)
    ```

- I noticed that _robots.txt_ was always being consulted in the shell. To disable this:
  ```{diff }
diff --git a/spiders/gre_words/gre_words/settings.py b/spiders/gre_words/gre_words/settings.py
index 78f049d..377ded3 100644
--- a/spiders/gre_words/gre_words/settings.py
+++ b/spiders/gre_words/gre_words/settings.py
@@ -28,7 +28,7 @@ NEWSPIDER_MODULE = 'gre_words.spiders'
 #USER_AGENT = 'gre_words (+http://www.yourdomain.com)'

 # Obey robots.txt rules
-ROBOTSTXT_OBEY = True
+ROBOTSTXT_OBEY = False

 # Configure maximum concurrent requests performed by Scrapy (default: 16)
 #CONCURRENT_REQUESTS = 32
  ```

##### Natural vocab list identifier to use as db primary ID?

- My defined vocabulary lists can be seen at https://www.vocabulary.com/account/lists/.
  - The links to vocabulary lists have embedded IDs, e.g. my "800 high frequency words GRE" list has ID 185604, seen in link https://www.vocabulary.com/lists/185604.
  - How to manually scrape:
    ```{python evaluate = False}
    In [5]: fetch(SeleniumRequest(url = 'https://www.vocabulary.com/account/lists/'))

    In [32]: response.css('table.list-list td a')[0].css('::text').extract()
    Out[32]: ['800 high frequency words GRE\n\t', 'November 9, 2018 (816 words)', '\n\t']

    In [33]: response.css('table.list-list td a')[0].css('::attr(href)').extract()
    Out[33]: ['/lists/185604']
    ```


##### Natural word/definition IDs?

- Continuing above, first follow link to vocab list:
  ```{python evaluate = False}
  In [42]: next_page = response.css('table.list-list td a')[0].css('::attr(href)').extract_first()

  In [43]: fetch(SeleniumRequest(url = 'https://www.vocabulary.com/{}'.format(next_page)))
  ```

- Observations:
  - There appears to be no natural ID associated with a word.
    - Or at least it's not on this web page.
    - Probably the reason is to provide friendly URLs.
  - The thing that I'm calling `short_definition` is apparently the primary synonym sense for the word.
    - _So I don't need a `short_definition` entry in the `definitions` table._
    - _I can also now:
      - Move `short_blurb` and `long_blurb` fields into the `words` table.
      - Remove the `definitions` table.
      - Remove the `word_definition_join` table.


- How to scrape word info from vocab list page:
  - Entry html:
    ```{python evaluate = False}
    In [53]: entry = response.css('.wordlist li')[0]
    ```
  - Word:
    ```{python evaluate = False}
    In [54]: word = entry.css('a.word::text').extract_first()
    ```
  - Word frequency:
    ```{python evaluate = False}
    In [55]: freq = entry.css('::attr(freq)').extract_first()
    ```
  - Relative link to word page:
    ```{python evaluate = False}
    In [56]: word_page = entry.css('::attr(href)').extract_first()
    ```
  - Displaying word info:
    ```{python evaluate = False}
    In [57]: word, freq, word_page
    Out[57]: ('abdicate', '1648.06', '/dictionary/abdicate')
    ```

##### 1640: Break; next: examine synonyms on word page.
##### 1706: Try setting up ORM.


```{python }
%pushd '/mnt/Work/Repos/irrealis/flashcards/spiders/gre_words'
%pwd
```

```{python }
from irrealis.orm import ORM
from sqlalchemy import Table, Column, Integer, Numeric, Text, MetaData, ForeignKey, create_engine
from sqlalchemy.orm import relationship
from sqlalchemy.orm.exc import MultipleResultsFound


db_url = 'sqlite:///vocab.sqlite'

metadata = MetaData()
Table('vocabs', metadata,
  Column('id', Integer, primary_key = True, autoincrement = False),
  Column('description', Text),
)
Table('words', metadata,
  Column('id', Integer, primary_key = True),
  Column('word', Text),
  Column('short_blurb', Text),
  Column('long_blurb', Text),
  Column('frequency', Numeric)
)
Table('vocab_word_association', metadata,
  Column('id', Integer, primary_key = True),
  Column('vocab_id', Integer, ForeignKey('vocabs.id')),
  Column('word_id', Integer, ForeignKey('words.id')),
)
engine = create_engine(db_url)
metadata.create_all(engine)

orm_defs = dict(
  Vocab = dict(
    __tablename__ = 'vocabs',
    words = relationship(
      'Word',
      secondary = 'vocab_word_association',
      primaryjoin = 'Word.id == vocab_word_association.c.vocab_id',
      secondaryjoin = 'Word.id == vocab_word_association.c.word_id',
      # backref = 'vocabs',
    ),
  ),
  Word = dict(
    __tablename__ = 'words',
  ),
  VocabWordAssociation = dict(
    __tablename__ = 'vocab_word_association',
  )
)
# orm = ORM(orm_defs, engine)
orm = ORM(orm_defs, engine = db_url)

orm.mapped_classes

# db_url = 'sqlite://'
orm_defs = dict(
  Vocab = dict(
    __tablename__ = 'vocabs',
    id = Column('id', Integer, primary_key = True, autoincrement = False),
    description = Column('description', Text),
    words = relationship(
      'Word',
      secondary = 'vocab_word_association',
      primaryjoin = 'Word.id == vocab_word_association.c.vocab_id',
      secondaryjoin = 'Word.id == vocab_word_association.c.word_id',
      # backref = 'vocabs',
    ),
  ),
  Word = dict(
    __tablename__ = 'words',
    id = Column('id', Integer, primary_key = True),
    word = Column('word', Text),
    short_blurb = Column('short_blurb', Text),
    long_blurb = Column('long_blurb', Text),
    frequency = Column('frequency', Numeric)
  ),
  VocabWordAssociation = dict(
    __tablename__ = 'vocab_word_association',
    id = Column('id', Integer, primary_key = True),
    vocab_id = Column('vocab_id', Integer, ForeignKey('vocabs.id')),
    word_id = Column('word_id', Integer, ForeignKey('words.id')),
  )
)

orm = ORM(orm_defs, db_url)
```

```{python }
vocab_185604 = orm.create(orm.Vocab, id = 185604)
orm.session.commit()
for entry in response.css('.wordlist li'):
  word_text = entry.css('a.word::text').extract_first()
  freq = entry.css('::attr(freq)').extract_first()
  word = orm.create(orm.Word, word = word_text, frequency = freq)
  vocab_185604.words.append(word)
orm.session.commit()
```


##### 1902: Yeesh. SQLAlchemy changed again, breaking my ORM system.

To setup automapped vocabularies and words, with many-to-many join, I had to return to basics. The following seems to work correctly.


```{python }
%pushd '/mnt/Work/Repos/irrealis/flashcards/spiders/gre_words'
```

```{python }
%cd '/mnt/Work/Repos/irrealis/flashcards/spiders/gre_words'
%rm vocab.sqlite

from sqlalchemy import Table, Column, Integer, Numeric, Text, MetaData, ForeignKey, create_engine

from sqlalchemy.ext.automap import automap_base
from sqlalchemy.orm import Session


db_url = 'sqlite:///vocab.sqlite'
metadata = MetaData()
engine = create_engine(db_url)
session = Session(engine)

Table('vocabs', metadata,
  Column('id', Integer, primary_key = True, autoincrement = False),
  Column('description', Text),
)

Table('words', metadata,
  Column('id', Integer, primary_key = True),
  Column('word', Text),
  Column('short_blurb', Text),
  Column('long_blurb', Text),
  Column('frequency', Numeric)
)

Table('words', metadata,
  Column('id', Integer, primary_key = True),
  Column('word', Text),
  Column('short_blurb', Text),
  Column('long_blurb', Text),
  Column('frequency', Numeric)
)

Table('vocab_word_association', metadata,
  Column('vocab_id', Integer, ForeignKey('vocabs.id'), primary_key = True),
  Column('word_id', Integer, ForeignKey('words.id'), primary_key = True),
)

metadata.create_all(engine)

Base = automap_base()

Base.prepare(engine, reflect=True)

Vocab = Base.classes.vocabs
Word = Base.classes.words

session.add(Vocab(id = 185604, description = '800 high frequency words GRE'))
session.commit()

session.add(Word(word = 'abdicate'))
session.commit()

vocab_185604 = session.query(Vocab).first()
abdicate = session.query(Word).first()

vocab_185604.words_collection.append(abdicate)

session.add_all(vocab_185604.words_collection)
session.commit()


abdicate.vocabs_collection[0].id
```


##### 1904: Stopping.

##### 2045: Resuming, probably briefly. Considering sense IDs.

- On a word's page senses have a natural ID embedded in `div.sense` `id`.
  - However, the IDs of related senses are not included on the page.
    - Only the synonyms and the text of the related sense are included.
  - I think this means it makes sense to use the embedded sense ID as the db primary key.
  - But it also means I'll have to search for related senses by text.
    - So I'll need to index that column.
- I've observed the following "types" of senses:
  - Synonyms
  - Antonyms
  - Types
  - Types of
  - Examples
    - _Don't use this type._ Reason: instead of linked individual words, they provide linked phrases or usage examples.
- Since the data is there, if it isn't too much trouble I might as well scrape it.
  - This suggests the following additional tables:
    - `senses`
      - `id`: the `div.sense` `id` from the word's page
      - `sense`
    - `word_sense_join`
      - `word_id`
      - `sense_id`
    - `sense_relation_types`
      - `id`: standard primary key
      - `sense_relation_type`
    - `related_sense_join`
      - `relation_type_id`: related key from `sense_relation_types`
- This is starting to look like a complex many-to-many self join. Which may be more complex than I want or need.
  - Wouldn't be too hard to handle. It would slightly easier if I were making a directed graph... Here I have the following symmetries:
    - A sense is the antonym of an antonym.
      - This is an undirected relationship.
    - A sense is the synonym of a synonym.
      - This is an undirected relationship.
    - A sense is the type of a typeof.
      - This is a directed relationship.
  - These kinds of relationships could be simplified using some helper functions.
- Decision: this is more complex than I want right now.
  - _Don't model sense-sense relationships. Just model word-sense relationships.
  - Yes, I may want to analyze these relationships in future, but for now instead of trying to model this in the database, I'll just store the HTML file for each word.

- _AHA! instead of including the type in sense-sense relationships, I can include the type in the word-sense relationship._
  - No, I don't think this works.
    - There are synonyms directly related to this sense.
    - And there are synonyms indirectly related, via a directly related sense.


##### 2138: Stopping for night.
