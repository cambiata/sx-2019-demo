package view;

import js.html.MouseEvent;
import js.Browser;
import data.AppStore;
import data.Model;
import mithril.M;
import mithril.M.m;

class AppBaseView implements Mithril {
	var store:AppStore;

	public function new(store:AppStore) {
		this.store = store;
	}

	function detailsSummary(title:String, summaryView:Vnodes) {
		return m('details.center', [m('summary', title), summaryView,]);
	}
}
