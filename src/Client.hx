import js.html.MouseEvent;
import js.Browser;
import data.AppStore;
import data.Model;
import pushstate.PushState;
import mithril.M;
import mithril.M.m;

using cx.Validation;

class Client {
	static function main() {
		trace("Hello, world!");

		var store = new AppStore(new DeepState<AppState>({
			page: Home,
			userId: null,
			users: null,
			groups: null,
			songs: null,
		}));

		store.subscribe(store.state, state -> {
			M.redraw();
			trace('redraw');
		}, store.state);

		store.load();

		M.mount(js.Browser.document.querySelector('#header'), new Userview(store));
		M.mount(js.Browser.document.querySelector('#nav'), new MenuView(store));
		M.mount(js.Browser.document.querySelector('#footer'), new FooterView(store));
		M.mount(js.Browser.document.querySelector('main'), new Pageview(store));
	}
}

class AppStoreView implements Mithril {
	var store:AppStore;

	public function new(store:AppStore) {
		this.store = store;
	}
}

class FooterView extends AppStoreView {
	public function view() {
		return [
			m('ul', this.store.state.users.map(u -> m('li', '${u.firstname} ${u.lastname} ${u.username} ${u.password}'))),
			m('ul', this.store.state.groups.map(g -> m('li', '${g.name} ${g.sensus}'))),
			m('ul',
				this.store.state.songs.map(s -> m('li', '${s.title} ${s.category} ${s.producer}'))),
		];
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
				case SearchChoir: m('div.center', [
						m('input.center[placeholder=Sök din kör]', {
							oninput: e -> {
								trace(e.target.value);
							},
							style: {fontSize: '3vmax'},
						}),
					]);
				case BuySongs: m('div.center', [m('button.center', {
						onclick: e -> {
							trace('Click');
						}
					}, 'Gå till butiken'),]);

				case _: null;
			}
		}));
	}

	public function user() {
		var user:User = this.store.getUser();
		// return m('h1', 'user ' + user);

		var groups:Array<Group> = user.groups.map(groupname -> this.store.getGroup(groupname));

		var groupLists = groups.map(group -> cells([
			Songlist(group.name, group.songs.map(title -> this.store.getSong(title)), [Group(group.name)])
		]));

		var choirsInfo = groupLists
			.length > 0 ? 'Här visas de låtar dom delats ut till dig genom dina körer.' : 'Du verkar inte vara kopplad till någon kör eller grupp i ScorX. Du kan söka efter din kör och begära att bli medlem.';

		var searchChoirCell = null;
		if (groupLists.length == 0) {
			searchChoirCell = cells([SearchChoir]);
		}

		var mySongs:Array<Song> = user.songs.map(title -> this.store.getSong(title));
		trace(mySongs.length);
		var myList = mySongs.length > 0 ? cells([Songlist('Mina låtar', mySongs, [LimitNumber(5)])]) : cells([BuySongs]);

		return m('div.center', [
			cells([Title('Körernas låtar'), Info(choirsInfo),]),

			groupLists,
			searchChoirCell,

			cells([
				Title('Dina låtar'),
				Info('Här visas de låtar som du har köpt eller valt genom förmånserbjudanden.'),
			]),
			myList,

		]);
	}

	public function songlist(title:String, songs:Array<Song>, filter:Array<SongFilter>) {
		// var songs = this.store.state.songs.copy();
		var totalNumber:Int = songs.length;

		for (f in filter) {
			trace(songs.length);
			switch f {
				case Search(str):
				case Category(cat):
					songs = songs.filter(song -> {
						trace(song.category + ' ' + cat);
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
		trace(songs.length);

		return m('article.center', [
			m('header', m('span', title), m('input[placeholder=Sök]')),

			m('ul', songs.map(song -> m('li', [
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
								groups: [],
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
		trace('userview');
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
