/*testing stuff that didn't work out*/

DROP VIEW IF EXISTS test;

CREATE VIEW test AS
SELECT b.subreddit AS subreddit_a, a.subreddit AS subreddit_b
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



DROP TABLE IF EXISTS subreddit_comb;
CREATE TABLE subreddit_comb(
i INT);

DROP PROCEDURE IF EXISTS make_subreddit_comb;
delimiter //
CREATE PROCEDURE make_subreddit_comb()
BEGIN
SET @i = 0;
REPEAT
	SET @i = @i + 1;
    INSERT INTO subreddit_comb(i) VALUES(@i);
    UNTIL @i = (SELECT COUNT(subreddit_a) FROM test) END REPEAT;
    END
//
delimiter ;

CALL make_subreddit_comb();

SELECT subreddit_comb.i, test.subreddit_a, test.subreddit_b
FROM test 
JOIN subreddit_comb
GROUP BY i;
