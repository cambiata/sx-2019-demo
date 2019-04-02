package view;

import js.html.MouseEvent;
import mithril.M.Vnodes;
import data.Model;
import data.AppStore;
import view.*;

class SearchGroupView extends AppBaseView {
	static var searchChoirText:String = '';
	static var filteredGroups = [];

	var info:String;
	var cb:Group->Void;

	public function new(store, info:String, cb:Group->Void) {
		super(store);
		this.info = info;
		this.cb = cb;
	}

	public function view() {
		var groups = this.store.state.groups.array().copy();
		return detailsSummary('Sök kör', m('div', [

			m('div', info),
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

			m('ul', filteredGroups.map(group -> m('li', {
				onclick: e -> {
					trace(group);
					if (this.cb != null)
						this.cb(group);
				},
				style: {cursor: 'pointer'}
			}, group.name))),
		]));
	}
}
