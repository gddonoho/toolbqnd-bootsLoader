select c.concertid, c.concertdate, rec.mp3s, setlist.songs
from concert c,
(select r.concertid, r.linkurl, count(m.*) mp3s
from recording r, concert c2, mp3link m
where r.concertid = c2.concertid
and r.recordingid = m.recordingid
group by r.concertid, r.linkurl) as rec,
(select c3.concertid, count(s.*) songs
from setlist s, concert c3
where s.concertid = c3.concertid
group by c3.concertid) as setlist
where rec.concertid = c.concertid
and setlist.concertid = c.concertid
order by concertdate