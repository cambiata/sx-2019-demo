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
			}, 'Email'),
			m('span.button', {
				onclick: e -> {
					this.store.gotoPage(Page.Other);
				}
			}, 'Other'),
			m('span.button', {
				onclick: e -> {
					this.store.resetToDefaultData();
					this.store.gotoPage(Page.Home);
				}
			}, 'Reset'),
			m('span.button', {
				onclick: e -> {
					var overlay = Browser.document.querySelector("body");
					overlay.classList.toggle('hide-overlay');
					overlay.classList.toggle('webkit-scrolling');
				}
			}, 'Ovl'),
		];
}
