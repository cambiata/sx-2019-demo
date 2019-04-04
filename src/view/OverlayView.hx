package view;

import data.Model;
import data.AppStore;
import view.*;

class OverlayView extends AppBaseView {
	public function view() {
		return (this.store.state.playerSong == null) ? m('h2', 'No song selected') : [
			m('h2', this.store.state.playerSong.title),
			m('button.round', {
				onclick: e -> {
					this.store.update(this.store.state.playerShow = !this.store.state.playerShow, 'showPlayer');
				}
			}, 'Stäng'),
		];
	}
}
