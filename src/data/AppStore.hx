package data;

import js.Browser;
import haxe.Json;
import ds.ImmutableArray;
import data.Model;

using cx.ArrayItems;
using cx.Validation;

/**
 * Applikationens state-objekt (à la Redux)
 */
typedef AppState = {
	/**
	 * userId = inloggad användares e-postadress
	 * Om värdet är null så finns ingen inloggad användare
	 */
	final userId:String;

	/**
	 * Lista med användare
	 */
	final users:ImmutableArray<User>;

	/**
	 * Lista med grupper
	 */
	final groups:ImmutableArray<Group>;
	/**
	 * Lista med gruppansökningar, skapade av användare som vill bli medlem i grupp
	 */
	// final applications:ImmutableArray<GroupApplication>;
	/**
	 * Lista med gruppinbjudningar, skapade av ledare som vill bjuda in användare till sin grupp
	 */
	// final invitations:ImmutableArray<GroupApplication>;

	/**
	 * Lista med låtar
	 */
	final songs:ImmutableArray<Song>;

	/**
	 * Lista med "e-postmeddelanden"
	 */
	final messages:ImmutableArray<EmailMessage>;

	/**
	 * Info om aktuell "sida", i brist på riktig url-router i denna demo
	 */
	final page:Page;
}

/**
 * AppStore
 * Demosystemets state-hanterare (à la Redux)
 * Fungerar även som databas som jobbar gentemot browserns localStorage
 */
class AppStore extends DeepStateContainer<AppState> {
	public function new(initstate) {
		super(initstate);
	}

	/**
	 * Sparar state till localStorage
	 * @param tag
	 */
	public function save(tag:String = 'store') {
		js.Browser.window.localStorage.setItem(tag, Json.stringify(this.state));
	}

	/**
	 * Laddar state från localStorage
	 * Första körningen, när localStorage är tomt, sparas först defaultdata
	 * @param tag
	 */
	public function load(tag:String = 'store') {
		try {
			var stateObj = Json.parse(js.Browser.window.localStorage.getItem(tag));
			if (stateObj == null) {
				this.resetToDefaultData();
			} else
				this.update(this.state = stateObj, this.state.page = Home);
		} catch (e:Dynamic) {
			Browser.alert('Could not load state object form localStorage! $e');
		}
	}

	/**
	 * Lägger till användare i state.users
	 * @param user
	 */
	public function addUser(user:User) {
		try {
			if (this.state.users.filter(u -> u.username == user.username).length > 0)
				throw 'The username ${user.username} already exists!';

			this.update(state.users = state.users.copy().push(user));
			this.save();
		} catch (e:Dynamic) {
			js.Browser.alert(e);
		}
	}

	/**
	 * Prövar logga in med användarnamn och lösenord
	 * Ifall användaren existerar så sätts state.userId
	 * @param tryUsername
	 * @param tryPassword
	 */
	public function tryLogin(tryUsername:String, tryPassword:String) {
		try {
			trace(tryUsername);
			trace(this.state.users.length);
			var foundUser:User = switch this.state.users.filter(u -> {
				return u.username == tryUsername;
			}).first() {
				case Some(user): user;
				case _: null;
			};

			if (foundUser == null)
				throw 'User $tryUsername does not exist';
			if (foundUser.password != tryPassword)
				throw 'Password is wrong $foundUser : ' + foundUser.password + ' ' + tryPassword;

			// Success! :-)
			haxe.Timer.delay(() -> { // simulera fördrörjning vid inloggning
				this.update(state.userId = foundUser.username);
				this.save();
				this.gotoPage(Page.Home);
			}, cx.Random.int(100, 500));
		} catch (e:Dynamic) {
			js.Browser.alert(e);
			this.logout();
		}
	}

	/**
	 * Logga ut användare
	 */
	public function logout() {
		this.update(state.userId = null);
		this.save();
	}

	/**
	 * Lägg till scorx-låt i state.songs
	 * @param title
	 */
	public function addSong(title:String) {
		var newSong:Song = {
			title: title,
			category: SongCategory.Free,
			producer: SongProducer.Korakademin
		};
		this.update(state.songs = state.songs.push(newSong));
	}

	/**
	 * Hämta User-object för aktuellt användarnamn
	 * @param findUsername
	 * @return User
	 */
	public function getUser(findUsername:String = null):User {
		if (findUsername == null)
			findUsername = this.state.userId;
		return switch this.state.users.filter(u -> u.username == findUsername).first() {
			case Some(v): v;
			case _: null;
		};
	}

	/**
	 * Hämta Group-objekt för aktuellt gruppnamn
	 * @param findGroupname
	 * @return Group
	 */
	public function getGroup(findGroupname:String):Group {
		return switch this.state.groups.filter(group -> group.name.toLowerCase() == findGroupname.toLowerCase()).first() {
			case Some(v): v;
			case _: null;
		}
	}

	/**
	 * Hämta Song-objekt för aktuell sång-titel
	 * @param findSongtitle
	 * @return Song
	 */
	public function getSong(findSongtitle:String):Song {
		return switch this.state.songs.filter(song -> song.title.toLowerCase() == findSongtitle.toLowerCase()).first() {
			case Some(v): v;
			case _: null;
		}
	}

	// /**
	//  * Lägg gruppansökan till state.applications
	//  * @param item
	//  */
	// public function addApplication(item:GroupApplication) {
	// 	try {
	// 		if (this.state.applications.filter(a -> a.groupname == item.groupname && a.username == item.username).length > 0)
	// 			throw "Ansökan till denna grupp finns redan!";
	// 		this.update(this.state.applications = this.state.applications.push(item));
	// 		this.save();
	// 	} catch (e:Dynamic) {
	// 		Browser.alert(e);
	// 	}
	// }
	// /**
	//  * Slutför gruppansökan genom att
	//  * 1. Lägga till aktuell användare till group.members
	//  * 2. Ta bort ansökan från state.applications
	//  * @param application
	//  */
	// public function addUsernameToGroupFromLeaderInvitation(application:GroupApplication) {
	// 	try {
	// 		var group:Group = this.getGroup(application.groupname);
	// 		if (group == null)
	// 			throw "Can not resolve application to group " + application.groupname;
	// 		if (group.members.filter(member -> member == application.username).length > 0)
	// 			throw 'User ${application.username} is already a member of ${application.groupname}';
	// 		var groupIndex = this.state.groups.indexOf(group);
	// 		var members = group.members.push(application.username);
	// 		this.update(state.groups[groupIndex].members = members,
	// 			state.invitations = cast state.invitations.filter(app -> app.groupname != application.groupname
	// 				&& app.username != application.username));
	// 		this.save();
	// 	} catch (e:Dynamic) {
	// 		Browser.alert(e);
	// 	}
	// }
	// /**
	//  * Slutför gruppansökan genom att
	//  * 1. Lägga till aktuell användare till group.members
	//  * 2. Ta bort ansökan från state.applications
	//  * @param application
	//  */
	// public function addUsernameToGroupFromUserApplication(application:GroupApplication) {
	// 	try {
	// 		var group:Group = this.getGroup(application.groupname);
	// 		if (group == null)
	// 			throw "Can not resolve application to group " + application.groupname;
	// 		if (group.members.filter(member -> member == application.username).length > 0)
	// 			throw 'User ${application.username} is already a member of ${application.groupname}';
	// 		var groupIndex = this.state.groups.indexOf(group);
	// 		var members = group.members.push(application.username);
	// 		this.update(state.groups[groupIndex].members = members,
	// 			state.applications = cast state.applications.filter(app -> app.groupname != application.groupname
	// 				&& app.username != application.username));
	// 		this.save();
	// 	} catch (e:Dynamic) {
	// 		Browser.alert(e);
	// 	}
	// }
	// /**
	//  * Ta bort ansökan
	//  * @param item
	//  */
	// public function removeApplication(item:GroupApplication) {
	// 	try {
	// 		this.update(this.state.applications = this.state.applications.remove(item));
	// 		this.save();
	// 	} catch (e:Dynamic) {
	// 		Browser.alert(e);
	// 	}
	// }
	// /**
	//  * Lägg till inbjudan till state.invitations
	//  * @param item
	//  */
	// public function addInvitation(item:GroupApplication) {
	// 	try {
	// 		item.username.validateAsEmail();
	// 		if (this.isMemberOfGroup(item.username, item.groupname))
	// 			throw '${item.username} är redan medlem i ${item.groupname}';
	// 		if (this.state.invitations.filter(a -> a.groupname == item.groupname && a.username == item.username).length > 0)
	// 			throw 'Ansökan till ${item.groupname} från ${item.username} finns redan!';
	// 		this.update(this.state.invitations = this.state.invitations.push(item));
	// 		this.save();
	// 	} catch (e:Dynamic) {
	// 		Browser.alert(e);
	// 	}
	// }
	// /**
	//  * Ta bort inbjudan
	//  * @param item
	//  */
	// public function removeInvitation(item:GroupApplication) {
	// 	try {
	// 		this.update(this.state.invitations = this.state.invitations.remove(item));
	// 		this.save();
	// 	} catch (e:Dynamic) {
	// 		Browser.alert(e);
	// 	}
	// }
	// /**
	//  * Ändra ansökans status
	//  * @param item
	//  * @param newStatus
	//  */
	// public function changeApplicationStatus(item:GroupApplication, newStatus:GroupApplicationStatus) {
	// 	try {
	// 		var index = this.state.applications.indexOf(item);
	// 		trace(index);
	// 		if (index < 0)
	// 			throw 'Denna ansökan verkar inte finnas i ansökningstabellen';
	// 		var newItem:GroupApplication = {
	// 			groupname: item.groupname,
	// 			username: item.username,
	// 			status: newStatus
	// 		};
	// 		this.update(this.state.applications[index] = newItem);
	// 		trace(this.state.applications);
	// 		this.save();
	// 	} catch (e:Dynamic) {
	// 		Browser.alert(e);
	// 	}
	// }
	// /**
	//  * Ändra inbjudans status
	//  * @param item
	//  * @param newStatus
	//  */
	// public function changeInvitationStatus(item:GroupApplication, newStatus:GroupApplicationStatus) {
	// 	// try {
	// 	// 	var invitationIndex = this.state.invitations.indexOf(item);
	// 	// 	trace(invitationIndex);
	// 	// 	if (invitationIndex < 0)
	// 	// 		throw 'Denna ansökan verkar inte finnas i inbjudningstabellen';
	// 	// 	var newItem:GroupApplication = {
	// 	// 		groupname: item.groupname,
	// 	// 		username: item.username,
	// 	// 		status: newStatus
	// 	// 	};
	// 	// 	this.update(this.state.invitations[invitationIndex] = newItem);
	// 	// 	trace(this.state.invitations);
	// 	// 	this.save();
	// 	// } catch (e:Dynamic) {
	// 	// 	Browser.alert(e);
	// 	// }
	// }

	public function handleMessageClicks(mess:EmailMessage) {
		// js.Browser.alert('Handle message click: ' + mess);

		try {
			switch mess.type {
				case UserAccountActivation(email, password, firstname, lastname):
					var newUser:User = {
						username: email,
						password: password,
						firstname: firstname,
						lastname: lastname,
						sensus: false,
						songs: []
					};
					this.addUser(newUser);
					js.Browser.alert('Kontot har skapats och ett bekräftelsemejl skickas till användaren.');
					this.sendEmailMessage({
						to: email,
						from: 'admin@scorx.org',
						type: AfterUserActivationSuccess,
					});

				case UserGroupjoinInfo(groupname):
				case AdminGroupjoinInfo(joinedUsername, groupname):
				case UserAccountActivationAndGroupjoin(email, pass, firstname, lastname, groupname):
				case AfterUserActivationSuccess:
					this.gotoPage(Page.Home);
					js.Browser.alert('Användaren har klickat på sitt Välkommen-meddelande.');
				case SimpleMessage(title, text):
			}
		} catch (e:Dynamic) {
			js.Browser.alert(e);
		}
	}

	public function sendEmailMessage(mess:EmailMessage) {
		trace(this.state.messages.length);
		this.update(this.state.messages = this.state.messages.push(mess));
		trace(this.state.messages.length);
		this.save();
	}

	/**
	 * Kontrollera ifall användare är medlem i grupp
	 * @param username
	 * @param groupname
	 * @return Bool
	 */
	public function isMemberOfGroup(username:String, groupname:String):Bool {
		var group = this.getGroup(groupname);
		if (group.members.filter(member -> member == username).length > 0)
			return true;
		return false;
	}

	/**
	 * Kontrollera ifall användare existerar i state.users
	 * @param username
	 */
	public function userExists(username:String) {
		return this.state.users.filter(user -> user.username == username).length == 1;
	}

	public function gotoPage(page:Page) {
		this.update(this.state.page = page);
	}

	/**
	 * Nollställ local-storage-databasen till default-värden
	 */
	public function resetToDefaultData() {
		trace('Reset data');
		this.update(this.state = {
			page: Home,
			userId: null,
			users: cast Default.users(),
			groups: cast Default.groups(),
			// applications: cast Default.applications(),
			// invitations: cast Default.invitations(),
			songs: cast Default.songs(),
			messages: cast Default.messages(),
		}, 'do reset');
		this.save();
	}
}
