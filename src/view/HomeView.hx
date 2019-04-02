package view;

import data.Model;
import data.AppStore;
import view.*;

class HomeView extends AppBaseView {
	// /**
	//  * Första vattendelare för hemsidan
	//  * Ifall userId är null, visa hemsidan för gäst
	//  * Ifall userId är satt, visa hemsidan för inloggad användare
	//  */
	public function view() {
		return this.store.state.userId == null ? this.guestView() : this.userView();
	}

	//-------------------------------------------------------------------------------------

	/**
	 * Returnera vy för gäst
	 */
	public function guestView() {
		return [
			buildCells([
				Image('assets/img/old-town.jpg'),
				Title('Sjung och spela var du vill'),
				Info('ScorX spelare funkar både för mobil och surfplatta!'),
			]),
			buildCells([
				Image('assets/img/happy.jpg'),
				Title('Pröva ScorX gratis!'),
				Info('Klicka på valfri titel i listan nedan, lyssna och sjung med!'),
				Songlist('Gratislåtar', this.store.state.songs, [Category(Free), LimitNumber(5)]),
			]),
		];
	}

	//-------------------------------------------------------------------------------------

	/**
	 * Returnera vyer för inloggad användare
	 */
	function userView() {
		return [choirMemberView(), choirAdminView(), mySongsView()];
	}

	function choirMemberView() {
		var user:User = this.store.getUser();

		var groups:Array<Group> = this.store.state.groups.filter(group -> group.members.indexOf(user.username) > -1);
		var groupLists = groups.map(group -> buildCells([
			Songlist(group.name, group.songs.map(title -> this.store.getSong(title)), [Group(group.name)])
		]));

		var choirsInfo = groupLists
			.length > 0 ? 'Här visas de låtar som delats ut till dig av dina körer.' : 'Du verkar inte vara deltagare i någon kör eller grupp i ScorX.';

		return m('div.center', [
			buildCells([Title('Körernas låtar'), Info(choirsInfo),]),

			groupLists,
			groupLists.length == 0 ? buildCells([SearchChoir]) : null,

			// new UserInvitationsView(this.store).view(),

		]);
	}

	function choirAdminView() {
		var user:User = this.store.getUser();

		var groups:Array<Group> = this.store.state.groups.filter(group -> group.admins.indexOf(user.username) > -1);
		if (groups == null || groups.length == 0)
			return null;

		var groupLists = groups.map(group -> buildCells([
			Songlist(group.name, group.songs.map(title -> this.store.getSong(title)), [Group(group.name)]),
			Info('Gruppens nuvarande medlemmar:'),
			ListGroupMembers(group.name),
			Info('Här kan du bjuda in medlemmar till gruppen:'),
			InviteGroupMembers(group.name),
			Info('Här visas ansökningar från användare som vill bli medlemmar gruppen:'),
			ApplicationsToGroup(group.name),

		]));

		return m('div.center', [buildCells([Title('Du leder följande körer'),]), groupLists,]);
	}

	function mySongsView() {
		var user:User = this.store.getUser();
		var mySongs:Array<Song> = user.songs.map(title -> this.store.getSong(title));
		var myList = mySongs.length > 0 ? buildCells([Songlist('Mina låtar', mySongs, [LimitNumber(5)])]) : buildCells([BuySongs]);

		return [
			buildCells([
				Title('Mina låtar'),
				Info('Här visas de låtar som du har köpt eller valt genom förmånserbjudanden.'),
			]),
			myList
		];
	}

	//-------------------------------------------------------------------------------------
	// Hjälpfunktioner för att skapa element på sidan

	function buildCells(cells:Array<HomeCell>) {
		return m('section', cells.map(cell -> {
			return switch cell {
				case Image(url): m('img', {src: url});
				case Title(title): m('h1.limit-width.center', title);
				case Info(info): m('p.limit-width.center', info);
				case Songlist(title, songs, filter): this.songlist(title, songs, filter);
				case SearchChoir:
					// skapa lista för eventuella gruppansökningar för inloggad användare
					// cast [new UserApplicationsView(this.store).view(),];
					new SearchGroupView(this.store).view();
				case BuySongs: m('div.center', [m('button.center', {
						onclick: e -> {
							trace('Click');
						}
					}, 'Gå till butiken'),]);
				case ListGroupMembers(groupname):
					var group:Group = this.store.getGroup(groupname);
					m('div.groupmembers', [m('ul', group.members.map(member -> m('li', member)))]);
				// case InviteGroupMembers(groupname):
				// 	var group:Group = this.store.getGroup(groupname);
				// 	new LeaderInvitationsView(this.store, group).view();
				// case ApplicationsToGroup(groupname):
				// 	var group:Group = this.store.getGroup(groupname);
				// 	new LeaderApplicationsView(this.store, group).view();
				case _: null;
			}
		}));
	}

	function songlist(title:String, songs:Array<Song>, filter:Array<SongFilter>) {
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
