import data.AppStore;
import data.Model;
import view.*;
import mithril.M;
import mithril.M.m;

using cx.Validation;

class Client {
	static function main() {
		/**
		 * Initiera state-hanteraren (à la Redux)
		 */
		var store = new AppStore(new DeepState<AppState>({
			userId: null,
			users: null,
			groups: null,
			songs: null,
			messages: null,
			page: Home,
			overlay: null,
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

		store.subscribe(store.state.overlay, overlay -> {
			var body = js.Browser.document.querySelector("body");
			if (overlay == null || overlay == []) {
				body.classList.add('hide-overlay');
				body.classList.add('webkit-scrolling');
			} else {
				body.classList.remove('hide-overlay');
				body.classList.remove('webkit-scrolling');
			}
		});

		/**
		 * Montera Mithril-vyerna i respektive index.html-element
		 */
		M.mount(js.Browser.document.querySelector('#header'), new Userview(store));
		M.mount(js.Browser.document.querySelector('#nav'), new MenuView(store));
		M.mount(js.Browser.document.querySelector('#footer'), new FooterView(store));
		M.mount(js.Browser.document.querySelector('main'), new PageView(store));
		M.mount(js.Browser.document.querySelector('#scorxlist'), new OverlayView(store));
	}
}
