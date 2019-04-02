package view;

import data.Model;
import data.AppStore;
import view.*;

class EmailView extends AppBaseView {
	static var anonymousEmail:String;

	public function view() {
		var anonymousEmailView = null;

		if (this.store.state.userId == null) {
			anonymousEmailView = [
				m('input', {
					oninput: e -> {
						anonymousEmail = e.target.value;
					}
				}),
				m('p', 'AE:' + anonymousEmail),

			];
		}

		var currentEmail = this.store.getUser() != null ? this.store.getUser().username : anonymousEmail;

		var messages:Array<EmailMessage> = this.store.state.messages;
		var userMessages:Array<EmailMessage> = messages.filter(mess -> mess.to == currentEmail);

		// return m('h1', 'hej');
		return m('div.email.center', [
			m('div.emailLeft', [
				m('img', {src: 'assets/img/mail.png'}),
				anonymousEmailView,
				messages.map(mess -> m('p', {
					onclick: e -> {
						anonymousEmail = mess.to;
					},
					style: {cursor: 'pointer'},
				}, 'to:${mess.to}')),
			]),
			//
			//
			// m('div.emailRight', [m('h3', 'Inkorgen'), messages.map(mess -> this.message(mess)),]),
			m('div.emailRight', [
				m('h3', 'Inkorgen:' + currentEmail),
				userMessages.map(mess -> this.message(mess)),
			]),

		]);
	};

	function message(mess:EmailMessage) {
		// var user:User = this.store.getUser();

		var sender:User = this.store.getUser(mess.from);

		var title = try {
			switch mess.type {
				case UserAccountActivation(email, pass, firstname, lastname): 'Välkommen, ${firstname} ${lastname}, till ditt nya ScorX-konto';
				case UserGroupjoinInfo(groupname):
					var user = this.store.getUser(mess.to);
					'Välkommen, ${user.firstname}, med i ScorX-gruppen ' + groupname;
				case UserAccountActivationAndGroupjoin(email, pass, firstname, lastname, groupname): 'Inbjudan till ScorX-gruppen $groupname';

				case AdminGroupjoinInfo(joinedUsername, groupname):
					'En ny medlem har anslutit sig till ScorX-gruppen ' + groupname;

				case AfterUserActivationSuccess:
					// var user = this.store.getUser(mess.to);
					'Välkommen till ScorX!';
				case SimpleMessage(title, text): title;
			}
		} catch (e:Dynamic) {
			'Titeln för $mess kan inte visas: $e';
		}
		var message = try {
			switch mess.type {
				case UserAccountActivation(email, pass, firstname, lastname): 'Hej ${firstname}! Klicka på denna länk för att aktivera ditt ScorX-konto';
				case UserGroupjoinInfo(groupname):
					var user = this.store.getUser(mess.to);
					'Hej ${user.firstname}! Du är nu  medlem i ScorX-gruppen ' + groupname;
				case UserAccountActivationAndGroupjoin(email, pass, firstname, lastname, groupname):
					'Hej ${firstname}! Du har bjudits in som medlem i ScorX-gruppen $groupname. Eftersom du inte har någt ScorX-konto så kan skapas det ett sådant när du klickar på denna länk. Du loggar in med din e-postadress och lösenordet $pass';

				case AdminGroupjoinInfo(joinedUsername, groupname): {
						var joinedUser:User = this.store.getUser(joinedUsername);
						var user = this.store.getUser(mess.to);
						'Hej ${user.firstname}! En ny deltagare har nu anslutit sig till gruppen ${groupname}, nämligen ${joinedUser.firstname} ${joinedUser.lastname}';
					}
				case AfterUserActivationSuccess:
					var user:User = this.store.getUser(mess.to);
					'Hej ${user.firstname}! Ditt konto har nu skapats och du kan logga in med din e-postadress och lösenordet ${user.password}';
				case SimpleMessage(title, text): text;
			}
		} catch (e:Dynamic) {
			'Meddelandet för $mess kan inte visas: $e';
		}
		return [
			m('details', [
				m('summary', title),
				m('p.emailSender', 'Avsändare: ' + mess.from),
				m('p.emailMessage', {
					onclick: e -> {
						this.store.handleMessageClicks(mess);
					}
				}, message),
			]),
		];
	}
}
