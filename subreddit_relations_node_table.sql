/*testing stuff that didn't work out*/


/* subreddit_combinations has all the combinations between subreddits*/

DROP TABLE IF EXISTS subreddit_answer;

CREATE TABLE subreddit_answer(
i INT,
subreddit_a VARCHAR(30),
subreddit_b VARCHAR(30)
);

DROP PROCEDURE IF EXISTS subreddits;
delimiter //
CREATE PROCEDURE subreddits()
BEGIN
SET @x = 0;
REPEAT
	SET @x = @x + 1;
    /*checks if the amount of same commenters in subreddit_a and b are equal, counts them and if the number is above 1 sets bit to 1*/
    /*row are inserted to subreddit_answer table which is selected to display the results*/
    INSERT INTO subreddit_answer SELECT IF(COUNT(*)>1, FLOOR(COUNT(*)* 1/COUNT(*)), 0), table_1.subreddit, table_2.subreddit
	FROM
	((SELECT DISTINCT author, subreddit
	FROM rawdata
	WHERE rawdata.subreddit = (SELECT subreddit_a FROM subreddit_combinations WHERE i = @x)) AS table_1),
	
	((SELECT DISTINCT author, subreddit
	FROM rawdata
	WHERE rawdata.subreddit = (SELECT subreddit_b FROM subreddit_combinations WHERE i = @x)) AS table_2)
	
	WHERE table_1.author = table_2.author;
    UNTIL @x = 15 END REPEAT;
    END
//
delimiter ;
CALL subreddits();
SELECT * FROM subreddit_answer;
DROP TABLE IF EXISTS subreddit_answer;