SELECT final.subreddit_a, final.subreddit_b 
FROM 
    (SELECT a.subreddit AS subreddit_a, a.authors AS authors_in_sub_a, b.subreddit AS subreddit_b, b.authors AS authors_in_sub_b, floor(100 * count(*)/((a.authors + b.authors)/2)) AS percent 
    FROM
        (SELECT t1.author AS author, t1.subreddit AS subreddit, t2.authors AS authors
        FROM 
            (SELECT DISTINCT author, subreddit 
            FROM %s 
            WHERE %s author!='[deleted]') AS t1
            JOIN 
                (SELECT * 
                FROM 
                    (SELECT subreddit, count(distinct author) AS authors 
                    FROM %s 
                    WHERE %s author!='[deleted]' GROUP BY subreddit) AS t5 
                    WHERE authors >= %s) AS t2 
                    WHERE t1.subreddit=t2.subreddit GROUP BY subreddit, author) AS a
                    JOIN 
                        (SELECT t3.author AS author, t3.subreddit AS subreddit, t4.authors AS authors
                        FROM 
                            (SELECT DISTINCT author, subreddit 
                            FROM %s 
                            WHERE %s author!='[deleted]') AS t3
                            JOIN 
                                (SELECT * 
                                FROM 
                                    (SELECT subreddit, count(distinct author) AS authors 
                                    FROM %s 
                                    WHERE %s author!='[deleted]' GROUP BY subreddit) AS t6 
                                    WHERE authors >= %s) AS t4 
                                    WHERE t3.subreddit=t4.subreddit GROUP BY subreddit, author) AS b 
                                    ON a.author=b.author 
                                    WHERE a.subreddit!=b.subreddit GROUP BY 1,3) AS final
                                    WHERE final.percent > %s;