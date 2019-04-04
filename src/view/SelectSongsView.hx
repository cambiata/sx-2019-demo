package view;

import data.KorakademinScorxItems;
import view.AppBaseView;

class SelectSongsView extends AppBaseView {
	var leftSongs:Array<ScorxItem>;
	var rightSongs:Array<ScorxItem>;

	public function new(store, leftSongs, rightSongs) {
		super(store);
		this.leftSongs = leftSongs;
		this.rightSongs = rightSongs;
	}

	function leftSongClick(song:ScorxItem) {
		var moveSongs = this.leftSongs.splice(this.leftSongs.indexOf(song), 1);
		this.rightSongs = moveSongs.concat(this.rightSongs);
	}

	function rightSongClick(song:ScorxItem) {
		var moveSongs = this.rightSongs.splice(this.rightSongs.indexOf(song), 1);
		this.leftSongs = moveSongs.concat(this.leftSongs);
	}

	public function view() {
		return m('div.selectSongsView', [
			m('h1', 'SelectSongs'),
			m('div.twoColumns', [
				new SongListView(this.store, 'Left', leftSongs, null, leftSongClick).view(),
				new SongListView(this.store, 'Right', rightSongs, null, rightSongClick).view(),
			]),

		]);
	}
}
