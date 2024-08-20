# Spotify Project

## Project Description

This is a final project created by Emma Bittinger for Purdue's Spring 2024 course **STAT 506: Statistical Programming and Data Management.**

1. The first two datasets I scraped from my own ([throwbaccc](https://open.spotify.com/playlist/66kbLWdmxWuMYeByFkqADT])) and another user’s ([Songs Everyone Knows the Words To](https://open.spotify.com/playlist/7dBWDKw7I8kZy0td1VYFIY)) playlist using the Spotify API. The scripts and libraries used to scrape this data are in the [folder]() of this repository.

2. The third dataset is from Kaggle, containing similar data with different but similar column names. This ([Top Spotify Songs from 2010-2019 – BY YEAR](https://www.kaggle.com/datasets/leonardopena/top-spotify-songs-from-20102019-by-year)) (`top10s.csv`) dataset has over 22,000 downloads, indicating its popularity and reliability. 

Amongst all three datasets, there are a multitude of attributes for each song, ranging from track popularity, danceability, and energy, this dataset offers an exciting opportunity to dive deeper into music analytics. I hope to uncover a few reasons behind what makes certain songs so appealing and likable to millions of listeners and music enthusiasts. 

## Data Content

a. `artist`: Name of the Artist.

b. `song`: Name of the Track.

c. `duration_ms`: Duration of the track in milliseconds.

d. `explicit`: The lyrics or content of a song or a music video contain one or more of the criteria that could be considered offensive or unsuitable for children.

e. `year`: Release Year of the track.

f. `popularity`: The higher the value the more popular the song is.

g. `danceability`: Danceability describes how suitable a track is for dancing based on a combination of musical elements including tempo, rhythm stability, beat strength, and overall regularity. A value of 0.0 is the least danceable and 1.0 is the most danceable.

h. `energy`: Energy is a measure from 0.0 to 1.0 and represents a perceptual measure of intensity and activity.

i. `key`: The key the track is in. Integers map to pitches using standard Pitch Class notation. E.g. 0 = C, 1 = C♯/D♭, 2 = D, and so on. If no key was detected, the value is -1.

j. `loudness`: The overall loudness of a track in decibels (dB). Loudness values are averaged across the entire track and are useful for comparing the relative loudness of tracks. Loudness is the quality of a sound that is the primary psychological correlate of physical strength (amplitude). Values typically range between -60 and 0 db.
mode: Mode indicates the modality (major or minor) of a track, the type of scale from which its melodic content is derived. Major is represented by 1 and minor is 0.

k. `speechiness`: Speechiness detects the presence of spoken words in a track. The more exclusively speech-like the recording is (e.g. talk show, audiobook, poetry) the closer to 1.0 the attribute value. Values above 0.66 describe tracks that are probably made entirely of spoken words. Values between 0.33 and 0.66 describe tracks that may contain both music and speech, either in sections or layered, including such cases as rap music. Values below 0.33 most likely represent music and other non-speech-like tracks.

l. `acousticness`: A confidence measure from 0.0 to 1.0 of whether the track is acoustic. 1.0 represents high confidence that the track is acoustic.
instrumentalness: Predicts whether a track contains no vocals. “Ooh” and “aah” sounds are treated as instrumental in this context. Rap or spoken word tracks are clearly “vocal”. The closer the instrumentalness value is to 1.0, the greater the likelihood the track contains no vocal content. Values above 0.5 are intended to represent instrumental tracks, but confidence is higher as the value approaches 1.0.

m. `liveness`: Detects the presence of an audience in the recording. Higher liveness values represent an increased probability that the track was performed live. A value above 0.8 provides a strong likelihood that the track is live.

n. `valence`: A measure from 0.0 to 1.0 describing the musical positiveness conveyed by a track. Tracks with high valence sound more positive (e.g. happy, cheerful, euphoric), while tracks with low valence sound more negative (e.g. sad, depressed, angry).

o. `tempo`: The overall estimated tempo of a track in beats per minute (BPM). In musical terminology, tempo is the speed or pace of a given piece and derives directly from the average beat duration.

p. `genre`: Genre of the track.
