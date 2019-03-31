package data;

typedef User = {
	final username:String;
	final password:String;
	final firstname:String;
	final lastname:String;
	final sensus:Bool;
	final songs:ds.ImmutableArray<String>;
	final groups:ds.ImmutableArray<String>;
}

typedef Group = {
	final name:String;
	final info:String;
	final admins:ds.ImmutableArray<String>;
	final sensus:Bool;
	final members:ds.ImmutableArray<String>;
	final songs:ds.ImmutableArray<String>;
}

enum GroupApplicationStatus {
	Start;
	Pending;
	// Accepted; // Not needed in demo
	Rejected;
}

typedef GroupApplication = {
	final username:String;
	final groupname:String;
	final status:GroupApplicationStatus;
}

typedef Song = {
	final title:String;
	final category:SongCategory;
	final producer:SongProducer;
}

enum Page {
	Home;
	Other;
	CreateUser;
}

enum SongCategory {
	Free;
	Protected;
	Commercial;
}

enum SongProducer {
	Korakademin;
	Other;
}

enum SongFilter {
	Search(str:String);
	Category(cat:SongCategory);
	Producer(prod:SongProducer);
	Group(groupname:String);
	LimitNumber(max:Int);
}

enum HomeCell {
	Image(url:String);
	Title(title:String);
	Info(info:String);
	Button(label:String, onclick:js.html.MouseEvent->Void);
	Songlist(title:String, songs:Array<Song>, filter:Array<SongFilter>);
	SearchChoir;
	BuySongs;
}

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
				groups: ['Örkelhåla kyrkokör', 'Bromölla Bandidos']
			},
			{
				firstname: 'Beda',
				lastname: 'Bensin',
				username: 'beda@bensin.se',
				password: 'beda',
				sensus: false,
				songs: ['Örkelhåla kyrkokör'],
				groups: []
			},
			{
				firstname: 'Örkel1',
				lastname: 'Örkelsson',
				username: 'orkel1@orkel.se',
				password: 'orkel1',
				sensus: false,
				songs: [],
				groups: []
			},
			{
				firstname: 'Örkel2',
				lastname: 'Örkelsson',
				username: 'orkel2@orkel.se',
				password: 'orkel2',
				sensus: false,
				songs: [],
				groups: []
			},
			{
				firstname: 'Örkel3',
				lastname: 'Örkelsson',
				username: 'orkel3@orkel.se',
				password: 'orkel3',
				sensus: false,
				songs: [],
				groups: []
			},
			{
				firstname: 'Örkel4',
				lastname: 'Örkelsson',
				username: 'orkel4@orkel.se',
				password: 'orkel4',
				sensus: false,
				songs: [],
				groups: []
			},

			{
				firstname: 'Bro1',
				lastname: 'Brorsson',
				username: 'bro1@bro.se',
				password: 'bro1',
				sensus: false,
				songs: [],
				groups: []
			},
			{
				firstname: 'Bro2',
				lastname: 'Brorsson',
				username: 'bro2@bro.se',
				password: 'bro2',
				sensus: false,
				songs: [],
				groups: []
			},
			{
				firstname: 'Bro3',
				lastname: 'Brorsson',
				username: 'bro3@bro.se',
				password: 'bro3',
				sensus: false,
				songs: [],
				groups: []
			},
			{
				firstname: 'Bro4',
				lastname: 'Brorsson',
				username: 'bro4@bro.se',
				password: 'bro4',
				sensus: false,
				songs: [],
				groups: []
			},
		];
	}

	static public function groups():Array<Group> {
		return [
			{
				name: 'Örkelhåla kyrkokör',
				info: 'Soli deo gloria. Plus vår körledare.',
				admins: ['orkel1@orkel.se'],
				members: ['orkel1@orkel.se', 'orkel2@orkel.se', 'orkel3@orkel.se',],
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
				admins: [],
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
