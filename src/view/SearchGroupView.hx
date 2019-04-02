package view;

import js.html.MouseEvent;
import mithril.M.Vnodes;
import data.Model;
import data.AppStore;
import view.*;

class SearchGroupView extends AppBaseView {
	static var searchChoirText:String = '';
	static var filteredGroups = [];

	var onGroupClick:Group->Void;

	public function new(store:AppStore, onGroupClick:Group->Void = null) {
		super(store);
		this.onGroupClick = onGroupClick;
	}

	public function view() {
		var groups = this.store.state.groups.array().copy();
		return detailsSummary('Sök kör', m('div', [
			m('p', 'Skriv namnet på den kör du vill söka efter i sökfältet.'),
			m('input[placeholder=Sök kör]', {
				oninput: e -> {
					searchChoirText = e.target.value;
					if (searchChoirText.length > 0)
						filteredGroups = groups.filter(group -> group.name.toLowerCase().indexOf(searchChoirText.toLowerCase()) > -1);
					else
						filteredGroups = [];
				},
				value: searchChoirText
			}),

			m('div', {
				style: {
					padding: '1vmax',
					margin: '1vmax',
					maxHeight: '10vmax',
					overflowY: 'scroll',
					border: '1px solid #ccc',
					borderRadius: '2vmax',
				}
			}, [
					m('ul', filteredGroups.map(group -> m('li', {
						onclick: e -> {
							if (this.onGroupClick != null)
								this.onGroupClick(group);
						},
						style: {cursor: 'pointer'}
					}, group.name))),
				]),

		]));
	}
}
