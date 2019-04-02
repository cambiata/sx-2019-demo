package view;

import data.Model;
import data.AppStore;
import view.*;

class PageView extends AppBaseView {
	var home:HomeView;

	// var create:CreateUserView;
	// var email:EmailView;
	// var other:SearchChoirView;

	public function new(store:AppStore) {
		super(store);
		this.home = new HomeView(store);
		// this.create = new CreateUserView(store);
		// this.email = new EmailView(store);
		// this.other = new SearchChoirView(store);
	}

	public function view() {
		return switch this.store.state.page {
			case Page.Home: this.home.view();
			case Page.CreateUser: new CreateUserView(this.store).view(); // this.create.view();
			case Page.Email: new EmailView(this.store).view();
			case Page.Other: new SearchGroupView(this.store, group -> trace('Group ' + group)).view();
			case _: null;
		}
	}
}
