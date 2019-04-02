package view;

import data.KorakademinScorxItems;

class SongListView extends AppBaseView {
	static var searchString:String = '';

	public function view() {
		var songs = KorakademinScorxItems.items().filter(item -> item.title.indexOf(searchString) > -1);
		return [
			m('div', [
				m('input[placeholder=Sök titel, upphovsman, besättning]', {
					oninput: e -> {
						searchString = e.target.value;
					},
					value: searchString
				}),
				m('div', searchString),
			]),
			m('div', songs.map(song -> m('div', song.title)))

		];
	}
}
