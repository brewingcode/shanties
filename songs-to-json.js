const fs = require('fs');
const path = require('path');

const songsDir = 'songs';
const songs = {};
const byTitle = {};

for (const f of fs.readdirSync(songsDir)) {
  if (!/\.txt$/i.test(f)) continue;

  const buf = fs.readFileSync(path.join(songsDir, f));
  let song = buf.toString('utf8');
  if (song.includes('\uFFFD')) song = buf.toString('latin1');
  song = song.replace(/\r\n/g, '\n');

  songs[f] = song;

  const m = song.match(/^T:\s*(.*)/m);
  if (m) {
    byTitle[m[1]] = song;
  } else {
    console.log('weird song:', f);
  }
}

fs.writeFileSync('src/songs.json', JSON.stringify(songs));
fs.writeFileSync('src/by-title.json', JSON.stringify(byTitle));
