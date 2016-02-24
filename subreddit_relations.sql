/* includes additional information about the query*/

SELECT final.subreddit_a, final.subreddit_b FROM (
SELECT a.subreddit AS subreddit_a, a.authors AS authors_in_sub_a, b.subreddit AS subreddit_b, b.authors AS authors_in_sub_b , FLOOR(100*COUNT(*)/((a.authors + b.authors)/2)) AS percent, FLOOR(100*COUNT(*)/b.authors) AS b_percent, COUNT(*)
FROM
((SELECT t1.author AS author, t1.subreddit AS subreddit, t2.authors AS authors
FROM (SELECT DISTINCT author, subreddit FROM rawdata WHERE author!='[deleted]') AS t1 /* deleted authors are not included*/
JOIN (SELECT subreddit, count(distinct author) AS authors FROM rawdata WHERE author!='[deleted]' GROUP BY subreddit) AS t2
WHERE t1.subreddit=t2.subreddit
GROUP BY subreddit, author) AS a)
JOIN 
((SELECT t3.author AS author, t3.subreddit AS subreddit, t4.authors AS authors
FROM (SELECT DISTINCT author, subreddit FROM rawdata WHERE author!='[deleted]') AS t3 /* deleted authors are not included*/
JOIN (SELECT subreddit, count(distinct author) AS authors FROM rawdata WHERE author!='[deleted]' GROUP BY subreddit) AS t4
WHERE t3.subreddit=t4.subreddit
GROUP BY subreddit, author
 ) AS b /*b is a table which includes every distinct author in every subreddits and also the amount of distinct authors in every subreddit*/)
ON a.author=b.author
WHERE a.subreddit!=b.subreddit 
GROUP BY 1,3) AS final
WHERE final.percent > 5;

