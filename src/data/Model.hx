/**
 * Datamodeller i Scorx 2019 Demo
 * data.Model.hx
 *
 * Jonas Nyström
 */

package data; // Model.hx

import js.Browser;
import haxe.Json;
import ds.ImmutableArray;
import data.KorakademinScorxItems;

using cx.ArrayItems;
using cx.Validation;

/**
 * Användare
 */
typedef User = {
	final username:String; // e-post - används som primärnyckel för användare i demon
	final password:String;
	final firstname:String;
	final lastname:String;
	final sensus:SensusUser; // status för Sensus-deltagarskap, null = ej Sensus-deltagare
	final userSongs:ds.ImmutableArray<ScorxAccess>;
}

/**
 * Flagga för att sensus-status
 * används för att ha möjlighet att skilja ut overifierade sensusdeltagare
 */
enum SensusUser {
	UserClaimed; // Användaren har själv flaggat sig som Sensus-deltagare
	SensusVerified; // Anv är bekräftad efter kontroll mot Sensus adm system
}

/**
 * Grupp
 */
typedef Group = {
	final name:String; // 'name' fungerar som primärnyckel i denna demo
	final info:String;
	final admins:ds.ImmutableArray<String>;
	final members:ds.ImmutableArray<String>;
	final groupSongs:ds.ImmutableArray<ScorxAccess>;
}

/**
 * ScorxAccess definierar hur en låt har gjorts tillgänglig för en användare eller grupp
 */
enum ScorxAccess {
	FreeItem(scorxProductId:Int, provider:String);
	UserPurchase(scorxProductId:Int, expires:Date);
	UserPrivilege(scorxProductId:Int, privilege:UserPrivilegeType);
	GroupPurchase(scorxProductId:Int, expires:Date, validOnlyForTheseMembers:ds.ImmutableArray<String>);
	GroupPrivilege(scorxProductId:Int, privilege:GroupPrivilegeType);
}

/**
 * Detaljer om UserPrivilege - vilken typ av förmånserbjudande ligger till grund för att
 * användaren får tillgång till aktuell tillgång
 */
enum UserPrivilegeType {
	KorakademinUserAccess;
	ScorxLotteryLifetimeAccess;
}

/**
 * Detaljer om GroupPrivilege - vilken typ av förmånserbjudande ligger till grund för att
 * gruppen får tillgång till aktuell låt
 */
enum GroupPrivilegeType {
	KorakademinGroupAccess;
}

/**
 * Hjälpfunktioner för ScorxAccess
 */
class ScorxAccessUtils {
	static public function getProductId(access:ScorxAccess):Int {
		var productId:Int = switch access {
			case FreeItem(scorxProductId, provider): scorxProductId;
			case UserPurchase(scorxProductId, expires): scorxProductId;
			case UserPrivilege(scorxProductId, privilege): scorxProductId;
			case GroupPurchase(scorxProductId, expires, validOnlyForTheseMembers): scorxProductId;
			case GroupPrivilege(scorxProductId, privilege): scorxProductId;
		}
		return productId;
	}

	static public function getAccessListItem(access:ScorxAccess):ScorxAccessListItem {
		var productId:Int = ScorxAccessUtils.getProductId(access);
		var song:ScorxItem = KorakademinScorxItems.getSong(productId);
		var listItem:ScorxAccessListItem = {access: access, song: song};
		return listItem;
	}
}

/**
 * ScorxItem = Scorx-låt
 * OBS, ej komplett definition - denna bygger på Körakademins excel-låtlista
 * Men, good enough för demon
 */
typedef ScorxItem = {
	final scorxProductId:Int;
	final title:String;
	final composer:String;
	final lyricist:String;
	final arranger:String;
	final ensemble:String;
	final language:String;
	final licenseholder:String;
	final playProducer:String;
	final paskmusik:String;
	final julmusik:String;
	final shopLink:String;
	final externalLink:String;
}

/**
 * Kombination av ScorxItem och ScorxAccess
 * Används som Array<{song:ScorxItem, access:ScorxAccess} för att populera låtlistorna
 */
typedef ScorxAccessListItem = {
	final song:ScorxItem;
	final access:ScorxAccess;
}

// enum SongListFunctions {
// 	EditUser;
// 	EditGroup;
// 	BuyToUser;
// 	BuyToGroup;
// }

/**
 * Kombinerbara celler Array<HomeCell> som används för att styra uppbyggnaden av Hemsidan för
 * de olika användarkategorierna (gäst, användare, ledare)
 */
enum HomeCell {
	Image(url:String); // stor sektionsbild på hemsidan
	Title(title:String); // stor h1-rubrik för sektionerna
	Info(info:String); // h3-information under rubrik
	Infoblobs(blobs:Array<Infoblob>); // Länkklickbara annons-utrymmen
	SonglistHeader(title:String, info:String); // Rubrik för låtlista
	Songlist2(accesses:Array<ScorxAccessListItem>); // Låtlista
	Songlist3(title:String, accesses:Array<ScorxAccessListItem>); // Låtlista
	SearchChoir; // Sökfält för att hitta kör
	GroupAddSongs(group:Group); // Knappar för att lägga till låtar till gruppens lista
	UserAddSongs(user:User); // kNappar för att lägga till låtar till användarens lista
	ShowFreeSongsIfNothingElse(user:User); // visa gratislåtar om det inte finns annat att visa
	ListGroupMembers(groupname:String);
	InviteGroupMembers(groupname:String); // gränssnit för att bjuda in medlemmar till aktuella gruppen
	AutogeneratedSensusLeaderSonglist; // Visa lista för Sensusanslutna körledare
	AutogeneratedNewsList; // idé för att visa nypublicerade låtar
	AutogeneratedHistoryList; // idé för att snabbt hitta senast spelade låtar - ska möjligen ligga på spelarsidan!!! :-)
}

enum Infoblob {
	Standard(title:String, info:String);
}

/**
 * Definition av sida som visas i demon, som inte har någon url-routing
 */
enum Page {
	Home;
	Email;
	Other;
	CreateUser;
	UserSettings;
}

/**
 * E-postmeddelande
 */
typedef EmailMessage = {
	final to:String;
	final from:String;
	final type:EmailType;
}

/**
 * Definition av epostmeddelanden som används i systemet
 */
enum EmailType {
	UserAccountActivation(email:String, pass:String, firstname:String, lastname:String, sensus:SensusUser);
	UserGroupjoinInfo(groupname:String);
	AdminGroupjoinInfo(joinedUsername:String, groupname:String);
	UserAccountActivationAndGroupjoin(email:String, pass:String, firstname:String, lastname:String, groupname:String);
	AfterUserActivationSuccess;
	SimpleMessage(title:String, text:String);
} // enum OverlayPage {

//---------------------------------------------------------------------------
//---------------------------------------------------------------------------
//---------------------------------------------------------------------------

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
				sensus: SensusUser.UserClaimed,
				userSongs: [
					UserPurchase(999, Date.fromString('2020-01-18')),
					UserPrivilege(789, UserPrivilegeType.KorakademinUserAccess)
				],
			},
			{
				firstname: 'Beda',
				lastname: 'Bensin',
				username: 'beda@bensin.se',
				password: 'beda',
				sensus: null,
				userSongs: [UserPurchase(1353, Date.fromString('2020-03-03')),],
			},
			{
				firstname: 'Caesar',
				lastname: 'Citrus',
				username: 'caesar@citrus.se',
				password: 'caesar',
				sensus: null,
				userSongs: [],
			},

			{
				firstname: 'Avledare',
				lastname: 'Jonsson',
				username: 'avledare@kor.se',
				password: 'avledare',
				sensus: null,
				userSongs: [],
			},

			{
				firstname: 'Örkel1',
				lastname: 'Örkelsson',
				username: 'orkel1@orkel.se',
				password: 'orkel1',
				sensus: SensusUser.SensusVerified,
				userSongs: [],
			},
			{
				firstname: 'Örkel2',
				lastname: 'Örkelsson',
				username: 'orkel2@orkel.se',
				password: 'orkel2',
				sensus: null,
				userSongs: [],
			},
			{
				firstname: 'Örkel3',
				lastname: 'Örkelsson',
				username: 'orkel3@orkel.se',
				password: 'orkel3',
				sensus: null,
				userSongs: [],
			},
			{
				firstname: 'Bro1',
				lastname: 'Brorsson',
				username: 'bro1@bro.se',
				password: 'bro1',
				sensus: null,
				userSongs: [],
			},
			{
				firstname: 'Bro2',
				lastname: 'Brorsson',
				username: 'bro2@bro.se',
				password: 'bro2',
				sensus: null,
				userSongs: [],
			},

		];
	}

	static public function groups():Array<Group> {
		return [
			{
				name: 'Örkelhåla kyrkokör',
				info: 'Soli deo gloria. Plus vår körledare.',
				admins: ['orkel1@orkel.se'],
				members: ['adam@adam.se', 'orkel1@orkel.se', 'orkel2@orkel.se', 'orkel3@orkel.se',],
				groupSongs: [
					ScorxAccess.GroupPurchase(397, Date.fromString('2020-01-18'), []),
					ScorxAccess.GroupPrivilege(975, KorakademinGroupAccess),
				],
			},
			{
				name: 'Bromölla Bandidos',
				info: 'Vi sjunger - ni pröjsar!',
				admins: [],
				members: [],
				groupSongs: [],
			},
			{
				name: 'Avunda Kyrkokör',
				info: 'Ju mer förr, desto bättre!',
				admins: ['avledare@kor.se'],
				members: [],
				groupSongs: [ScorxAccess.GroupPurchase(50, Date.fromString('2020-01-18'), []),],
			},

		];
	}

	static public function messages() {
		return [];
	}
}
