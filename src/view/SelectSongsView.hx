package view;

import view.AppBaseView;
import data.Model;

class SelectSongsView extends AppBaseView {
	var leftSongs:Array<ScorxAccessListItem>;
	var rightSongs:Array<ScorxAccessListItem>;

	public function new(store, leftSongs, rightSongs) {
		super(store);
		this.leftSongs = leftSongs;
		this.rightSongs = rightSongs;
	}

	function leftSongClick(song:ScorxAccessListItem) {
		var moveSongs = this.leftSongs.splice(this.leftSongs.indexOf(song), 1);
		this.rightSongs = moveSongs.concat(this.rightSongs);
	}

	function rightSongClick(song:ScorxAccessListItem) {
		var moveSongs = this.rightSongs.splice(this.rightSongs.indexOf(song), 1);
		this.leftSongs = moveSongs.concat(this.leftSongs);
	}

	public function view() {
		return m('div.selectSongsView', [
			m('h1.center-narrow.vspace', 'Välj låtar till /listans-namn/ här'),
			m('h3.center-narrow.vspace', 'Bra och tydlig info om hur valet går till...'),
			m('div.twoColumns', [
				m('div', [
					m('h3', 'Tillgängliga låtar, ' + leftSongs.length + ' st'),
					new SongListView2(this.store, leftSongs, leftSongClick).view(),
				]),

				m('div', [
					m('h3', 'Valda låtar, ' + rightSongs.length + ' st'),
					new SongListView2(this.store, rightSongs, rightSongClick).view(),
					m('button.bigger', {
						onclick: e -> {
							js.Browser.alert('Du har valt '
								+ rightSongs.length
								+ ' låtar som kommer att läggas till listan /listans-namn/...');
						}
					}, 'Bekräfta val av låtar...'),
				]),
			]),

		]);
	}
}
