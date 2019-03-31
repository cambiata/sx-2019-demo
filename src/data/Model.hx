package data;

import js.Browser;
import haxe.Json;
import ds.ImmutableArray;

using cx.ArrayItems;
using cx.Validation;

/**
 * Applikationens state-objekt (à la Redux)
 */
typedef AppState = {
	final page:Page;
	final userId:String;
	final users:ImmutableArray<User>;
	final groups:ImmutableArray<Group>;
	final applications:ImmutableArray<GroupApplication>;
	final invitations:ImmutableArray<GroupApplication>;
	final songs:ImmutableArray<Song>;
}

/**
 * Användare
 */
typedef User = {
	final username:String;
	final password:String;
	final firstname:String;
	final lastname:String;
	final sensus:Bool;
	final songs:ds.ImmutableArray<String>;
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
	final songs:ds.ImmutableArray<String>;
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

/**
 * ScorX-låt
 */
typedef Song = {
	final title:String;
	final category:SongCategory;
	final producer:SongProducer;
}

/**
 * Kategori för aktuell ScorX-låt
 */
enum SongCategory {
	Free;
	Protected;
	Commercial;
}

/**
 * Producent av aktuell ScorX-låt
 */
enum SongProducer {
	Korakademin;
	Other;
}

/**
 * Filteralternativ för listning av ScorX-låtar
 * Kombineras på lämpligt stätt i Array<SongFilter>
 */
enum SongFilter {
	Search(str:String);
	Category(cat:SongCategory);
	Producer(prod:SongProducer);
	Group(groupname:String);
	LimitNumber(max:Int);
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
	Songlist(title:String, songs:Array<Song>, filter:Array<SongFilter>);
	SearchChoir;
	ListGroupMembers(groupname:String);
	InviteGroupMembers(groupname:String);
	BuySongs;
}

/**
 * Demo-applikationens sida (i brist på riktig router)
 */
enum Page {
	Home;
	Other;
	CreateUser;
}

/**
 * Defaultvärden för localStorage-databasen
 */
class Default {
	static public function users():Array<User> {
		return [
			{
				firstname: 'Adam',
				lastname: 'Adamsson',
				username: 'adam@adam.se',
				password: 'adam1',
				sensus: false,
				songs: ['Kommersiell06', 'Kommersiell07'],
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
		return [{username: 'beda@bensin.se', groupname: 'Örkelhåla kyrkokör', status: Start}];
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
				songs: ['Sensus01', 'Sensus02', 'Sensus03'],
			},
			{
				name: 'Bromölla Bandidos',
				info: 'Vi sjunger - ni pröjsar!',
				admins: [],
				members: [],
				sensus: true,
				songs: ['Kommersiell01', 'Sensus01'],
			},
			{
				name: 'Lingonbergens sångfåglar',
				info: 'Vi trallar så glatt! Vill du va me?',
				admins: [],
				members: [],
				sensus: true,
				songs: ['Kommersiell01', 'Sensus01'],
			},
			{
				name: 'Avunda Kyrkokör',
				info: 'Ju mer förr, desto bättre!',
				admins: ['avledare@kor.se'],
				members: [],
				sensus: true,
				songs: ['Kommersiell01', 'Sensus01'],
			},
			{
				name: 'Nya kören, Hässleholm',
				info: 'Information...',
				admins: [],
				members: [],
				sensus: true,
				songs: ['Kommersiell01', 'Sensus01'],
			},
			{
				name: 'Nya kören, Hallandsåsen',
				info: 'Information...',
				admins: [],
				members: [],
				sensus: true,
				songs: ['Kommersiell01', 'Sensus01'],
			},
		];
	}

	static public function songs():Array<Song> {
		return [
			{title: 'Ave veum corpus', category: Free, producer: Korakademin}, {title: 'Kommersiell titel', category: Commercial, producer: Other},

			{title: 'Gratis01', category: Free, producer: Korakademin}, {title: 'Gratis02', category: Free, producer: Korakademin},
			{title: 'Gratis03', category: Free, producer: Korakademin}, {title: 'Gratis04', category: Free, producer: Korakademin},
			{title: 'Gratis05', category: Free, producer: Korakademin}, {title: 'Gratis06', category: Free, producer: Other},
			{title: 'Gratis07', category: Free, producer: Other}, {title: 'Gratis08', category: Free, producer: Other},
			{title: 'Gratis09', category: Free, producer: Other}, {title: 'Gratis10', category: Free, producer: Other},
			{title: 'Gratis11', category: Free, producer: Other}, {title: 'Kommersiell01', category: Commercial, producer: Other},

			{title: 'Kommersiell02', category: Commercial, producer: Other}, {title: 'Kommersiell03', category: Commercial, producer: Other},
			{title: 'Kommersiell04', category: Commercial, producer: Other}, {title: 'Kommersiell05', category: Commercial, producer: Other},
			{title: 'Kommersiell06', category: Commercial, producer: Other}, {title: 'Kommersiell07', category: Commercial, producer: Other},
			{title: 'Kommersiell08', category: Commercial, producer: Other}, {title: 'Sensus01', category: Commercial, producer: Korakademin},

			{title: 'Sensus02', category: Commercial, producer: Korakademin}, {title: 'Sensus03', category: Commercial, producer: Korakademin},
			{title: 'Sensus04', category: Commercial, producer: Korakademin}, {title: 'Sensus05', category: Commercial, producer: Korakademin},
		];
	}
}
