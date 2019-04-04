package view;

import data.Model;
import data.AppStore;
import view.*;

class Userview extends AppBaseView {
	public function view() {
		return this.store.state.userId != null ? this.user() : this.guest();
	}

	public function user() {
		if (this.store.getUser() == null)
			return null;
		return m('select.user', [

			m('option', 'Välkommen, ${this.store.getUser().firstname}! '),
			m('option', {
				onclick: e -> {
					this.store.gotoPage(Page.UserSettings);
					// e.target.parent.selectedIndex = 0;
					trace(e.target.parentElement.selectedIndex = 0);
				}
			}, 'Inställningar'),
			m('option', {
				onclick: e -> {
					this.store.logout();
					e.target.selectedIndex = 0;
				}
			}, 'Logga ut'),
		]);
	}

	static var tryUsername:String = '';
	static var tryPassword:String = '';

	public function guest() {
		return [

			m('div', [

				m('input[placeholder=E-postadress][required]', {
					oninput: e -> {
						tryUsername = e.target.value;
					},
					value: tryUsername,
				}),
				m('input[placeholder=Lösenord][required]', {
					oninput: e -> {
						tryPassword = e.target.value;
					},
					value: tryPassword,
				}),
				m('button', {
					onclick: e -> {
						this.store.tryLogin(tryUsername, tryPassword);
					}
				}, 'Logga in'),
			]),
		];
	}
}
