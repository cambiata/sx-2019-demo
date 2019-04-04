package view;

import js.Browser;
import data.Model;
import data.AppStore;
import view.*;

using data.Validation;

class CreateUserView extends AppBaseView {
	static var newUsername:String = 'nisse@nisse.se';
	static var newPassword:String = 'nisse';
	static var newFirstname:String = 'Nils';
	static var newLastname:String = 'Nilsson';
	static var sensusPnr:String;
	static var sensusMember:Bool;

	public function reset() {
		newUsername = '';
		newPassword = '';
		newFirstname = '';
		newLastname = '';
		return this;
	}

	public function view()
		m('div.createuser', [
			m('h1', 'Skapa konto'),
			m('h2', 'Kontouppgifter'),
			m('div.createuserform', [
				m('input[placeholder=Användarnamn][required]', {
					oninput: e -> {
						newUsername = e.target.value;
						trace(e.target.value);
						trace(newUsername);
					},
					value: newUsername,
				}),
				m('input[placeholder=Lösenord][required]', {
					oninput: e -> {
						newPassword = e.target.value;
					},
					value: newPassword,
				}),
				m('input[placeholder=Förnamn][required]', {
					oninput: e -> {
						newFirstname = e.target.value;
					},
					value: newFirstname,
				}),
				m('input[placeholder=Lastname][required]', {
					oninput: e -> {
						newLastname = e.target.value;
					},
					value: newLastname,
				}),
				// Sensusformulär
				m('details', [
					m('summary', 'Sjunger du i en sensus-kör?'),
					m('div', {style: {padding: '1vmax'}}, [
						m('p', 'Som deltagare i en Sensus-kör så får du del av förmånserbjudanden I ScorX.'),
						m('p',
							'Du har exempelvis möjlighet att kostnadsfritt använda 10 av Körakademins sånger.'),
						m('p',
							'För att kunna säkerställa att du är en Sensus-deltagare så behöver du ange ditt personnummer och kryssa i bekräftelserutan.'),
						m('input[placeholder=Personnummer]', {
							oninput: e -> {
								sensusPnr = e.target.value;
							}
						}),
						m('div', [
							m('input[type=checkbox][id=userSensusCb]', {
								onchange: e -> {
									trace(e.target.checked);
									var checked:Bool = e.target.checked;
									if (sensusPnr == null || sensusPnr == '') {
										Browser.alert('Du måste ange ditt personnummer!');
										sensusMember = false;
									} else {
										sensusMember = e.target.checked;
									}
								},
								checked: sensusMember,
							}),
							m('label[for=userSensusCb]', 'Ja, jag sjunger i en Sensus-kör'),
						]),
					]),
				]),
				m('button', {
					onclick: e -> {
						// this.store.tryLogin(this.newUsername, this.newPassword);
						trace(newUsername + ' ' + newPassword + ' ' + newFirstname + ' ' + newLastname);
						try {
							if (this.store.userExists(newUsername))
								throw 'Användaren $newUsername finns redan i ScorX!';
							newUsername.validateAsEmail();
							newPassword.validateAsPassword();
							newFirstname.validateAsFirstname();
							newLastname.validateAsLastname();
							if (sensusMember)
								sensusPnr.validateAsPersonnummer();
							var sensus = sensusMember ? SensusUser.UserClaimed : null;
							var mess:EmailMessage = {
								to: newUsername,
								from: 'admin@scorx.org',
								type: EmailType.UserAccountActivation(newUsername, newPassword, newFirstname, newLastname, sensus),
							}
							this.store.sendEmailMessage(mess);
							js.Browser
								.alert('Ett mejl har skickats till $newUsername. Gå till din inkorg och klicka på den bifogade länken för att aktivera ditt konto!');
							this.store.gotoPage(Page.Home);
							this.reset();
							null;
						} catch (e:Dynamic) {
							js.Browser.alert(e);
						}
					}
				}, 'Skapa användare'),
			]),
			// m('h2', 'Vill du ta del av Sensus förmånserbjudanden?'),
			// m('div.createuserform', [
			// 	m('p', '(Detta är ett försök att hantera de fria Sensus-valen..!)'),
			// 	m('p',
			// 		'Som sångare i Sensus-kör så får du ta del av förmånserbjudanden som exempelvis gratis tillgång av låtar som du själv väljer.'),
			// 	m('p',
			// 		'Du behöver ange ditt personnummer för att vi ska kunna säkerställa att du verkligen är en Sensus-sångare.'),
			// 	m('input[placeholder=Personnummer]'),
			// 	m('div', [
			// 		m('input[type=checkbox]'),
			// 		m('span', 'Ja, jag sjunger i en Sensus-kör och vill ta del av förmånserbjudanden'),
			// 	]),
			// ]),
			// m('h2', 'Sök din kör'),
			// m('div.createuserform', [
			// 	m('p', 'Här kan du söka och hitta den kör eller grupp som du är medlem i. '),
			// 	m('p', '(Du kan också ange om du är ledare för gruppen i fråga. ???)'),
			// ]),
		]);
}
