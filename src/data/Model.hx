package data;

import data.KorakademinScorxItems.ScorXItem;
import js.Browser;
import haxe.Json;
import ds.ImmutableArray;

using cx.ArrayItems;
using cx.Validation;

/**
 * Användare
 */
typedef User = {
	final username:String;
	final password:String;
	final firstname:String;
	final lastname:String;
	final sensus:Bool;
	final songs:ds.ImmutableArray<Int>;
}

/**
 * Kör/grupp
 */
typedef Group = {
	final name:String;
	final info:String;
	final admins:ds.ImmutableArray<String>;
	final sensus:Bool;
	final members:ds.ImmutableArray<String>;
	final songs:ds.ImmutableArray<Int>;
}

/**
 * Definition för medlemsansökan till grupp
 */
typedef GroupApplication = {
	final username:String;
	final groupname:String;
	final status:GroupApplicationStatus;
}

/**
 * Status som ansökan kan befinna sig i
 */
enum GroupApplicationStatus {
	Start; // Initialt status - ansökan är skapad men ej skickad till mottagaren
	Pending; // Ansökan är skickad men ej behandlad av mottagaren
	Rejected; // Ansökan är nekad av mottagaren
}

// /**
//  * ScorX-låt
//  */
// typedef Song = {
// 	final title:String;
// 	final category:SongCategory;
// 	final producer:SongProducer;
// }
// /**
//  * Kategori för aktuell ScorX-låt
//  */
// enum SongCategory {
// 	Free;
// 	Protected;
// 	Commercial;
// }
// /**
//  * Producent av aktuell ScorX-låt
//  */
// enum SongProducer {
// 	Korakademin;
// 	Other;
// }
// /**
//  * Filteralternativ för listning av ScorX-låtar
//  * Kombineras på lämpligt stätt i Array<SongFilter>
//  */
// enum SongFilter {
// 	Search(str:String);
// 	Category(cat:SongCategory);
// 	Producer(prod:SongProducer);
// 	Group(groupname:String);
// 	LimitNumber(max:Int);
// }

enum ScorxFilter {
	SelectProductIds(ids:Array<Int>);
	LicenseHolder(lic:String);
	LimitNumber(num:Int);
}

/**
 * Celler som kan visas på hemsidan
 * Kombineras på lämpligt sätt i Array<HomeCell>
 */
enum HomeCell {
	Image(url:String);
	Title(title:String);
	Info(info:String);
	Button(label:String, onclick:js.html.MouseEvent->Void);
	Songlist(title:String, songs:Array<ScorXItem>, filter:Array<ScorxFilter>);
	SearchChoir;
	ListGroupMembers(groupname:String);
	InviteGroupMembers(groupname:String);
	// ApplicationsToGroup(groupname:String);
	BuySongs;
}

/**
 * Demo-applikationens sida (i brist på riktig router)
 */
enum Page {
	Home;
	Email;
	Other;
	CreateUser;
	UserSettings;
}

typedef EmailMessage = {
	final to:String;
	final from:String;
	final type:EmailType;
}

enum EmailType {
	UserAccountActivation(email:String, pass:String, firstname:String, lastname:String);
	UserGroupjoinInfo(groupname:String);
	AdminGroupjoinInfo(joinedUsername:String, groupname:String);
	UserAccountActivationAndGroupjoin(email:String, pass:String, firstname:String, lastname:String, groupname:String);
	AfterUserActivationSuccess;
	SimpleMessage(title:String, text:String);
}

// enum OverlayPage {
// 	SongList(filter:ScorxFilter);
// }

/**
 * Defaultvärden så att vi har något att utgå ifrån
 */
class Default {
	static public function users():Array<User> {
		return [
			{
				firstname: 'Adam',
				lastname: 'Adamsson',
				username: 'adam@adam.se',
				password: 'adam',
				sensus: false,
				songs: [999, 789],
			},
			{
				firstname: 'Beda',
				lastname: 'Bensin',
				username: 'beda@bensin.se',
				password: 'beda',
				sensus: false,
				songs: [],
			},
			{
				firstname: 'Caesar',
				lastname: 'Citrus',
				username: 'caesar@citrus.se',
				password: 'caesar',
				sensus: false,
				songs: [],
			},

			{
				firstname: 'Avledare',
				lastname: 'Jonsson',
				username: 'avledare@kor.se',
				password: 'avledare',
				sensus: false,
				songs: [],
			},

			{
				firstname: 'Örkel1',
				lastname: 'Örkelsson',
				username: 'orkel1@orkel.se',
				password: 'orkel1',
				sensus: false,
				songs: [],
			},
			{
				firstname: 'Örkel2',
				lastname: 'Örkelsson',
				username: 'orkel2@orkel.se',
				password: 'orkel2',
				sensus: false,
				songs: [],
			},
			{
				firstname: 'Örkel3',
				lastname: 'Örkelsson',
				username: 'orkel3@orkel.se',
				password: 'orkel3',
				sensus: false,
				songs: [],
			},
			{
				firstname: 'Örkel4',
				lastname: 'Örkelsson',
				username: 'orkel4@orkel.se',
				password: 'orkel4',
				sensus: false,
				songs: [],
			},

			{
				firstname: 'Bro1',
				lastname: 'Brorsson',
				username: 'bro1@bro.se',
				password: 'bro1',
				sensus: false,
				songs: [],
			},
			{
				firstname: 'Bro2',
				lastname: 'Brorsson',
				username: 'bro2@bro.se',
				password: 'bro2',
				sensus: false,
				songs: [],
			},
			{
				firstname: 'Bro3',
				lastname: 'Brorsson',
				username: 'bro3@bro.se',
				password: 'bro3',
				sensus: false,
				songs: [],
			},
			{
				firstname: 'Bro4',
				lastname: 'Brorsson',
				username: 'bro4@bro.se',
				password: 'bro4',
				sensus: false,
				songs: [],
			},
		];
	}

	static public function applications():Array<GroupApplication> {
		return [];
		// return [{username: 'beda@bensin.se', groupname: 'Örkelhåla kyrkokör', status: Start}];
	}

	static public function invitations():Array<GroupApplication> {
		return [{username: 'beda@bensin.se', groupname: 'Avunda Kyrkokör', status: Pending}];
	}

	static public function groups():Array<Group> {
		return [
			{
				name: 'Örkelhåla kyrkokör',
				info: 'Soli deo gloria. Plus vår körledare.',
				admins: ['orkel1@orkel.se'],
				members: ['adam@adam.se', 'orkel1@orkel.se', 'orkel2@orkel.se', 'orkel3@orkel.se',],
				sensus: true,
				songs: [56, 397, 58, 59, 1357, 975, 2405],
			},
			{
				name: 'Bromölla Bandidos',
				info: 'Vi sjunger - ni pröjsar!',
				admins: [],
				members: [],
				sensus: true,
				songs: [1993, 1377, 639],
			},
			{
				name: 'Lingonbergens sångfåglar',
				info: 'Vi trallar så glatt! Vill du va me?',
				admins: [],
				members: [],
				sensus: true,
				songs: [2096, 250, 63, 2315],
			},
			{
				name: 'Avunda Kyrkokör',
				info: 'Ju mer förr, desto bättre!',
				admins: ['avledare@kor.se'],
				members: [],
				sensus: true,
				songs: [1784, 1778, 1780, 2467, 64, 1288, 598],
			},
			{
				name: 'Nya kören, Hässleholm',
				info: 'Information...',
				admins: [],
				members: [],
				sensus: true,
				songs: [],
			},
			{
				name: 'Nya kören, Hallandsåsen',
				info: 'Information...',
				admins: [],
				members: [],
				sensus: true,
				songs: [],
			},
		];
	}

	static public function messages() {
		return [ // {to: 'new@new.se', from: 'orkel1@orkel.se', type: EmailType.UserAccountActivation('new@new.se', 'pass12345', 'Nyamko', 'Neebie'),},
			// {to: 'adam@adam.se', from: 'orkel1@orkel.se', type: EmailType.UserGroupjoinInfo('Örkelhåla'),},
			// {
			// 	to: 'new@new.se',
			// 	from: 'orkel1@orkel.se',
			// 	type: EmailType.UserAccountActivationAndGroupjoin('new@new.se', 'pass1234', 'Nyamko', 'Neebie', 'Nisselunda'),
			// },
			// {to: 'adam@adam.se', from: 'orkel1@orkel.se', type: EmailType.AdminGroupjoinInfo('adam@adam.se', 'Nisselunda'),},
			// {to: 'adam@adam.se', from: 'beda@beda.se', type: EmailType.SimpleMessage('Hej snygging!', 'Ska vi ta en fika? :-) / Beda')},
		];
	}
}
