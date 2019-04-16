package view;

import data.Model;
import data.KorakademinScorxItems;

class SongListView3 extends AppBaseView {
	var items:Array<ScorxAccessListItem>;
	var onItemClick:ScorxAccessListItem->Void;
	var title:String;
	var cells:Array<HomeCell>;

	public function new(store, title:String, items:Array<ScorxAccessListItem> = null, onItemClick:ScorxAccessListItem->Void = null,
			cells:Array<HomeCell> = null) {
		super(store);
		this.title = title;
		this.items = items.copy();
		this.onItemClick = onItemClick;
		this.cells = cells;
	}

	static var searchString:String = '';
	static var sortindex:Int = 0;

	public function view() {
		var searchStrings:Array<String> = searchString.split(' ');

		if (items.length == 0)
			return m('p.graytext', 'Listan är tom');

		for (search in searchStrings) {
			items = items.filter(item -> ((item.song.title.toLowerCase().indexOf(search.toLowerCase()) > -1)
				|| (item.song.composer != null && (item.song.composer.toLowerCase().indexOf(search.toLowerCase()) > -1))
				|| (item.song.lyricist != null && (item.song.lyricist.toLowerCase().indexOf(search.toLowerCase()) > -1))
				|| (item.song.arranger != null && (item.song.arranger.toLowerCase().indexOf(search.toLowerCase()) > -1))
				|| (item.song.ensemble != null && (item.song.ensemble.toLowerCase().indexOf(search.toLowerCase()) > -1))));
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

		items.sort((a, b) -> {
			return switch sortindex {
				case 0: Reflect.compare(a.song.title, b.song.title);
				case 1: Reflect.compare(a.song.composer, b.song.composer);
				case 2: Reflect.compare(a.song.lyricist, b.song.lyricist);
				case 3: Reflect.compare(a.song.arranger, b.song.arranger);
				case 4: Reflect.compare(a.song.ensemble, b.song.ensemble);
				case _: 0;
			}
		});

		var songlist = m('div.scorxlist', items.map(item -> m('div.scorxitem', [

			m('div.columnOne', [

				[
					m('span.title', item.song.title),
					m('span.ensemble.' + item.song.ensemble, item.song.ensemble),
					m('span.idnr', item.song.scorxProductId)
				],
				item.song.composer != '' ? m('div.orig', [m('span', 'musik:'), m('span', item.song.composer)]) : null,
				item.song.lyricist != '' ? m('div.orig', [m('span', 'text:'), m('span', item.song.lyricist)]) : null,
				item.song.arranger != '' ? m('div.orig', [m('span', 'arr:'), m('span', item.song.arranger)]) : null,
			]),
			m('div.columnTwo', m('div.scorxaccess', [
				m('p.smalltext', '' + item.access.getName()),
				m('p.smalltext', '' + item.access.getParameters()),
			])),

			m('div.columnThree', [

				m('button.round', {
					onclick: e -> {
						if (this.onItemClick != null)
							this.onItemClick(item);
					}
				}, 'Play'),
			]),

			(cells != null && cells != [])
			? new HomeView(this.store).buildCells(this.cells) : null,
		])));

		return m('details[open=true].songlist', [

			m('summary', m('span.songlisttitle', this.title)),
			m('div.songlistcontent', [

				m('div.searchinput', [
					m('input[placeholder=Sök titel, upphovspersoner, besättning]', {
						oninput: e -> {
							searchString = e.target.value;
						},
						value: searchString
					}),
					sort1,
					m('span', ' ' + items.length + ' låtar i listan'),
				]),
				songlist,
			])

		]);
	}
}
