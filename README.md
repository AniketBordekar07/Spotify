# Spotify 

[Click Here to get Dataset](https://www.kaggle.com/datasets/sanjanchaudhari/spotify-dataset)

![Spotify Logo](https://github.com/AniketBordekar07/Spotify/blob/main/spotify.jpg)

## Overview
This project involves analyzing a Spotify dataset with various attributes about tracks, albums, and artists using **SQL**. It covers an end-to-end process of normalizing a denormalized dataset, performing SQL queries of varying complexity (easy, medium, and advanced), and optimizing query performance. The primary goals of the project are to practice advanced SQL skills and generate valuable insights from the dataset.
language = PLpgSQL
```sql
-- create table
DROP TABLE IF EXISTS spotify;
CREATE TABLE spotify (
    artist VARCHAR(255),
    track VARCHAR(255),
    album VARCHAR(255),
    album_type VARCHAR(50),
    danceability FLOAT,
    energy FLOAT,
    loudness FLOAT,
    speechiness FLOAT,
    acousticness FLOAT,
    instrumentalness FLOAT,
    liveness FLOAT,
    valence FLOAT,
    tempo FLOAT,
    duration_min FLOAT,
    title VARCHAR(255),
    channel VARCHAR(255),
    views FLOAT,
    likes BIGINT,
    comments BIGINT,
    licensed BOOLEAN,
    official_video BOOLEAN,
    stream BIGINT,
    energy_liveness FLOAT,
    most_played_on VARCHAR(50)
);
```


### Data Exploration
Before diving into SQL, it’s important to understand the dataset thoroughly. The dataset contains attributes such as:
- `Artist`: The performer of the track.
- `Track`: The name of the song.
- `Album`: The album to which the track belongs.
- `Album_type`: The type of album (e.g., single or album).
- Various metrics such as `danceability`, `energy`, `loudness`, `tempo`, and more.

---

## Questions


1. Retrieve the names of all tracks that have more than 1 billion streams.
```sql
select * from spotify
where stream > 1000000000;
```
2. List all albums along with their respective artists.
```sql
select distinct  album ,artist from spotify;
```
3. Get the total number of comments for tracks where `licensed = TRUE`.
```sql
select sum(comments) as total_comments
from spotify
where licensed = 'true';
```
4. Find all tracks that belong to the album type `single`.
```sql
select track from spotify
where album_type = 'single';
```
5. Count the total number of tracks by each artist.
```sql
select artist, count(track) as total_no_track
from spotify
group by 1 
order by 2 desc;
```
6. Calculate the average danceability of tracks in each album.
```sql
select  album, Avg(danceability)
from spotify 
group by 1
order by 2 desc
```
7. Find the top 5 tracks with the highest energy values.
```sql
SELECT track, artist, energy
FROM spotify
ORDER BY energy DESC
LIMIT 5;
```
8. List all tracks along with their views and likes where `official_video = TRUE`.
```sql
select 
	track, 
	sum(views) as total_views ,
	sum(likes) as total_likes
from spotify
where official_video = 'true' 
group by 1
order by 2 desc;
```
9. For each album, calculate the total views of all associated tracks.
```sql
select 
	album ,
	track, 
	sum(views) as total_view 
from  spotify 
group by 1,2
order by 3 desc;
```
10. Retrieve the track names that have been streamed on Spotify more than YouTube.
```sql
select * from (
select 
	track,
	coalesce(sum(case when most_played_on = 'Youtube' then stream end),0) as streamed_on_youtube,
    coalesce(sum(case when most_played_on = 'Spotify' then stream end),0) as streamed_on_spotify
from spotify
group by 1
) as T1
where streamed_on_spotify > streamed_on_youtube
	 and streamed_on_youtube <> 0
;
```
11. Find the top 3 most-viewed tracks for each artist using window functions.
```sql
with  artist_ranking 
as 
(
select 
	artist, 
	track,
	sum(views) as total_views,
	dense_rank() over(partition by artist order by sum(views)desc) as rank
from spotify 
group by 1,2
order by 1,3 DESC
)
select * from artist_ranking
where rank<= 3;
```
12. Write a query to find tracks where the liveness score is above the average.
```sql
select 
	track,
	liveness
from spotify
where liveness > (select avg(liveness) from spotify); 
```
13. **Use a `WITH` clause to calculate the difference between the highest and lowest energy
values for tracks in each album.**
```sql
with difference_energy
as
(
select  
	album,
	-- track,
	max(energy) as highest_energy,
	min(energy) as lowest_energy
from spotify
group by 1
)
select 
	album,
	highest_energy -lowest_energy as diff_in_energy
from difference_energy
order by 2 desc;
```
14. Find tracks where the energy-to-liveness ratio is greater than 1.2.
```sql
SELECT 
	artist, 
	track, 
	energy,
	liveness,
    (energy / liveness) AS energy_to_liveness_ratio
FROM spotify
WHERE (energy / liveness) > 1.2
ORDER BY 5 DESC;
```
15. Calculate the cumulative sum of likes for tracks ordered by the number of views, using window functions.
```sql
SELECT 
    artist,
    track,
    views,
    likes,
    SUM(likes) OVER (ORDER BY views) AS cumulative_likes
FROM spotify
ORDER BY 5 DESC ;
```

