package view;

import js.Browser;
import data.Model;
import data.AppStore;
import view.*;

class MenuView extends AppBaseView {
	public function view()
		[
			m('span.button', {
				onclick: e -> {
					this.store.gotoPage(Page.Home);
				}
			}, 'Hem'),
			m('span.button', {
				onclick: e -> {
					this.store.gotoPage(Page.CreateUser);
				}
			}, 'Skapa konto'),
			m('span.button', {
				onclick: e -> {
					this.store.gotoPage(Page.Email);
				}
			}, 'E-post'),
			m('span.button', {
				onclick: e -> {
					this.store.update(this.store.state.showOverlay = !this.store.state.showOverlay);
				}
			}, 'Spelare'),
			m('span.button', {
				onclick: e -> {
					this.store.resetToDefaultData();
					this.store.gotoPage(Page.Home);
				}
			}, 'Nollställ demo'),
			m('span.button', {
				onclick: e -> {
					this.store.gotoPage(Page.Other);
				}
			}, 'Other'),
		];
}
