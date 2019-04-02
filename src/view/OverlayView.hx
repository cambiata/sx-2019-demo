package view;

import data.KorakademinScorxItems;

class OverlayView extends AppBaseView {
	public function view() {
		return new SongListView(this.store, 'Körakademins låtar', KorakademinScorxItems.items(), []).view();
	}
}
