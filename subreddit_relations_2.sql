SELECT b.subreddit AS subreddit_a, a.subreddit AS subreddit_b, b.author, a.author, b.authors, FLOOR(100*COUNT(*)/b.authors)
FROM
((SELECT DISTINCT (author), subreddit FROM rawdata ORDER BY subreddit) AS a)
JOIN 
((SELECT t1.author AS author, t1.subreddit AS subreddit, t2.authors AS authors
FROM ((SELECT DISTINCT author, subreddit FROM rawdata ) AS t1)
JOIN (SELECT authors FROM authors_in_subreddits) AS t2
GROUP BY subreddit
 ) AS b)
ON a.author=b.author
WHERE a.subreddit!=b.subreddit 
GROUP BY 1,2;