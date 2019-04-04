package view;

class SensusUserView extends AppBaseView {
	var username:String;

	public function new(store, username:String) {
		super(store);
		this.username = username;
	}

	public function view() {
		return m('details', [m('summary', 'Sjunger du i en sensus-kör?'), m('p', 'Hejsan hoppsan'),]);
	}
}
