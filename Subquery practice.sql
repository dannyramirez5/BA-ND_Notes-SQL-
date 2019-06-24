SELECT t3.id, t3.name, t3.channel, t3.ct

	/* Here I retrieve the count of instances of each channel for each name/id */
  FROM (SELECT a.id, a.name, we.channel, COUNT(*) ct
	FROM accounts a
	JOIN web_events we
	ON a.id = we.account_id
	GROUP BY a.id, a.name, we.channel) t3
	/*This JOIN retrieves a list of MAX counts for each if which I will then match up to the original list with all the counts and only pick out the entries that match the id and MAX count.*/
  JOIN (SELECT t1.id, t1.name, MAX(ct) max_chan
	FROM (SELECT a.id, a.name, we.channel, COUNT(*) ct
		FROM accounts a
		JOIN web_events we
		ON a.id = we.account_id
		GROUP BY a.id, a.name, we.channel) t1
	GROUP BY t1.id, t1.name) t2
ON t2.id = t3.id AND t2.max_chan = t3.ct
ORDER BY t3.id, t3.ct;