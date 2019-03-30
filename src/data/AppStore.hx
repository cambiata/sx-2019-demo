package data;

import js.Browser;
import haxe.Json;
import ds.ImmutableArray;
import data.Model;

using cx.ArrayItems;

class AppStore extends DeepStateContainer<AppState> {
	public function new(initstate) {
		super(initstate);
	}

	public function save(tag:String = 'store') {
		js.Browser.window.localStorage.setItem(tag, Json.stringify(this.state));
	}

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

			haxe.Timer.delay(() -> {
				this.update(state.userId = foundUser.username);
				this.save();
			}, cx.Random.int(100, 500));
		} catch (e:Dynamic) {
			js.Browser.alert(e);
			this.logout();
		}
	}

	public function addSong(title:String) {
		var newSong:Song = {
			title: title,
			category: SongCategory.Free,
			producer: SongProducer.Korakademin
		};
		this.update(state.songs = state.songs.push(newSong));
	}

	public function logout() {
		this.update(state.userId = null);
		this.save();
	}

	public function getUser(findUsername:String = null):User {
		if (findUsername == null)
			findUsername = this.state.userId;
		return switch this.state.users.filter(u -> u.username == findUsername).first() {
			case Some(v): v;
			case _: null;
		};
	}

	public function getGroup(findGroupname:String):Group {
		return switch this.state.groups.filter(group -> group.name.toLowerCase() == findGroupname.toLowerCase()).first() {
			case Some(v): v;
			case _: null;
		}
	}

	public function getSong(findSongtitle:String):Song {
		return switch this.state.songs.filter(song -> song.title.toLowerCase() == findSongtitle.toLowerCase()).first() {
			case Some(v): v;
			case _: null;
		}
	}

	public function resetToDefaultData() {
		js.Browser.alert('Reset data');
		this.update(this.state = {
			page: Home,
			userId: null,
			users: cast Default.users(),
			groups: cast Default.groups(),
			songs: cast Default.songs(),
		}, 'do reset');
		this.save();
	}
}

typedef AppState = {
	final page:Page;
	// final user:User;
	final userId:String;
	final users:ImmutableArray<User>;
	final groups:ImmutableArray<Group>;
	final songs:ImmutableArray<Song>;
}
