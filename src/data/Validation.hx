package data;

class Validation {
	static public function validateAsFirstname(s:String, length = 2) {
		if (s.length < length)
			throw 'First name is too short, must be $length chars';
		return s;
	}

	static public function validateAsLastname(s:String, length = 3) {
		if (s.length < length)
			throw 'Lastname is too short, must be $length chars';
		return s;
	}

	static public function validateAsPassword(s:String, length = 3) {
		if (s.length < length)
			throw 'Password is too short, must be $length chars';
		return s;
	}

	static var emailReg = ~/^[\w-\.]{2,}@[\w-\.]{2,}\.[a-z]{2,6}$/i;

	static public function validateAsEmail(email:String) {
		if (!emailReg.match(email))
			throw 'EmailAddress "$email" is invalid';
		return email;
	}

	static public function validateAsPersonnummer(pnr:String) {
		if (pnr.length < 3)
			throw 'Personnummer $pnr is invalid';
		return pnr;
	}
}
