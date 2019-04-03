package view;

import cx.Random;
import js.Browser;
import data.Model;

using cx.Validation;
using cx.ArrayTools;
using Lambda;

class LeaderInviteUsers extends AppBaseView {
	static var inputUsername:String;
	static var iviteUsernames:Array<String> = []; // ['adam@adam.se', 'beda@bensin.se', 'nisse@nisse.se', 'caesar@citrus.se'];
	static var inviteFirstnames:Array<String> = [];
	static var inviteLastnames:Array<String> = [];

	function reset() {
		inputUsername = '';
		iviteUsernames = [];
		inviteFirstnames = [];
		inviteLastnames = [];
	}

	var group:Group;

	public function new(store, group:Group) {
		super(store);
		this.group = group;
	}

	public function view() {
		function finns(email)
			return this.store.userExists(email);

		return [

			m('div.invitationform', [
				m('div',
					'Ange e-postadress till den eller de personer som du vill bjuda in, och klicka på knappen Lägg till i inbjudningslistan. '),
				m('input[placeholder=E-postadress]', {
					oninput: e -> {
						inputUsername = e.target.value;
					},
					value: inputUsername
				}),
				m('button', {
					onclick: e -> {
						try {
							inputUsername.validateAsEmail();
							if (this.store.isGroupMember(inputUsername, group.name))
								throw 'Användaren $inputUsername finns redan i gruppen ' + group.name;

							if (iviteUsernames.has(inputUsername))
								throw '$inputUsername finns redan i inbjudningslistan';

							iviteUsernames.push(inputUsername);
							inviteLastnames.push('');
							inviteFirstnames.push('');
							inputUsername = '';
							null;
						} catch (e:Dynamic) {
							Browser.alert(e);
						}
					}
				}, 'Lägg till i inbjudningslistan:'),

			]),

			m('h3', 'Inbjudningslistan'),

			iviteUsernames.length == 0 ? m('p', 'listan är tom') : cast [
				iviteUsernames.mapi((index,
						email) -> m('div.invite.' + finns(email), [
					m('div', 'Inbjudan till $email'),
					m('div', finns(email) ? {
						var user:User = this.store.getUser(email);
						'Finns i ScorX som ' + user;
					} : [
							m('div', 'Finns ej i ScorX sedan tidigare. Ange för- och efternam.'),
							m('input[placeholder=Förnamn][required]', {
								oninput: e -> {
									inviteFirstnames[index] = e.target.value;
								}
							}),
							m('input[placeholder=Efternamn][required]', {
								oninput: e -> {
									inviteLastnames[index] = e.target.value;
								}
							}),
						]),

					m('button', {
						onclick: e -> {
							iviteUsernames.remove(email);
						}
					}, 'Ta bort'),

				])),
				m('button', {
					onclick: e -> {
						try {
							iviteUsernames.mapi((index, email) -> {
								try {
									if (!finns(email)) {
										inviteFirstnames[index].validateAsFirstname();
										inviteLastnames[index].validateAsLastname();
									}
								} catch (e:Dynamic) {
									Browser.alert('Fel gällande $email: ' + e);
									throw 'Korrigera!';
								}
								null;
							});

							iviteUsernames.mapi((index, email) -> {
								if (finns(email)) {
									// Browser.alert('Finns $email');
									this.store.addGroupMember(email, this.group.name);
									this.store.sendEmailMessage({
										to: email,
										from: this.store.state.userId,
										type: EmailType.UserGroupjoinInfo(this.group.name),
									});
								} else {
									// Browser.alert('Finns inte $email');
									var firstname = inviteFirstnames[index];
									var lastname = inviteLastnames[index];
									var randomPassword = 'slump' + Random.int(100, 999);

									this.store.sendEmailMessage({
										to: email,
										from: this.store.state.userId,
										type: EmailType.UserAccountActivationAndGroupjoin(email, randomPassword, firstname, lastname, this.group.name),
									});
								}
								return null;
							});

							Browser.alert('Inbjudningmejl har skickats till namnen i listan.');

							// Klart!

							reset();

							null;
						} catch (e:Dynamic) {
							Browser.alert(e);
						}
					}
				}, 'Skicka inbjudningar'),
			],
		];
	}
}
