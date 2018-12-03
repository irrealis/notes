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

##### 1239: Document work done over weekend: modeling time spent studying vocab.

I started recording in the afternoon 20 minutes after the start of the hour. Which hour I don't recall. I just recorded the minutes and seconds at the start of each word's study period.

Below, for date-time computation, I assume I started studying at midnight, and I construct a list of corresponding timestamps (HH:MM:SS).

```{python }
times = [
  "00:20:00",
  "00:20:40",
  "00:21:15",
  "00:22:27",
  "00:23:20",
  "00:24:23",
  "00:25:15",
  "00:26:06",
  "00:26:40",
  "00:27:26",
  "00:28:16",
  "00:29:54",
  "00:30:09",
  "00:30:59",
  "00:31:36",
  "00:32:18",
  "00:34:05",
  "00:35:03",
  "00:35:42",
  "00:36:47",
  "00:37:44",
  "00:38:21",
  "00:39:09",
  "00:40:17",
  "00:41:13",
  "00:42:07",
  "00:43:00",
  "00:43:47",
  "00:44:39",
  "00:45:18",
  "00:45:52",
  "00:46:30",
  "00:47:05",
  "00:47:52",
  "00:48:36",
  "00:49:22",
  "00:49:53",
  "00:50:40",
  "00:51:25",
  "00:52:09",
  "00:53:47",
  "00:54:45",
  "00:55:27",
  "00:56:27",
  "00:57:22",
  "00:58:05",
  "00:59:02",
  "00:59:50",
  "01:01:31",
  "01:02:15",
  "01:03:19",
  "01:04:05",
  "01:04:39",
  "01:05:37",
  "01:06:48",
  "01:07:03",
  "01:07:56",
  "01:09:03",
  "01:10:08",
  "01:11:01",
  "01:12:04",
  "01:13:20",
  "01:14:15",
  "01:15:48",
  "01:16:20",
  "01:17:06",
  "01:17:46",
  "01:18:37",
  "01:19:25",
  "01:19:57",
]
```

Here I play with various ways to work with the date-time data, including generating the model, and using the model to generate "study periods".

```{python }
import datetime as dt
import matplotlib as mp
import numpy as np
import pandas as pd
from scipy import stats as st
import matplotlib.pyplot as plt

x = np.array([0])
print(x[0])
help(x)

dts = [dt.datetime.strptime(time, '%H:%M:%S') for time in times]
ds = np.array([(b-a).seconds for (b,a) in zip(dts[1:], dts[:-1])])
ds
dist = pd.DataFrame(ds)
# fig, ax = plt.subplots()
# ax.hist(ds)
# dist.plot.kde(ax=ax)
# dist.plot.hist(density=True, ax=ax)

kde = st.gaussian_kde(ds)
samp = kde.resample(100)
samp

mins = 12.7234 + 2*st.norm().rvs(100)
mins

generated_dts = np.maximum(samp[0], mins)
generated_dts

x = max(kde.resample(1)[0], 12.7234 + 2*st.norm().rvs(1))
x

dt.datetime(2018, 12, 2, 20) - dt.datetime(2018, 12, 2, 8)

12*60*60/50
50*60/50

5000/(20*60)

def interval(kde, m, sd):
  return max(kde.resample(1)[0], m + sd*st.norm().rvs(1))

sched = np.add.accumulate(
  np.concatenate([interval(kde, 12.7236, 2.7) for i in range(60)])
)

[dt.datetime(2018, 12, 2, 8) + dt.timedelta(seconds = x) for x in sched]
[
  dt.datetime(2018, 12, 2, 8) + dt.timedelta(seconds = x)
  for x in
  np.add.accumulate(
    np.concatenate([interval(kde, 12.7236, 2.7) for i in range(60)])
  )
]

list((interval(kde, 12.7236, 2.7) for i in range(1000)))


start_times = [dt.datetime(2018, 12, 2, i, 0) for i in range(7, 19)]
start_times

list(range(8, 20))

help(kde)
```

Here I work out how to do asynchronous task scheduling for the simulation.

```{python }
import asyncio

async def foo():
    print('Running in foo')
    await asyncio.sleep(0)
    print('Explicit context switch to foo')

async def bar():
    print('Running in bar')
    await asyncio.sleep(0)
    print('Explicit context switch to bar')

async def main():
    print("\nStarting in main")
    tasks = [foo(), bar()]
    print("Gathering in main")
    await asyncio.gather(*tasks)
    print("Done in main")

asyncio.ensure_future(main())
```

I make a toy version of the problem, with 10-second "study sessions", 2-second "study periods", and 5-second "breaks".

```{python }
import asyncio

sleep_mu = 2.
sleep_sd = 0.5
break_sd = 1
now = dt.datetime.now()
s = [
  (now + dt.timedelta(seconds = i*15 + 10), now + dt.timedelta(seconds = (i+1)*15))
  for i in range(4)
]
s

async def fubar(schedule, sleep_mu, sleep_sd, break_sd):
  print("\nStarting in fubar")
  for break_t, start_t in s:
    print('break_t:', break_t, 'start_t:', start_t)

    while dt.datetime.now() < break_t:
      print("awake; now:", dt.datetime.now())
      sleep_dt = sleep_mu + sleep_sd*st.norm().rvs(1)
      print("sleeping for", sleep_dt, "seconds...")
      await asyncio.sleep(sleep_dt)

    print("done working; now:", dt.datetime.now())
    break_dt = (start_t - dt.datetime.now()).seconds + break_sd*st.norm().rvs(1)
    print("break for", break_dt, "seconds...")
    await asyncio.sleep(break_dt)
  print("done.")

asyncio.ensure_future(fubar(s, sleep_mu, sleep_sd, break_sd))
```

Now I put everything together into a single code block, simulating full study sessions, study periods, and breaks. I add a "do stuff" section that for now doesn't do anything but sleep for five seconds. I plan to fill out this this section with code to download and scrape vocabulary web pages.

```{python }
import datetime as dt
import matplotlib as mp
import numpy as np
import pandas as pd
from scipy import stats as st
import matplotlib.pyplot as plt
import asyncio

# Minimum sleep time. The idea is to simulate the minimum time to view a page.
min_sleep_mu = 12.30987
min_sleep_sd = 2.23487
# Break time standard deviation. The idea is to simulate variance in taking a study break.
break_sd = 154

# Actual times I started each new Vocabulary.com problem, so I model the distribution of time taken to answer each problem. I want to simulate these periods, and I'll use a gaussian KDE for this simulation.
times = [
  "00:20:00",
  "00:20:40",
  "00:21:15",
  "00:22:27",
  "00:23:20",
  "00:24:23",
  "00:25:15",
  "00:26:06",
  "00:26:40",
  "00:27:26",
  "00:28:16",
  "00:29:54",
  "00:30:09",
  "00:30:59",
  "00:31:36",
  "00:32:18",
  "00:34:05",
  "00:35:03",
  "00:35:42",
  "00:36:47",
  "00:37:44",
  "00:38:21",
  "00:39:09",
  "00:40:17",
  "00:41:13",
  "00:42:07",
  "00:43:00",
  "00:43:47",
  "00:44:39",
  "00:45:18",
  "00:45:52",
  "00:46:30",
  "00:47:05",
  "00:47:52",
  "00:48:36",
  "00:49:22",
  "00:49:53",
  "00:50:40",
  "00:51:25",
  "00:52:09",
  "00:53:47",
  "00:54:45",
  "00:55:27",
  "00:56:27",
  "00:57:22",
  "00:58:05",
  "00:59:02",
  "00:59:50",
  "01:01:31",
  "01:02:15",
  "01:03:19",
  "01:04:05",
  "01:04:39",
  "01:05:37",
  "01:06:48",
  "01:07:03",
  "01:07:56",
  "01:09:03",
  "01:10:08",
  "01:11:01",
  "01:12:04",
  "01:13:20",
  "01:14:15",
  "01:15:48",
  "01:16:20",
  "01:17:06",
  "01:17:46",
  "01:18:37",
  "01:19:25",
  "01:19:57",
]
dts = [dt.datetime.strptime(time, '%H:%M:%S') for time in times]
ds = np.array([(b-a).seconds for (b,a) in zip(dts[1:], dts[:-1])])
dist = pd.DataFrame(ds)
kde = st.gaussian_kde(ds)

# I'll be simulating according a schedule of 50-minute study periods followed by 10-minute breaks, with some jitter in length of breaks.
now = dt.datetime.now()
s = [
  (
    now + dt.timedelta(seconds = i*60*60 + 50*60),
    now + dt.timedelta(seconds = (i+1)*60*60)
  )
  for i in range(4)
]

# Prototype method to perform simulated problems on Vocabulary.com.
async def simulation(schedule, kde, min_sleep_mu, min_sleep_sd, break_sd):
  print("\nStarting simulation.")

  # This loops over simulated study periods, each 50 minutes long with 10-minute breaks in between.
  for break_t, start_t in s:
    print('Starting period; next break at: {}, next start at: {}'.format(
      break_t.strftime('%H:%M:%S'),
      start_t.strftime('%H:%M:%S')
    ))

    # This loops over simulated vocabulary problems within a study period.
    now = dt.datetime.now()
    while now < break_t:
      # Decide when we want to start the next simulated problem.
      min_sleep_period = (min_sleep_mu + min_sleep_sd*st.norm().rvs(1))[0]
      samp_sleep_period = (kde.resample(1)[0])[0]
      sleep_period = max(samp_sleep_period, min_sleep_period)
      wake = now + dt.timedelta(seconds = sleep_period)
      print("Awake; now: {}, min: {:.2f}s, samp: {:.2f}s, sleep: {:.6f}s".format(
        now.strftime('%H:%M:%S.%f'),
        min_sleep_period,
        samp_sleep_period,
        sleep_period,
      ))
      print(" Next wake: {}".format(wake.strftime('%H:%M:%S.%f')))

      # Do stuff...
      await asyncio.sleep(5)

      # Decide how long we need to sleep in order to awaken when planned.
      sleep_dt = wake - dt.datetime.now()
      await asyncio.sleep(sleep_dt.seconds + 1e-6*sleep_dt.microseconds)
      now = dt.datetime.now()

    # This simulates the break between study periods.
    break_period = ((start_t - dt.datetime.now()).seconds + break_sd*st.norm().rvs(1))[0]
    wake = now + dt.timedelta(seconds = break_period)
    print("Break; now: {}, sleep {:.6f}s until about {}...".format(
      now.strftime('%H:%M:%S.%f'),
      break_period,
      start_t.strftime('%H:%M:%S'),
    ))
    print(" Next wake: {}".format(wake.strftime('%H:%M:%S.%f')))
    sleep_dt = wake - dt.datetime.now()
    await asyncio.sleep(sleep_dt.seconds + 1e-6*sleep_dt.microseconds)

  print("Done; leaving simulation.")

asyncio.ensure_future(simulation(s, kde, min_sleep_mu, min_sleep_sd, break_sd))
```


Here I'm just playing aroud a little bit with learning the Julia programming language.

```{julia }
print("Hi.")
versioninfo()
varinfo()
pwd()

clipboard()
```

```{julia }
"""Sieve of Eratosthenes function docstring"""
function es(n::Int) # accepts one integer argument
  isprime = trues(n) # n-element vector of true-s
  isprime[1] = false # 1 is not a prime
  for i in 2:isqrt(n) # loop odd integers less or equal than sqrt(n)
    if isprime[i] # conditional evaluation
      for j in i^2:i:n # sequence with step i
        isprime[j] = false
      end
    end
  end
  return filter(x -> isprime[x], 1:n) # filter using anonymous function
end
println(es(100)) # print all primes less or equal than 100
@time length(es(10^6)) # check function execution time and memory usage
```


##### 1253: Document work done over weekend: Anki update script.


##### 1427: Switch to math. Doesn't look I'll get to web scraper today.
