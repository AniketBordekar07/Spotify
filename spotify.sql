-- spotify 

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
	


select * from spotify
limit 100


-- EDA

select count(*) from spotify;
-- distinct artist 
select count (distinct artist) from spotify;

-- distint album 
select count (distinct album) from spotify;

select distinct album_type  from spotify;

-- duration 
select max(duration_min) from spotify;

select min(duration_min) from spotify;

select * from spotify 
where duration_min = 0;

-- deleted zero min album
delete from spotify
where duration_min = 0;

select distinct channel from spotify 
select count(distinct channel)from spotify 


select distinct most_played_on from spotify 


-- Data analysis question 

--  1) Retrieve the names of all tracks that have more than 1 billion streams.
select * from spotify
where stream > 1000000000

-- 2)List all albums along with their respective artists.
select distinct  album ,artist from spotify

-- 3)Get the total number of comments for tracks where licensed = TRUE.
select sum(comments) as total_comments
from spotify
where licensed = 'true'

-- 4)Find all tracks that belong to the album type single.
select distinct album_type from spotify

select track from spotify
where album_type = 'single'


select track from spotify
where album_type ILIKE 'single'

-- 5)Count the total number of tracks by each artist.

select artist, count(track) as total_no_track
from spotify
group by 1 
order by 2 desc


-- 6)Calculate the average danceability of tracks in each album.


select  album, Avg(danceability)
from spotify 
group by 1
order by 2 desc


-- Find the top 5 tracks with the highest energy values.
select  track,max(energy)
from spotify
group by 1 
order by 2 desc
limit 5

SELECT track, artist, energy
FROM spotify
ORDER BY energy DESC
LIMIT 5;

-- List all tracks along with their views and likes where official_video = TRUE.
select 
	track, 
	sum(views) as total_views ,
	sum(likes) as total_likes
from spotify
where official_video = 'true' 
group by 1
order by 2 desc

-- For each album, calculate the total views of all associated tracks.
select 
	album ,
	track, 
	sum(views) as total_view 
from  spotify 
group by 1,2
order by 3 desc

 -- Retrieve the track names that have been streamed on Spotify more than YouTube.
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
























