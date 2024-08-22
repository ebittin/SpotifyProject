# Spotify API Scraping for Creating Datasets
### I used the code (but slightly modified it to my needs to include the `release_date`) from this [lovely article](https://www.linkedin.com/pulse/extracting-your-fav-playlist-info-spotifys-api-samantha-jones/)!


```python
# pip install spotifyscraper
```


```python
# pip install pathlib
```


```python
# pip install ruamel-yaml
```


```python
# pip install spotipy
```


```python
import spotipy
from spotipy.oauth2 import SpotifyClientCredentials
from spotipy.oauth2 import SpotifyOAuth
import pandas as pd
import time
```


```python
cid = '6ff98eca336346ee942d607cc2d23879'
secret = '7d7292ad3cf0420e8f270e7d049f40ba'
client_credentials_manager = SpotifyClientCredentials(client_id=cid, client_secret=secret)
sp = spotipy.Spotify(client_credentials_manager = client_credentials_manager)
```


```python
# Pagination (to extract more than 100 songs at a time)
def call_playlist(creator, playlist_id):
    # Step 1: Initialize DataFrame and other variables
    playlist_features_list = ["artist", "album", "track_name", "track_id", "release_date", "danceability", "energy", "key", "loudness", "mode", "speechiness", "instrumentalness", "liveness", "valence", "tempo", "duration_ms", "time_signature"]
    playlist_df = pd.DataFrame(columns=playlist_features_list)
    offset = 0
    total_tracks = sp.user_playlist_tracks(creator, playlist_id)["total"]
    
    # Step 2: Fetch tracks with pagination
    while offset < total_tracks:
        playlist = sp.user_playlist_tracks(creator, playlist_id, offset=offset)["items"]
        for track in playlist:
            playlist_features = {}
            playlist_features["artist"] = track["track"]["album"]["artists"][0]["name"]
            playlist_features["album"] = track["track"]["album"]["name"]
            playlist_features["track_name"] = track["track"]["name"]
            playlist_features["track_id"] = track["track"]["id"]
            playlist_features["release_date"] = track["track"]["album"]["release_date"]
            audio_features = sp.audio_features(playlist_features["track_id"])[0]
            for feature in playlist_features_list[5:]:
                playlist_features[feature] = audio_features[feature]
            track_df = pd.DataFrame(playlist_features, index=[0])
            playlist_df = pd.concat([playlist_df, track_df], ignore_index=True)
        offset += 100
    # Step 3: Return DataFrame
    return playlist_df
```


```python
# Function to fetch audio features with retry logic
def fetch_audio_features(track_id):
    retries = 10  # Maximum number of retry attempts
    for _ in range(retries):
        try:
            return sp.audio_features(track_id)[0]
        except spotipy.SpotifyException as e:
            if e.http_status == 429:
                # Retry after a fixed delay
                retry_after = int(e.headers.get('Retry-After', 10))  # Default to 10 seconds if no Retry-After header
                print(f"Rate limited. Retrying after {retry_after} seconds...")
                time.sleep(retry_after)
            else:
                raise  # Re-raise the exception if it's not a 429 error
    raise Exception("Max retries reached, unable to fetch audio features")
```


```python
# https://open.spotify.com/playlist/5yAPuepGnApi5yc4QoZMDl
# "old" Playlist compiled by "emmabittinger" (this is a test)
old_playlist = call_playlist("spotify","5yAPuepGnApi5yc4QoZMDl")
```


```python
old_playlist.head()
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>artist</th>
      <th>album</th>
      <th>track_name</th>
      <th>track_id</th>
      <th>release_date</th>
      <th>danceability</th>
      <th>energy</th>
      <th>key</th>
      <th>loudness</th>
      <th>mode</th>
      <th>speechiness</th>
      <th>instrumentalness</th>
      <th>liveness</th>
      <th>valence</th>
      <th>tempo</th>
      <th>duration_ms</th>
      <th>time_signature</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>Various Artists</td>
      <td>Cars (Versión de Colección)</td>
      <td>Life Is A Highway - From "Cars"/Soundtrack Ver...</td>
      <td>1QezVl06xBzPfgJ2HXST5d</td>
      <td>2006-06-06</td>
      <td>0.561</td>
      <td>0.932</td>
      <td>5</td>
      <td>-5.475</td>
      <td>1</td>
      <td>0.0584</td>
      <td>0</td>
      <td>0.1810</td>
      <td>0.670</td>
      <td>103.062</td>
      <td>275640</td>
      <td>4</td>
    </tr>
    <tr>
      <th>1</th>
      <td>Anthem Lights</td>
      <td>Covers Part IV</td>
      <td>Don't Stop Believing</td>
      <td>0wBqAqxUygzHrUgw0MTJ6J</td>
      <td>2015-07-17</td>
      <td>0.516</td>
      <td>0.391</td>
      <td>10</td>
      <td>-7.319</td>
      <td>1</td>
      <td>0.0315</td>
      <td>0</td>
      <td>0.1440</td>
      <td>0.395</td>
      <td>117.873</td>
      <td>218644</td>
      <td>4</td>
    </tr>
    <tr>
      <th>2</th>
      <td>Bruce Springsteen</td>
      <td>Born In The U.S.A.</td>
      <td>Born in the U.S.A.</td>
      <td>0dOg1ySSI7NkpAe89Zo0b9</td>
      <td>1984-06-04</td>
      <td>0.398</td>
      <td>0.952</td>
      <td>4</td>
      <td>-6.042</td>
      <td>1</td>
      <td>0.0610</td>
      <td>0.000077</td>
      <td>0.1000</td>
      <td>0.584</td>
      <td>122.093</td>
      <td>278680</td>
      <td>4</td>
    </tr>
    <tr>
      <th>3</th>
      <td>Lynyrd Skynyrd</td>
      <td>Second Helping (Expanded Edition)</td>
      <td>Sweet Home Alabama</td>
      <td>7e89621JPkKaeDSTQ3avtg</td>
      <td>1974-04-15</td>
      <td>0.596</td>
      <td>0.605</td>
      <td>7</td>
      <td>-12.145</td>
      <td>1</td>
      <td>0.0255</td>
      <td>0.000331</td>
      <td>0.0863</td>
      <td>0.886</td>
      <td>97.798</td>
      <td>283800</td>
      <td>4</td>
    </tr>
    <tr>
      <th>4</th>
      <td>Rick Astley</td>
      <td>Whenever You Need Somebody</td>
      <td>Never Gonna Give You Up</td>
      <td>7GhIk7Il098yCjg4BQjzvb</td>
      <td>1987-12-08</td>
      <td>0.727</td>
      <td>0.939</td>
      <td>8</td>
      <td>-11.855</td>
      <td>1</td>
      <td>0.0369</td>
      <td>0.000044</td>
      <td>0.1510</td>
      <td>0.916</td>
      <td>113.330</td>
      <td>212827</td>
      <td>4</td>
    </tr>
  </tbody>
</table>
</div>




```python
# https://open.spotify.com/playlist/66kbLWdmxWuMYeByFkqADT
# "throwbaccc" Playlist compiled by "emmabittinger"
throbaccc_playlist = call_playlist("spotify","66kbLWdmxWuMYeByFkqADT")
```


```python
throbaccc_playlist.to_csv("throbaccc_playlist.csv")
```


```python
# https://open.spotify.com/playlist/7dBWDKw7I8kZy0td1VYFIY
# "Songs Everyone Knows the Words To" Playlist compiled by "Ava Montgomery"
long_playlist = call_playlist("spotify","7dBWDKw7I8kZy0td1VYFIY")
```


```python
long_playlist.to_csv("long_playlist.csv")
```


```python
throbaccc_playlist.head()
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>artist</th>
      <th>album</th>
      <th>track_name</th>
      <th>track_id</th>
      <th>release_date</th>
      <th>danceability</th>
      <th>energy</th>
      <th>key</th>
      <th>loudness</th>
      <th>mode</th>
      <th>speechiness</th>
      <th>instrumentalness</th>
      <th>liveness</th>
      <th>valence</th>
      <th>tempo</th>
      <th>duration_ms</th>
      <th>time_signature</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>Miley Cyrus</td>
      <td>The Time Of Our Lives</td>
      <td>Party In The U.S.A.</td>
      <td>5Q0Nhxo0l2bP3pNjpGJwV1</td>
      <td>2009-01-01</td>
      <td>0.652</td>
      <td>0.698</td>
      <td>10</td>
      <td>-4.667</td>
      <td>0</td>
      <td>0.0420</td>
      <td>0.000115</td>
      <td>0.0886</td>
      <td>0.470</td>
      <td>96.021</td>
      <td>202067</td>
      <td>4</td>
    </tr>
    <tr>
      <th>1</th>
      <td>Rihanna</td>
      <td>Loud</td>
      <td>What's My Name?</td>
      <td>5FTCKvxzqy72ceS4Ujux4N</td>
      <td>2010-11-16</td>
      <td>0.692</td>
      <td>0.786</td>
      <td>2</td>
      <td>-2.959</td>
      <td>1</td>
      <td>0.0690</td>
      <td>0.000000</td>
      <td>0.0797</td>
      <td>0.583</td>
      <td>100.025</td>
      <td>263173</td>
      <td>4</td>
    </tr>
    <tr>
      <th>2</th>
      <td>Train</td>
      <td>Hey, Soul Sister</td>
      <td>Hey, Soul Sister</td>
      <td>0KpfYajJVVGgQ32Dby7e9i</td>
      <td>2009-08-06</td>
      <td>0.675</td>
      <td>0.885</td>
      <td>1</td>
      <td>-4.432</td>
      <td>0</td>
      <td>0.0436</td>
      <td>0.000000</td>
      <td>0.0860</td>
      <td>0.768</td>
      <td>97.030</td>
      <td>216667</td>
      <td>4</td>
    </tr>
    <tr>
      <th>3</th>
      <td>Justin Bieber</td>
      <td>My World</td>
      <td>One Time</td>
      <td>6eDApnV9Jdb1nYahOlbbUh</td>
      <td>2009-01-01</td>
      <td>0.691</td>
      <td>0.853</td>
      <td>1</td>
      <td>-2.528</td>
      <td>0</td>
      <td>0.0372</td>
      <td>0.000071</td>
      <td>0.0820</td>
      <td>0.762</td>
      <td>145.999</td>
      <td>215867</td>
      <td>4</td>
    </tr>
    <tr>
      <th>4</th>
      <td>Taio Cruz</td>
      <td>Rokstarr (International Version)</td>
      <td>Dynamite</td>
      <td>0bg6otrW5gxNnlCqrCrXyd</td>
      <td>2010-05-28</td>
      <td>0.754</td>
      <td>0.804</td>
      <td>4</td>
      <td>-3.177</td>
      <td>1</td>
      <td>0.0853</td>
      <td>0.000000</td>
      <td>0.0329</td>
      <td>0.818</td>
      <td>119.968</td>
      <td>203867</td>
      <td>4</td>
    </tr>
  </tbody>
</table>
</div>




```python
throbaccc_playlist.describe()
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>danceability</th>
      <th>energy</th>
      <th>loudness</th>
      <th>speechiness</th>
      <th>instrumentalness</th>
      <th>liveness</th>
      <th>valence</th>
      <th>tempo</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>count</th>
      <td>330.000000</td>
      <td>330.000000</td>
      <td>330.000000</td>
      <td>330.000000</td>
      <td>330.000000</td>
      <td>330.000000</td>
      <td>330.000000</td>
      <td>330.000000</td>
    </tr>
    <tr>
      <th>mean</th>
      <td>0.647394</td>
      <td>0.738092</td>
      <td>-5.048933</td>
      <td>0.075087</td>
      <td>0.005875</td>
      <td>0.177032</td>
      <td>0.587910</td>
      <td>121.181464</td>
    </tr>
    <tr>
      <th>std</th>
      <td>0.117276</td>
      <td>0.164847</td>
      <td>1.792816</td>
      <td>0.061893</td>
      <td>0.056663</td>
      <td>0.128664</td>
      <td>0.206436</td>
      <td>25.593651</td>
    </tr>
    <tr>
      <th>min</th>
      <td>0.327000</td>
      <td>0.056500</td>
      <td>-15.099000</td>
      <td>0.025400</td>
      <td>0.000000</td>
      <td>0.019300</td>
      <td>0.076500</td>
      <td>65.043000</td>
    </tr>
    <tr>
      <th>25%</th>
      <td>0.578500</td>
      <td>0.676250</td>
      <td>-5.889250</td>
      <td>0.037700</td>
      <td>0.000000</td>
      <td>0.088675</td>
      <td>0.428000</td>
      <td>101.734500</td>
    </tr>
    <tr>
      <th>50%</th>
      <td>0.658500</td>
      <td>0.773000</td>
      <td>-4.823500</td>
      <td>0.051100</td>
      <td>0.000000</td>
      <td>0.127000</td>
      <td>0.619000</td>
      <td>122.624000</td>
    </tr>
    <tr>
      <th>75%</th>
      <td>0.724750</td>
      <td>0.857000</td>
      <td>-3.848500</td>
      <td>0.088050</td>
      <td>0.000004</td>
      <td>0.248750</td>
      <td>0.748000</td>
      <td>132.023000</td>
    </tr>
    <tr>
      <th>max</th>
      <td>0.979000</td>
      <td>0.981000</td>
      <td>-1.644000</td>
      <td>0.449000</td>
      <td>0.871000</td>
      <td>0.758000</td>
      <td>0.965000</td>
      <td>194.077000</td>
    </tr>
  </tbody>
</table>
</div>




```python
long_playlist.head()
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>artist</th>
      <th>album</th>
      <th>track_name</th>
      <th>track_id</th>
      <th>release_date</th>
      <th>danceability</th>
      <th>energy</th>
      <th>key</th>
      <th>loudness</th>
      <th>mode</th>
      <th>speechiness</th>
      <th>instrumentalness</th>
      <th>liveness</th>
      <th>valence</th>
      <th>tempo</th>
      <th>duration_ms</th>
      <th>time_signature</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>Coldplay</td>
      <td>Viva La Vida or Death and All His Friends</td>
      <td>Viva La Vida</td>
      <td>1mea3bSkSGXuIRvnydlB5b</td>
      <td>2008-05-26</td>
      <td>0.486</td>
      <td>0.617</td>
      <td>5</td>
      <td>-7.115</td>
      <td>0</td>
      <td>0.0287</td>
      <td>0.000003</td>
      <td>0.1090</td>
      <td>0.417</td>
      <td>138.015</td>
      <td>242373</td>
      <td>4</td>
    </tr>
    <tr>
      <th>1</th>
      <td>Rihanna</td>
      <td>Good Girl Gone Bad</td>
      <td>Umbrella</td>
      <td>2yPoXCs7BSIUrucMdK5PzV</td>
      <td>2007-01-01</td>
      <td>0.583</td>
      <td>0.829</td>
      <td>1</td>
      <td>-4.603</td>
      <td>1</td>
      <td>0.1340</td>
      <td>0.000000</td>
      <td>0.0426</td>
      <td>0.575</td>
      <td>174.028</td>
      <td>275987</td>
      <td>4</td>
    </tr>
    <tr>
      <th>2</th>
      <td>*NSYNC</td>
      <td>No Strings Attached</td>
      <td>Bye Bye Bye</td>
      <td>62bOmKYxYg7dhrC6gH9vFn</td>
      <td>2000-03-21</td>
      <td>0.610</td>
      <td>0.926</td>
      <td>8</td>
      <td>-4.843</td>
      <td>0</td>
      <td>0.0479</td>
      <td>0.001200</td>
      <td>0.0821</td>
      <td>0.861</td>
      <td>172.638</td>
      <td>200400</td>
      <td>4</td>
    </tr>
    <tr>
      <th>3</th>
      <td>Train</td>
      <td>Save Me, San Francisco (Golden Gate Edition)</td>
      <td>Hey, Soul Sister</td>
      <td>4HlFJV71xXKIGcU3kRyttv</td>
      <td>2010-12-01</td>
      <td>0.673</td>
      <td>0.886</td>
      <td>1</td>
      <td>-4.440</td>
      <td>0</td>
      <td>0.0431</td>
      <td>0.000000</td>
      <td>0.0826</td>
      <td>0.795</td>
      <td>97.012</td>
      <td>216773</td>
      <td>4</td>
    </tr>
    <tr>
      <th>4</th>
      <td>Carrie Underwood</td>
      <td>Some Hearts</td>
      <td>Before He Cheats</td>
      <td>0ZUo4YjG4saFnEJhdWp9Bt</td>
      <td>2005-11-14</td>
      <td>0.519</td>
      <td>0.749</td>
      <td>6</td>
      <td>-3.318</td>
      <td>0</td>
      <td>0.0405</td>
      <td>0.000000</td>
      <td>0.1190</td>
      <td>0.290</td>
      <td>147.905</td>
      <td>199947</td>
      <td>4</td>
    </tr>
  </tbody>
</table>
</div>




```python
long_playlist.describe()
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>danceability</th>
      <th>energy</th>
      <th>loudness</th>
      <th>speechiness</th>
      <th>instrumentalness</th>
      <th>liveness</th>
      <th>valence</th>
      <th>tempo</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>count</th>
      <td>345.000000</td>
      <td>345.000000</td>
      <td>345.000000</td>
      <td>345.000000</td>
      <td>345.000000</td>
      <td>345.00000</td>
      <td>345.000000</td>
      <td>345.000000</td>
    </tr>
    <tr>
      <th>mean</th>
      <td>0.614093</td>
      <td>0.704965</td>
      <td>-5.682510</td>
      <td>0.079451</td>
      <td>0.007984</td>
      <td>0.17513</td>
      <td>0.508641</td>
      <td>125.870136</td>
    </tr>
    <tr>
      <th>std</th>
      <td>0.139569</td>
      <td>0.171480</td>
      <td>2.219701</td>
      <td>0.069564</td>
      <td>0.049434</td>
      <td>0.13550</td>
      <td>0.228687</td>
      <td>26.866936</td>
    </tr>
    <tr>
      <th>min</th>
      <td>0.209000</td>
      <td>0.111000</td>
      <td>-18.064000</td>
      <td>0.024900</td>
      <td>0.000000</td>
      <td>0.02100</td>
      <td>0.038500</td>
      <td>65.997000</td>
    </tr>
    <tr>
      <th>25%</th>
      <td>0.522000</td>
      <td>0.594000</td>
      <td>-6.682000</td>
      <td>0.038200</td>
      <td>0.000000</td>
      <td>0.09010</td>
      <td>0.336000</td>
      <td>106.970000</td>
    </tr>
    <tr>
      <th>50%</th>
      <td>0.614000</td>
      <td>0.728000</td>
      <td>-5.223000</td>
      <td>0.054500</td>
      <td>0.000000</td>
      <td>0.12000</td>
      <td>0.506000</td>
      <td>125.072000</td>
    </tr>
    <tr>
      <th>75%</th>
      <td>0.717000</td>
      <td>0.839000</td>
      <td>-4.165000</td>
      <td>0.085300</td>
      <td>0.000090</td>
      <td>0.23700</td>
      <td>0.691000</td>
      <td>142.673000</td>
    </tr>
    <tr>
      <th>max</th>
      <td>0.967000</td>
      <td>0.986000</td>
      <td>-1.848000</td>
      <td>0.449000</td>
      <td>0.616000</td>
      <td>0.77000</td>
      <td>0.969000</td>
      <td>199.935000</td>
    </tr>
  </tbody>
</table>
</div>




```python

```
