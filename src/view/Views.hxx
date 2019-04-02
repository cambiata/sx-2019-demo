package view;

import js.html.MouseEvent;
import js.Browser;
import data.AppStore;
import data.Model;
import mithril.M;
import mithril.M.m;

using cx.Validation; /**
 * Base class for views
 */

/*
	class UserApplicationsView extends AppBaseView {
	public function view() {
		var itemsList:Vnodes = this.store.state.applications != null ? this.store.state.applications.filter(a -> a.username == this.store.state.userId)
			.map(a -> {
			switch a.status {
				case Start: cast m('div.application.start', [
						m('span', 'Du kan nu skicka en ansöka om medlemskap i ${a.groupname}.'),
						m('button', {
							onclick: e -> {
								this.store.changeApplicationStatus(a, Pending);
							}
						}, 'Skicka ansökan'),
						m('button', {
							onclick: e -> {
								this.store.removeApplication(a);
							}
						}, 'Ta bort')
					]);
				case Pending: cast m('div.application.pending', [
						m('span',
							'Din ansökan om att gå med i ${a.groupname} väntar på att behandlas av gruppledaren.'),
						m('button', {onclick: e -> {}}, 'Ta bort')
					]);

				case Rejected: cast m('div.application.rejected', [
						m('span', 'Din ansökan om medlemskap i ${a.groupname} har avslagits'),
						m('button', {onclick: e -> {}}, 'Ta bort')
					]);
			}
		}) : m('div', 'No applications');

			[
				// visa aktuella gruppansökningar
				m('div.groupapplications', [
					m('h3.groupsearch', 'Mina ansökningar'),
					m('p.groupsearch',
						'Här kan du skapa ansökan om medlemskap för den kör/grupp som du vill bli deltagare i.'),
					itemsList
				]),

				// sökfält för grupper
				m('select.groupsearch', [m('option', 'Sök din kör eller grupp här')].concat(this.store.state.groups.map(group -> m('option', {
					onclick: e -> {
						trace('click ' + group.name);
						var newApplication:GroupApplication = {
							groupname: group.name,
							username: this.store.state.userId,
							status: GroupApplicationStatus.Start,
						};

						this.store.addApplication(newApplication);
					},
					value: '${group.name}'
				}, '${group.name}')))),

			];
	}
	}
 */
/*
	class UserInvitationsView extends AppBaseView {
	public function view() {
		var myInvitations = this.store.state.invitations.filter(a -> a.username == this.store.state.userId);
		var itemsList:Vnodes = myInvitations != null ? myInvitations.map(a -> {
			switch a.status {
				case Start: cast m('div.application.start', [
						m('span', {
							onclick: e->{
								///
							}
						}, 'Klicka här för att ansöka om medlemskap i ${a.groupname}'),
						m('button', {
							onclick: e -> {
								this.store.removeApplication(a);
							}
						}, 'Ta bort')
					]);
				case Pending: cast m('div.application.pending', [
						m('span',
							'Du har fått en inbjudan om att gå med i ${a.groupname}. Du kan välja om du vill gå med eller inte.'),
						m('button', {
							onclick: e -> {
								this.store.addUsernameToGroupFromLeaderInvitation(a);
							}
						}, 'Ja, jag vill gå med i ${a.groupname}'),
						m('button', {onclick: e -> {}}, 'Nej, jag vill inte gå med i ${a.groupname}'),
					]);

				case Rejected: cast m('div.application.rejected', [
						m('span', 'Din ansökan om medlemskap i ${a.groupname} har avslagits'),
						m('button', {onclick: e -> {}}, 'Ta bort')
					]);
			}
		}) : m('div', 'No invitations');

		// visa aktuella gruppansökningar
		m('div.groupapplications', [
			myInvitations.length > 0 ? m('h3.groupsearch', 'Mina inbjudningar') : null,
			itemsList
		]);
	}
	}
 */
/*
	class LeaderInvitationsView extends AppBaseView {
	var group:Group;

	static var username:String;

	public function new(store:AppStore, group:Group) {
		super(store);
		this.group = group;
	}

	public function view() {
		function existsMessage(username):String {
			return (this.store
				.userExists(username)) ? ' ' : ' (Användaren $username har ännu inte skapat något ScorX-konto, men kommer att nås av denna inbjudan när detta sker.)';
		}

		var itemsList:Vnodes = this.store.state.invitations != null ? this.store.state.invitations.filter(a -> a.groupname == this.group.name).map(a -> {
			switch a.status {
				case Start: cast m('div.application.start', [
						m('span', 'Här kan du skicka inbjudan till ${a.username} om att bli medlem i ${a.groupname}.'
							+ existsMessage(a.username)),
						m('button', {
							onclick: e -> {
								this.store.changeInvitationStatus(a, Pending);
							}
						}, 'Skicka inbjudan till ${a.username}'),
						m('button', {
							onclick: e -> {
								this.store.removeApplication(a);
							}
						}, 'Ta bort')
					]);
				case Pending: cast m('div.application.pending', [
						m('span',
							'Du har skickat en inbjudan till ${a.username} om att gå med i gruppen ${a.groupname}.' + existsMessage(a.username)),
						m('button', {
							onclick: e -> {
								this.store.removeInvitation(a);
							}
						}, 'Ta bort'),
					]);

				case Rejected: cast m('div.application.rejected', [
						m('span', 'Din ansökan om medlemskap i ${a.groupname} har avslagits'),
						m('button', {onclick: e -> {}}, 'Ta bort')
					]);
			}
		}) : m('div', 'No invitations');

		return m('div.groupinvitation', [
			m('div', [
				m('input[placeholder=Medlemmens e-postadress]', {
					oninput: e -> {
						username = e.target.value;
						trace(username);
					},
					// value: this.username,
				}),
				m('button', {
					onclick: e -> {
						trace(username);
						var application:GroupApplication = {username: username, groupname: group.name, status: GroupApplicationStatus.Start};
						this.store.addInvitation(application);
					}
				}, 'Skapa en inbjudan'),
				itemsList,
			]),

		]);
	}
	}
 */
/*
	class LeaderApplicationsView extends AppBaseView {
	var group:Group;

	public function new(store, group) {
		super(store);
		this.group = group;
	}

	public function view() {
		var items = this.store.state.applications.filter(app -> app.groupname == this.group.name);

		var itemsList:Vnodes = items != null ? items.map(a -> {
			var user:User = this.store.getUser(a.username);
			switch a.status {
				case Start: cast m('div.application.start', [
						m('span', {
							onclick: e->{
								///
							}
						}, 'Ska inte visas!'),
						m('button', {
							onclick: e -> {
								this.store.removeApplication(a);
							}
						}, 'Ta bort')
					]);
				case Pending: cast m('div.application.pending', [
						m('span',
							'Användaren ${user.firstname} ${user.lastname} önskar bli medlem i ${this.group.name}. Du kan välja om du accepterar denna ansökan eller inte.'),
						m('button', {
							onclick: e -> {
								this.store.addUsernameToGroupFromUserApplication(a);
							}
						}, 'Ja, ansökan från ${user.firstname} accepteras'),
						m('button', {onclick: e -> {}}, 'Nej, ansökan avslås'),
					]);

				case Rejected: cast m('div.application.rejected', [
						m('span', 'Din ansökan om medlemskap i ${a.groupname} har avslagits'),
						m('button', {onclick: e -> {}}, 'Ta bort')
					]);
			}
		}) : m('div', 'No invitations');

		// visa aktuella gruppansökningar
		m('div.groupapplications', [
			items.length > 0 ? m('h3.groupsearch', 'Ansökningar till gruppen') : null,
			itemsList
		]);
	}
	}
 */
