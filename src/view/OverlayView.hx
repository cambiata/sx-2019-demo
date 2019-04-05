package view;

import data.Model;
import data.AppStore;
import view.*;

class OverlayView extends AppBaseView {
	public function view() {
		var closeButton = m('button.round', {
			onclick: e -> {
				this.store.update(this.store.state.playerShow = !this.store.state.playerShow, 'showPlayer');
			}
		}, 'Stäng');

		if (this.store.state.playerAccessItem == null)
			return [m('h2', 'Inget item valt!'), closeButton];

		return [
			m('div', [
				m('h3', '' + this.store.state.playerAccessItem.song.title),
				m('p.smalltext', 'access: ' + this.store.state.playerAccessItem.access)
			]),
			closeButton
		];
	}
}
