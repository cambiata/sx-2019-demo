package view;

class OverlayView extends AppBaseView {
	public function view() {
		return m('div', m('h1', 'Overlay'), [this.store.state.overlay.map(ovl -> m('h2', '' + ovl))]);
	}
}
