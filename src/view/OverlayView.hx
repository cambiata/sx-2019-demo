package view;

class OverlayView extends AppBaseView {
	public function view() {
		return new SongListView(this.store).view();
	}
}
