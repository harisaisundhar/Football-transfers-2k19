Queries:-

1)Club count of every league

MATCH (l:League)-[IN_LEAGUE]-(c:Club) RETURN l.name as Leagues,count(c) as Number_Of_Clubs

2)No of Players who actually transferred

MATCH (n:Transfer) RETURN count(n) as No_Players_Transferred

3)Player count of every league

MATCH (l:League)-[IN_LEAGUE]-(c:Club)-[:TO_CLUB]-(t:Transfer)-[:OF_PLAYER]-(p:Player) return l.name as Leagues,count(c.name) as NO_PLAYERS

4)List the players name along with their name in the LaLiga2 League

MATCH (l:League)-[IN_LEAGUE]-(c:Club)-[:TO_CLUB]-(t:Transfer)-[:OF_PLAYER]-(p:Player) WHERE l.name="LaLiga2" return p.name as Players,c.name as THEIR_CLUB

5)Top 10 transfers

MATCH (t:Transfer)-[:OF_PLAYER]->(player), (from)<-[:FROM_CLUB]-(t)-[:TO_CLUB]->(to)
RETURN player.name, from.name, to.name, apoc.number.format(t.value) AS price
ORDER BY t.value DESC LIMIT 10

6)Money Handling

MATCH (club:Club) WITH club,
apoc.coll.sumLongs(
[(club)<-[:FROM_CLUB]-(t) | t.value]) AS moneyIn,
apoc.coll.sumLongs(
[(club)<-[:TO_CLUB]-(t) | t.value]) AS moneyOut
RETURN club.name, apoc.number.format(moneyIn) AS in, apoc.number.format(moneyOut) AS out
ORDER BY moneyIn + moneyOut DESC LIMIT 10

7)Money out

MATCH (club:Club)-[*2]->(country:Country) WITH club, country,
apoc.coll.sumLongs(
[(club)<-[:TO_CLUB]-(t) | t.value]) AS moneyOut
RETURN club.name, country.name, apoc.number.format(moneyOut) AS out ORDER BY moneyOut DESC
LIMIT 10

8)Money by country

MATCH (t:Transfer)-[:OF_PLAYER]->(player), (fromCountry)<-[:IN_COUNTRY]-(fromLeague), (fromLeague)<-[:IN_LEAGUE]-(from)<-[:FROM_CLUB]-(t), (t)-[:TO_CLUB]->(to)-[:IN_LEAGUE]->(toLeague), (toLeague)-[:IN_COUNTRY]->(toCountry)
WITH *
ORDER BY fromLeague, toLeague, t.value DESC
WITH fromLeague, toLeague, sum(t.value) AS totalFees,
fromCountry, toCountry,
collect({player: player.name, fee: t.value}) AS transfers WHERE fromCountry <> toCountry
RETURN fromCountry.name, toCountry.name,
apoc.number.format(totalFees) AS total, transfers[0].player AS player, apoc.number.format(transfers[0].fee) AS fee, size(transfers) AS numberOfTransfers
ORDER By totalFees DESC LIMIT 10