package view;

class OverlayView extends AppBaseView {
	public function view() {
		if (this.store.state.overlay == null)
			return m('div', 'nothing');
		return m('div', m('h1', 'Overlay'), [this.store.state.overlay.map(ovl -> m('h2', '' + ovl))]);
	}
}
