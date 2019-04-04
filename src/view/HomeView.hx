package view;

import data.KorakademinScorxItems;
import js.Browser;
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
		return this.store.state.userId == null ? this.guestView() : cast this.userView();
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

				Infoblobs([
					Infoblob.Standard('Har du prövat?', 'Klicka här för att...'),
					Infoblob.Standard('Titta här!', 'Skulle inte du också vilja åka till...'),
					Infoblob.Standard('Vill du veta mer?', 'Undrar du över något? klicka här!')
				]),
				Image('assets/img/happy.jpg'),
				Title('Pröva ScorX gratis!'),
				Info('Klicka på valfri titel i listan nedan, lyssna och sjung med!'),
				Songlist('Gratislåtar', KorakademinScorxItems.items(), [LicenseHolder('Upphovsrättsfri')]),
			]),
		];
	}

	//-------------------------------------------------------------------------------------

	/**
	 * Returnera vyer för inloggad användare
	 */
	function userView() {
		return [choirAdminView(), choirMemberView(), mySongsView()];
	}

	function choirMemberView() {
		var user:User = this.store.getUser();

		var groups:Array<Group> = this.store.state.groups.filter(group -> group.members.indexOf(user.username) > -1);

		// filtrera bort så att inte ledarna ser denna vy,
		// de ser ju samma grupp i choirAdminsView()
		groups = groups.filter(group -> {
			!(group.admins.indexOf(user.username) > -1);
		});

		var groupLists = groups.map(group -> buildCells([
			Songlist(group.name, KorakademinScorxItems.items(), [SelectProductIds(group.songs)]),
		]));

		var choirsInfo = groupLists
			.length > 0 ? 'Här visas de låtar som delats ut till dig av dina körer.' : 'Du verkar inte vara deltagare i någon kör eller grupp i ScorX.';

		return [
			buildCells([
				Infoblobs([
					Infoblob.Standard('Hej Körsångare', 'Klicka här för att...'),
					Infoblob.Standard('1000 låtar gratis!', 'Körakademin Plus är stället för dej!'),
					Infoblob.Standard('Vad betyder "con tenerezza"?', 'Undrar du över något? klicka här!')
				]),

			]),
			buildCells([Title('Körernas låtar'), Info(choirsInfo),]),

			groupLists,
			groupLists.length == 0 ? buildCells([SearchChoir]) : null,

			// new UserInvitationsView(this.store).view(),
		];
	}

	function choirAdminView() {
		var user:User = this.store.getUser();

		var groups:Array<Group> = this.store.state.groups.filter(group -> group.admins.indexOf(user.username) > -1);
		if (groups == null || groups.length == 0)
			return null;

		var groupLists = groups.map(group -> buildCells([
			Songlist(group.name, KorakademinScorxItems.items(), [SelectProductIds(group.songs)]),
			ListGroupMembers(group.name),
			InviteGroupMembers(group.name),

		]));

		return [buildCells([Title('Du leder följande körer'),]), groupLists,];
	}

	function mySongsView() {
		var user:User = this.store.getUser();
		// var mySongs:Array<Song> = user.songs.map(title -> this.store.getSong(title));
		// var myList = buildCells([Songlist('Mina låtar', KorakademinScorxItems.items(), [LimitNumber(5)])]) : buildCells([BuySongs]);

		return [
			buildCells([
				Title('Mina låtar'),
				Info('Här visas de låtar som du har köpt eller valt genom förmånserbjudanden.'),
				Songlist('Mina låtar', KorakademinScorxItems.items(), [SelectProductIds(user.songs)]),
				BuySongs,
			]),
		];
	}

	//-------------------------------------------------------------------------------------
	// Hjälpfunktioner för att skapa element på sidan

	function buildCells(cells:Array<HomeCell>) {
		return m('section', cells.map(cell -> {
			return switch cell {
				case Image(url): m('img', {src: url});
				case Title(title): m('h1.center-narrow.vspace', title);
				case Info(info): m('h3.center-narrow.vspace', info);
				case Songlist(title, songs, filter):
					m('div.centerpad', new SongListView(this.store, title, songs, filter).view());
				case SearchChoir:
					// skapa lista för eventuella gruppansökningar för inloggad användare
					// cast [new UserApplicationsView(this.store).view(),];
					new SearchGroupView(this.store,
						'Skriv körens namn i listan för att hitta din kör. Klicka därefter på körens namn för att ansluta dig till gruppen.', group -> {
						this.store.addGroupMember(this.store.state.userId, group.name);
						// group.admins.map(admin->this.store.sendEmailMessage({to:admin.username, from:'admin@scorx.org', })
						this.store.sendEmailMessage({to: this.store.state.userId, from: 'admin@scorx.org', type: EmailType.UserGroupjoinInfo(group.name)});
						group.admins.map(admin -> {
							this.store.sendEmailMessage({
								to: admin,
								from: 'admin@scorx.org',
								type: EmailType.AdminGroupjoinInfo(this.store.state.userId, group.name)
							});
						});
					}).view();
				case BuySongs: m('div.center', [m('button.center', {
						onclick: e -> {
							trace('Click');
						}
					}, 'Gå till butiken'),]);
				case ListGroupMembers(groupname):
					var group:Group = this.store.getGroup(groupname);
					this.detailsSummary('Gruppens medlemmar', [m('ul', group.members.map(member -> m('li', member)))]);

				case InviteGroupMembers(groupname):
					var group:Group = this.store.getGroup(groupname);
					this.detailsSummary('Bjud in medlemmar', new LeaderInviteUsers(this.store, group).view());

				// 	var group:Group = this.store.getGroup(groupname);
				// 	new LeaderInvitationsView(this.store, group).view();
				// case ApplicationsToGroup(groupname):
				// 	var group:Group = this.store.getGroup(groupname);
				// 	new LeaderApplicationsView(this.store, group).view();
				// Array<{title:String, info:String, link:String}>
				case Infoblobs(blobs):
					m('div.infoblobs-wide', m('div.infoblobs.centerdiv', blobs.map(blob -> {
						return switch blob {
							case Infoblob.Standard(title, info): m('div.infoblob',
									m('div.infoblob-content', [m('div.infoblob-title', title), m('div.infoblob-info', info)]));
						}
					})));

				case _: null;
			}
		}));
	}

	// function songlist(title:String, songs:Array<Song>, filter:Array<SongFilter>) {
	// 	// var songs = this.store.state.songs.copy();
	// 	var totalNumber:Int = songs.length;
	// 	for (f in filter) {
	// 		switch f {
	// 			case Search(str):
	// 			case Category(cat):
	// 				songs = songs.filter(song -> {
	// 					return song.category.getName() == cat.getName();
	// 				});
	// 			case Producer(prod):
	// 				songs = songs.filter(song -> song.producer == prod);
	// 			case Group(groupname):
	// 				var group:Group = this.store.getGroup(groupname);
	// 				songs = group.songs.map(songtitle -> this.store.getSong(songtitle));
	// 				totalNumber = songs.length;
	// 			case LimitNumber(max):
	// 				// songs = songs.splice(max, 10000);
	// 				songs = songs.slice(0, 5);
	// 		}
	// 	}
	// 	return m('article.center', [
	// 		m('header', m('span', title), m('input[placeholder=Sök]')),
	// 		m('ul', songs.filter(song -> song != null).map(song -> m('li', [
	// 			m('.thumb', m('img', {src: 'assets/scorx/${song.producer.getName()}.png'})),
	// 			m('.title', [m('h3', song.title), m('p', 'Information...')]),
	// 			m('.originators', 'Originators'),
	// 		]))),
	// 		m('footer', [m('button', {onclick: e -> {}}, 'Visa alla ${totalNumber}'),]),
	// 	]);
	// }
}
