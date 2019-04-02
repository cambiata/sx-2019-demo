package view;

import data.AppStore;
import mithril.M.Vnodes;

class DetailsSummaryView extends AppBaseView {
	var title:String;
	var summaryView:Vnodes;

	public function new(store:AppStore, title:String, summaryView:Vnodes) {
		super(store);
		this.title = title;
		this.summaryView = summaryView;
	}

	public function view() {
		return m('details', [m('summary', this.title), this.summaryView,]);
	}
}
