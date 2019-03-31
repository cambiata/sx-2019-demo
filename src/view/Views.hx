package view;

import js.html.MouseEvent;
import js.Browser;
import data.AppStore;
import data.Model;
import mithril.M;
import mithril.M.m;

using cx.Validation;

// Base class for views
class AppStoreView implements Mithril {
	var store:AppStore;

	public function new(store:AppStore) {
		this.store = store;
	}
}

class FooterView extends AppStoreView {
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
					m('p', '${g.name} ${g.sensus}'),
					m('ul', g.members.map(member -> m('li', member))),

				]))),
			]),

			cast m('div', [
				m('p', 'Songs'),
				m('ul',
					this.store.state.songs.map(s -> m('li', '${s.title} ${s.category} ${s.producer}'))),
			]),

			cast m('div', [
				m('p', 'Applications'),
				m('ul', this.store.state.applications.map(s -> m('li', '' + s))),
			]),

			cast m('div', [
				m('p', 'Invitations'),
				m('ul', this.store.state.invitations.map(s -> m('li', '' + s))),
			]),
		];
	}
}

class ApplicationsView extends AppStoreView {
	public function view() {
		var itemsList:Vnodes = this.store.state.applications != null ? this.store.state.applications.filter(a -> a.username == this.store.state.userId)
			.map(a -> {
			switch a.status {
				case Start: cast m('div.application.start', [
						m('span', 'Klicka här för att ansöka om medlemskap i ${a.groupname}'),
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
					m('h3.groupsearch', 'Dina Ansökningar'),
					m('p.groupsearch',
						'Här kan du hitta den kör som du vill bli deltagare i, och skapa en ansökan som kommer att skickas till ledaren för den aktuella gruppen.'),
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

class InvitationsView extends AppStoreView {
	public function view() {
		var myInvitations = this.store.state.invitations.filter(a -> a.username == this.store.state.userId);
		var itemsList:Vnodes = myInvitations != null ? myInvitations.map(a -> {
			switch a.status {
				case Start: cast m('div.application.start', [
						m('span', 'Klicka här för att ansöka om medlemskap i ${a.groupname}'),
						m('button', {
							onclick: e -> {
								this.store.removeApplication(a);
							}
						}, 'Ta bort')
					]);
				case Pending: cast m('div.application.pending', [
						m('span',
							'Du har en inbjudan om att gå med i ${a.groupname}. Du kan välja om du vill gå med eller inte.'),
						m('button', {
							onclick: e -> {
								this.store.addUsernameToGroupFromInvitation(a);
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
		m('div.groupapplications', [myInvitations.length > 0 ? m('h3', 'Mina inbjudningar') : null, itemsList]);
	}
}

class CreateInvitationsView extends AppStoreView {
	var group:Group;

	static var username:String;

	public function new(store:AppStore, group:Group) {
		super(store);
		this.group = group;
	}

	public function view() {
		function existsMessage(username):String {
			return (this.store
				.userExists(username)) ? ' Finns.' : ' (Användaren $username har ännu inte skapat något ScorX-konto, men kommer att nås av denna inbjudan när detta sker.)';
		}

		var itemsList:Vnodes = this.store.state.invitations != null ? this.store.state.invitations.filter(a -> a.groupname == this.group.name).map(a -> {
			switch a.status {
				case Start: cast m('div.application.start', [
						m('span', {
							onclick: e -> {
								this.store.changeApplicationStatus(a, Pending);
							}
						}, 'Klicka här för att skapa en inbjudan till ${a.username} om att bli medlem i ${a.groupname}.' + existsMessage(a.username)),
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

class Homeview extends AppStoreView {
	public function view() {
		return this.store.state.userId == null ? this.guest() : this.user();
	}

	public function guest() {
		return [
			cells([
				Image('assets/img/old-town.jpg'),
				Title('Sjung och spela var du vill'),
				Info('ScorX spelare funkar både för mobil och surfplatta!'),
			]),
			cells([
				Image('assets/img/happy.jpg'),
				Title('Pröva ScorX gratis!'),
				Info('Klicka på valfri titel i listan nedan, lyssna och sjung med!'),
				Songlist('Gratislåtar', this.store.state.songs, [Category(Free), LimitNumber(5)]),
			]),
		];
	}

	public function cells(cells:Array<HomeCell>) {
		return m('section', cells.map(cell -> {
			return switch cell {
				case Image(url): m('img', {src: url});
				case Title(title): m('h1.limit-width.center', title);
				case Info(info): m('p.limit-width.center', info);
				case Songlist(title, songs, filter): this.songlist(title, songs, filter);
				case SearchChoir:
					// skapa lista för eventuella gruppansökningar för inloggad användare
					cast [new ApplicationsView(this.store).view(),];
				case BuySongs: m('div.center', [m('button.center', {
						onclick: e -> {
							trace('Click');
						}
					}, 'Gå till butiken'),]);
				case ListGroupMembers(groupname):
					var group:Group = this.store.getGroup(groupname);
					m('div.groupmembers', [m('ul', group.members.map(member -> m('li', member)))]);
				case InviteGroupMembers(groupname):
					var group:Group = this.store.getGroup(groupname);
					new CreateInvitationsView(this.store, group).view();

				case _: null;
			}
		}));
	}

	public function user() {
		return [choirMember(), choirAdmin(), mySongs()];
	}

	public function mySongs() {
		var user:User = this.store.getUser();
		var mySongs:Array<Song> = user.songs.map(title -> this.store.getSong(title));
		var myList = mySongs.length > 0 ? cells([Songlist('Mina låtar', mySongs, [LimitNumber(5)])]) : cells([BuySongs]);

		return [
			cells([
				Title('Mina låtar'),
				Info('Här visas de låtar som du har köpt eller valt genom förmånserbjudanden.'),
			]),
			myList
		];
	}

	public function choirAdmin() {
		var user:User = this.store.getUser();

		var groups:Array<Group> = this.store.state.groups.filter(group -> group.admins.indexOf(user.username) > -1);
		if (groups == null || groups.length == 0)
			return null;

		var groupLists = groups.map(group -> cells([
			Songlist(group.name, group.songs.map(title -> this.store.getSong(title)), [Group(group.name)]),
			Info('Gruppens nuvarande medlemmar:'),
			ListGroupMembers(group.name),
			Info('Här kan du bjuda in medlemmar till gruppen:'),
			InviteGroupMembers(group.name),
		]));

		return m('div.center', [cells([Title('Du leder följande körer'),]), groupLists,]);
	}

	public function choirMember() {
		var user:User = this.store.getUser();

		var groups:Array<Group> = this.store.state.groups.filter(group -> group.members.indexOf(user.username) > -1);
		var groupLists = groups.map(group -> cells([
			Songlist(group.name, group.songs.map(title -> this.store.getSong(title)), [Group(group.name)])
		]));

		var choirsInfo = groupLists
			.length > 0 ? 'Här visas de låtar dom delats ut till dig genom dina körer.' : 'Du verkar inte vara deltagare i någon kör eller grupp i ScorX.';

		return m('div.center', [
			cells([Title('Körernas låtar'), Info(choirsInfo),]),

			groupLists,
			groupLists.length == 0 ? cells([SearchChoir]) : null,

			new InvitationsView(this.store).view(),

		]);
	}

	public function songlist(title:String, songs:Array<Song>, filter:Array<SongFilter>) {
		// var songs = this.store.state.songs.copy();
		var totalNumber:Int = songs.length;

		for (f in filter) {
			switch f {
				case Search(str):
				case Category(cat):
					songs = songs.filter(song -> {
						return song.category.getName() == cat.getName();
					});
				case Producer(prod):
					songs = songs.filter(song -> song.producer == prod);
				case Group(groupname):
					var group:Group = this.store.getGroup(groupname);
					songs = group.songs.map(songtitle -> this.store.getSong(songtitle));
					totalNumber = songs.length;

				case LimitNumber(max):
					// songs = songs.splice(max, 10000);
					songs = songs.slice(0, 5);
			}
		}

		return m('article.center', [
			m('header', m('span', title), m('input[placeholder=Sök]')),

			m('ul', songs.filter(song -> song != null).map(song -> m('li', [
				m('.thumb', m('img', {src: 'assets/scorx/${song.producer.getName()}.png'})),
				m('.title', [m('h3', song.title), m('p', 'Information...')]),
				m('.originators', 'Originators'),
			]))),

			m('footer', [m('button', {onclick: e -> {}}, 'Visa alla ${totalNumber}'),]),
		]);
	}
}

class Pageview extends AppStoreView {
	var home:Homeview;
	var create:CreateUserView;

	public function new(store:AppStore) {
		super(store);
		this.home = new Homeview(store);
		this.create = new CreateUserView(store);
	}

	public function view() {
		return switch this.store.state.page {
			case Page.Home: this.home.view();
			case Page.CreateUser: this.create.view();
			case _: null;
		}
	}
}

class CreateUserView extends AppStoreView {
	var tryUsername:String = 'a';
	var tryPassword:String = 'a';
	var firstname:String = 'a';
	var lastname:String = 'a';

	public function view()
		[
			m('h1', 'Create user'),
			m('div', [
				m('input[placeholder=Användarnamn][required]', {
					oninput: e -> {
						this.tryUsername = e.target.value;
						trace(e.target.value);
						trace(this.tryUsername);
					},
					// value: this.tryUsername,
				}),
				m('input[placeholder=Lösenord][required]', {
					oninput: e -> {
						this.tryPassword = e.target.value;
					},
					// value: this.tryPassword,
				}),
				m('input[placeholder=Förnamn][required]', {
					oninput: e -> {
						this.firstname = e.target.value;
					},
					// value: this.firstname,
				}),
				m('input[placeholder=Lastname][required]', {
					oninput: e -> {
						this.lastname = e.target.value;
					},
					// value: this.lastname,
				}),
				m('button', {
					onclick: e -> {
						// this.store.tryLogin(this.tryUsername, this.tryPassword);
						trace(this.tryUsername + ' ' + this.tryPassword + ' ' + this.firstname + ' ' + this.lastname);
						try {
							this.tryUsername.asEmail();
							this.tryPassword.asPassword();
							this.firstname.asFirstname();
							this.lastname.asLastname();
							var newUser:User = {
								firstname: this.firstname,
								lastname: this.lastname,
								password: this.tryPassword,
								username: this.tryUsername,
								sensus: false,
								songs: [],
							};
							trace(newUser);
							this.store.addUser(newUser);
						} catch (e:Dynamic) {
							js.Browser.alert(e);
						}
					}
				}, 'Skapa användare'),
			]),
		];
}

class MenuView extends AppStoreView {
	public function view()
		[
			m('button', {
				onclick: e -> {
					this.store.update(this.store.state.page = Page.Home);
				}
			}, 'Home'),
			m('button', {
				onclick: e -> {
					this.store.update(this.store.state.page = Page.CreateUser);
				}
			}, 'Create user'),
			m('button', {
				onclick: e -> {
					this.store.resetToDefaultData();
				}
			}, 'Reset data'),
		];
}

class Userview extends AppStoreView {
	public function view() {
		return this.store.state.userId != null ? this.user() : this.guest();
	}

	public function user() {
		if (this.store.getUser() == null)
			return null;
		return [
			m('h3', 'Välkommen, ${this.store.getUser().firstname}!'),
			m('button', {
				onclick: e -> {
					this.store.logout();
				}
			}, 'Logga ut'),
		];
	}

	var tryUsername:String = 'adam@adam.se';
	var tryPassword:String = 'adam1';

	public function guest() {
		return [

			m('div', [

				m('input[placeholder=Användarnamn][required]', {
					oninput: e -> {
						this.tryUsername = e.target.value;
					},
					value: this.tryUsername,
				}),
				m('input[placeholder=Lösenord][required]', {
					oninput: e -> {
						this.tryPassword = e.target.value;
					},
					value: this.tryPassword,
				}),
				m('button', {
					onclick: e -> {
						this.store.tryLogin(this.tryUsername, this.tryPassword);
					}
				}, 'Logga in'),
			]),
		];
	}
}
