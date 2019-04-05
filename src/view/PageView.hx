package view;

import data.KorakademinScorxItems;
import data.Model;
import data.AppStore;
import view.*;

class PageView extends AppBaseView {
	var home:HomeView;
	var selectSongs:SelectSongsView;

	// var create:CreateUserView;
	// var email:EmailView;
	// var other:SearchChoirView;

	public function new(store:AppStore) {
		super(store);
		this.home = new HomeView(store);
		this.selectSongs = new SelectSongsView(store,
			KorakademinScorxItems.songs()
				.map(song -> {song: song, access: GroupPrivilege(song.scorxProductId, null)}), []); // this.create = new CreateUserView(store);

		// this.email = new EmailView(store);
		// this.other = new SearchChoirView(store);
	}

	public function view() {
		return switch this.store.state.page {
			case Page.Home: this.home.view();
			case Page.CreateUser: new CreateUserView(this.store).view(); // this.create.view();
			case Page.Email: new EmailView(this.store).view();
			case Page.Other: this.selectSongs.view();
			/*new SongListView(this.store, 'Körakademins låtar', KorakademinScorxItems.items(), [ScorxFilter
				.SelectProductIds([3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14]),]).view(); */
			case Page.UserSettings: new UserSettingsView(this.store).view();
			case _: null;
		}
	}
}
