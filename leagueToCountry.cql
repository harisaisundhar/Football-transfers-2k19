CALL apoc.load.json("https://raw.githubusercontent.com/harisaisundhar/Football-transfers-2k19/master/data/leagues.json")
YIELD value
MATCH (l:League {id: value.league})
MERGE (c:Country {name: value.country})
MERGE (l)-[:IN_COUNTRY]->(c);