/* this query returned stuff locally from the server but not with the app*/
SELECT final.sub_a, final.sub_b FROM 
(SELECT a.subreddit AS sub_a, a.authors, b.subreddit AS sub_b, b.authors, FLOOR(100*COUNT(*)/((a.authors + b.authors)/2))
 AS percent FROM (
 SELECT t1.author, t1.subreddit, t2.authors FROM 
 (SELECT DISTINCT author, subreddit FROM rawdata WHERE author!='[deleted]') AS t1 
  INNER JOIN 
  (SELECT * FROM 
  	(SELECT subreddit, count(distinct author) AS authors FROM rawdata WHERE author!='[deleted]' GROUP BY subreddit) AS t5
  	WHERE authors >= 5) AS t2 
  ON t1.subreddit=t2.subreddit GROUP BY t1.subreddit, t2.authors, t1.author) AS a 
  INNER JOIN (
  SELECT t3.author, t3.subreddit, t4.authors FROM (SELECT DISTINCT author, subreddit FROM rawdata WHERE author != '[deleted]') AS t3 
  INNER JOIN (
  SELECT * FROM (
  SELECT subreddit, count(distinct author) AS authors FROM rawdata WHERE author!='[deleted]' GROUP BY subreddit) AS t6 WHERE authors >= 5) AS t4 
  ON t3.subreddit=t4.subreddit GROUP BY t3.subreddit, t3.author, t4.authors ) AS b 
  ON a.author=b.author 
  WHERE a.subreddit!=b.subreddit 
  GROUP BY a.subreddit, a.authors, b.subreddit, b.authors) AS final 
WHERE final.percent > 10;