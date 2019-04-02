package view;

import data.Model;
import data.AppStore;
import view.*;

class FooterView extends AppBaseView {
	public function view() {
		return [
			cast m('div', [
				m('p', 'Users'),
				m('ul', this.store.state.users.map(u -> m('li', {
					onclick: e -> {
						this.store.tryLogin(u.username, u.password);
					},
					style: {cursor: 'pointer'},
				}, '${u.firstname} ${u.lastname}'))),
			]),

			cast m('div', [
				m('p', 'Groups'),
				m('ul', this.store.state.groups.map(g -> m('li', [
					m('p', '${g.name}:${g.sensus}'),
					m('ul', g.admins.map(username -> m('li', {
						onclick: e -> {
							var user:User = this.store.getUser(username);
							this.store.tryLogin(user.username, user.password);
						},
						style: {cursor: 'pointer'},
					}, 'Ledare:' + username))),
					m('ul', g.members.map(username -> m('li', {
						onclick: e -> {
							var user:User = this.store.getUser(username);
							this.store.tryLogin(user.username, user.password);
						}
					}, username))),

				]))),
			]),

			cast m('div', [
				m('p', 'Songs'),
				m('ul',
					this.store.state.songs.map(s -> m('li', '${s.title} ${s.category} ${s.producer}'))),
			]),

		];
	}
}
