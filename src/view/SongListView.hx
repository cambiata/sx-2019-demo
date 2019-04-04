package view;

import data.Model;
import data.KorakademinScorxItems;

class SongListView extends AppBaseView {
	var title:String;
	var songs:Array<ScorxItem>;
	var onSongClick:ScorxItem->Void;

	public function new(store, title:String, songs:Array<ScorxItem> = null, filters:Array<ScorxFilter> = null, onSongClick:ScorxItem->Void = null) {
		super(store);
		this.title = title;
		this.songs = applyScorxFilters(songs, filters);
		this.onSongClick = onSongClick;
	}

	function applyScorxFilters(songs:Array<ScorxItem>, filters:Array<ScorxFilter>):Array<ScorxItem> {
		var songs = songs.copy();
		if (filters != null)
			for (filter in filters) {
				switch filter {
					case ScorxFilter.SelectProductIds(ids):
						songs = songs.filter(song -> ids.indexOf(song.scorxProductId) > -1);
					case ScorxFilter.LicenseHolder(lic):
						songs = songs.filter(song -> song.licenseholder == lic);

						// case ScorxFilter.LimitNumber(num):
						// 	this.numBeforeLimit = songs.length;
						// 	songs = songs.slice(0, num);
						// 	this.numAfterLimit = songs.length;
				}
			}
		return songs;
	}

	static var searchString:String = '';
	static var sortindex:Int = 0;

	public function view() {
		var searchStrings:Array<String> = searchString.split(' ');

		for (search in searchStrings) {
			songs = songs.filter(item -> ((item.title.toLowerCase().indexOf(search.toLowerCase()) > -1)
				|| (item.composer.toLowerCase().indexOf(search.toLowerCase()) > -1)
				|| (item.lyricist.toLowerCase().indexOf(search.toLowerCase()) > -1)
				|| (item.arranger.toLowerCase().indexOf(search.toLowerCase()) > -1)
				|| (item.ensemble.toLowerCase().indexOf(search.toLowerCase()) > -1)));
		}

		var sortalts = ['titel', 'tonsättare', 'författare', 'arrangör', 'besättning'];

		var sort1 = m('select', {
			onchange: e -> {
				trace(e.target.selectedIndex);
				sortindex = e.target.selectedIndex;
			},
			onblur: e -> {
				trace(e.target.selectedIndex);
				sortindex = e.target.selectedIndex;
			}
		}, sortalts.map(alt -> m('option', {value: alt}, alt)));

		songs.sort((a, b) -> {
			return switch sortindex {
				case 0: Reflect.compare(a.title, b.title);
				case 1: Reflect.compare(a.composer, b.composer);
				case 2: Reflect.compare(a.lyricist, b.lyricist);
				case 3: Reflect.compare(a.arranger, b.arranger);
				case 4: Reflect.compare(a.ensemble, b.ensemble);
				case _: 0;
			}
		});

		return m('div.songListView', [
			m('div.searchinput', [
				m('input[placeholder=Sök titel, upphovspersoner, besättning]', {
					oninput: e -> {
						searchString = e.target.value;
					},
					value: searchString
				}),
				// m('span', 'Sortering: '),
				sort1,

			]),

			m('div.scorxlist', songs.map(song -> m('div.scorxitem', [
				m('div.columnOne', [
					[
						m('span.title', song.title),
						m('span.ensemble.' + song.ensemble, song.ensemble),
						m('span.idnr', song.scorxProductId)
					],
					song.composer != '' ? m('div.orig', [m('span', 'musik:'), m('span', song.composer)]) : null,
					song.lyricist != '' ? m('div.orig', [m('span', 'text:'), m('span', song.lyricist)]) : null,
					song.arranger != '' ? m('div.orig', [m('span', 'arr:'), m('span', song.arranger)]) : null,
				]),

				m('div.columnTwo', [
					m('button.round', {
						onclick: e -> {
							if (this.onSongClick != null)
								this.onSongClick(song);
						}
					}, 'Select'),
				]),

			]))),
			m('div.underlist', [m('p', songs.length + ' låtar')]),
		]);
	}
}
