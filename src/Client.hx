import data.AppStore;
import data.Model;
import view.Views;
import mithril.M;
import mithril.M.m;

using cx.Validation;

class Client {
	static function main() {
		/**
		 * Initiera state-hanteraren (à la Redux)
		 */
		var store = new AppStore(new DeepState<AppState>({
			page: Home,
			userId: null,
			users: null,
			groups: null,
			applications: null,
			invitations: null,
			songs: null,
		}));

		/**
		 * Ladda data från localStorage
		 */
		store.load();

		/**
		 * När state updateras, skicka redraw-kommando till Mithrils virtual-dom
		 * för att rita om aktuella delar av sidan
		 */
		store.subscribe(store.state, state -> {
			M.redraw();
		}, store.state);

		/**
		 * Montera Mithril-vyerna i respektive index.html-element
		 */
		M.mount(js.Browser.document.querySelector('#header'), new Userview(store));
		M.mount(js.Browser.document.querySelector('#nav'), new MenuView(store));
		M.mount(js.Browser.document.querySelector('#footer'), new FooterView(store));
		M.mount(js.Browser.document.querySelector('main'), new Pageview(store));
	}
}
