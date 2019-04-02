class Main {
	static function main() {
		var filename = 'PLAY-titles available in ScorX.org e-shop - Blad1.tsv';
		var fin = sys.io.File.read(filename, false);
		var items:ScorXItems = [];
		try {
			while (true) {
				fin.readLine();
				var line = fin.readLine();
				var parts = line.split('\t');
				trace(parts.length);

				var item:ScorXItem = {
					title: parts[0],
					composer: parts[1],
					lyricist: parts[2],
					arranger: parts[3],
					ensemble: parts[4],
					language: parts[5],
					licenseholder: parts[6],
					playProducer: parts[7],
					scorxProductId: parts[8],
					paskmusik: parts[9],
					julmusik: parts[10],
					shopLink: parts[11],
					externalLink: parts[12],
				}
				items.push(item);
				trace(item);
			}
		} catch (e:haxe.io.Eof) {
			trace(e);
			fin.close();
		}
		sys.io.File.saveContent('./items.json', haxe.Json.stringify(items));
	}
}

typedef ScorXItems = Array<ScorXItem>;

typedef ScorXItem = {
	final title:String;
	final composer:String;
	final lyricist:String;
	final arranger:String;
	final ensemble:String;
	final language:String;
	final licenseholder:String;
	final playProducer:String;
	final scorxProductId:String;
	final paskmusik:String;
	final julmusik:String;
	final shopLink:String;
	final externalLink:String;
}

// Title	Composer	Lyricist	Arranger	Ensemble	Language	Licenceholder	PLAY Producer	Scorx product ID	PÅSKMUSIK	JULMUSIK	Link to product in ScorX e-shop	Link to webshop to purchase printed score
