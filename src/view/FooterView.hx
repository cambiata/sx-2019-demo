package view;

import data.Model;
import data.AppStore;
import view.*;

class FooterView extends AppBaseView {
	public function view() {
		return [
			cast m('div', [
				m('p', 'Users'),
				m('ul',
					this.store.state.users.map(u -> m('li.' + (this.store.userIsSensusMember(u) ? 'sensus' : 'notNensus'), {
						onclick: e -> {
							this.store.tryLogin(u.username, u.password);
						},
						style: {cursor: 'pointer'},
					}, '${u.firstname} ${u.lastname} '))),
			]),

			cast m('div', [
				m('p', 'Groups'),
				m('ul', this.store.state.groups.map(g -> m('li', [
					m('h4', '${g.name}'),
					m('p', 'ledare:'),
					m('ul',
						g.admins.map(username -> m('li.' + (this.store.usernameIsSensusMember(username) ? 'sensus' : 'notNensus'), {
							onclick: e -> {
								var user:User = this.store.getUser(username);
								this.store.tryLogin(user.username, user.password);
							},
							style: {cursor: 'pointer'},
						}, username))),
					m('p', 'deltagare:'),
					m('ul',
						g.members.map(username -> m('li.' + (this.store.usernameIsSensusMember(username) ? 'sensus' : 'notNensus'), {
							onclick: e -> {
								var user:User = this.store.getUser(username);
								this.store.tryLogin(user.username, user.password);
							}
						}, username))),

				]))),
			]),

		];
	}
}
