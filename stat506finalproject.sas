/*	Spring 2024 STAT 506 - Final Project 				*/
/* 	Professor Tim Keaton, ebittin@purdue.edu			*/
LIBNAME PROJ 'G:\My Drive\School\Purdue\Spring 2024\STAT 506\Final Project'; /* 2a LIBNAME statement */
%LET s=song; /* 7d Use macro variables in at least two of the above (TITLE or FOOTNOTE) */
%LET capL=Love; /* 7d Use macro variables in at least two of the above (TITLE or FOOTNOTE) */
%Let vol=Volume; /* 7d Use macro variables in at least two of the above (TITLE or FOOTNOTE) */

/* 22) Create and use at least 2 user-defined formats using VALUE statements */ 
PROC FORMAT LIBRARY=PROJ.myFmts; /* 22c) Save these as permanent formats */
	VALUE key_fmt /* 22b) Numeric column */
		0='C'
		1='C_s or D_f'
		2='D'
		3='D_s or E_f'
		4='E'
		5='F'
		6='F_s or G_f'
		7='G'
		8='G_s or A_f'
		9='A'
		10='A_s or B_f'
		11='B'
		other='No key detected';
	VALUE mode_fmt /* 22b) Numeric column */
		0='Minor'
		1='Major';
	VALUE vol_fmt /* 22b) Numeric column */
		low--60='Very Quiet (shh)'
		-60<--40='Quiet'
		-40<--20='Average (ok)'
		-20<--10='Loud'
		-10<-0='Very Loud (agh)';
	VALUE $dayz /* 22a) Character column */
		'Monday'='MoNdAy'
		'Tuesday'='TuEsDaY'
		'Wednesday'='WeDnEsDaY'
		'Thursday'='ThUrSdAy'
		'Friday'='FrIdAy'
		'Saturday'='SaTuRdAy'
		'Sunday'='SuNdAy';
RUN;
OPTIONS FMTSEARCH=(PROJ.myFmts WORK.Formats);

/* Songs from "Everyone Knows the Words To" Playlist (345 obs) */
PROC IMPORT DATAFILE="G:\My Drive\Purdue\Spring 2024\STAT 506\Final Project\long_playlist.csv"
	DBMS=CSV OUT=songs_noedit REPLACE; /* 1a) PROC IMPORT step */
	GUESSINGROWS=MAX;
RUN;
PROC CONTENTS DATA=songs_noedit VARNUM; RUN; /* 1b) PROC CONTENTS for the imported table, using the VARNUM option */
PROC CONTENTS DATA=PROJ._ALL_ NODS; RUN; /* 2b) PROC CONTENTS for the library itself */

DATA PROJ.songs;
	SET songs_noedit(RENAME=(track_name=&s)); /* 5a) SET statement*/ 
	LENGTH is_upbeat $ 3; /* 5e) LENGTH statement */
	IF LENGTH(release_date)=4 THEN rdate=MDY(1,1,INPUT(release_date,4.)); /* 5f) Creation of column with assignment statement, 18b) LENGTH function, 17b) MDY function, 21a) Character to numeric conversion using INPUT function */
	ELSE rdate=INPUT(release_date,ANYDTDTE10.); /* 5f) Creation of column with assignment statement, 21a) Character to numeric conversion using INPUT function */
	rdate=DHMS(rdate,0,0,0); /* 5f) Creation of column with assignment statement */
	r_valence = ROUND(valence,0.01); /* 20a) ROUND function */
	mean_dur = MEAN(duration_ms); /* 20b) MEAN function */
	min_tempo = MIN(tempo); /* 20b) MIN function */
	max_tempo = MAX(tempo); /* 20b) MAX function */
	IF r_valence < 0.5 THEN is_upbeat='No'; /* 6a) IF THEN statement */
	ELSE is_upbeat='Yes'; /* 6a IF THEN statement */
	duration_min=CEIL(duration_ms/60000); /* 5f) Creation of column with assignment statement, 20a) CEIL function */
	duration_sec=INT((duration_ms-duration_min*60000)/1000); /* 5f) Creation of column with assignment statement, 20a) INT function */
	ryear=PUT(DATEPART(rdate),YEAR4.); /* 21b) Numeric to Character conversion using PUT function */
	rmonth=PUT(DATEPART(rdate),MONTH.); /* 21b) Numeric to Character conversion using PUT function */
	rday=PUT(DATEPART(rdate),DAY2.); /* 21b) Numeric to Character conversion using PUT function */
	rwkday=PUT(DATEPART(rdate),DOWNAME.); /* 21b) Numeric to Character conversion using PUT function */
	a=STRIP(artist); /* 19e) STRIP function */
	IF FIND(a,'é')>0 THEN a=TRANWRD(artist,"é","�"); /* 6b) IF THEN; ELSE IF THEN statement, 19c) TRANWRD function */
	ELSE IF FIND(a,'å')>0 THEN a=TRANWRD(artist,"å","�"); /* 6b) IF THEN; ELSE IF THEN statement, 19c) TRANWRD function */
	ELSE IF FIND(a,'*')>0 THEN a=COMPRESS(artist,'*'); /* 6b) IF THEN; ELSE IF THEN statement, 19d) COMPRESS function */
	ELSE IF FIND(a,'Ø')>0 THEN a=TRANWRD(artist,"Ø","�"); /* 6b) IF THEN; ELSE IF THEN statement, 19c) TRANWRD function */
	ELSE IF FIND(a,'–')>0 THEN a=TRANWRD(artist,'–','-'); /* 6b) IF THEN; ELSE IF THEN statement, 19c) TRANWRD function */
	FORMAT duration_min duration_sec 8. rdate datetime9. rwkday $dayz.; /* 5d) FORMAT statement */
	DROP artist release_date time_signature valence tempo VAR1; /* 5c) DROP statement */
RUN;
PROC CONTENTS DATA=PROJ.songs; RUN; /* 2c) PROC CONTENTS for a single table in the library */

/* Songs from "throwbaccc" Playlist (330 obs) */
PROC IMPORT DATAFILE="G:\My Drive\Purdue\Spring 2024\STAT 506\Final Project\throbaccc_playlist.csv"
	DBMS=CSV OUT=tsongs_noedit REPLACE;
	GUESSINGROWS=MAX;
RUN;
DATA PROJ.tsongs;
	SET tsongs_noedit;
	IF LENGTH(release_date)=4 THEN rdate=MDY(1,1,INPUT(release_date,4.)); /* 5f) Creation of column with assignment statement, 18b) LENGTH function, 17b) MDY function, 21a) Character to numeric conversion using INPUT function */
	ELSE rdate=INPUT(release_date,ANYDTDTE10.); /* 5f) Creation of column with assignment statement, 21a) Character to numeric conversion using INPUT function */
	rdate=DHMS(rdate,0,0,0); /* 5f) Creation of column with assignment statement */
	duration_min=INT(duration_ms/60000); /* 20a) INT function */ 
	duration_sec=FLOOR((duration_ms-duration_min*60000)/1000); /* 20a) FLOOR function */
	ryear=PUT(DATEPART(rdate),YEAR4.); /* 21b) Numeric to Character conversion using PUT function */
	rmonth=PUT(DATEPART(rdate),MONTH.); /* 21b) Numeric to Character conversion using PUT function */
	rday=PUT(DATEPART(rdate),DAY2.); /* 21b) Numeric to Character conversion using PUT function */
	rwkday=PUT(DATEPART(rdate),DOWNAME.); /* 21b) Numeric to Character conversion using PUT function */
	a=STRIP(artist); /* 19e) STRIP function */
	IF FIND(a,'é')>0 THEN a=TRANWRD(artist,"é","�"); /* 6b) IF THEN; ELSE IF THEN statement, 19c) TRANWRD function */
	ELSE IF FIND(a,'å')>0 THEN a=TRANWRD(artist,"å","�"); /* 6b) IF THEN; ELSE IF THEN statement, 19c) TRANWRD function */
	ELSE IF FIND(a,'*')>0 THEN a=COMPRESS(artist,'*'); /* 6b) IF THEN; ELSE IF THEN statement, 19d) COMPRESS function */
	ELSE IF FIND(a,'Ø')>0 THEN a=TRANWRD(artist,"Ø","�"); /* 6b) IF THEN; ELSE IF THEN statement, 19c) TRANWRD function */
	ELSE IF FIND(a,'–')>0 THEN a=TRANWRD(artist,'–','-'); /* 6b) IF THEN; ELSE IF THEN statement, 19c) TRANWRD function */
	FORMAT duration_min duration_sec 8. rdate datetime9. rwkday $dayz.; /* 5d) FORMAT statement */
	DROP release_date time_signature tempo VAR1; /* 5c) DROP statement */
RUN;
PROC CONTENTS DATA=PROJ.tsongs; RUN; /* 21d) PROC CONTENTS showing the original/new column types */
PROC FREQ DATA=PROJ.tsongs ORDER=FREQ; /* 22d) PROC FREQ applying the formats you created */
	FORMAT key key_fmt.;
	tables key;
RUN;

/* Songs from Kaggle "Top Spotify songs from 2010-2019 - BY YEAR" (603 obs) */
PROC IMPORT DATAFILE="G:\My Drive\Purdue\Spring 2024\STAT 506\Final Project\top10s.csv"
	DBMS=CSV OUT=topsongs_noedit REPLACE;
	GUESSINGROWS=MAX;
RUN;
DATA PROJ.topsongs;
	SET topsongs_noedit(RENAME=(title=&s year=ryear bpm=tempo nrgy=energy dnce=danceability dB=loudness
								live=liveness val=valence dur=duration_ms spch=speechiness));
	a=STRIP(artist); /* 19e */
	IF FIND(a,'é')>0 THEN a=TRANWRD(artist,"é","�"); /* 6b) IF THEN; ELSE IF THEN statement, 19c) TRANWRD function */
	ELSE IF FIND(a,'å')>0 THEN a=TRANWRD(artist,"å","�"); /* 6b) IF THEN; ELSE IF THEN statement, 19c) TRANWRD function */
	ELSE IF FIND(a,'*')>0 THEN a=COMPRESS(artist,'*'); /* 6b) IF THEN; ELSE IF THEN statement, 19d) COMPRESS function */
	ELSE IF FIND(a,'Ø')>0 THEN a=TRANWRD(artist,"Ø","�"); /* 6b) IF THEN; ELSE IF THEN statement, 19c) TRANWRD function */
	ELSE IF FIND(a,'–')>0 THEN a=TRANWRD(artist,'–','-'); /* 6b) IF THEN; ELSE IF THEN statement, 19c) TRANWRD function */
	DROP VAR1 acous; /* 5c) DROP statement */
RUN;
PROC FREQ DATA=PROJ.topsongs ORDER=FREQ; /* 22d) PROC FREQ applying the formats you created */
	tables top_genre / OUT=tg;
RUN;
/* (675 obs) */ 
DATA cat_songs;
	SET PROJ.songs(DROP=is_upbeat) PROJ.tsongs(RENAME=(track_name=&s)); /* 24a) Concatenate two or more tables using RENAME= option */
	LENGTH album $ 100;
	LENGTH a $ 100;
	LENGTH song $ 30;
	WHERE DATEPART(rdate) BETWEEN '01JAN2010'd AND '31DEC2019'd; /* 5b) WHERE statement in DATA step */
RUN;
/* Must sort before ONE-TO-ONE merge */
PROC SORT DATA=PROJ.songs(DROP=ryear) OUT=songs_sorted; /* (345) */
	BY a song;
RUN;
/* Must sort before ONE-TO-ONE merge */
PROC SORT DATA=PROJ.topsongs(DROP=ryear) OUT=topsongs_sorted; /* (330) */
	BY a song; 
RUN;
/* Simple Merge ONE-TO-ONE */
DATA simple_merge; /* 24b) Simple merge (ONE to ONE) */
	MERGE songs_sorted topsongs_sorted; 
	BY a song;
RUN;
DATA missing;
    SET simple_merge END=last;
    RETAIN m_albums t_albums m_key t_key 0;
    m_loudness + NMISS(loudness); /* 20c) NMISS function */
    t_loudness + N(loudness); /* 20c) N function */
	m_mode + NMISS(mode); /* 20c) NMISS function */
    t_mode + N(mode); /* 20c) N function */
    m_key + NMISS(key); /* 20c) NMISS function */
    t_key + N(key); /* 20c) N function */
    if last; 
    keep m_loudness t_loudness m_key t_key m_mode t_mode;
RUN;
/* Identify duplicate rows (songs with same title) */
PROC FREQ DATA=PROJ.songs NOPRINT ORDER=FREQ; /* 4a) PROC FREQ to identify duplicate rows or column values */
	TABLES &s / OUT=dups;
RUN;
/* Remove unwanted duplicate rows (songs with same title) */
PROC SORT DATA=PROJ.songs OUT=songs_nodups DUPOUT=song_dups NODUPKEY; /* 4b) PROC SORT to remove unwanted duplicate rows */
	BY &s; 
RUN;

DATA hit_songs;
	SET simple_merge;
	IF pop >= 70 AND energy >= 70 THEN DO; /* 6c) IF THEN DO; END; statement */
		hit_song = 1; 
		IF valence >= 50 THEN upbeat_song = 1; /* 6a) IF THEN statement */
		ELSE upbeat_song = 0; /* 6a) IF THEN statement */
	END; /* 6c) IF THEN DO; END; statement */
	ELSE DO; /* 6c) IF THEN DO; END; statement */
		hit_song = 0; 
		IF valence >= 50 THEN upbeat_song = 1; /* 6a) IF THEN statement */
		ELSE upbeat_song = 0; /* 6a) IF THEN statement */
	END; /* 6c) IF THEN DO; END; statement */
RUN;

TITLE "Top 10 Songs with the Key Word '&capL'"; /* 7a) TITLE statement, 7d) MACRO variable in TITLE statement */ 
TITLE2 "Featuring Artist, Song, Release Year, Key, Mode, and &vol"; /* 7b) TITLE2 statement, 7d) MACRO variable in TITLE2 statement */ 
FOOTNOTE "&vol is measured in decibels (dB) where anything -10 to 0 is considered VERY LOUD!"; /* 7c) FOOTNOTE statement, 7d) MACRO variable in FOOTNOTE statement */ 
PROC PRINT DATA=simple_merge(OBS=10) LABEL; /* 3a) PROC PRINT step, 3c) OBS= option */
	VAR a &s rwkday key mode loudness; /* 3b) VAR statement */ 
	LABEL loudness="&vol"; /* 7d) MACRO variable in LABEL */
	WHERE song LIKE "%Love%" OR song LIKE "%love%"; /* 3d) Use either IN or LIKE in a WHERE statement */
	FORMAT energy percent10. key key_fmt. loudness volume_fmt. mode mode_fmt. rwkday $dayz.; /* 3e) Apply at least two different formats */
RUN;
TITLE; /* 7f) After displaying the above titles and footnote in the PROC PRINT, clear the titles and footnote */
FOOTNOTE; /* 7f) After displaying the above titles and footnote in the PROC PRINT, clear the titles and footnote */

TITLE "Frequency Report for Number of Minutes Per Song (Long Playlist)";
PROC FREQ DATA=PROJ.songs ORDER=FREQ; /* 8a) Save a one-way frequency report as a SAS table, using the ORDER option */
	TABLES duration_min / OUT=out_dur_min; /* 8a) Save a one-way frequency report as a SAS table, using the ORDER option */
RUN;
TITLE;

TITLE "Hit vs Upbeat Songs";
FOOTNOTE "0=No, 1=Yes";
PROC FREQ DATA=hit_songs ORDER=FREQ; /* 8b) Create a two-way frequency report for two columns. Suppress some of the statistics that would be displayed by default */
	TABLES hit_song*upbeat_song / NOCOL NOROW NOCUM OUT=hit_upbeat; /* 8b) Create a two-way frequency report for two columns. Suppress some of the statistics that would be displayed by default */
RUN; 
TITLE; FOOTNOTE;

/* 9) Create a summary statistics report using PROC MEANS */ 
TITLE "Summary Statistics of Danceability, Energy, and Valence by Artist";
PROC MEANS DATA=simple_merge MEAN MIN Q1 MEDIAN Q3 MAX RANGE MAXDEC=2; /* 9a) Produce some non-default summary statistics */
	VAR danceability energy valence; /* 9b) VAR statement */
	CLASS a; /* 9c) CLASS statement */
	WAYS 1; /* 9c) WAYS statement */ 
	OUTPUT OUT=summary_stats; /* 9d) OUTPUT results to a new table */
RUN;
TITLE;

PROC SORT DATA=PROJ.tsongs OUT=sorted_a; /* 15d) PROC SORT */
	BY a; 
RUN;

DATA dur_total;
	SET sorted_a;
	BY a;
	min_len = 0;
	RETAIN total_dur_ms total_dur_min total_dur_sec; /* 15a) Use of RETAIN */
	IF FIRST.a=1 THEN total_dur_ms=0; /* 15c) Use of FIRST. and LAST. in IF conditionals */
	total_dur_ms+duration_ms; /* 15b) SUM statement */
	IF LAST.a=1 THEN DO; /* 15c) Use of FIRST. and LAST. in IF conditionals */
		total_dur_min = INT(total_dur_ms / 60000);
        total_dur_sec = INT((total_dur_ms - (total_dur_min * 60000)) / 1000);
		OUTPUT;
	END;
	KEEP a total_dur_ms total_dur_min total_dur_sec;
RUN;

DATA dur_total_updated; 
	SET dur_total;
	LENGTH t $ 15 first_name $ 20 last_name $ 20;
	first_name=a; last_name="-";
	CALL SCAN(a,2,pos,len,' '); /* 16a) SCAN call function */
	IF pos>0 AND COUNTW(a)=2 THEN DO;
		first_name = SCAN(a, 1, ' ');
        last_name = SCAN(a, -1, ' ');
	END;
	CALL CATX(' ',t,total_dur_min,'min,',total_dur_sec,'sec'); /* 16b) CATX call function */
	IF total_dur_min>9 THEN SUBSTR(t,4,3)="MIN"; /* 19b) SUBSTR function on left side of assignment statement */
	KEEP a first_name last_name t;
RUN;

TITLE "Total Duration of Songs by Artist";
PROC PRINT DATA=dur_total_updated; RUN;
TITLE;

DATA sentence;
	SET PROJ.songs;
	LENGTH s1 $ 500 s2 $ 500 s3 $ 500;
	d_since = INTCK('DAY',DATEPART(rdate),TODAY(),'c'); /* 17a) TODAY function, 17d) INTCK function */
	mo_since = INTCK('MONTH',DATEPART(rdate),TODAY(),'c'); //* 17a) TODAY function, 17d) INTCK function */
	yr_since = INTCK('YEAR',DATEPART(rdate),TODAY(),'c'); /* 17a) TODAY function, 17d) INTCK function */
	days_42 = PUT(INTNX('WEEK',DATEPART(rdate),42,'s'),DATE9.); /* 17e) INTNX function */
	readable_dt = CATS(PUT(DATEPART(rdate),DOWNAME.),", ",PUT(DATEPART(rdate),DATE9.));
	s1 = CAT(a,"'s album, ",album,", debuted the track, ",song,", on ",readable_dt, 
					" with a time of ",PUT(duration_min,2.),":",PUT(duration_sec,Z2.)); /* 18f) CAT function */
	s2 = CAT(song," was released ",d_since," days, ",mo_since," months, and ",yr_since," years ago"); /* 18f) CAT function */
	s3 = CAT("If a baby was conceived on the release date of ",song,", the artist's baby would be born on ",days_42); /* 18f) CAT function */
	KEEP s1 s2 s3;
RUN;

DATA char_data;
	SET sentence;
	a=SCAN(s1,1,"'"); /* 18c) SCAN function */
	s_start = SUBSTR(s1,FIND(s1,'track, '));
	s = SCAN(s_start,2,',');
	IF COUNTW(a)=2 THEN DO;
		f_init = CHAR(a,1); /* 18e) CHAR function */
		s_pos = FIND(a,' ',1)+1; /* 19a) FIND function */
		s_init = CHAR(a,s_pos); /* 18e) CHAR function */
		i=CAT(f_init,'.',s_init,'.');
	END;
	ELSE DO;
		i=LOWCASE(a); /* 18d) LOWCASE function */
	END;
	KEEP a i s;
RUN;

